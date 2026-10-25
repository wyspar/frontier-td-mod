require("prototypes.entity.entities")
require("prototypes.entity.explosions")
require("prototypes.entity.remnants")
require("prototypes.entity.enemies")
--the flyers (merged from the l9m2-flyer-enemy mod), before base-data-updates.lua which changes their health
require("prototypes.entity.l9m2-flyer.flyers")

require("prototypes.item-groups")
require("prototypes.item")
require("prototypes.recipe")
require("prototypes.categories.recipe-category")
require("prototypes.projectiles.bullet-projectile")
require("prototypes.projectiles.bullet-projectile-tier-two")
require("prototypes.projectiles.bullet-projectile-tier-three")
require("prototypes.projectiles.bullet-projectile-tier-four")
require("prototypes.projectiles.bullet-projectile-tier-five")

require("prototypes.entity.myTurrets.physical.infinite-gun-turret")

require("prototypes.beams.blue-laser-beam")
require("prototypes.beams.green-laser-beam")
require("prototypes.beams.gray-laser-beam")
require("prototypes.beams.red-laser-beam")
require("prototypes.beams.white-laser-beam")
require("prototypes.entity.myTurrets.laser.tier-one-laser-turret")
require("prototypes.entity.myTurrets.laser.tier-two-laser-turret")
require("prototypes.entity.myTurrets.laser.tier-three-laser-turret")
require("prototypes.entity.myTurrets.laser.tier-four-laser-turret")
require("prototypes.entity.myTurrets.laser.tier-five-laser-turret")

require("prototypes.entity.myTurrets.physical.tier-two-gun-turret")
require("prototypes.entity.myTurrets.physical.tier-three-gun-turret")
require("prototypes.entity.myTurrets.physical.tier-four-gun-turret")
require("prototypes.entity.myTurrets.physical.tier-five-gun-turret")

require("prototypes.beams.blue-tesla-beam")
require("prototypes.beams.green-tesla-beam")
require("prototypes.beams.gray-tesla-beam")
require("prototypes.beams.red-tesla-beam")
require("prototypes.beams.white-tesla-beam")
require("prototypes.entity.myTurrets.electric.tier-one-tesla-turret")
require("prototypes.entity.myTurrets.electric.tier-two-tesla-turret")
require("prototypes.entity.myTurrets.electric.tier-three-tesla-turret")
require("prototypes.entity.myTurrets.electric.tier-four-tesla-turret")
require("prototypes.entity.myTurrets.electric.tier-five-tesla-turret")

require("prototypes.entity.myTurrets.fire.tier-one-flamer-turret")
require("prototypes.entity.myTurrets.fire.tier-two-flamer-turret")
require("prototypes.entity.myTurrets.fire.tier-three-flamer-turret")
require("prototypes.entity.myTurrets.fire.tier-four-flamer-turret")
require("prototypes.entity.myTurrets.fire.tier-five-flamer-turret")

require("prototypes.entity.myTurrets.poison.ut-poison-cannon-one")
require("prototypes.entity.myTurrets.acid.ut-acid-shooter")

require("prototypes.biter-modules")
require("prototypes.money-tree")


require("base-data-updates")
--after base-data-updates: its recipe copies the (changed) assembling machine 1 recipe
require("prototypes.entity.mini-foundry")

local enabledTechnologies = {
  ["electronics"] = true,
  ["big-mining-drill"] = true,
  ["automation"] = true,
  ["automation-2"] = true,
  ["electric-energy-distribution-1"] = true,
  ["heating-tower"] = true,
  ["processing-unit"] = true,
  ["advanced-circuit"] = true,
  ["mining-productivity-1"] = true,
  ["mining-productivity-2"] = true,
  ["mining-productivity-3"] = true,
  ["mining-productivity-4"] = true,
  ["modules"] = true,
  ["battery"] = true,
  ["electric-engine"] = true,
  ["concrete"] = true,
  ["steel-axe"] = true,
  ["steel-processing"] = true,
  ["effect-transmission"] = true,
  ["fast-inserter"] = true,
  ["inserter-capacity-bonus-1"] = true,
  ["bulk-inserter"] = true,
  ["automation-3"] = true,
  ["landfill"] = true
}

for _, technology in pairs(data.raw.technology) do
  if not enabledTechnologies[technology.name] then
    technology.enabled = false
    technology.visible_when_disabled = false
  end
end

require("prototypes.technology")

--our infinite damage techs reuse vanilla names, and Factorio does not allow any level after an infinite one,
--so the disabled vanilla levels after them (e.g. vanilla electric-weapons-damage-4) are removed
local infiniteTechnologies = {
  ["electric-weapons-damage"] = 3,
  ["physical-projectile-damage"] = 6,
  ["stronger-explosives"] = 4,
  ["laser-weapons-damage"] = 4,
  ["flamer-damage"] = 3
}

local removedTechnologies = {}
for prefix, infiniteLevel in pairs(infiniteTechnologies) do
  local level = infiniteLevel + 1
  while data.raw.technology[prefix .. "-" .. level] do
    removedTechnologies[prefix .. "-" .. level] = true
    data.raw.technology[prefix .. "-" .. level] = nil
    level = level + 1
  end
end

for _, technology in pairs(data.raw.technology) do
  if technology.prerequisites then
    for i = #technology.prerequisites, 1, -1 do
      if removedTechnologies[technology.prerequisites[i]] then
        table.remove(technology.prerequisites, i)
      end
    end
  end
end

local towerCoinCosts = require("models.tower-coin-costs")
local upgradeableTowers = {}

for tower, _ in pairs(towerCoinCosts) do
  if tower.upgradeToName ~= nil then
    table.insert(upgradeableTowers, tower)
  end
end

local turret_upgrade_tool = {
  type = "selection-tool",
  name = "turret-upgrade-tool",

  icon = "__frontier-td__/graphics/icons/upgrade-tool.png",
  icon_size = 64,

  flags = {
    "only-in-cursor",
    "spawnable"
  },

  stack_size = 1,

  -- live cost preview while dragging (scripts/turret-info.lua)
  send_pre_selection_events = true,

  select = {
    border_color = {0, 1, 0, 1},
    mode = {"any-entity"},
    cursor_box_type = "entity",

    entity_filter_mode = "whitelist",
    entity_filters = upgradeableTowers
  },

  alt_select = {
    border_color = {1, 0.5, 0, 1},
    mode = {"any-entity"},
    cursor_box_type = "entity",
    entity_filter_mode = "whitelist",
    entity_filters = upgradeableTowers
  }
}

local turret_upgrade_shortcut = {
type = "shortcut",
  name = "turret-upgrade-shortcut",
  order = "b[blueprints]-k[turret-upgrade]",
  action = "spawn-item",
  localised_name = {"shortcut.turret-upgrade"},
  associated_control_input = "give-turret-upgrade-tool",
  item_to_spawn = "turret-upgrade-tool",
  --style = "green",
  icon = "__frontier-td__/graphics/icons/upgrade-tool.png",
  icon_size = 64,
  small_icon = "__frontier-td__/graphics/icons/upgrade-tool.png",
  small_icon_size = 64
}

data:extend({
  turret_upgrade_tool,
  turret_upgrade_shortcut
})

data:extend({
  {
    type = "custom-input",
    name = "give-turret-upgrade-tool",
    key_sequence = "ALT + Q",
    consuming = "game-only",
    item_to_spawn = "turret-upgrade-tool",
    action = "spawn-item"
  }
})