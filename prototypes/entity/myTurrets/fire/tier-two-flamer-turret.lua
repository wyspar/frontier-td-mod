require("util")
require("circuit-connector-sprites")

local sounds = require("__base__.prototypes.entity.sounds")
local fireutil = require("__base__.prototypes.fire-util")
local color_flame =
{
  r = 0.1,
  g = 1.0,
  b = 0.1,
  a = 0.85
}

local color_flame_glow =
{
  r = 0.15,
  g = 1.0,
  b = 0.15,
  a = 0.65
}

local turretTint = {r=0.1, g=1.0, b=0.1, a=1}

local color_flame_sticker = {
  r = 0.1,
  g = 1.0,
  b = 0.1,
  a = 0.30
}

-- COLORED FIRE
data:extend(
{
  {
    type = "fire",
    name = "tier-two-green-fire",
    flags =
    {
      "placeable-off-grid",
      "not-on-map"
    },
    hidden = true,
    damage_per_tick =
    {
      amount = 1 / 60,
      type = "fire"
    },
    maximum_damage_multiplier = 6,
    damage_multiplier_increase_per_added_fuel = 1,
    damage_multiplier_decrease_per_tick = 0.005,
    spread_delay = 300,
    spread_delay_deviation = 180,
    maximum_spread_count = 100,
    emissions_per_second =
    {
      pollution = 0.005
    },
    initial_lifetime = 120,
    lifetime_increase_by = 150,
    lifetime_increase_cooldown = 4,
    maximum_lifetime = 1800,
    delay_between_initial_flames = 10,
    pictures =
      fireutil.create_fire_pictures(
        {
          tint = color_flame
        }
      ),
    smoke_source_pictures =
      fireutil.create_fire_smoke_source_pictures(
        0.6,
        util.premul_color
        {
          r = color_flame.r,
          g = color_flame.g,
          b = color_flame.b,
          a = color_flame.a
        }
      ),

    light =
    {
      intensity = 0.5,
      size = 8,
      color = color_flame
    },

    working_sound =
    {
      sound =
      {
        category = "weapon",
        filename = "__base__/sound/fire-1.ogg"
      },

      max_sounds_per_prototype = 2
    }
  }
})


-- FIRE STICKER
data:extend(
{
  {
    type = "sticker",
    name = "tier-two-green-fire-sticker",
    flags =
    {
      "not-on-map"
    },
    hidden = true,
    animation =
    {
      filename =
        "__base__/graphics/entity/fire-flame/fire-flame-01.png",
      line_length = 10,
      width = 84,
      height = 130,
      frame_count = 90,
      blend_mode = "normal",
      animation_speed = 1,
      scale = 0.4,
      tint = color_flame_sticker,
      shift =
      {
        -0.078125 * 0.1,
        -1.8125 * 0.1
      },
      draw_as_glow = true
    },
    duration_in_ticks = 30 * 60,
    damage_interval = 10,
    target_movement_modifier = 0.8,
    damage_per_tick =
    {
      amount = 3 / 60,
      type = "fire"
    },
    spread_fire_entity = "tier-two-green-fire",
    fire_spread_cooldown = 30,
    fire_spread_radius = 0.75
  }
})


-- FLAMETHROWER STREAM
local flamer_stream_spine =
{
  filename =
    "__base__/graphics/entity/flamethrower-fire-stream/flamethrower-fire-stream-spine.png",

  blend_mode = "normal",
  tint = color_flame_glow,
  line_length = 6,
  width = 54,
  height = 26,
  frame_count = 36,
  animation_speed = 2,
  shift = {0, 0}
}

local flamer_stream_shadow =
{
  filename =
    "__base__/graphics/entity/acid-projectile/projectile-shadow.png",

  line_length = 5,
  width = 28,
  height = 16,
  frame_count = 33,
  priority = "high",
  shift = {-0.09, 0.395}
}

local flamer_stream_particle =
{
  filename =
    "__base__/graphics/entity/flamethrower-fire-stream/flamethrower-explosion.png",
  priority = "extra-high",
  blend_mode = "normal",
  tint = color_flame_glow,
  line_length = 6,
  width = 124,
  height = 108,
  frame_count = 36,
  scale = 0.666
}

------------------------------------------------------------
-- STREAM
--
-- This is NOT a fluid stream.
--
-- The turret creates this directly.
-- There is therefore NO oil requirement.
------------------------------------------------------------

