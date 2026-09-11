require ("__base__.prototypes.entity.enemy-constants")
require ("__base__.prototypes.entity.biter-animations")
require ("__base__.prototypes.entity.spitter-animations")
require ("__base__.prototypes.entity.spawner-animation")
local biter_ai_settings = require ("__base__.prototypes.entity.biter-ai-settings")
local enemy_autoplace = require ("__base__.prototypes.entity.enemy-autoplace-utils")
local sounds = require ("__base__.prototypes.entity.sounds")
local hit_effects = require ("__base__.prototypes.entity.hit-effects")
local simulations = require("__base__.prototypes.factoriopedia-simulations")

-- resistances =
--     {
--       {
--         type = "fire",
--         decrease = 0,
--         percent = 100
--       },
--       {
--         type = "physical",
--         decrease = 0,
--         percent = 100
--       },
--       {
--         type = "impact",
--         decrease = 0,
--         percent = 0
--       },
--       {
--         type = "explosion",
--         decrease = 0,
--         percent = 100
--       },
--       {
--         type = "acid",
--         decrease = 0,
--         percent = 100
--       },
--       {
--         type = "laser",
--         decrease = 0,
--         percent = 100
--       },
--       {
--         type = "electric",
--         decrease = 0,
--         percent = 100
--       },
--     },

local make_unit_melee_ammo_type = function(damage_value)
  return
  {
    target_type = "entity",
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "damage",
          damage = { amount = damage_value , type = "physical"}
        }
      }
    }
  }
end

local bossBiter1Scale = 2
local bossBiter1Tint1 = {0.5, 0.5, 0.5, 1}
local bossBiter1Tint2 = {0.15, 0.15, 0.15, 0.7}
local bossBiter1 = {
  type = "unit",
  name = "boss-biter-1",
  order="b-a-c",
  icon = "__base__/graphics/icons/big-biter.png",
  flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air", "not-repairable"},
  max_health = 5000,
  subgroup = "enemies",
  factoriopedia_simulation = simulations.factoriopedia_big_biter,
  impact_category = "organic",
  resistances =
  {
    {
      type = "physical",
      percent = 25
    }
  },
  spawning_time_modifier = 3,
  healing_per_tick = 0.00,
  collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
  selection_box = {{-0.7, -1.5}, {0.7, 0.3}},
  damaged_trigger_effect = hit_effects.biter(),
  sticker_box = {{-0.6, -0.8}, {0.6, 0}},
  distraction_cooldown = 300,
  min_pursue_time = 10 * 60,
  max_pursue_distance = 50,
  attack_parameters =
  {
    type = "projectile",
    range = 1.5,
    cooldown = 25,
    cooldown_deviation = 0.15,
    ammo_category = "melee",
    ammo_type = make_unit_melee_ammo_type(200),
    sound =  sounds.biter_roars_big(0.37),
    animation = biterattackanimation(bossBiter1Scale, bossBiter1Tint1, bossBiter1Tint2),
    range_mode = "bounding-box-to-bounding-box"
  },
  vision_distance = 30,
  movement_speed = 0.18,
  distance_per_frame = 0.30,
  -- in pu
  absorptions_to_join_attack = { pollution = 80 },
  corpse = "big-biter-corpse",
  dying_explosion = "big-biter-die",
  working_sound = sounds.biter_calls_big(0.4, 0.7),
  dying_sound = sounds.biter_dying_big(0.45),
  run_animation = biterrunanimation(bossBiter1Scale, bossBiter1Tint1, bossBiter1Tint2),
  running_sound_animation_positions = {2,},
  walking_sound = sounds.biter_walk_big(0.6, 0.7),
  ai_settings = biter_ai_settings,
  water_reflection = biter_water_reflection(bossBiter1Scale)
}

