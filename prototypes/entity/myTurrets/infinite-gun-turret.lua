local turret = table.deepcopy(data.raw["electric-turret"]["laser-turret"])
local sounds = require("__base__.prototypes.entity.sounds")
local hit_effects = require("__base__.prototypes.entity.hit-effects")

function gun_turret_extension(inputs)
return
{
  filename = "__base__/graphics/entity/gun-turret/gun-turret-raising.png",
  priority = "medium",
  width = 130,
  height = 126,
  direction_count = 4,
  frame_count = inputs.frame_count or 5,
  line_length = inputs.line_length or 0,
  run_mode = inputs.run_mode or "forward",
  shift = util.by_pixel(0, -26.5),
  scale = 0.75
}
end

function gun_turret_extension_mask(inputs)
return
{
  filename = "__base__/graphics/entity/gun-turret/gun-turret-raising-mask.png",
  flags = {"mask"},
  width = 48,
  height = 62,
  direction_count = 4,
  frame_count = inputs.frame_count or 5,
  line_length = inputs.line_length or 0,
  run_mode = inputs.run_mode or "forward",
  shift = util.by_pixel(0, -28),
  apply_runtime_tint = false,
  scale = 0.75
}
end

function gun_turret_extension_shadow(inputs)
return
{
  filename = "__base__/graphics/entity/gun-turret/gun-turret-raising-shadow.png",
  width = 250,
  height = 124,
  direction_count = 4,
  frame_count = inputs.frame_count or 5,
  line_length = inputs.line_length or 0,
  run_mode = inputs.run_mode or "forward",
  shift = util.by_pixel(19, 2.5),
  draw_as_shadow = true,
  scale = 0.75
}
end

function gun_turret_attack(inputs)
return
{
  layers =
  {
    {
      width = 132,
      height = 130,
      frame_count = inputs.frame_count or 2,
      direction_count = 64,
      shift = util.by_pixel(0, -27.5),
      stripes =
      {
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-1.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      },
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-2.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      },
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-3.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      },
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-4.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      }
      },
      scale = 0.75
    },
    {
      flags = {"mask"},
      line_length = inputs.frame_count or 2,
      width = 58,
      height = 54,
      frame_count = inputs.frame_count or 2,
      direction_count = 64,
      shift = util.by_pixel(0, -32.5),
      apply_runtime_tint = false,
      stripes =
      {
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-mask-1.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      },
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-mask-2.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      },
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-mask-3.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      },
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-mask-4.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      }
      },
      scale = 0.75
    },
    {
      width = 250,
      height = 124,
      frame_count = inputs.frame_count or 2,
      direction_count = 64,
      shift = util.by_pixel(22, 2.5),
      draw_as_shadow = true,
      stripes =
      {
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-shadow-1.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      },
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-shadow-2.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      },
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-shadow-3.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      },
      {
      filename = "__base__/graphics/entity/gun-turret/gun-turret-shooting-shadow-4.png",
      width_in_frames = inputs.frame_count or 2,
      height_in_frames = 16
      }
      },
      scale = 0.75
    }
  }
}
end


turret.name = "infinite-gun-turret"
turret.minable = {
  mining_time = 0.1,
  result = "infinite-gun-turret"
}
turret.fast_replaceable_group = "ammo-turret"
turret.energy_source = {
    type = "void"
}
turret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/infinite-gun-turret.png",
    icon_size = 64,
    -- tint = {r = 0.1, g = 1.0, b = 0.1, a = 1.0}
  }
}
turret.max_health = 100
turret.corpse = "gun-turret-remnants"
turret.dying_explosion = "gun-turret-explosion"
turret.rotation_speed = 0.015
turret.preparing_speed = 0.08
turret.preparing_sound = sounds.gun_turret_activate
turret.folding_sound = sounds.gun_turret_deactivate
turret.attacking_speed = .5 --animation?
turret.alert_when_attacking = false
turret.attack_parameters = {
  type = "projectile",
  ammo_category = "bullet",
  health_penalty = 1,
  cooldown = 12, --firerate
  projectile_creation_distance = 1.39375,
  projectile_center = {0, -0.0875}, -- same as gun_turret_attack shift
  -- shell_particle =
  -- {
  --   name = "shell-particle",
  --   direction_deviation = 0.1,
  --   speed = 0.1,
  --   speed_deviation = 0.03,
  --   center = {-0.0625, 0},
  --   creation_distance = -1.925,
  --   starting_frame_speed = 0.2,
  --   starting_frame_speed_deviation = 0.1
  -- },
  range = 16,
  sound = sounds.gun_turret_gunshot,
  ammo_type = {
    action = {
      type = "direct",
      action_delivery = {
        type = "projectile",
        projectile = "infinite-bullet-projectile",
        starting_speed = .5
      }
    }
  }
}

--3x3 box, .75 scale
turret.collision_box = {{-1.2, -1.2 }, {1.2, 1.2}}
turret.selection_box = {{-1.5, -1.5 }, {1.5, 1.5}}
turret.folded_animation =
{
  layers =
  {
    gun_turret_extension{frame_count = 1, line_length = 1},
    gun_turret_extension_mask{frame_count = 1, line_length = 1},
    gun_turret_extension_shadow{frame_count = 1, line_length = 1}
  }
}

turret.preparing_animation =
{
  layers =
  {
    gun_turret_extension{},
    gun_turret_extension_mask{},
    gun_turret_extension_shadow{}
  }
}

turret.prepared_animation = gun_turret_attack{frame_count = 1}
turret.attacking_animation = gun_turret_attack{}
turret.folding_animation =
{
  layers =
  {
    gun_turret_extension{run_mode = "backward"},
    gun_turret_extension_mask{run_mode = "backward"},
    gun_turret_extension_shadow{run_mode = "backward"}
  }
}


--increase scale for bigger base
turret.graphics_set =
{
  base_visualisation =
  {
    animation =
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/gun-turret/gun-turret-base.png",
          priority = "high",
          width = 150,
          height = 118,
          shift = util.by_pixel(0.5, -1),
          scale = 0.75
        },
        {
          filename = "__base__/graphics/entity/gun-turret/gun-turret-base-mask.png",
          flags = {"mask", "low-object"},
          line_length = 1,
          width = 122,
          height = 102,
          shift = util.by_pixel(0, -4.5),
          apply_runtime_tint = false,
          scale = 0.75
        }
      }
    }
  }
}
data:extend({
  turret
})