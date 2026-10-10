-- biter modules (prototypes/biter-modules.lua): every normal craft of a machine spawns one friendly
-- armoured biter (ArmouredBiters mod). only one biter module works per machine, extras are dropped. only the normal crafting bar counts,
-- the productivity bonus bar never spawns anything.
-- crafts are found by watching crafting_progress: it drops when a craft finishes and the next one starts,
-- and products_finished has to go up at the same time (a recipe change also drops the progress)
local biterModules = {}

local SCAN_INTERVAL_TICKS = 60

local MODULE_BITERS = {
  ["biter-module-1"] = "small-armoured-biter",
  ["biter-module-2"] = "medium-armoured-biter",
  ["biter-module-3"] = "big-armoured-biter",
}

-- most friendly biters of each kind a force can have alive at once
local BITER_CAPS = {
  ["small-armoured-biter"] = 20,
  ["medium-armoured-biter"] = 20,
  ["big-armoured-biter"] = 15,
}

local function getStorage()
  storage.biterModules = storage.biterModules or {}
  local data = storage.biterModules
  -- unit_number -> {entity, moduleName, progress, finished}
  data.machines = data.machines or {}
  -- forceName -> biterName -> {unit_number -> unit}
  data.biters = data.biters or {}
  return data
end

local MODULE_TIERS = {
  ["biter-module-1"] = 1,
  ["biter-module-2"] = 2,
  ["biter-module-3"] = 3,
}

-- the game does not say who put a module in, so this guesses: a player with the machine's window open,
-- then a player hovering it (ctrl+click inserts), then the machine's last user. nil if none is connected
local function findModuleInserter(machine)
  for _, player in pairs(machine.force.connected_players) do
    if player.opened == machine then
      return player
    end
  end
  for _, player in pairs(machine.force.connected_players) do
    if player.selected == machine then
      return player
    end
  end
  local lastUser = machine.last_user
  if lastUser and lastUser.valid and lastUser.connected then
    return lastUser
  end
  return nil
end

-- only one biter module (any tier) works per machine: the highest tier one stays,
-- every other biter module is popped out onto the ground next to the machine.
-- returns the name of the biter module that stays, or nil if there is none
local function keepOneBiterModule(machine)
  local inventory = machine.get_module_inventory()
  if not inventory then
    return nil
  end

  local bestSlot = nil
  local biterSlots = {}
  for i = 1, #inventory do
    local stack = inventory[i]
    if stack.valid_for_read and MODULE_BITERS[stack.name] then
      table.insert(biterSlots, i)
      if not bestSlot or MODULE_TIERS[stack.name] > MODULE_TIERS[inventory[bestSlot].name] then
        bestSlot = i
      end
    end
  end
  if not bestSlot then
    return nil
  end

  local removedAny = false
  for _, i in ipairs(biterSlots) do
    local stack = inventory[i]
    -- the best slot keeps 1, module slots normally only hold 1 anyway
    local extra = (i == bestSlot) and (stack.count - 1) or stack.count
    if extra > 0 then
      machine.surface.spill_item_stack({
        position = machine.position,
        stack = {name = stack.name, count = extra, quality = stack.quality},
        enable_looted = true,
        force = machine.force
      })
      stack.count = stack.count - extra
      removedAny = true
    end
  end
  if removedAny then
    local message = {"", "Only one biter module works per machine, the extra ones were dropped next to the ", machine.localised_name, "."}
    local player = findModuleInserter(machine)
    if player then
      player.print(message)
    else
      machine.force.print(message)
    end
  end

  return inventory[bestSlot].name
end

-- alive friendly biters of this kind on the force, dead ones are dropped
local function countAliveBiters(data, forceName, biterName)
  local byForce = data.biters[forceName]
  if not byForce or not byForce[biterName] then
    return 0
  end
  local alive = 0
  for unitNumber, unit in pairs(byForce[biterName]) do
    if unit.valid then
      alive = alive + 1
    else
      byForce[biterName][unitNumber] = nil
    end
  end
  return alive
end

local function rememberBiter(data, forceName, biterName, unit)
  data.biters[forceName] = data.biters[forceName] or {}
  data.biters[forceName][biterName] = data.biters[forceName][biterName] or {}
  data.biters[forceName][biterName][unit.unit_number] = unit
end

-- the biter walks to its force's silo and guards it, fighting any enemy that comes close
local function sendToGuard(unit, surface, force)
  local silo = surface.find_entities_filtered({name = "rocket-silo", force = force, limit = 1})[1]
  local commands = {}
  if silo and silo.valid then
    table.insert(commands, {
      type = defines.command.go_to_location,
      destination = silo.position,
      radius = 8,
      distraction = defines.distraction.by_enemy
    })
  end
  table.insert(commands, {
    type = defines.command.wander,
    radius = 12,
    distraction = defines.distraction.by_enemy
  })
  unit.commandable.set_command({
    type = defines.command.compound,
    structure_type = defines.compound_command.return_last,
    commands = commands
  })
