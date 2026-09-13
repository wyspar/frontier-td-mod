local turret = table.deepcopy(data.raw["electric-turret"]["tesla-turret"])
local sounds = require("__base__.prototypes.entity.sounds")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local turretTint = {2, 2, 2, 1}
local tesla_turret_shift = -26

local function white_tesla_rising(inputs)
  return
  {
    layers =
    {
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-rising",
      {
        priority = "medium",
        direction_count = 4,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5,
        frame_count = 16,
        line_length = 16,
        run_mode = inputs.run_mode or "forward",
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-rising-mask",
      {
        flags = {"mask"},
        apply_runtime_tint = false,
        tint = turretTint,
        priority = "medium",
        direction_count = 4,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5,
        frame_count = 16,
        line_length = 16,
        run_mode = inputs.run_mode or "forward",
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-rising-emit",
      {
        priority = "medium",
        direction_count = 4,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5,
        draw_as_glow = true,
        blend_mode = "additive",
        tint = turretTint,
        frame_count = 16,
        line_length = 16,
        run_mode = inputs.run_mode or "forward",
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-rising-shadow",
      {
        draw_as_shadow = true,
        priority = "medium",
        direction_count = 4,
        shift = util.by_pixel(96, 0 + tesla_turret_shift),
        scale = 0.5,
        frame_count = 16,
        line_length = 16,
        run_mode = inputs.run_mode or "forward",
      }),
    }
  }
end

local function white_tesla_ready(inputs)
  return
  {
    layers =
    {
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking",
      {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 30,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking-mask",
      {
        flags = {"mask"},
        apply_runtime_tint = false,
        tint = turretTint,
        direction_count = 64,
        frame_count = 1,
        repeat_count = 30,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking-emit",
      {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 30,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5,
        draw_as_glow = true,
        blend_mode = "additive",
        tint = turretTint
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking-shadow",
      {
        draw_as_shadow = true,
        direction_count = 64,
        frame_count = 1,
        repeat_count = 30,
        shift = util.by_pixel(96, 0 + tesla_turret_shift),
        scale = 0.5
      }),
    }
  }
end

local function white_tesla_cooldown(inputs)
  return
  {
    layers =
    {
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking",
      {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 30,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking-mask",
      {
        flags = {"mask"},
        apply_runtime_tint = false,
        tint = turretTint,
        direction_count = 64,
        frame_count = 1,
        repeat_count = 30,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking-emit",
      {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 30,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5,
        draw_as_glow = true,
        blend_mode = "additive",
        tint = turretTint
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking-facelight",
      {
        direction_count = 64,
        frame_count = 1,
        repeat_count = 30,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5,
        draw_as_glow = true,
        blend_mode = "additive",
        tint = turretTint
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking-shadow",
      {
        draw_as_shadow = true,
        direction_count = 64,
        frame_count = 1,
        repeat_count = 30,
        shift = util.by_pixel(96, 0 + tesla_turret_shift),
        scale = 0.5
      }),
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-sfx-active",
      {
        direction_count = 1,
        duplicate_first_direction = true,
        frame_count = 30,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        scale = 0.5,
        animation_speed = 0.5,
        draw_as_glow = true,
        blend_mode = "additive",
        tint = turretTint
      }),
    }
  }
end

local function white_tesla_led()
  return
  {
    layers =
    {
      util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-LED",
      {
        direction_count = 1,
        duplicate_first_direction = true,
        shift = util.by_pixel(0, 0 + tesla_turret_shift),
        draw_as_glow = true,
        blend_mode = "additive",
        tint = turretTint,
        scale = 0.5,
        frame_count = 5
      }),
    }
  }
end

local function white_tesla_glow()
  return util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-head-attacking-emit",
  {
    direction_count = 64,
    frame_count = 1,
    repeat_count = 30,
    shift = util.by_pixel(0, 0 + tesla_turret_shift),
    scale = 0.5,
    draw_as_glow = true,
    blend_mode = "additive",
    tint = turretTint
  })
end

local function white_tesla_base_visualisation()
  return
  {
    {
      animation =
      {
        layers =
        {
          util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-base",
          {
            frame_count = 1,
            repeat_count = 30,
            shift = util.by_pixel(0, 0 + tesla_turret_shift),
            scale = 0.5,
            animation_speed = 0.5
          }),
          util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-base-mask",
          {
            flags = {"mask"},
            apply_runtime_tint = false,
            tint = turretTint,
            frame_count = 1,
            repeat_count = 30,
            shift = util.by_pixel(0, 0 + tesla_turret_shift),
            scale = 0.5
          }),
          util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-base-shadow",
          {
            frame_count = 1,
            repeat_count = 30,
            draw_as_shadow = true,
            shift = util.by_pixel(0, 0 + tesla_turret_shift),
            scale = 0.5
          }),
          util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-base-emit",
          {
            frame_count = 1,
            repeat_count = 30,
            shift = util.by_pixel(0, 0 + tesla_turret_shift),
            scale = 0.5,
            draw_as_glow = true,
            blend_mode = "additive",
            tint = turretTint
          }),
        }
      }
    },
    {
      enabled_states = { "folded", "preparing", "rotate-for-folding", "folding" },
      draw_when_no_energy = false,
      draw_when_frozen = false,
      animation =
      {
        layers =
        {
          util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-sfx-idle-2",
          {
            frame_count = 50,
            repeat_count = 4,
            shift = util.by_pixel(0, 0 + tesla_turret_shift),
            scale = 0.5,
            animation_speed = 0.33,
            draw_as_glow = true,
            blend_mode = "additive",
            tint = turretTint
          }),
          util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-sfx-idle-1",
          {
            frame_count = 40,
            repeat_count = 5,
            shift = util.by_pixel(0, 0 + tesla_turret_shift),
            scale = 0.5,
            animation_speed = 0.33,
            draw_as_glow = true,
            blend_mode = "additive",
            tint = turretTint
          }),
        },
      }
    },
    {
      enabled_states = { "prepared", "starting-attack", "attacking", "ending-attack" },
      draw_when_no_energy = false,
      draw_when_frozen = false,
      animation =
      {
        layers =
        {
          util.sprite_load("__space-age__/graphics/entity/tesla-turret/tesla-turret-sfx-passive",
          {
            frame_count = 30,
            shift = util.by_pixel(0, 0 + tesla_turret_shift),
            scale = 0.5,
            animation_speed = 0.5,
            draw_as_glow = true,
            blend_mode = "additive",
            tint = turretTint
          })
        }
      }
    }
  }
