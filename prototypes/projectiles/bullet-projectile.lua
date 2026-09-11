-- for name, projectile in pairs(data.raw["projectile"]) do
--     log("PROJECTILE: " .. name)
-- end


-- local base_projectile = data.raw["projectile"]["visual-tracer-projectile-normal"]

-- local projectile = table.deepcopy(base_projectile)

-- projectile.name = "infinite-bullet-projectile"

-- -- Movement
-- projectile.acceleration = 0.01
-- --projectile.direction_only = true
-- projectile.max_speed = 1

-- -- Visual
-- projectile.animation = {
--     filename = "__base__/graphics/entity/bullet/bullet.png",
--     width = 3,
--     height = 50,
--     scale = 0.5
-- }

-- -- Replace the damage
-- projectile.action = {
--     type = "direct",
--     action_delivery = {
--         type = "instant",
--         target_effects = {
--             {
--                 type = "damage",
--                 damage = {
--                     amount = 5,
--                     type = "physical"
--                 }
--             }
--         }
--     }
-- }

-- data:extend({projectile})

local projectile = {
    type = "projectile",
    name = "infinite-bullet-projectile",

    flags = {"not-on-map"},
    hidden = true,
    acceleration = 0,

    animation = {
        filename = "__base__/graphics/entity/bullet/bullet.png",
        draw_as_glow = true,
        width = 3,
        height = 50,
        priority = "high",
        scale = 0.5
    },

    action = {
        type = "direct",
        action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "damage",
                    damage = {
                        amount = 3,
                        type = "physical"
                    },
                    force = "enemy"
                }
            }
        }
    }
}

data:extend({projectile})

  --  1.382 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: shotgun-pellet
  --  1.382 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: grenade
  --  1.382 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: defender-capsule
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: laser
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: blue-laser
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: rocket
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: explosive-rocket
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: piercing-shotgun-pellet
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: cannon-projectile
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: uranium-cannon-projectile
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: explosive-uranium-cannon-projectile
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: explosive-cannon-projectile
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: cluster-grenade
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: distractor-capsule
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: destroyer-capsule
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: poison-capsule
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: slowdown-capsule
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: cliff-explosives
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: atomic-bomb-wave-spawns-nuke-shockwave-explosion
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: atomic-bomb-wave-spawns-nuclear-smoke
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: atomic-bomb-wave-spawns-fire-smoke-explosion
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: atomic-bomb-wave-spawns-cluster-nuke-explosion
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: atomic-bomb-wave
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: atomic-bomb-ground-zero-projectile
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: atomic-rocket
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: visual-tracer-projectile-normal
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: visual-tracer-projectile-piercing
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: visual-tracer-projectile-uranium
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: small-strafer-projectile
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: medium-strafer-projectile
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: big-strafer-projectile
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: boompuff-seed
  --  1.383 Script @__frontier-td__/prototypes/projectile.lua:2: PROJECTILE: capture-robot-rocket