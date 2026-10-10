-- UT Acid Shooter: 4x4 tower made from the space age rocket turret graphics (3x3, scaled up), tinted bright green.
-- like the ut-poison-cannon-one it is an electric-turret with a void energy source, so it needs no ammo and no power.
-- it spits a goopy bright green acid stream (the worm acid stream, recolored) that only deals acid damage:
--   * the glob splashes acid on every enemy around where it lands
--   * it leaves a bubbling acid puddle that keeps burning enemies walking through it
--   * anything hit gets a corrosive coating (sticker) that slows it down and eats away at it
-- everything only hits enemies of the turret's force, so it never hurts your own base

local acidTint = {0.35, 1, 0.2, 1}
-- the goop itself, a bit brighter and see-through like the vanilla acid
local goopTint = {0.4, 1, 0.15, 0.9}

-- the rocket turret is 3x3, everything is scaled up to 4x4
local GRAPHICS_SCALE = 4 / 3

local RANGE = 45
local MIN_RANGE = 7
-- ticks between spits
local COOLDOWN = 60
-- acid damage to every enemy within SPLASH_RADIUS of where a glob lands
local SPLASH_DAMAGE = 1000
local SPLASH_RADIUS = 5
-- acid damage per second to enemies standing in a puddle. a puddle (fire) only applies its damage every
-- PUDDLE_DAMAGE_INTERVAL ticks, so each hit is PUDDLE_DAMAGE_PER_SECOND / (60 / PUDDLE_DAMAGE_INTERVAL)
local PUDDLE_DAMAGE_PER_SECOND = 250
local PUDDLE_DAMAGE_INTERVAL = 10
local PUDDLE_LIFETIME = 6 * 60
-- how much bigger the puddle looks than the vanilla behemoth worm acid splash, and the radius it hurts enemies in
local PUDDLE_GRAPHICS_SCALE = 1.5
local PUDDLE_RADIUS = 2
-- the corrosive coating: enemies start at this share of their speed and recover to full speed over the
-- coating duration (half the slow of the vanilla behemoth acid, which starts at 0.3), and it burns them
local COATING_SPEED_MODIFIER = 0.5
local COATING_DAMAGE_PER_TICK = 2
local COATING_DURATION = 3 * 60

--------------------------------------------------------------------------------
-- helpers
--------------------------------------------------------------------------------

local function isSprite(t)
  return (t.filename or t.filenames or t.stripes) and (t.width or t.height or t.size)
end

-- scales every sprite (and its shift) inside a graphics table, sounds are left alone
local function scaleGraphics(t, factor)
  if type(t) ~= "table" then
    return
  end
  if isSprite(t) then
    t.scale = (t.scale or 1) * factor
    if t.shift then
      t.shift = {(t.shift[1] or t.shift.x or 0) * factor, (t.shift[2] or t.shift.y or 0) * factor}
    end
  end
  for key, value in pairs(t) do
    if type(value) == "table" and not (type(key) == "string" and key:find("sound")) then
      scaleGraphics(value, factor)
    end
  end
end

-- tints every sprite except shadows. masks get the tint instead of the force color
local function tintGraphics(t, tint)
  if type(t) ~= "table" then
    return
  end
  if isSprite(t) and not t.draw_as_shadow then
    t.tint = tint
    if t.apply_runtime_tint then
      t.apply_runtime_tint = false
    end
  end
  for key, value in pairs(t) do
    if type(value) == "table" and not (type(key) == "string" and key:find("sound")) then
      tintGraphics(value, tint)
    end
  end
end

--------------------------------------------------------------------------------
-- corrosive coating (sticker)
--------------------------------------------------------------------------------

local coating = table.deepcopy(data.raw["sticker"]["acid-sticker-behemoth"])
coating.name = "ut-acid-shooter-coating"
coating.localised_name = nil
coating.duration_in_ticks = COATING_DURATION
-- the vanilla acid sticker slows with _from (start) and _to (end) values, those are what count
coating.target_movement_modifier_from = COATING_SPEED_MODIFIER
coating.target_movement_modifier_to = 1
coating.vehicle_speed_modifier_from = COATING_SPEED_MODIFIER
coating.vehicle_speed_modifier_to = 1
coating.damage_per_tick = {amount = COATING_DAMAGE_PER_TICK, type = "acid"}
coating.damage_interval = 1
tintGraphics(coating, goopTint)

--------------------------------------------------------------------------------
-- acid puddle (fire entity, like the worm acid splash)
--------------------------------------------------------------------------------

