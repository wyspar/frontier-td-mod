-- 4x4 poison cannon, cannon-turret graphics originally from TwoMoreTurrets (scaled up 2x)
-- like the infinite-gun-turret it is an electric-turret with a void energy source,
-- so it needs no ammo and no power. it shoots its own projectile below
local sounds = require("__base__.prototypes.entity.sounds")
local hit_effects = require("__base__.prototypes.entity.hit-effects")

local graphicsPath = "__frontier-td__/graphics/entity/cannon-turret"
local poisonTint = {0.3, 0.1, 0.7, 1}

-- the original cannon turret is 2x2 and draws 3 tiles wide, everything here is 2x for 4x4
local GRAPHICS_SCALE = 2

local function cannonSheet(inputs)
  return {
    filename = graphicsPath .. "/cannon-turret-sheet.png",
    priority = "medium",
    scale = 0.5 * GRAPHICS_SCALE,
    width = 192,
    height = 192,
    direction_count = 64,
    frame_count = 1,
    line_length = 8,
    axially_symmetrical = false,
    run_mode = inputs.run_mode or "forward",
    shift = {0.25 * GRAPHICS_SCALE, -0.3 * GRAPHICS_SCALE},
  }
end

local function cannonSheetShadow(inputs)
  return {
    filename = graphicsPath .. "/cannon-turret-sheet-shadow.png",
    priority = "medium",
    scale = 0.5 * GRAPHICS_SCALE,
    width = 192,
    height = 192,
    direction_count = 64,
    frame_count = 1,
    line_length = 8,
    axially_symmetrical = false,
    run_mode = inputs.run_mode or "forward",
    shift = {0.25 * GRAPHICS_SCALE, -0.3 * GRAPHICS_SCALE},
    draw_as_shadow = true,
  }
end

-- the colored stripes on the barrel, tinted poison green instead of the force color
local function cannonMask(inputs)
  return {
    filename = graphicsPath .. "/cannon-turret-mask.png",
    flags = {"mask"},
    scale = 0.75 * GRAPHICS_SCALE,
    width = 128,
    height = 128,
    direction_count = 64,
    frame_count = 1,
    line_length = 8,
    axially_symmetrical = false,
    run_mode = inputs.run_mode or "forward",
    shift = {0.25 * GRAPHICS_SCALE, -0.3 * GRAPHICS_SCALE},
    apply_runtime_tint = false,
    tint = poisonTint
  }
end

local function cannonLayers(inputs)
  return {
    layers = {
      cannonSheetShadow(inputs),
      cannonSheet(inputs),
      cannonMask(inputs)
    }
  }
end

-- tiny poison cloud left where the shell lands
-- CLOUD_DURATION is how long it deals damage, the visuals below use the same time so
-- what you see is what hurts (the vanilla visual dummies last 24 seconds and deal no damage)
local CLOUD_DURATION = 120 -- ticks, 60 = 1 second
local CLOUD_FADE = math.min(20, CLOUD_DURATION)

-- visual only puffs around the cloud, a short lived copy of the vanilla poison-cloud-visual-dummy
local poisonCloudVisual = table.deepcopy(data.raw["smoke-with-trigger"]["poison-cloud-visual-dummy"])
poisonCloudVisual.name = "ut-poison-cannon-one-cloud-visual"
poisonCloudVisual.duration = CLOUD_DURATION
poisonCloudVisual.fade_away_duration = CLOUD_FADE
poisonCloudVisual.spread_duration = 5
poisonCloudVisual.spread_duration_variation = 0
poisonCloudVisual.particle_duration_variation = 0
poisonCloudVisual.particle_count = 6
poisonCloudVisual.particle_spread = {1.2, 0.8}
poisonCloudVisual.color = poisonTint

local poisonCloud = table.deepcopy(data.raw["smoke-with-trigger"]["poison-cloud"])
poisonCloud.name = "ut-poison-cannon-one-cloud"
poisonCloud.duration = CLOUD_DURATION
poisonCloud.fade_away_duration = CLOUD_FADE
poisonCloud.spread_duration = 5
poisonCloud.spread_duration_variation = 0
-- vanilla lets particles live up to 3 seconds longer than the cloud, keep them in sync
poisonCloud.particle_duration_variation = 0
poisonCloud.particle_count = 4
poisonCloud.particle_spread = {1.2, 0.8}
poisonCloud.color = poisonTint
-- the vanilla cloud spawns a big ring of 24 second visual dummies, use a few short lived ones instead
poisonCloud.created_effect = {
  {
    type = "cluster",
    cluster_count = 3,
    distance = 1,
    distance_deviation = 1,
    action_delivery = {
      type = "instant",
      target_effects = {
        {
          type = "create-smoke",
          show_in_tooltip = false,
          entity_name = "ut-poison-cannon-one-cloud-visual",
          initial_height = 0
        }
      }
    }
  }
}
-- 10 poison every 15 ticks while the cloud lasts (CLOUD_DURATION 30 = 2 hits, 60 = 4 hits)
poisonCloud.action = {
  type = "direct",
  action_delivery = {
    type = "instant",
    target_effects = {
      type = "nested-result",
      action = {
        type = "area",
        radius = 2.5,
        entity_flags = {"breaths-air"},
        action_delivery = {
          type = "instant",
          target_effects = {
            type = "damage",
            damage = {amount = 10, type = "poison"}
          }
        }
      }
    }
  }
}
poisonCloud.action_cooldown = 15

