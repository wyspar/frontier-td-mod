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
  max_health = 25000,
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
  --only collides with tiles: walks over/through entities, but water tiles (player layer) still block it
  collision_mask = {layers = {player = true}, colliding_with_tiles_only = true, not_colliding_with_itself = true},
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
  movement_speed = 0.14,
  distance_per_frame = 0.30,
  has_belt_immunity = true,
  -- in pu
  absorptions_to_join_attack = { pollution = 80 },
  corpse = "boss-biter-1-corpse",
  dying_explosion = "boss-biter-1-die",
  working_sound = sounds.biter_calls_big(0.4, 0.7),
  dying_sound = sounds.biter_dying_big(0.45),
  run_animation = biterrunanimation(bossBiter1Scale, bossBiter1Tint1, bossBiter1Tint2),
  running_sound_animation_positions = {2,},
  walking_sound = sounds.biter_walk_big(0.6, 0.7),
  ai_settings = biter_ai_settings,
  water_reflection = biter_water_reflection(bossBiter1Scale)
}

--boss biters 3-6: copies of boss-biter-1, bigger and tankier each time, each with its own resistance theme
--boss 2 is the ultra-flyer (35000 hp, set in base-data-updates.lua)
--keep the scales/tints in sync with explosions.lua
local function allResistances(percent)
  local resistances = {}
  for _, damageType in pairs({"physical", "impact", "fire", "explosion", "acid", "poison", "laser", "electric"}) do
    table.insert(resistances, {type = damageType, percent = percent})
  end
  return resistances
end

local bossBiterTiers = {
  { --laser
    name = "boss-biter-3",
    scale = 3,
    maxHealth = 60000,
    movementSpeed = 0.10,
    damage = 300,
    tint1 = {0.9, 0.8, 0.1, 1},
    tint2 = {0.1, 0.2, 0.55, 0.8},
    resistances =
    {
      {type = "laser", percent = 50}
    }
  },
  { --explosion
    name = "boss-biter-4",
    scale = 4,
    maxHealth = 100000,
    movementSpeed = 0.10,
    damage = 450,
    tint1 = {0.9, 0.15, 0.15, 1},
    tint2 = {0.55, 0.05, 0.05, 0.8},
    resistances =
    {
      {type = "explosion", percent = 60}
    }
  },
  { --electric, laser, poison, acid
    name = "boss-biter-5",
    scale = 5,
    maxHealth = 175000,
    movementSpeed = 0.09,
    damage = 650,
    tint1 = {0.6, 0.2, 0.85, 1},
    tint2 = {0.35, 0.8, 0.2, 0.8},
    resistances =
    {
      {type = "electric", percent = 45},
      {type = "laser", percent = 45},
      {type = "poison", percent = 45},
      {type = "acid", percent = 45}
    }
  },
  { --50% everything
    name = "boss-biter-6",
    scale = 6,
    maxHealth = 1000000,
    movementSpeed = 0.05,
    damage = 1000,
    tint1 = {0.0, 0.0, 0.0, 1},
    tint2 = {0.0, 0.0, 0.0, 0.8},
    resistances = allResistances(50),
    --no "ground-unit" (the unit default is {"common", "ground-unit"}), so tesla push-back can't hit it
    triggerTargetMask = {"common"}
  },
}

local bossBiters = {}
for _, tier in pairs(bossBiterTiers) do
  local bossBiter = table.deepcopy(bossBiter1)
  local sizeMultiplier = tier.scale / bossBiter1Scale
  bossBiter.name = tier.name
  bossBiter.max_health = tier.maxHealth
  bossBiter.movement_speed = tier.movementSpeed
  bossBiter.resistances = tier.resistances
  bossBiter.trigger_target_mask = tier.triggerTargetMask
  --collision box stays the same so they don't get stuck on the biter paths, only the clickable area grows
  bossBiter.selection_box = {{-0.7 * sizeMultiplier, -1.5 * sizeMultiplier}, {0.7 * sizeMultiplier, 0.3 * sizeMultiplier}}
  bossBiter.sticker_box = {{-0.6 * sizeMultiplier, -0.8 * sizeMultiplier}, {0.6 * sizeMultiplier, 0}}
  bossBiter.distance_per_frame = 0.15 * tier.scale
  bossBiter.corpse = tier.name .. "-corpse"
  bossBiter.dying_explosion = tier.name .. "-die"
  bossBiter.working_sound = sounds.biter_calls_behemoth(0.6, 0.9)
  bossBiter.dying_sound = sounds.biter_dying_big(0.6)
  bossBiter.run_animation = biterrunanimation(tier.scale, tier.tint1, tier.tint2)
  bossBiter.attack_parameters.ammo_type = make_unit_melee_ammo_type(tier.damage)
  bossBiter.attack_parameters.sound = sounds.biter_roars_behemoth(0.5)
  bossBiter.attack_parameters.animation = biterattackanimation(tier.scale, tier.tint1, tier.tint2)
  bossBiter.water_reflection = biter_water_reflection(tier.scale)
  table.insert(bossBiters, bossBiter)
