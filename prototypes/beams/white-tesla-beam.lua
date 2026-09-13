local space_age_sounds = require("__space-age__.prototypes.entity.sounds")

local white_beam_blend_mode = "additive"
local white_beam_flags = { "trilinear-filtering" }
local white_beam_tint = {1, 1, 1}

local function white_tesla_body_sprite(token)
  return
  {
    util.sprite_load("__space-age__/graphics/entity/beam/tesla-body-" .. token,
    {
      frame_count = 20,
      repeat_count = 4,
      draw_as_glow = true,
      animation_speed = 0.5,
      scale = 0.5,
      tint = white_beam_tint,
      blend_mode = white_beam_blend_mode
    }),
    util.sprite_load("__space-age__/graphics/entity/beam/lightning-loop-" .. token,
    {
      frame_count = 80,
      draw_as_glow = true,
      animation_speed = 0.5,
      scale = 0.5,
      tint = white_beam_tint,
      blend_mode = white_beam_blend_mode
    })
  }
end

local function white_tesla_chain_sprite(token)
  return
  {
    util.sprite_load("__space-age__/graphics/entity/beam/chain-body-0",
    {
      frame_count = 1,
      repeat_count = 40,
      draw_as_glow = true,
      animation_speed = 0.5,
      scale = 0.5,
      tint = white_beam_tint,
      blend_mode = white_beam_blend_mode
    }),
    util.sprite_load("__space-age__/graphics/entity/beam/chain-body-" .. token,
    {
      frame_count = 40,
      draw_as_glow = true,
      animation_speed = 0.5,
      scale = 0.5,
      tint = white_beam_tint,
      blend_mode = white_beam_blend_mode
    })
  }
end

local function white_tesla_ground_lights()
  return
  {
    head =
    {
      filename = "__base__/graphics/entity/laser-turret/laser-ground-light-head.png",
      draw_as_light = true,
      flags = {"light"},
      line_length = 1,
      width = 256,
      height = 256,
      scale = 0.5,
      shift = util.by_pixel(-32, 0),
      animation_speed = 0.5,
      tint = white_beam_tint
    },
    tail =
    {
      filename = "__base__/graphics/entity/laser-turret/laser-ground-light-tail.png",
      draw_as_light = true,
      flags = {"light"},
      line_length = 1,
      width = 256,
      height = 256,
      scale = 0.5,
      shift = util.by_pixel(32, 0),
      animation_speed = 0.5,
      tint = white_beam_tint
    },
    body =
    {
      filename = "__base__/graphics/entity/laser-turret/laser-ground-light-body.png",
      draw_as_light = true,
      flags = {"light"},
      line_length = 1,
      width = 64,
      height = 256,
      scale = 0.5,
      animation_speed = 0.5,
      tint = white_beam_tint
    }
  }
end

local function white_tesla_beam_graphics()
  local graphics_set =
  {
    desired_segment_length = 1,
    randomize_animation_per_segment = true
  }

  graphics_set.beam =
  {
    start = util.sprite_load("__space-age__/graphics/entity/beam/tesla-beam-START",
    {
      flags = white_beam_flags,
      frame_count = 20,
      draw_as_glow = true,
      tint = white_beam_tint,
      animation_speed = 0.5,
      scale = 0.5
    }),

    ending = util.sprite_load("__space-age__/graphics/entity/beam/tesla-beam-END",
    {
      flags = white_beam_flags,
      frame_count = 20,
      draw_as_glow = true,
      tint = white_beam_tint,
      animation_speed = 0.5,
      scale = 0.5
    }),

    head = util.sprite_load("__space-age__/graphics/entity/beam/tesla-head",
    {
      flags = white_beam_flags,
      frame_count = 20,
      draw_as_glow = true,
      animation_speed = 0.5,
      scale = 0.5,
      tint = white_beam_tint,
      blend_mode = white_beam_blend_mode
    }),

    tail = util.sprite_load("__space-age__/graphics/entity/beam/tesla-tail",
    {
      flags = white_beam_flags,
      frame_count = 20,
      draw_as_glow = true,
      animation_speed = 0.5,
      scale = 0.5,
      tint = white_beam_tint,
      blend_mode = white_beam_blend_mode
    }),

    body =
    {
      {layers = white_tesla_body_sprite('1')},
      {layers = white_tesla_body_sprite('2')},
      {layers = white_tesla_body_sprite('3')},
      {layers = white_tesla_body_sprite('4')},
      {layers = white_tesla_body_sprite('5')},
      {layers = white_tesla_body_sprite('6')},
    }
  }

  graphics_set.ground = white_tesla_ground_lights()

  return graphics_set
