-- turret information for players:
--  * a live cost preview next to the cursor while dragging the turret upgrade tool (Factorio 2.1 preselection events)
--  * extra lines in the hover tooltip of turrets (tier, next upgrade cost, kills) and of the silo (difficulty, wave, next wave timer)
local towerCoinCosts = require('models.tower-coin-costs')
local mapModule = require('scripts.map')
local util = require('util')

local turretInfo = {}

local UPGRADE_TOOL_NAME = "turret-upgrade-tool"

local PREVIEW_COLOR_AFFORDABLE = {r = 0.4, g = 1, b = 0.4}
local PREVIEW_COLOR_TOO_EXPENSIVE = {r = 1, g = 0.35, b = 0.35}
local PREVIEW_COLOR_NOTHING = {r = 0.8, g = 0.8, b = 0.8}

-- fixed tooltip field ids, so refreshing a tooltip updates its lines instead of adding new ones
local TOOLTIP_TIER = 1
local TOOLTIP_NEXT_UPGRADE = 2
local TOOLTIP_KILLS = 3
local TOOLTIP_DIFFICULTY = 1
local TOOLTIP_WAVE = 2
local TOOLTIP_NEXT_WAVE = 3

-- tier number and family size of every turret, worked out from the upgradeToName chains in tower-coin-costs
local turretTierByName = {}
local turretMaxTierByName = {}

