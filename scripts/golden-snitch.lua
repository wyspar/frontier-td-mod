-- golden snitch (prototypes/entity/golden-snitch.lua): every 30 to 60 minutes of a round one spawns somewhere random
-- in the slot, flies from one random spot to the next and never attacks. it is on the neutral force so turrets
-- ignore it, players have to shoot it by hand. not killed within 2 minutes, it flies away (despawns). the killing team gets coins for the wave
-- they are on (control.lua pays them out in on_entity_died).
-- pvp: the two linked slots share one timer, both get a snitch at the same time.
local mapModule = require('scripts.map')

local goldenSnitch = {}

local SNITCH_NAME = "golden-snitch-flyer"
local MIN_INTERVAL_TICKS = 30 * 60 * 60 --30 minutes min
local MAX_INTERVAL_TICKS = 60 * 60 * 60 --60 minutes max
local LIFETIME_TICKS = 2 * 60 * 60
-- coins = BASE_COINS + COINS_PER_WAVE * wave, so wave 1 = 32, wave 50 = 375, wave 150 = 1075, wave 300 = 2125
local BASE_COINS = 25
local COINS_PER_WAVE = 7
-- tiles kept clear of the slot's edges when picking a spot
local EDGE_MARGIN = 10
local SURFACE_NAME = "frontier"

goldenSnitch.SNITCH_NAME = SNITCH_NAME

-- storage.goldenSnitches[unit_number] = {entity, despawnTick, slotId}
local function getSnitches()
  storage.goldenSnitches = storage.goldenSnitches or {}
  return storage.goldenSnitches
end

local function isInRound(slot)
  return slot and slot.isGameStarted and not slot.isDead
end

-- the linked pvp slot, if it is still in the round
local function getPvpPartner(slot)
  if not slot.isPvp or not slot.enemyForce then
    return nil
  end
  local partner = mapModule.getSlotByForceName(slot.enemyForce)
  if isInRound(partner) then
    return partner
  end
  return nil
end

local function randomInterval()
  return math.random(MIN_INTERVAL_TICKS, MAX_INTERVAL_TICKS)
end

local function randomSlotPosition(slotDef)
  return {
    x = slotDef.x + math.random(EDGE_MARGIN, slotDef.width - EDGE_MARGIN),
    y = slotDef.y + math.random(EDGE_MARGIN, slotDef.height - EDGE_MARGIN)
  }
end

-- off to another random spot in its slot, nothing distracts it on the way
local function flySomewhere(entity, slotId)
  local slotDef = mapModule.getSlotDefinitionById(slotId)
  if not slotDef or not entity.valid or not entity.commandable then
    return
  end
  entity.commandable.set_command({
    type = defines.command.go_to_location,
    destination = randomSlotPosition(slotDef),
    radius = 3,
    distraction = defines.distraction.none
  })
end

function goldenSnitch.getCoins(wave)
  return BASE_COINS + COINS_PER_WAVE * math.max(0, tonumber(wave) or 0)
end

-- one snitch somewhere random in the slot, returns it or nil
local function spawnInSlot(slot)
  local surface = game.surfaces[SURFACE_NAME]
  local slotDef = mapModule.getSlotDefinitionById(slot.id)
  if not surface or not slotDef then
    return nil
  end

  local entity = surface.create_entity({
    name = SNITCH_NAME,
    position = randomSlotPosition(slotDef),
    --neutral force (turrets do not shoot neutral, players have to kill it themselves). was game.forces.enemy
    force = game.forces.neutral
  })
  if not entity then
    return nil
  end

  getSnitches()[entity.unit_number] = {
    entity = entity,
    despawnTick = game.tick + LIFETIME_TICKS,
    slotId = slot.id
  }
  flySomewhere(entity, slot.id)

  local force = game.forces[tostring(slot.forceName)]
  if force then
    force.print("A golden snitch appeared [gps=" .. math.floor(entity.position.x) .. "," .. math.floor(entity.position.y) .. "," .. SURFACE_NAME .. "]! "
      .. "Kill it within " .. LIFETIME_TICKS / 3600 .. " minutes for " .. goldenSnitch.getCoins(slot.currentWave) .. " coins. Must manually shoot it.")
  end
  return entity
end

-- a snitch in the slot, and in the linked pvp slot if that one is in the round too. returns how many spawned
function goldenSnitch.spawnFor(slot)
  local count = spawnInSlot(slot) and 1 or 0
  local partner = getPvpPartner(slot)
  if partner and spawnInSlot(partner) then
    count = count + 1
  end
  return count
end

-- a new round starts its own timer
function goldenSnitch.onRoundStarted(slot)
  slot.nextSnitchTick = game.tick + randomInterval()
end

-- every second: snitches that ran out of time fly away, idle ones get a new spot, and slots whose timer is up get one
function goldenSnitch.onSecond()
  local snitches = getSnitches()
  for unitNumber, data in pairs(snitches) do
    if not data.entity.valid then
      snitches[unitNumber] = nil
    elseif game.tick >= data.despawnTick then
      local slot = storage.mapSlots[data.slotId]
      local force = slot and game.forces[tostring(slot.forceName)]
      if force then
        force.print("The golden snitch got away.")
      end
      data.entity.destroy()
      snitches[unitNumber] = nil
    elseif not data.entity.commandable.has_command then
      flySomewhere(data.entity, data.slotId)
    end
  end

  for _, slot in pairs(storage.mapSlots) do
    local partner = isInRound(slot) and getPvpPartner(slot)
    -- in pvp the slot with the lower id keeps the timer for both
    if isInRound(slot) and not (partner and partner.id < slot.id) then
      if not slot.nextSnitchTick then
        slot.nextSnitchTick = game.tick + randomInterval()
      elseif game.tick >= slot.nextSnitchTick then
        goldenSnitch.spawnFor(slot)
        slot.nextSnitchTick = game.tick + randomInterval()
      end
    end
  end
end

-- a snitch got where it was going (or could not), send it somewhere else. returns true if it was a snitch
function goldenSnitch.onAiCommandCompleted(event)
  local data = getSnitches()[event.unit_number]
  if not data then
    return false
  end
  if data.entity.valid then
    flySomewhere(data.entity, data.slotId)
  end
  return true
end

-- returns true if the dead entity was a snitch (control.lua then pays the killers)
function goldenSnitch.onDied(entity)
  if entity.name ~= SNITCH_NAME then
    return false
  end
  if entity.unit_number then
    getSnitches()[entity.unit_number] = nil
  end
  return true
end

return goldenSnitch