-- the shell: explosion + poison damage on the target, an explosion + poison splash, then the cloud
local projectile = table.deepcopy(data.raw["projectile"]["explosive-cannon-projectile"])
projectile.name = "ut-poison-cannon-one-projectile"
projectile.piercing_damage = nil
-- default is "all", which would let the shell hit our own walls and turrets on the way
projectile.force_condition = "not-same"
projectile.action = {
  type = "direct",
  action_delivery = {
    type = "instant",
    target_effects = {
      {
        type = "damage",
        damage = {amount = 120, type = "explosion"}
      },
      {
        type = "damage",
        damage = {amount = 60, type = "poison"}
      }
    }
  }
}
projectile.final_action = {
  type = "direct",
  action_delivery = {
    type = "instant",
    target_effects = {
      {
        type = "create-entity",
        entity_name = "big-explosion"
      },
      {
        type = "nested-result",
        action = {
          type = "area",
          radius = 3,
          action_delivery = {
            type = "instant",
            target_effects = {
              {
                type = "damage",
                damage = {amount = 80, type = "explosion"}
              },
              {
                type = "damage",
                damage = {amount = 30, type = "poison"}
              }
            }
          }
        }
      },
      {
        type = "create-smoke",
        entity_name = "ut-poison-cannon-one-cloud",
        show_in_tooltip = true,
        initial_height = 0
      },
      {
        type = "create-entity",
        entity_name = "medium-scorchmark-tintable",
        check_buildability = true
      }
    }
  }
}

-- same trick as infinite-gun-turret: copy the laser turret (electric-turret) and give it a void energy source
local turret = table.deepcopy(data.raw["electric-turret"]["laser-turret"])
turret.name = "ut-poison-cannon-one"
turret.icon = nil
turret.icons = {
  {
    icon = graphicsPath .. "/cannon-turret-icon.png",
    icon_size = 64,
    tint = poisonTint
  }
}
turret.minable = {mining_time = 0.1, result = "ut-poison-cannon-one"}
turret.fast_replaceable_group = nil
-- the laser turret circuit connector is placed for a 2x2 sprite, drop it
turret.circuit_connector = nil
turret.next_upgrade = nil
turret.energy_source = {type = "void"}
turret.max_health = 1500
turret.resistances = {
  {type = "fire", percent = 60},
  {type = "poison", percent = 100}
}
turret.corpse = "big-remnants"
turret.dying_explosion = "big-explosion"
turret.damaged_trigger_effect = hit_effects.entity()

-- 4x4
turret.collision_box = {{-1.9, -1.9}, {1.9, 1.9}}
turret.selection_box = {{-2, -2}, {2, 2}}
turret.drawing_box_vertical_extension = 1

turret.rotation_speed = 0.01
turret.preparing_speed = 0.08
turret.folding_speed = 0.04
turret.attacking_speed = 0.5
turret.preparing_sound = sounds.gun_turret_activate
turret.folding_sound = sounds.gun_turret_deactivate
turret.alert_when_attacking = true
turret.glow_light_intensity = 0

-- the cannon sprite only has a turning barrel, so every state uses the same sheet
turret.folded_animation = cannonLayers{}
turret.preparing_animation = cannonLayers{}
turret.prepared_animation = cannonLayers{}
turret.attacking_animation = cannonLayers{}
turret.folding_animation = cannonLayers{run_mode = "backward"}
turret.energy_glow_animation = nil
turret.graphics_set = {
  base_visualisation = {
    animation = {
      layers = {
        {
          filename = graphicsPath .. "/cannon-turret-base.png",
          priority = "medium",
          width = 128,
          height = 128,
          shift = {0, 0},
          scale = 0.5 * GRAPHICS_SCALE
        },
        {
          filename = graphicsPath .. "/cannon-turret-base-mask.png",
          flags = {"mask", "low-object"},
          line_length = 1,
          width = 128,
          height = 128,
          shift = {0, 0},
          apply_runtime_tint = false,
          tint = poisonTint,
          scale = 0.5 * GRAPHICS_SCALE
        }
      }
    }
  }
}

turret.attack_parameters = {
  type = "projectile",
  -- cannon-shell so the vanilla cannon damage/speed research applies to it
  ammo_category = "cannon-shell",
  cooldown = 110,
  projectile_creation_distance = 1.5 * GRAPHICS_SCALE,
  projectile_center = {0, 0.2 * GRAPHICS_SCALE},
  range = 45,
  min_range = 10,
  turn_range = 1,
  prepare_range = 50,
  lead_target_for_projectile_speed = 1,
  rotate_penalty = 1,
  health_penalty = 0,
  sound = sounds.tank_gunshot,
  ammo_type = {
    target_type = "entity",
    action = {
      type = "direct",
      action_delivery = {
        type = "projectile",
        projectile = "ut-poison-cannon-one-projectile",
        starting_speed = 1,
        max_range = 45,
        min_range = 10,
        source_effects = {
          type = "create-explosion",
          entity_name = "explosion-gunshot"
        }
      }
    }
  }
}
turret.call_for_help_radius = 50

data:extend({
  poisonCloudVisual,
  poisonCloud,
  projectile,
  turret
})