end

local smallPhysicalBiterScale = 0.25
local smallPhysicalBiterTint1 = {0.1, 0.1, 0.9, 1}
local smallPhysicalBiterTint2 = {0.15, 0.15, 0.15, 0.7}
local smallPhysicalBiter = {
  type = "unit",
  name = "small-physical-biter",
  order="b-a-c",
  icon = "__base__/graphics/icons/small-biter.png",
  flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air", "not-repairable"},
  max_health = 60,
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
  movement_speed = 0.35,
  distance_per_frame = 0.1,
  -- in pu
  absorptions_to_join_attack = { pollution = 80 },
  corpse = "small-physical-biter-corpse",
  dying_explosion = "small-physical-biter-die",
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
  max_health = 250,
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
  corpse = "medium-physical-biter-corpse",
  dying_explosion = "medium-physical-biter-die",
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
  max_health = 1000,
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
  corpse = "big-physical-biter-corpse",
  dying_explosion = "big-physical-biter-die",
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
  max_health = 9000,
  subgroup = "enemies",
  factoriopedia_simulation = simulations.factoriopedia_behemoth_biter,
  impact_category = "organic",
  resistances =
  {
    {
      type = "physical",
      decrease = 10,
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
  corpse = "behemoth-physical-biter-corpse",
  dying_explosion = "behemoth-physical-biter-die",
  working_sound = sounds.biter_calls_behemoth(0.5, 0.9),
  dying_sound = sounds.biter_dying_big(0.5),
  run_animation = biterrunanimation(behemothPhysicalBiterScale, smallPhysicalBiterTint1, smallPhysicalBiterTint2),
  running_sound_animation_positions = {2,},
  walking_sound = sounds.biter_walk_big(0.6, 0.8),
  ai_settings = biter_ai_settings,
  water_reflection = biter_water_reflection(behemothPhysicalBiterScale)
}

--fire biters: copies of the physical biters with only a 99% fire resistance,
--vanilla biter movement speeds and an orange-red tint
--keep the tints in sync with explosions.lua
local fireBiterTint1 = {1, 0.35, 0.05, 1}
local fireBiterTint2 = {0.6, 0.12, 0.02, 0.8}

local fireBiterTiers = {
  {
    name = "small-fire-biter",
    copyFrom = smallPhysicalBiter,
    scale = smallPhysicalBiterScale,
    maxHealth = 60,
    movementSpeed = 0.2,
    distancePerFrame = 0.125
  },
  {
    name = "medium-fire-biter",
    copyFrom = mediumPhysicalBiter,
    scale = mediumPhysicalBiterScale,
    maxHealth = 300,
    movementSpeed = 0.24,
    distancePerFrame = 0.188
  },
  {
    name = "big-fire-biter",
    copyFrom = bigPhysicalBiter,
    scale = bigPhysicalBiterScale,
    maxHealth = 1200,
    movementSpeed = 0.23,
    distancePerFrame = 0.30
  },
  {
    name = "behemoth-fire-biter",
    copyFrom = behemothPhysicalBiter,
    scale = behemothPhysicalBiterScale,
    maxHealth = 10000,
    movementSpeed = 0.3,
    distancePerFrame = 0.32
  },
}

local fireBiters = {}
for _, tier in pairs(fireBiterTiers) do
  local fireBiter = table.deepcopy(tier.copyFrom)
  fireBiter.name = tier.name
  fireBiter.max_health = tier.maxHealth
  fireBiter.resistances =
  {
    {
      type = "fire",
      percent = 99
    }
  }
  fireBiter.movement_speed = tier.movementSpeed
  fireBiter.distance_per_frame = tier.distancePerFrame
  fireBiter.corpse = tier.name .. "-corpse"
  fireBiter.dying_explosion = tier.name .. "-die"
  fireBiter.run_animation = biterrunanimation(tier.scale, fireBiterTint1, fireBiterTint2)
  fireBiter.attack_parameters.animation = biterattackanimation(tier.scale, fireBiterTint1, fireBiterTint2)
  table.insert(fireBiters, fireBiter)
end

--explosion and laser biters: made the same way as the fire biters (same tiers, hp and speeds),
--each with only one 65% resistance and its own tint
--keep the tints in sync with explosions.lua
local elementalBiterTypes = {
  {
    element = "explosion",
    resistance = {type = "explosion", percent = 65},
    tint1 = {0.9, 0.15, 0.15, 1},
    tint2 = {0.55, 0.05, 0.05, 0.8}
  },
  {
    element = "laser",
    resistance = {type = "laser", percent = 65},
    tint1 = {0.9, 0.8, 0.1, 1},
    tint2 = {0.1, 0.2, 0.55, 0.8}
  },
}

local elementalBiters = {}
for _, biterType in pairs(elementalBiterTypes) do
  for _, tier in pairs(fireBiterTiers) do
    local name = string.gsub(tier.name, "%-fire%-", "-" .. biterType.element .. "-")
    local biter = table.deepcopy(tier.copyFrom)
    biter.name = name
    biter.max_health = tier.maxHealth
    biter.resistances = {table.deepcopy(biterType.resistance)}
    biter.movement_speed = tier.movementSpeed
    biter.distance_per_frame = tier.distancePerFrame
    biter.corpse = name .. "-corpse"
    biter.dying_explosion = name .. "-die"
    biter.run_animation = biterrunanimation(tier.scale, biterType.tint1, biterType.tint2)
    biter.attack_parameters.animation = biterattackanimation(tier.scale, biterType.tint1, biterType.tint2)
    table.insert(elementalBiters, biter)
  end
end

data:extend({
  bossBiter1,
  smallPhysicalBiter,
  mediumPhysicalBiter,
  bigPhysicalBiter,
  behemothPhysicalBiter
})
data:extend(fireBiters)
data:extend(elementalBiters)
data:extend(bossBiters)

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
mediumBiter.max_health = 50
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
mediumBiter.resistances =
{
  {
    type = "physical",
    decrease = 2,
    percent = 10
  }
}

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

--spitters recolored to the tier colors
--T1 gray, T2 green, T3 blue, T4 red
--tint1 is the main body color, tint2 is the secondary/accent color
local spitterTiers = {
	["small-spitter"] = {
		maxHealth = 200,
		fireResistance = {decrease = 0, percent = 10},
		scale = scale_spitter_small,
		tint1 = {0.5, 0.5, 0.5, 1},
		tint2 = {0.3, 0.3, 0.3, 0.8}
	},
	["medium-spitter"] = {
		maxHealth = 400,
		fireResistance = {decrease = 2, percent = 20},
		scale = scale_spitter_medium,
		tint1 = {0.2, 0.75, 0.2, 1},
		tint2 = {0.1, 0.45, 0.1, 0.8}
	},
	["big-spitter"] = {
		maxHealth = 1000,
		fireResistance = {decrease = 4, percent = 30},
		scale = scale_spitter_big,
		tint1 = {0.2, 0.35, 0.9, 1},
		tint2 = {0.1, 0.2, 0.55, 0.8},
    movement_speed = 0.12
	},
	["behemoth-spitter"] = {
		maxHealth = 5000,
		fireResistance = {decrease = 8, percent = 40},
		scale = scale_spitter_behemoth,
		tint1 = {0.9, 0.15, 0.15, 1},
		tint2 = {0.55, 0.05, 0.05, 0.8},
    movement_speed = 0.1
	},
}

--adds or replaces one damage type in an entity's resistances, keeping the others (vanilla spitters resist explosion)
local function setResistance(entity, damageType, resistance)
	if not resistance then
		return
	end

	entity.resistances = entity.resistances or {}
	for _, existing in pairs(entity.resistances) do
		if existing.type == damageType then
			existing.decrease = resistance.decrease
			existing.percent = resistance.percent
			return
		end
	end

	table.insert(entity.resistances, {
		type = damageType,
		decrease = resistance.decrease,
		percent = resistance.percent
	})
end

for spitterName, tier in pairs(spitterTiers) do
	local spitter = data.raw["unit"][spitterName]
	if spitter then
		spitter.max_health = tier.maxHealth
		setResistance(spitter, "fire", tier.fireResistance)
		spitter.run_animation = spitterrunanimation(tier.scale, tier.tint1, tier.tint2)
		spitter.attack_parameters.animation = spitterattackanimation(tier.scale, tier.tint1, tier.tint2)
    if tier.movement_speed then
      spitter.movement_speed = tier.movement_speed
    end
	end

	--the dying/decaying body is drawn by the corpse
	local corpse = data.raw["corpse"][spitterName .. "-corpse"]
	if corpse then
		add_spitter_die_animation(tier.scale, tier.tint1, tier.tint2, corpse)
	end
end
