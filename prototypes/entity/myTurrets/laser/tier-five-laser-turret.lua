local turret = table.deepcopy(data.raw["electric-turret"]["laser-turret"])
local sounds = require("__base__.prototypes.entity.sounds")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local turretTint = {1.3, 1.3, 1.3, 1}
local laserbeam_scale_mult = 1.5

function laser_turret_extension(inputs)
  return
  {
    filename = "__base__/graphics/entity/laser-turret/laser-turret-raising.png",
    priority = "medium",
    width = 130,
    height = 126,
    frame_count = inputs.frame_count or 15,
    line_length = inputs.line_length or 0,
    run_mode = inputs.run_mode or "forward",
    direction_count = 4,
    shift = util.by_pixel(0, -49.75),
    scale = 0.75
  }
end

function laser_turret_extension_shadow(inputs)
  return
  {
    filename = "__base__/graphics/entity/laser-turret/laser-turret-raising-shadow.png",
    width = 182,
    height = 96,
    frame_count = inputs.frame_count or 15,
    line_length = inputs.line_length or 0,
    run_mode = inputs.run_mode or "forward",
    direction_count = 4,
    draw_as_shadow = true,
    shift = util.by_pixel(47, 9.75),
    scale = 0.75
  }
end

function laser_turret_extension_mask(inputs)
  return
  {
    filename = "__base__/graphics/entity/laser-turret/laser-turret-raising-mask.png",
    flags = {"mask"},
    width = 86,
    height = 80,
    frame_count = inputs.frame_count or 15,
    line_length = inputs.line_length or 0,
    run_mode = inputs.run_mode or "forward",
    apply_runtime_tint = false,
    tint = turretTint,
    direction_count = 4,
    shift = util.by_pixel(0, -66),
    scale = 0.75
  }
end

function laser_turret_shooting()
  return
  {
    filename = "__base__/graphics/entity/laser-turret/laser-turret-shooting.png",
    line_length = 8,
    width = 126,
    height = 120,
    direction_count = 64,
    shift = util.by_pixel(0, -52),
    scale = 0.75
  }
end

function laser_turret_shooting_glow()
  return
  {
    filename = "__base__/graphics/entity/laser-turret/laser-turret-shooting-light.png",
    line_length = 8,
    width = 122,
    height = 116,
    direction_count = 64,
    shift = util.by_pixel(-0.5, -52),
    blend_mode = "additive",
    tint = turretTint,
    scale = 0.75
  }
end

function laser_turret_shooting_mask()
  return
  {
    filename = "__base__/graphics/entity/laser-turret/laser-turret-shooting-mask.png",
    flags = {"mask"},
    line_length = 8,
    width = 92,
    height = 80,
    apply_runtime_tint = false,
    tint = turretTint,
    direction_count = 64,
    shift = util.by_pixel(0, -65),
    scale = 0.75
  }
end

function laser_turret_shooting_shadow()
  return
  {
    filename = "__base__/graphics/entity/laser-turret/laser-turret-shooting-shadow.png",
    line_length = 8,
    width = 170,
    height = 92,
    direction_count = 64,
    draw_as_shadow = true,
    shift = util.by_pixel(50.5, 9.75),
    scale = 0.75
  }
end

turret.name = "tier-five-laser-turret"
turret.minable = {
  mining_time = 0.5,
  result = "tier-five-laser-turret"
}
turret.energy_source = {
  type = "void"
}

turret.collision_box = {{-1.2, -1.2 }, {1.2, 1.2}}
turret.selection_box = {{-1.5, -1.5 }, {1.5, 1.5}}
turret.folded_animation =
{
  layers =
  {
    laser_turret_extension{frame_count = 1, line_length = 1},
    laser_turret_extension_shadow{frame_count = 1, line_length = 1},
    laser_turret_extension_mask{frame_count = 1, line_length = 1}
  }
}

turret.preparing_animation =
{
  layers =
  {
    laser_turret_extension{},
    laser_turret_extension_shadow{},
    laser_turret_extension_mask{}
  }
}

turret.prepared_animation =
{
  layers =
  {
    laser_turret_shooting(),
    laser_turret_shooting_shadow(),
    laser_turret_shooting_mask()
  }
}

turret.energy_glow_animation = laser_turret_shooting_glow()
turret.glow_light_intensity = 0.5

turret.folding_animation =
{
  layers =
  {
    laser_turret_extension{run_mode = "backward"},
    laser_turret_extension_shadow{run_mode = "backward"},
    laser_turret_extension_mask{run_mode = "backward"}
  }
}

turret.graphics_set =
{
  base_visualisation =
  {
    animation =
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/laser-turret/laser-turret-base.png",
          priority = "high",
          width = 138,
          height = 104,
          shift = util.by_pixel(-0.5, 2),
          scale = 0.75
        },
        {
          filename = "__base__/graphics/entity/laser-turret/laser-turret-base-shadow.png",
          line_length = 1,
          width = 132,
          height = 82,
          draw_as_shadow = true,
          shift = util.by_pixel(6, 3),
          scale = 0.75
        }
      }
    }
  }
}

turret.max_health = 500
turret.attack_parameters = {
  type = "beam",
  cooldown = 40,
  range = 40,
  range_mode = "center-to-bounding-box",
  source_direction_count = 64,
  source_offset = {
    0,
    (-3.423489 / 4) * laserbeam_scale_mult
  },
  damage_modifier = 1,
  ammo_category = "laser",
  ammo_type = {
    action = {
      type = "direct",
      action_delivery = {
        type = "beam",
        beam = "white-laser-beam",
        max_length = 40,
        duration = 40,
        source_offset = {
          0,
          (-1.31439) * laserbeam_scale_mult
        }
      }
    }
  }
}

data:extend({
  turret
})
