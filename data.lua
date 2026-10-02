require("prototypes.entity.entities")
require("prototypes.entity.explosions")
require("prototypes.entity.remnants")
require("prototypes.entity.enemies")

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


require("base-data-updates")

local enabledTechnologies = {
  ["electronics"] = true,
  ["big-mining-drill"] = true,
  ["automation"] = true,
  ["automation-2"] = true,
  ["electric-energy-distribution-1"] = true,
  ["heating-tower"] = true,
}

for _, technology in pairs(data.raw.technology) do
  if not enabledTechnologies[technology.name] then
    technology.enabled = false
    technology.visible_when_disabled = false
  end
end

require("prototypes.technology")

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