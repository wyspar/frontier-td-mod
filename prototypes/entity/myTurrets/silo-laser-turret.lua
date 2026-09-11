local turret = table.deepcopy(data.raw["electric-turret"]["laser-turret"])
local sounds = require("__base__.prototypes.entity.sounds")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
turret.name = "silo-laser-turret"
turret.minable = {
  mining_time = 0.1,
  result = "silo-laser-turret"
}
turret.fast_replaceable_group = "ammo-turret"
turret.energy_source = {
    type = "void"
}
turret.max_health = 100
turret.attack_parameters = {
    type = "beam",
    cooldown = 40,
    range = 30,
    range_mode = "center-to-bounding-box",
    source_direction_count = 64,
    source_offset = {
        0,
        -3.423489 / 4
    },
    damage_modifier = 1,
    ammo_category = "laser",
    ammo_type = {
        action = {
            type = "direct",
            action_delivery = {
                type = "beam",
                beam = "blue-laser-beam",
                max_length = 24,
                duration = 40,
                source_offset = {
                    0,
                    -1.31439
                }
            }
        }
    }
}

turret.energy_glow_animation = {
    filename = "__base__/graphics/entity/laser-turret/laser-turret-shooting-light.png",
    line_length = 8,
    width = 122,
    height = 116,
    direction_count = 64,
    shift = util.by_pixel(-0.5, -35),
    blend_mode = "additive",
    scale = 0.5,
    tint = {0.0, 0.1, 1.0}
}

data:extend({
  turret
})