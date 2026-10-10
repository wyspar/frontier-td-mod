-- the "clear biter corpses" button in the bottom right corner of the screen.
-- clicking it removes every biter corpse in the clicking player's map slot
local mapModule = require('scripts.map')

local corpseButton = {}

local BUTTON_NAME = "clear_corpses_button"
local BUTTON_SIZE = 40
-- gap to the screen edges, in unscaled pixels
local BUTTON_MARGIN = 8
local MAIN_SURFACE_NAME = "frontier"

-- corpse names of every unit (biters, spitters, modded ones), built once per load
local unitCorpseNames = nil

local function getUnitCorpseNames()
  if unitCorpseNames then
    return unitCorpseNames
  end
  local names = {}
  for _, unit in pairs(prototypes.get_entity_filtered({{filter = "type", type = "unit"}})) do
    for corpseName, _ in pairs(unit.corpses or {}) do
      names[corpseName] = true
    end
  end
  unitCorpseNames = {}
  for corpseName, _ in pairs(names) do
    table.insert(unitCorpseNames, corpseName)
  end
  return unitCorpseNames
end

-- gui.screen has no anchoring, so the location is worked out from the player's resolution and ui scale
local function placeButton(player, button)
  local scale = player.display_scale
  local size = (BUTTON_SIZE + BUTTON_MARGIN) * scale
  button.location = {
    x = player.display_resolution.width - size,
    y = player.display_resolution.height - size
  }
end

-- adds the button if the player doesn't have it yet, and puts it in the corner
function corpseButton.ensure(player)
  if not player or not player.valid then
    return
  end
  local button = player.gui.screen[BUTTON_NAME]
  if not button then
    button = player.gui.screen.add({
      type = "sprite-button",
      name = BUTTON_NAME,
      sprite = "utility/trash",
      tooltip = "Clear biter corpses in your slot",
      style = "slot_button"
    })
    button.style.width = BUTTON_SIZE
    button.style.height = BUTTON_SIZE
  end
  placeButton(player, button)
end

function corpseButton.onResolutionOrScaleChanged(event)
  local player = game.get_player(event.player_index)
  if player and player.valid and player.gui.screen[BUTTON_NAME] then
    placeButton(player, player.gui.screen[BUTTON_NAME])
  end
end

-- returns true if the click was the corpse button
function corpseButton.onClick(element, player)
  if element.name ~= BUTTON_NAME then
    return false
  end

  local slot = mapModule.getSlotByForceName(player.force.name)
  local slotDef = slot and mapModule.getSlotDefinitionById(slot.id)
  local surface = game.surfaces[MAIN_SURFACE_NAME]
  if not slotDef or not surface then
    player.print("You are not in a map slot, there are no corpses to clear.")
    return true
  end

  -- an empty name list would match every entity
  local corpseNames = getUnitCorpseNames()
  if #corpseNames == 0 then
    return true
  end

  local corpses = surface.find_entities_filtered({
    area = {{slotDef.x, slotDef.y}, {slotDef.x + slotDef.width, slotDef.y + slotDef.height}},
    name = corpseNames
  })
  for _, corpse in pairs(corpses) do
    if corpse.valid then
      corpse.destroy()
    end
  end
  player.print("Cleared " .. #corpses .. " biter corpses.")
  return true
end

return corpseButton