local puddle = table.deepcopy(data.raw["fire"]["acid-splash-fire-worm-behemoth"])
puddle.name = "ut-acid-shooter-puddle"
puddle.localised_name = nil
puddle.initial_lifetime = PUDDLE_LIFETIME
puddle.maximum_lifetime = PUDDLE_LIFETIME
-- every enemy ground unit within PUDDLE_RADIUS of the puddle, not only the ones standing right on it
puddle.on_damage_tick_effect = {
  type = "area",
  radius = PUDDLE_RADIUS,
  force = "enemy",
  ignore_collision_condition = true,
  trigger_target_mask = {"ground-unit"},
  action_delivery = {
    type = "instant",
    target_effects = {
      {
        type = "create-sticker",
        sticker = coating.name,
        show_in_tooltip = true
      },
      {
        type = "damage",
        damage = {amount = PUDDLE_DAMAGE_PER_SECOND / (60 / PUDDLE_DAMAGE_INTERVAL), type = "acid"},
        apply_damage_to_trees = false
      }
    }
  }
}
scaleGraphics(puddle.pictures, PUDDLE_GRAPHICS_SCALE)
scaleGraphics(puddle.secondary_pictures, PUDDLE_GRAPHICS_SCALE)
tintGraphics(puddle, goopTint)

--------------------------------------------------------------------------------
-- the goopy acid stream
--------------------------------------------------------------------------------

local stream = table.deepcopy(data.raw["stream"]["acid-stream-worm-behemoth"])
stream.name = "ut-acid-shooter-stream"
stream.localised_name = nil
-- no damage to trees and rocks
stream.special_neutral_target_damage = nil
stream.initial_action = {
  {
    type = "direct",
    action_delivery = {
      type = "instant",
      target_effects = {
        -- keep the vanilla acid splash sound
        stream.initial_action[1].action_delivery.target_effects[1],
        {
          type = "create-fire",
          entity_name = puddle.name,
          tile_collision_mask = {layers = {water_tile = true}},
          show_in_tooltip = true
        },
        {
          type = "create-entity",
          entity_name = "water-splash",
          tile_collision_mask = {layers = {ground_tile = true}}
        }
      }
    }
  },
  {
    type = "area",
    radius = SPLASH_RADIUS,
    force = "enemy",
    ignore_collision_condition = true,
    action_delivery = {
      type = "instant",
      target_effects = {
        {
          type = "create-sticker",
          sticker = coating.name
        },
        {
          type = "damage",
          damage = {amount = SPLASH_DAMAGE, type = "acid"}
        }
      }
    }
  }
}
tintGraphics(stream.particle, goopTint)
tintGraphics(stream.spine_animation, goopTint)

--------------------------------------------------------------------------------
-- the turret
--------------------------------------------------------------------------------

local turret = table.deepcopy(data.raw["ammo-turret"]["rocket-turret"])
turret.type = "electric-turret"
turret.name = "ut-acid-shooter"
turret.icon = nil
turret.icons = {
  {
    icon = "__space-age__/graphics/icons/rocket-turret.png",
    icon_size = 64,
    tint = acidTint
  }
}
turret.minable = {mining_time = 0.5, result = "ut-acid-shooter"}
-- ammo-turret only fields
turret.inventory_size = nil
turret.automated_ammo_count = nil
-- needs no power, no ammo
turret.energy_source = {type = "void"}
turret.heating_energy = nil
-- the circuit connector is placed for the 3x3 sprite
turret.circuit_connector = nil
turret.circuit_wire_max_distance = nil
turret.fast_replaceable_group = nil
turret.next_upgrade = nil
turret.max_health = 1500
turret.resistances = {
  {type = "acid", percent = 100},
  {type = "fire", percent = 60}
}
turret.corpse = "big-remnants"
turret.dying_explosion = "big-explosion"

-- 4x4
turret.collision_box = {{-1.7, -1.7}, {1.7, 1.7}}
turret.selection_box = {{-2, -2}, {2, 2}}
turret.rotation_speed = 0.01

for _, animationName in pairs({"folded_animation", "preparing_animation", "prepared_animation", "attacking_animation", "folding_animation", "graphics_set"}) do
  scaleGraphics(turret[animationName], GRAPHICS_SCALE)
  tintGraphics(turret[animationName], acidTint)
end
if turret.water_reflection and turret.water_reflection.pictures then
  turret.water_reflection.pictures.scale = (turret.water_reflection.pictures.scale or 1) * GRAPHICS_SCALE
end

turret.prepare_range = RANGE + 5
turret.attack_parameters = {
  type = "stream",
  ammo_category = "biological",
  cooldown = COOLDOWN,
  range = RANGE,
  min_range = MIN_RANGE,
  turn_range = 1,
  -- the stream starts from the top of the turret head
  gun_center_shift = {0, -1.2 * GRAPHICS_SCALE},
  gun_barrel_length = 0.8 * GRAPHICS_SCALE,
  -- same as the stream's particle_horizontal_speed so it aims ahead of moving biters
  lead_target_for_projectile_speed = stream.particle_horizontal_speed,
  rotate_penalty = 1,
  health_penalty = 0,
  ammo_type = {
    target_type = "position",
    action = {
      type = "direct",
      action_delivery = {
        type = "stream",
        stream = stream.name,
        source_offset = {0, -0.5}
      }
    }
  }
}
turret.call_for_help_radius = 50

data:extend({
  coating,
  puddle,
  stream,
  turret
})