local smallPhysicalBiterScale = 0.25
local smallPhysicalBiterTint1 = {0.1, 0.1, 0.9, 1}
local smallPhysicalBiterTint2 = {0.15, 0.15, 0.15, 0.7}
local smallPhysicalBiter = {
  type = "unit",
  name = "small-physical-biter",
  order="b-a-c",
  icon = "__base__/graphics/icons/small-biter.png",
  flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air", "not-repairable"},
  max_health = 25,
  subgroup = "enemies",
  factoriopedia_simulation = simulations.factoriopedia_big_biter,
  impact_category = "organic",
  resistances =
  {
    {
      type = "physical",
      percent = 15
    }
  },
  spawning_time_modifier = 3,
  healing_per_tick = 0.01,
  collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
  selection_box = {{-0.4, -0.7}, {0.4, 0.4}},
  damaged_trigger_effect = hit_effects.biter(),
  sticker_box = {{-0.6, -0.8}, {0.6, 0}},
  distraction_cooldown = 300,
  min_pursue_time = 10 * 60,
  max_pursue_distance = 50,
  attack_parameters =
  {
    type = "projectile",
    range = 0.5,
    cooldown = 25,
    cooldown_deviation = 0.15,
    ammo_category = "melee",
    ammo_type = make_unit_melee_ammo_type(10),
    sound =  sounds.biter_roars(0.37),
    animation = biterattackanimation(smallPhysicalBiterScale, smallPhysicalBiterTint1, smallPhysicalBiterTint2),
    range_mode = "bounding-box-to-bounding-box"
  },
  vision_distance = 30,
  movement_speed = 0.4,
  distance_per_frame = 0.1,
  -- in pu
  absorptions_to_join_attack = { pollution = 80 },
  corpse = "small-biter-corpse",
  dying_explosion = "small-biter-die",
    dying_sound = sounds.biter_dying(0.5),
    working_sound = sounds.biter_calls(0.4, 0.75),
  run_animation = biterrunanimation(smallPhysicalBiterScale, smallPhysicalBiterTint1, smallPhysicalBiterTint2),
  running_sound_animation_positions = {2,},
  walking_sound = sounds.biter_walk(0, 0.3),
  ai_settings = biter_ai_settings,
  water_reflection = biter_water_reflection(smallPhysicalBiterScale)
}

local mediumPhysicalBiterScale = 0.5
local mediumPhysicalBiter = {
  type = "unit",
  name = "medium-physical-biter",
  order="b-a-c",
  icon = "__base__/graphics/icons/medium-biter.png",
  flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air", "not-repairable"},
  max_health = 125,
  subgroup = "enemies",
  factoriopedia_simulation = simulations.factoriopedia_big_biter,
  impact_category = "organic",
  resistances =
  {
    {
      type = "physical",
      percent = 25
    }
  },
  spawning_time_modifier = 3,
  healing_per_tick = 0.01,
  collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
  selection_box = {{-0.4, -0.7}, {0.4, 0.4}},
  damaged_trigger_effect = hit_effects.biter(),
  sticker_box = {{-0.6, -0.8}, {0.6, 0}},
  distraction_cooldown = 300,
  min_pursue_time = 10 * 60,
  max_pursue_distance = 50,
  attack_parameters =
  {
    type = "projectile",
    range = 0.5,
    cooldown = 25,
    cooldown_deviation = 0.15,
    ammo_category = "melee",
    ammo_type = make_unit_melee_ammo_type(25),
    sound =  sounds.biter_roars(0.37),
    animation = biterattackanimation(mediumPhysicalBiterScale, smallPhysicalBiterTint1, smallPhysicalBiterTint2),
    range_mode = "bounding-box-to-bounding-box"
  },
  vision_distance = 30,
  movement_speed = 0.25,
  distance_per_frame = 0.188,
  -- in pu
  absorptions_to_join_attack = { pollution = 80 },
  corpse = "small-biter-corpse",
  dying_explosion = "small-biter-die",
    dying_sound = sounds.biter_dying(0.5),
    working_sound = sounds.biter_calls(0.4, 0.75),
  run_animation = biterrunanimation(mediumPhysicalBiterScale, smallPhysicalBiterTint1, smallPhysicalBiterTint2),
  running_sound_animation_positions = {2,},
  walking_sound = sounds.biter_walk(0, 0.3),
  ai_settings = biter_ai_settings,
  water_reflection = biter_water_reflection(mediumPhysicalBiterScale)
}

local bigPhysicalBiterScale = 0.75
local bigPhysicalBiter = {
  type = "unit",
  name = "big-physical-biter",
  order="b-a-c",
  icon = "__base__/graphics/icons/big-biter.png",
  flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air", "not-repairable"},
  max_health = 450,
  subgroup = "enemies",
  factoriopedia_simulation = simulations.factoriopedia_big_biter,
  impact_category = "organic",
  resistances =
  {
    {
      type = "physical",
      percent = 45
    }
  },
  spawning_time_modifier = 3,
  healing_per_tick = 0.00,
  collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
  selection_box = {{-0.7, -1.5}, {0.7, 0.3}},
  damaged_trigger_effect = hit_effects.biter(),
  sticker_box = {{-0.6, -0.8}, {0.6, 0}},
  distraction_cooldown = 300,
  min_pursue_time = 10 * 60,
  max_pursue_distance = 50,
  attack_parameters =
  {
    type = "projectile",
    range = 1.5,
    cooldown = 25,
    cooldown_deviation = 0.2,
    ammo_category = "melee",
    ammo_type = make_unit_melee_ammo_type(50),
    sound =  sounds.biter_roars_big(0.37),
    animation = biterattackanimation(bigPhysicalBiterScale, smallPhysicalBiterTint1, smallPhysicalBiterTint2),
    range_mode = "bounding-box-to-bounding-box"
  },
  vision_distance = 30,
  movement_speed = 0.18,
  distance_per_frame = 0.30,
  -- in pu
  absorptions_to_join_attack = { pollution = 80 },
  corpse = "big-biter-corpse",
  dying_explosion = "big-biter-die",
  working_sound = sounds.biter_calls_big(0.4, 0.7),
  dying_sound = sounds.biter_dying_big(0.45),
  run_animation = biterrunanimation(bigPhysicalBiterScale, smallPhysicalBiterTint1, smallPhysicalBiterTint2),
  running_sound_animation_positions = {2,},
  walking_sound = sounds.biter_walk_big(0.6, 0.7),
  ai_settings = biter_ai_settings,
  water_reflection = biter_water_reflection(bigPhysicalBiterScale)
}

