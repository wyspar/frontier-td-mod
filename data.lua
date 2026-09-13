require("prototypes.entity.entities")
require("prototypes.entity.explosions")
require("prototypes.entity.remnants")
require("prototypes.entity.enemies")

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

require("base-data-updates")


for _, technology in pairs(data.raw.technology) do
  technology.enabled = false
  technology.visible_when_disabled = false
end

require("prototypes.technology")

local turret_upgrade_tool = {
  type = "selection-tool",
  name = "turret-upgrade-tool",

  icon = "__base__/graphics/icons/gun-turret.png",
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
    entity_filters = {
      "infinite-gun-turret",
      "tier-two-gun-turret",
      "tier-three-gun-turret",
      "tier-four-gun-turret"
    }
  },

  alt_select = {
    border_color = {1, 0.5, 0, 1},
    mode = {"any-entity"},
    cursor_box_type = "entity",
    entity_filter_mode = "whitelist",
    entity_filters = {
      "infinite-gun-turret",
      "tier-two-gun-turret",
      "tier-three-gun-turret",
      "tier-four-gun-turret"
    }
  }
}

data:extend({
  turret_upgrade_tool
})

local turret_upgrade_shortcut = {
type = "shortcut",
  name = "turret-upgrade-shortcut",
  order = "b[blueprints]-k[turret-upgrade]",
  action = "spawn-item",
  localised_name = {"shortcut.turret-upgrade"},
  associated_control_input = "give-turret-upgrade-tool",
  item_to_spawn = "turret-upgrade-tool",
  style = "green",
  icon = "__base__/graphics/icons/gun-turret.png",
  icon_size = 64,
  small_icon = "__base__/graphics/icons/gun-turret.png",
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