data:extend(
{
  {
    type = "stream",
    name = "tier-two-green-flame-stream",
    flags =
    {
      "not-on-map"
    },
    hidden = true,
    smoke_sources =
    {
      {
        name = "soft-fire-smoke",
        frequency = 0.05,
        position = {0, 0},
        starting_frame_deviation = 60
      }
    },

    particle_buffer_size = 90,
    particle_spawn_interval = 2,
    particle_spawn_timeout = 8,
    particle_vertical_acceleration =
      0.005 * 0.60,
    particle_horizontal_speed =
      0.2 * 0.75 * 1.5,
    particle_horizontal_speed_deviation =
      0.005 * 0.70,
    particle_start_alpha =
      0.5 / 0.666,
    particle_end_alpha = 1,
    particle_start_scale = 0.2,
    particle_loop_frame_count = 3,
    particle_fade_out_threshold = 0.9,
    particle_loop_exit_threshold = 0.25,
    action =
    {
      {
        type = "area",
        radius = 2.5,
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-sticker",
              sticker =
                "tier-two-green-fire-sticker",
              show_in_tooltip = true
            },
            {
              type = "damage",
              damage =
              {
                amount = 3,
                type = "fire"
              },
              apply_damage_to_trees = false
            }
          }
        }
      },
      {
        type = "direct",
        action_delivery =
        {
          type = "instant",
          target_effects =
          {
            {
              type = "create-fire",
              entity_name =
                "tier-two-green-fire",
              show_in_tooltip = true,
              initial_ground_flame_count = 2
            }
          }
        }
      }
    },

    spine_animation =
      flamer_stream_spine,

    shadow =
      flamer_stream_shadow,

    particle =
      flamer_stream_particle
  }
})

-- GUN SHIFT, this is the flamer head placement
local turret_gun_shift =
{
  north = util.by_pixel(0.0, -9.0),
  east = util.by_pixel(18.5, 6.5),
  south = util.by_pixel(0.0, 16.0),
  west = util.by_pixel(-12.0, 2.5)
}

-- FLAMETHROWER GUN ANIMATION
local function flamethrower_prepared_animation(shift, attacking)

  local diffuse =
  {
    filename =
      "__base__/graphics/entity/flamethrower-turret/flamethrower-turret-gun.png",
    priority = "medium",
    counterclockwise = true,
    line_length = 8,
    width = 158,
    height = 128,
    direction_count = 64,
    shift = util.by_pixel(-1, -32),
    scale = 0.5
  }

  local mask =
  {
    filename =
      "__base__/graphics/entity/flamethrower-turret/flamethrower-turret-gun-mask.png",
    flags = {"mask"},
    counterclockwise = true,
    line_length = 8,
    width = 144,
    height = 112,
    direction_count = 64,
    shift = util.by_pixel(-1, -35),
    apply_runtime_tint = false,
    scale = 0.5,
    tint = turretTint
  }

  local shadow =
  {
    filename =
      "__base__/graphics/entity/flamethrower-turret/flamethrower-turret-gun-shadow.png",
    counterclockwise = true,
    line_length = 8,
    width = 182,
    height = 116,
    direction_count = 64,
    shift = util.by_pixel(31, -7),
    draw_as_shadow = true,
    scale = 0.5
  }

  local layers =
  {
    diffuse,
    mask,
    shadow
  }

  -- ACTIVE GLOW
  if attacking then

    local glow =
    {
      filename =
        "__base__/graphics/entity/flamethrower-turret/flamethrower-turret-gun-active.png",

      counterclockwise = true,
      line_length = 8,
      width = 158,
      height = 126,
      direction_count = 64,
      shift = util.by_pixel(-1, -32),
      tint = color_flame_glow,
      blend_mode = "additive",
      scale = 0.5
    }

    table.insert(layers, 2, glow)
  end

  ----------------------------------------------------------
  -- APPLY DIRECTION SHIFT
  ----------------------------------------------------------

  for _, layer in pairs(layers) do

    if layer.shift then

      layer.shift =
      {
        layer.shift[1] + shift[1],
        layer.shift[2] + shift[2]
      }

    end
  end

  return
  {
    layers = layers
  }
end

------------------------------------------------------------
-- 8-WAY/DIRECTION SETS
------------------------------------------------------------

local prepared_animation =
{
  north =
    flamethrower_prepared_animation(
      turret_gun_shift.north,
      false
    ),

  east =
    flamethrower_prepared_animation(
      turret_gun_shift.east,
      false
    ),

  south =
    flamethrower_prepared_animation(
      turret_gun_shift.south,
      false
    ),

  west =
    flamethrower_prepared_animation(
      turret_gun_shift.west,
      false
    )
}

local attacking_animation =
{
  north =
    flamethrower_prepared_animation(
      turret_gun_shift.north,
      true
    ),

  east =
    flamethrower_prepared_animation(
      turret_gun_shift.east,
      true
    ),

  south =
    flamethrower_prepared_animation(
      turret_gun_shift.south,
      true
    ),

  west =
    flamethrower_prepared_animation(
      turret_gun_shift.west,
      true
    )
}