end

turret.name = "tier-five-tesla-turret"
turret.minable = {
  mining_time = 0.5,
  result = "tier-five-tesla-turret"
}
turret.icon = nil
turret.icons = nil
turret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-five-tesla-turret.png",
    icon_size = 64
  }
}
turret.energy_source = {
  type = "void"
}
turret.max_health = 500
turret.corpse = "tesla-turret-remnants"
turret.dying_explosion = "laser-turret-explosion"
turret.fast_replaceable_group = "tesla-turret"

turret.folded_animation = white_tesla_rising({})
turret.preparing_animation = white_tesla_rising({})
turret.prepared_animation = white_tesla_ready({})
turret.ending_attack_animation = white_tesla_cooldown({})
turret.folding_animation = white_tesla_rising({run_mode = "backward"})
turret.energy_glow_animation = white_tesla_glow()
turret.glow_light_intensity = 0.5
turret.resource_indicator_animation = white_tesla_led()

turret.graphics_set.base_visualisation = white_tesla_base_visualisation()

-- Tier 5 tesla turret: cooldown (fire rate) and beam damage are set on the
-- white-tesla-beam-start / white-tesla-beam-bounce / tier-five-tesla-chain
-- prototypes defined in white-tesla-beam.lua
turret.attack_parameters = {
  type = "beam",
  cooldown = 100,
  range = 40,
  range_mode = "center-to-bounding-box",
  fire_penalty = 0.9,
  source_direction_count = 64,
  source_offset = {0, -0.55},
  ammo_category = "tesla",
  ammo_type = {
    energy_consumption = "12MJ",
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          -- Chain jump must go first in case the beam kills the target
          {
            type = "nested-result",
            action = {
              type = "direct",
              action_delivery = {
                type = "chain",
                chain = "tier-five-tesla-chain"
              }
            }
          },
          {
            type = "nested-result",
            action = {
              type = "direct",
              action_delivery = {
                type = "beam",
                beam = "white-tesla-beam-start",
                max_length = 40,
                duration = 30,
                add_to_shooter = false,
                destroy_with_source_or_target = false,
                source_offset = {0, -2.6}
              }
            }
          }
        }
      }
    }
  }
}

data:extend({
  turret
})
