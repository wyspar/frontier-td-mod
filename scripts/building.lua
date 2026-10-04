local building = {}
local mapModule = require('scripts.map')

--entity types that have no item to refund, these just get destroyed
local nonRefundableTypes = {
  ["entity-ghost"] = true,
  ["tile-ghost"] = true,
  --enemies
  ["unit"] = true, --biters, spitters, modded flyers etc
  ["unit-spawner"] = true, --nests
  ["turret"] = true, --worms
  ["spider-unit"] = true, --pentapods
  ["segmented-unit"] = true, --demolishers
}

--tesla turrets need this much space between each other, they stun so stacking them is too strong
local TESLA_MIN_DISTANCE = 25
local teslaTurretNames = {
  "tesla-turret",
  "tier-one-tesla-turret",
  "tier-two-tesla-turret",
  "tier-three-tesla-turret",
  "tier-four-tesla-turret",
  "tier-five-tesla-turret",
}
local isTeslaTurret = {}
for _, name in pairs(teslaTurretNames) do
  isTeslaTurret[name] = true
end

--gives the item back to whoever built it: the player, or spilled on the ground for robots to pick up
local function refundBuiltEntity(entity, player)
  local items = entity.prototype.items_to_place_this
  local itemName = (items and items[1] and items[1].name) or entity.name

  local stack = {
    name = itemName,
    count = 1,
    quality = entity.quality
  }

  if player then
    if player.insert(stack) < 1 then
      player.print("Your inventory is full! The item could not be returned.")
    end
  else
    entity.surface.spill_item_stack({
      position = entity.position,
      stack = stack,
      enable_looted = true,
      force = entity.force,
      allow_belts = false
    })
  end
end

--returns true if the tesla turret (or its ghost) was too close to another tesla and got removed
function building.enforceTeslaSpacing(event)
  local entity = event.created_entity or event.entity
  if not entity or not entity.valid then
    return false
  end

  local isGhost = entity.type == "entity-ghost"
  local teslaName = isGhost and entity.ghost_name or entity.name
  if not isTeslaTurret[teslaName] then
    return false
  end

  -- built teslas and planned (ghost) teslas both count, so blueprints cannot stack them either
  local surface = entity.surface
  local nearby = surface.find_entities_filtered({
    position = entity.position,
    radius = TESLA_MIN_DISTANCE,
    name = teslaTurretNames
  })
  local nearbyGhosts = surface.find_entities_filtered({
    position = entity.position,
    radius = TESLA_MIN_DISTANCE,
    ghost_name = teslaTurretNames
  })

  local tooClose = false
  for _, list in pairs({nearby, nearbyGhosts}) do
    for _, other in pairs(list) do
      if other.valid and other ~= entity then
        tooClose = true
      end
    end
  end

  if not tooClose then
    return false
  end

  -- robots have no player_index
  local player = event.player_index and game.get_player(event.player_index)
  if player and player.valid then
    player.create_local_flying_text({
      text = "Tesla turrets must be " .. TESLA_MIN_DISTANCE .. " tiles apart",
      position = entity.position
    })
  else
    player = nil
  end

  if not isGhost then
    refundBuiltEntity(entity, player)
  end
  entity.destroy()
  return true
end

function building.preventBuilding(event)
  if building.enforceTeslaSpacing(event) then
    return
  end

  local entity = event.created_entity or event.entity
  if not entity then
    return
  end

  local player = game.get_player(event.player_index)
  if not player or not player.valid then
    return
  end

  local slot = mapModule.getSlotByForceName(player.force.name)
  if not slot then
    return
  end

  local mapId = slot.id
  if not mapId then
    return
  end

  local slotDef = mapModule.slotDefinitions[mapId]
  if not slotDef then
    return
  end

  local isEntityInsidePlayerSlot = mapModule.isEntityInSlot(entity, slotDef)

  local surface = entity.surface
  local position = entity.position
  local item_name = entity.name
  local item_type = entity.type
  local tile = surface.get_tile(position)

  if tile.name == "red-refined-concrete" or isEntityInsidePlayerSlot == false then
    if nonRefundableTypes[item_type] then
      entity.destroy()
      return
    end

    if string.find(item_name, "plant") then
      item_name = string.gsub(item_name, "plant", "seed")
    end

    if item_name == "jellystem" then
      item_name = "jellynut-seed"
    end

    if item_name == "yumako-tree" then
      item_name = "yumako-seed"
    end

    local inserted_count = player.insert({
      name = item_name,
      count = 1,
      quality = entity.quality
    })

    if inserted_count < 1 then
      player.print("Your inventory is full! The item could not be returned.")
    end

    entity.destroy()
    return
  end

  -- if item_name == "rocket-silo" then
  --   entity.destroy()
  --   return
  -- end

end

return building