-- GUN TURRET BASE
local gun_turret_base =
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
      scale = 0.75,
      tint = turretTint
    }
  }
}

local muzzle_animation =
{
  filename =
    "__base__/graphics/entity/flamethrower-turret/flamethrower-turret-muzzle-fire.png",
  line_length = 8,
  width = 16,
  height = 30,
  frame_count = 32,
  blend_mode = "additive",
  tint = color_flame_glow,
  scale = 0.45,
  shift =
  {
    0.015625 * 0.5,
    -0.546875 * 0.5 + 0.05
  }
}


local gun_center_base =
{
  0,
  -1.5
}

local gun_center_shift =
{
  north =
  {
    gun_center_base[1] + 0,
    gun_center_base[2] - 0.15
  },

  east =
  {
    gun_center_base[1] + 0.23125,
    gun_center_base[2] + 0.11875
  },

  south =
  {
    gun_center_base[1] + 0,
    gun_center_base[2] + 0.2375
  },

  west =
  {
    gun_center_base[1] - 0.15,
    gun_center_base[2] + 0.06875
  }
}

------------------------------------------------------------
-- SELF-POWERED TURRET
--
-- IMPORTANT:
--
-- type = "turret"
--
-- NOT:
--
-- type = "ammo-turret"
--
-- type = "fluid-turret"
--
-- A normal "turret" has no ammo inventory and no
-- fluid buffer.
--
-- We use the same general technique used by vanilla
-- stream-firing turrets such as worms.
------------------------------------------------------------

data:extend(
{
  {
    type = "turret",
    name = "tier-two-flamer-turret",
    icon =
      "__base__/graphics/icons/flamethrower-turret.png",
    flags =
    {
      "placeable-player",
      "player-creation"
    },
    minable =
    {
      mining_time = 0.1,
      result = "tier-two-flamer-turret"
    },
    fast_replaceable_group =
      "tier-two-flamer-turret",
    max_health = 100,
    corpse = "gun-turret-remnants",
    dying_explosion = "medium-explosion",
    collision_box = {{-1.2, -1.2 }, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5 }, {1.5, 1.5}},
    drawing_box_vertical_extension = 0.3,
    rotation_speed = 0.02,
    preparing_speed = 0.1,
    folding_speed = 0.1,
    attacking_speed = 1,
    ending_attack_speed = 0.2,
    open_sound = sounds.turret_open,
    close_sound = sounds.turret_close,
    preparing_sound =
      sounds.flamethrower_turret_activate,
    folding_sound =
      sounds.flamethrower_turret_deactivate,
    resistances =
    {
      {
        type = "fire",
        percent = 100
      }
    },

    circuit_connector =
      circuit_connector_definitions["flamethrower-turret"],
    circuit_wire_max_distance =
      default_circuit_wire_max_distance,

    turret_base_has_direction = true,

    -- gun turret base
    graphics_set =
    {
      base_visualisation =
      {
        render_layer = "object",
        secondary_draw_order = 0,
        animation =
          gun_turret_base
      }
    },

    -- FLAMETHROWER TOP
    folded_animation =
      prepared_animation,

    preparing_animation =
      prepared_animation,

    prepared_animation =
      prepared_animation,

    attacking_animation =
      attacking_animation,

    ending_attack_animation =
      attacking_animation,

    folding_animation =
      prepared_animation,

    gun_animation_render_layer = "object",

    gun_animation_secondary_draw_order = 1,

    -- MUZZLE
    muzzle_animation =
      muzzle_animation,

    muzzle_light =
    {
      size = 2,
      intensity = 0.35,
      color = turretTint
    },

    -- ATTACK
    attack_parameters =
    {
      type = "stream",
      cooldown = 4,
      range = 30,
      min_range = 6,
      turn_range = 1.0 / 3.0,
      fire_penalty = 15,

      --------------------------------------------------------
      -- IMPORTANT:
      --
      -- This is only an ammo CATEGORY identifier.
      -- There is no ammo inventory.
      -- There is no ammo item.
      -- There is no oil.
      --
      -- It allows the turret attack definition to use
      -- ammo_type while remaining a plain "turret".
      --------------------------------------------------------

      ammo_category = "biological",

      ammo_type =
      {
        action =
        {
          type = "direct",

          action_delivery =
          {
            type = "stream",
            stream =
              "tier-two-green-flame-stream",
            source_offset =
            {
              0.15,
              -0.5
            }
          }
        }
      },

      gun_center_shift =
        gun_center_shift,

      gun_barrel_length = 0.4,

      cyclic_sound =
      {
        begin_sound =
          sounds.flamethrower_turret_start,

        middle_sound =
          sounds.flamethrower_turret_mid,

        end_sound =
          sounds.flamethrower_turret_end
      }
    },

    call_for_help_radius = 40
  }
})