local laser_beam_blend_mode = "additive"
local beam_blend_mode = "additive-soft"
local beam_non_light_flags = { "trilinear-filtering" }

function make_laser_beam(sound)
  local result =
  {
    type = "beam",
    flags = {"not-on-map"},
    hidden = true,
    width = 0.5,
    damage_interval = 20,
    random_target_offset = true,
    action_triggered_automatically = false,
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "damage",
            damage = { amount = 10, type = "laser"}
          }
        }
      }
    },
    graphics_set =
    {
      beam =
      {
        head =
        {
          layers =
          {
            {
              filename = "__frontier-td__/graphics/entity/laser-turret/gray-laser-body.png",
              flags = beam_non_light_flags,
              line_length = 8,
              width = 64,
              height = 12,
              frame_count = 8,
              scale = 0.5,
              animation_speed = 0.5,
              blend_mode = laser_beam_blend_mode
            },
            {
              filename = "__base__/graphics/entity/laser-turret/laser-body-light.png",
              draw_as_light = true,
              flags = {"light"},
              line_length = 8,
              width = 64,
              height = 12,
              frame_count = 8,
              scale = 0.5,
              animation_speed = 0.5
            }
          }
        },
        tail =
        {
          layers =
          {
            {
              filename = "__frontier-td__/graphics/entity/laser-turret/gray-laser-end.png",
              flags = beam_non_light_flags,
              width = 110,
              height = 62,
              frame_count = 8,
              shift = util.by_pixel(11.5, 1),
              scale = 0.5,
              animation_speed = 0.5,
              blend_mode = laser_beam_blend_mode
            },
            {
              filename = "__base__/graphics/entity/laser-turret/laser-end-light.png",
              draw_as_light = true,
              flags = {"light"},
              width = 110,
              height = 62,
              frame_count = 8,
              shift = util.by_pixel(11.5, 1),
              scale = 0.5,
              animation_speed = 0.5
            }
          }
        },
        body =
        {
          {
            layers =
            {
              {
                filename = "__frontier-td__/graphics/entity/laser-turret/gray-laser-body.png",
                flags = beam_non_light_flags,
                line_length = 8,
                width = 64,
                height = 12,
                frame_count = 8,
                scale = 0.5,
                animation_speed = 0.5,
                blend_mode = laser_beam_blend_mode
              },
              {
                filename = "__base__/graphics/entity/laser-turret/laser-body-light.png",
                draw_as_light = true,
                flags = {"light"},
                line_length = 8,
                width = 64,
                height = 12,
                frame_count = 8,
                scale = 0.5,
                animation_speed = 0.5
              }
            }
          }
        },
        -- render_layer = "projectile"
      },

      ground =
      {
        head =
        {
          filename = "__base__/graphics/entity/laser-turret/laser-ground-light-head.png",
          draw_as_light = true,
          flags = {"light"},
          line_length = 1,
          width = 256,
          height = 256,
          repeat_count = 8,
          scale = 0.5,
          shift = util.by_pixel(-32, 0),
          animation_speed = 0.5,
          tint = {0.5, 0.05, 0.05}
        },
        tail =
        {
          filename = "__base__/graphics/entity/laser-turret/laser-ground-light-tail.png",
          draw_as_light = true,
          flags = {"light"},
          line_length = 1,
          width = 256,
          height = 256,
          repeat_count = 8,
          scale = 0.5,
          shift = util.by_pixel(32, 0),
          animation_speed = 0.5,
          tint = {0.5, 0.05, 0.05}
        },
        body =
        {
          filename = "__base__/graphics/entity/laser-turret/laser-ground-light-body.png",
          draw_as_light = true,
          flags = {"light"},
          line_length = 1,
          width = 64,
          height = 256,
          repeat_count = 8,
          scale = 0.5,
          animation_speed = 0.5,
          tint = {0.5, 0.05, 0.05}
        }
        -- render_layer = "projectile"
      }
    }
  }

  if sound then
    result.working_sound =
    {
      sound =
      {
        category = "weapon",
        filename = "__base__/sound/fight/laser-beam.ogg",
        volume = 0.75,
        modifiers = volume_multiplier("main-menu", 2.5)
      },
      max_sounds_per_prototype = 1
    }
    result.name = "gray-laser-beam"
  else
    result.name = "gray-laser-beam-no-sound"
  end
  return result
end

data:extend(
{
  make_laser_beam(true)
}
)