end

-- one biter per craft, of the tier of the machine's biter module, unless the force is at the cap
local function spawnBiter(data, machine, moduleName)
  local force = machine.force
  local surface = machine.surface
  local biterName = MODULE_BITERS[moduleName]
  -- watched machines saved by an older version have no moduleName until the next scan
  if not biterName then
    return
  end
  if countAliveBiters(data, force.name, biterName) >= BITER_CAPS[biterName] then
    return
  end
  local position = surface.find_non_colliding_position(biterName, machine.position, 10, 0.5)
  if not position then
    return
  end
  local unit = surface.create_entity({name = biterName, position = position, force = force})
  if unit and unit.valid then
    rememberBiter(data, force.name, biterName, unit)
    sendToGuard(unit, surface, force)
  end
end

-- finds every crafting machine on the surface that has a biter module, keeps the craft tracking
-- of machines that were already watched so no craft is missed or counted twice
local function scanMachines(data, surface, isSlotForce)
  local watched = {}
  for _, machine in pairs(surface.find_entities_filtered({type = {"assembling-machine", "furnace"}})) do
    if machine.valid and isSlotForce(machine.force.name) then
      local moduleName = keepOneBiterModule(machine)
      if moduleName then
        local previous = data.machines[machine.unit_number]
        watched[machine.unit_number] = {
          entity = machine,
          moduleName = moduleName,
          progress = previous and previous.progress or machine.crafting_progress,
          finished = previous and previous.finished or machine.products_finished,
        }
      end
    end
  end
  data.machines = watched
end

local function checkCrafts(data)
  for unitNumber, watched in pairs(data.machines) do
    local machine = watched.entity
    if not machine.valid then
      data.machines[unitNumber] = nil
    else
      local progress = machine.crafting_progress
      local finished = machine.products_finished
      if progress < watched.progress and finished > watched.finished then
        spawnBiter(data, machine, watched.moduleName)
      end
      watched.progress = progress
      watched.finished = finished
    end
  end
end

-- armoured biters hurt themselves when they attack (base-data-updates.lua), so a force can "kill" its own
-- friendly biter. the game counts that in the force's kill statistics, this keeps the count so
-- getBiterKillsByForce in control.lua can take them back out
function biterModules.onEntityDied(event)
  local entity = event.entity
  if not BITER_CAPS[entity.name] or not event.force or event.force ~= entity.force then
    return
  end
  local data = getStorage()
  data.selfKills = data.selfKills or {}
  data.selfKills[entity.force.name] = (data.selfKills[entity.force.name] or 0) + 1
end

function biterModules.getSelfKills(forceName)
  local data = getStorage()
  return data.selfKills and data.selfKills[forceName] or 0
end

-- called every tick from control.lua's on_tick. isSlotForce(forceName) says if the force owns a map slot
-- armoured biter corpses are removed this long after the biter died. the corpse prototype's time_before_removed
-- (data-final-fixes.lua) does this too, this is a backup that also catches corpses from before an update)
local CORPSE_REMOVAL_TICKS = 20 * 60

local ARMOURED_BITERS = {
  ["small-armoured-biter"] = true,
  ["medium-armoured-biter"] = true,
  ["big-armoured-biter"] = true,
  ["behemoth-armoured-biter"] = true,
}

-- from on_post_entity_died: queues the corpses an armoured biter left behind
function biterModules.onPostEntityDied(event)
  if not event.prototype or not ARMOURED_BITERS[event.prototype.name] or not event.corpses then
    return
  end
  local data = getStorage()
  data.corpseQueue = data.corpseQueue or {}
  for _, corpse in pairs(event.corpses) do
    table.insert(data.corpseQueue, {tick = game.tick + CORPSE_REMOVAL_TICKS, corpse = corpse})
  end
end

-- the queue is in death order, so only the front needs checking
local function removeExpiredCorpses(data, tick)
  local queue = data.corpseQueue
  if not queue then
    return
  end
  while queue[1] and queue[1].tick <= tick do
    local corpse = table.remove(queue, 1).corpse
    if corpse.valid then
      corpse.destroy()
    end
  end
end

function biterModules.onTick(tick, surface, isSlotForce)
  if not surface then
    return
  end
  local data = getStorage()
  if tick % SCAN_INTERVAL_TICKS == 0 then
    scanMachines(data, surface, isSlotForce)
  end
  checkCrafts(data)
  removeExpiredCorpses(data, tick)
end

return biterModules