do
  local isUpgradeTarget = {}
  for _, towerCostDto in pairs(towerCoinCosts) do
    if towerCostDto.upgradeToName then
      isUpgradeTarget[towerCostDto.upgradeToName] = true
    end
  end

  -- every turret that is not an upgrade of another one starts a family
  for name, _ in pairs(towerCoinCosts) do
    if not isUpgradeTarget[name] then
      local chain = {}
      local current = name
      while current and towerCoinCosts[current] and #chain < 100 do
        chain[#chain + 1] = current
        current = towerCoinCosts[current].upgradeToName
      end
      for tier, chainName in ipairs(chain) do
        turretTierByName[chainName] = tier
        turretMaxTierByName[chainName] = #chain
      end
    end
  end
end

-- what upgrading the given turrets costs: only turrets of the force that have a next tier count,
-- each one costs the next tier's cost. on_player_selected_area charges exactly this
function turretInfo.getUpgradeCost(entities, force)
  local totalCost = 0
  local upgradeCount = 0

  for _, turret in pairs(entities) do
    if turret.valid and turret.force.name == force.name then
      local towerCostDto = towerCoinCosts[turret.name]
      local upgradeTowerDto = towerCostDto and towerCostDto.upgradeToName and towerCoinCosts[towerCostDto.upgradeToName]
      if upgradeTowerDto then
        totalCost = totalCost + upgradeTowerDto.cost
        upgradeCount = upgradeCount + 1
      end
    end
  end

  return totalCost, upgradeCount
end

-- upgrade preview ---------------------------------------------------------------------------------

function turretInfo.clearUpgradePreview(playerIndex)
  local previews = storage.upgradePreviewTexts
  if not previews then
    return
  end
  local preview = previews[playerIndex]
  if preview and preview.valid then
    preview.destroy()
  end
  previews[playerIndex] = nil
end

-- on_player_start_selected_area and on_player_change_selected_area.
-- these events are "best effort" (they can be dropped or come late in multiplayer), so the preview only shows information,
-- the real check and payment stay in on_player_selected_area
function turretInfo.onUpgradePreselect(event)
  if event.item ~= UPGRADE_TOOL_NAME then
    return
  end

  -- only the normal select upgrades, alt-select does nothing
  if event.selection_mode ~= defines.selection_mode.select then
    turretInfo.clearUpgradePreview(event.player_index)
    return
  end

  local player = game.get_player(event.player_index)
  if not player or not player.valid then
    return
  end

  local inventory = player.get_main_inventory()
  local coins = inventory and inventory.get_item_count("coin") or 0
  local totalCost, upgradeCount = turretInfo.getUpgradeCost(event.entities, player.force)

  local text
  local color
  if upgradeCount == 0 then
    text = {"frontier-td-upgrade-preview.nothing"}
    color = PREVIEW_COLOR_NOTHING
  else
    text = {"frontier-td-upgrade-preview.cost", upgradeCount, util.format_number(totalCost), util.format_number(coins)}
    color = coins >= totalCost and PREVIEW_COLOR_AFFORDABLE or PREVIEW_COLOR_TOO_EXPENSIVE
  end

  -- just above and right of the cursor, so it does not cover the turrets being selected
  local target = {x = event.cursor_position.x + 0.6, y = event.cursor_position.y - 0.6}

  storage.upgradePreviewTexts = storage.upgradePreviewTexts or {}
  local preview = storage.upgradePreviewTexts[player.index]

  if preview and preview.valid and preview.surface == event.surface then
    preview.text = text
    preview.color = color
    preview.target = target
    return
  end

  turretInfo.clearUpgradePreview(player.index)
  storage.upgradePreviewTexts[player.index] = rendering.draw_text({
    text = text,
    surface = event.surface,
    target = target,
    color = color,
    players = {player},
    scale = 1.5,
    scale_with_zoom = true,
    use_rich_text = true,
    alignment = "left",
    vertical_alignment = "bottom"
  })
end

-- hover tooltips ----------------------------------------------------------------------------------

local function refreshTurretTooltip(turret)
  local tier = turretTierByName[turret.name]
  if not tier then
    return
  end

  local towerCostDto = towerCoinCosts[turret.name]
  local upgradeTowerDto = towerCostDto.upgradeToName and towerCoinCosts[towerCostDto.upgradeToName]

  turret.set_tooltip_field({
    id = TOOLTIP_TIER,
    order = 1,
    name = {"frontier-td-tooltip.tier"},
    value = {"frontier-td-tooltip.tier-value", tier, turretMaxTierByName[turret.name]}
  })
  turret.set_tooltip_field({
    id = TOOLTIP_NEXT_UPGRADE,
    order = 2,
    name = {"frontier-td-tooltip.next-upgrade"},
    value = upgradeTowerDto
      and {"frontier-td-tooltip.next-upgrade-value", util.format_number(upgradeTowerDto.cost)}
      or {"frontier-td-tooltip.max-tier"}
  })
  turret.set_tooltip_field({
    id = TOOLTIP_KILLS,
    order = 3,
    name = {"frontier-td-tooltip.kills"},
    value = util.format_number(turret.kills)
  })
end

local function formatWaveTimer(ticks)
  local seconds = math.floor(ticks / 60)
  return string.format("%d:%02d", math.floor(seconds / 60), seconds % 60)
end

local function refreshSiloTooltip(silo)
  local slot = mapModule.getSlotByForceName(silo.force.name)
  if not slot or not slot.isGameStarted or slot.isDead then
    silo.clear_tooltip_fields()
    return
  end

  local difficulty = mapModule.difficulties[tonumber(slot.difficulty)]
  local currentWave = slot.currentWave or 0
  local totalWaves = slot.totalWaves or 0

  local waveValue
  if slot.isEndless then
    waveValue = {"frontier-td-tooltip.wave-endless", currentWave}
  else
    waveValue = {"frontier-td-tooltip.wave-value", currentWave, totalWaves}
  end

  local nextWaveValue
  if not slot.isEndless and currentWave >= totalWaves then
    nextWaveValue = {"frontier-td-tooltip.final-wave"}
  else
    nextWaveValue = formatWaveTimer(slot.waveTimer or 0)
  end

  silo.set_tooltip_field({
    id = TOOLTIP_DIFFICULTY,
    order = 1,
    name = {"frontier-td-tooltip.difficulty"},
    value = difficulty and difficulty.label or tostring(slot.difficulty)
  })
  silo.set_tooltip_field({
    id = TOOLTIP_WAVE,
    order = 2,
    name = {"frontier-td-tooltip.wave"},
    value = waveValue
  })
  silo.set_tooltip_field({
    id = TOOLTIP_NEXT_WAVE,
    order = 3,
    name = {"frontier-td-tooltip.next-wave"},
    value = nextWaveValue
  })
end

local function refreshTooltip(entity)
  if not entity or not entity.valid then
    return
  end
  if entity.name == "rocket-silo" then
    refreshSiloTooltip(entity)
  elseif turretTierByName[entity.name] then
    refreshTurretTooltip(entity)
  end
end

-- tooltips only matter while hovered, so they are filled in when a player hovers an entity
function turretInfo.onSelectedEntityChanged(event)
  local player = game.get_player(event.player_index)
  if player and player.valid then
    refreshTooltip(player.selected)
  end
end

-- keeps the hovered tooltips live (kill count, wave timer)
function turretInfo.refreshHoveredTooltips()
  for _, player in pairs(game.connected_players) do
    refreshTooltip(player.selected)
  end
end

return turretInfo