end

local function white_tesla_chain_graphics()
  local graphics_set =
  {
    desired_segment_length = 1,
    randomize_animation_per_segment = true
  }

  graphics_set.beam =
  {
    start = util.sprite_load("__space-age__/graphics/entity/beam/chain-beam-START",
    {
      flags = white_beam_flags,
      frame_count = 20,
      draw_as_glow = true,
      tint = white_beam_tint,
      animation_speed = 0.5,
      scale = 0.5
    }),

    ending = util.sprite_load("__space-age__/graphics/entity/beam/chain-beam-END",
    {
      flags = white_beam_flags,
      frame_count = 20,
      draw_as_glow = true,
      tint = white_beam_tint,
      animation_speed = 0.5,
      scale = 0.5
    }),

    head = {layers = white_tesla_chain_sprite('1')},
    tail = {layers = white_tesla_chain_sprite('6')},

    body =
    {
      {layers = white_tesla_chain_sprite('1')},
      {layers = white_tesla_chain_sprite('2')},
      {layers = white_tesla_chain_sprite('3')},
      {layers = white_tesla_chain_sprite('4')},
      {layers = white_tesla_chain_sprite('5')},
      {layers = white_tesla_chain_sprite('6')},
    }
  }

  graphics_set.ground = white_tesla_ground_lights()

  return graphics_set
end

-- Primary hit: fired at the turret's initial target, carries the visual beam
local whiteTeslaBeamStart =
{
  type = "beam",
  name = "white-tesla-beam-start",
  flags = {"not-on-map"},
  hidden = true,
  width = 0.5,
  damage_interval = 20,
  random_target_offset = true,
  target_offset = {0, 0},
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
          damage = { amount = 200, type = "electric" }
        },
        {
          type = "push-back",
          distance = 0.5
        },
        {
          type = "create-sticker",
          sticker = "tesla-turret-stun"
        },
        {
          type = "create-sticker",
          sticker = "tesla-turret-slow"
        },
        {
          type = "play-sound",
          sound = space_age_sounds.tesla_turret_beam_deflect
        }
      }
    }
  },
  graphics_set = white_tesla_beam_graphics(),
  working_sound =
  {
    sound = {category = "weapon", filename = "__space-age__/sound/entity/tesla-turret/tesla-turret-beam.ogg", volume = 1.0},
    max_sounds_per_prototype = 4
  }
}

-- Chain jump hit: fired at each additional target the chain jumps to
local whiteTeslaBeamBounce =
{
  type = "beam",
  name = "white-tesla-beam-bounce",
  flags = {"not-on-map"},
  hidden = true,
  width = 0.5,
  damage_interval = 20,
  random_target_offset = true,
  target_offset = {0, 0},
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
          damage = { amount = 200, type = "electric" }
        },
        {
          type = "push-back",
          distance = 0.25
        },
        {
          type = "create-sticker",
          sticker = "tesla-turret-stun"
        },
        {
          type = "create-sticker",
          sticker = "tesla-turret-slow"
        }
      }
    }
  },
  graphics_set = white_tesla_chain_graphics(),
  working_sound =
  {
    sound = {category = "weapon", filename = "__space-age__/sound/entity/tesla-turret/tesla-turret-chain-beam.ogg", volume = 0.8},
    max_sounds_per_prototype = 4
  }
}

-- Finds nearby targets to jump to and fires the bounce beam at each one
local whiteTeslaChain =
{
  type = "chain-active-trigger",
  name = "tier-five-tesla-chain",
  max_jumps = 3,
  max_range_per_jump = 6,
  max_range = 20,
  jump_delay_ticks = 4,
  fork_chance = 0,
  action =
  {
    type = "direct",
    action_delivery =
    {
      type = "beam",
      beam = "white-tesla-beam-bounce",
      max_length = 40,
      duration = 30,
      add_to_shooter = false,
      destroy_with_source_or_target = false,
      source_offset = {0, -2.6}
    }
  }
}

data:extend({
  whiteTeslaBeamStart,
  whiteTeslaBeamBounce,
  whiteTeslaChain
})