local behemothPhysicalBiterScale = 1.2
local behemothPhysicalBiter = {
  type = "unit",
  name = "behemoth-physical-biter",
  order="b-a-c",
  icon = "__base__/graphics/icons/behemoth-biter.png",
  flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air", "not-repairable"},
  max_health = 3500,
  subgroup = "enemies",
  factoriopedia_simulation = simulations.factoriopedia_behemoth_biter,
  impact_category = "organic",
  resistances =
  {
    {
      type = "physical",
      percent = 75
    }
  },
  spawning_time_modifier = 3,
  healing_per_tick = 0.00,
  collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
  selection_box = {{-0.7, -1.5}, {0.7, 0.3}},
  damaged_trigger_effect = hit_effects.biter(),
  sticker_box = {{-0.6, -0.8}, {0.6, 0}},
  distraction_cooldown = 300,
  min_pursue_time = 10 * 60,
  max_pursue_distance = 50,
  attack_parameters =
  {
    type = "projectile",
    range = 1.5,
    cooldown = 25,
    cooldown_deviation = 0.2,
    ammo_category = "melee",
    ammo_type = make_unit_melee_ammo_type(150),
    sound =  sounds.biter_roars_behemoth(0.37),
    animation = biterattackanimation(behemothPhysicalBiterScale, smallPhysicalBiterTint1, smallPhysicalBiterTint2),
    range_mode = "bounding-box-to-bounding-box"
  },
  vision_distance = 30,
  movement_speed = 0.15,
  distance_per_frame = 0.32,
  -- in pu
  absorptions_to_join_attack = { pollution = 80 },
  corpse = "big-biter-corpse",
  dying_explosion = "big-biter-die",
  working_sound = sounds.biter_calls_behemoth(0.5, 0.9),
  dying_sound = sounds.biter_dying_big(0.5),
  run_animation = biterrunanimation(behemothPhysicalBiterScale, smallPhysicalBiterTint1, smallPhysicalBiterTint2),
  running_sound_animation_positions = {2,},
  walking_sound = sounds.biter_walk_big(0.6, 0.8),
  ai_settings = biter_ai_settings,
  water_reflection = biter_water_reflection(behemothPhysicalBiterScale)
}

data:extend({
  bossBiter1,
  smallPhysicalBiter,
  mediumPhysicalBiter,
  bigPhysicalBiter,
  behemothPhysicalBiter
})

local smallBiter = data.raw["unit"]["small-biter"]
local small_biter_scale = 0.25
smallBiter.run_animation = biterrunanimation(
	small_biter_scale,
	bossBiter1Tint1,
	bossBiter1Tint2
)
smallBiter.attack_parameters.animation = biterattackanimation(
	small_biter_scale,
	bossBiter1Tint1,
	bossBiter1Tint2
)

local mediumBiter = data.raw["unit"]["medium-biter"]
local medium_biter_scale = 0.5
mediumBiter.run_animation = biterrunanimation(
	medium_biter_scale,
	bossBiter1Tint1,
	bossBiter1Tint2
)
mediumBiter.attack_parameters.animation = biterattackanimation(
	medium_biter_scale,
	bossBiter1Tint1,
	bossBiter1Tint2
)

local bigBiter = data.raw["unit"]["big-biter"]
local big_biter_scale = 0.75
bigBiter.run_animation = biterrunanimation(
	big_biter_scale,
	bossBiter1Tint1,
	bossBiter1Tint2
)
bigBiter.attack_parameters.animation = biterattackanimation(
	big_biter_scale,
	bossBiter1Tint1,
	bossBiter1Tint2
)

local behemothBiter = data.raw["unit"]["behemoth-biter"]
local behemoth_biter_scale = 1.2
behemothBiter.run_animation = biterrunanimation(
	behemoth_biter_scale,
	bossBiter1Tint1,
	bossBiter1Tint2
)
behemothBiter.attack_parameters.animation = biterattackanimation(
	behemoth_biter_scale,
	bossBiter1Tint1,
	bossBiter1Tint2
)