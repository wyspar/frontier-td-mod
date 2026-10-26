-- golden snitch: a gold copy of the small flyer that spawns now and then anywhere in a running slot, flies around
-- and never attacks. kill it within 2 minutes for coins, the spawning and reward are in scripts/golden-snitch.lua.
-- needs prototypes/entity/l9m2-flyer/flyers.lua loaded first (small-flyer and its animation functions)
local GOLD_TINT = {r = 1, g = 0.8, b = 0.1}

local snitch = table.deepcopy(data.raw.unit["small-flyer"])
snitch.name = "golden-snitch-flyer"
snitch.icon = nil
snitch.icons = {
  {icon = "__frontier-td__/graphics/l9m2-flyer/small-flyer-icon.png", icon_size = 64, tint = GOLD_TINT}
}
snitch.order = "a-a-a-i"
snitch.max_health = 250
-- a bit bigger than the small flyer's (collision 0.6x0.6, selection 1.4x2) so it is easier to hit by hand
snitch.collision_box = {{-0.5, -0.5}, {0.5, 0.5}}
snitch.selection_box = {{-1, -2.9}, {1, -0.1}}
snitch.resistances = {}
snitch.healing_per_tick = 0
-- pretty fast, the small flyer is 0.215
snitch.movement_speed = 0.35
snitch.distance_per_frame = 0.09
-- not part of any attack, the script gives it all its commands
snitch.absorptions_to_join_attack = nil
snitch.ai_settings = {destroy_when_commands_fail = false, allow_try_return_to_spawner = false}

local runAnimation = l9m2_smallflyerrunanimation(scale_flyer_small)
runAnimation.layers[1].tint = GOLD_TINT
snitch.run_animation = runAnimation

-- it always has a distraction-free move command, this is only so it can never hurt anything
snitch.attack_parameters = {
  type = "projectile",
  range = 0.5,
  cooldown = 60,
  ammo_category = "melee",
  ammo_type = {
    target_type = "entity",
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = {
          {type = "damage", damage = {amount = 0, type = "physical"}}
        }
      }
    }
  },
  animation = runAnimation
}

data:extend({snitch})
