local physical_projectile_damage_1_icon = "__base__/graphics/technology/physical-projectile-damage-1.png"
local physical_projectile_damage_2_icon = "__base__/graphics/technology/physical-projectile-damage-2.png"
local stronger_explosives_1_icon = "__base__/graphics/technology/stronger-explosives-1.png"
local stronger_explosives_2_icon = "__base__/graphics/technology/stronger-explosives-2.png"
local stronger_explosives_3_icon = "__base__/graphics/technology/stronger-explosives-3.png"
local refined_flammables_icon = "__base__/graphics/technology/refined-flammables.png"
local laser_weapons_damage_1_icon = "__base__/graphics/technology/laser-weapons-damage.png"
local laser_weapons_damage_2_icon = "__base__/graphics/technology/laser-weapons-damage.png"
local laser_weapons_damage_3_icon = "__base__/graphics/technology/laser-weapons-damage.png"
local weapon_shooting_speed_1_icon = "__base__/graphics/technology/weapon-shooting-speed-1.png"
local weapon_shooting_speed_2_icon = "__base__/graphics/technology/weapon-shooting-speed-2.png"
local weapon_shooting_speed_3_icon = "__base__/graphics/technology/weapon-shooting-speed-3.png"
local laser_shooting_speed_icon = "__base__/graphics/technology/laser-shooting-speed.png"
local electric_weapons_damage_icon = "__space-age__/graphics/technology/electric-weapons-damage.png"

data:extend({
  {
    type = "technology",
    name = "an-unlock-gun-turrets",
    icon = "__frontier-td__/graphics/technology/infinte-gun-turret.png",
    icon_size = 256,
    effects =
    {
      {
        type = "character-crafting-speed",
        modifier = 0.25
      },
      {
        type = "create-ghost-on-entity-death",
        modifier = true
      }
    },
    research_trigger =
    {
      type = "craft-item",
      item = "infinite-gun-turret",
      count = 1
    }
  },
  {
    type = "technology",
    name = "steam-power",
    icon = "__base__/graphics/technology/steam-power.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "pipe"
      },
      {
        type = "unlock-recipe",
        recipe = "pipe-to-ground"
      },
      {
        type = "unlock-recipe",
        recipe = "offshore-pump"
      },
      {
        type = "unlock-recipe",
        recipe = "steam-engine"
      },
      {
        type = "unlock-recipe",
        recipe = "boiler"
      },
    },
    research_trigger =
    {
      type = "craft-item",
      item = "iron-plate",
      count = 25
    }
  },
  {
    type = "technology",
    name = "crafting-speed-bonus-1",
    icon = "__base__/graphics/technology/logistics-1.png",
    icon_size = 256,
    effects =
    {
      {
        type = "character-crafting-speed",
        modifier = 0.25
      }
    },
    research_trigger =
    {
      type = "craft-item",
      item = "transport-belt",
      count = 100
    }
  },
  {
    type = "technology",
    name = "crafting-speed-bonus-2",
    icon = "__base__/graphics/technology/logistics-1.png",
    icon_size = 256,
    prerequisites = {"crafting-speed-bonus-1"},
    effects =
    {
      {
        type = "character-crafting-speed",
        modifier = 0.5
      }
    },
    research_trigger =
    {
      type = "craft-item",
      item = "tier-two-science-pack",
      count = 100
    }
  },
  {
    type = "technology",
    name = "b-upgrade-turret-reward",
    icon = "__frontier-td__/graphics/technology/upgrade-tool.png",
    icon_size = 256,
    prerequisites = {"an-unlock-gun-turrets"},
    effects =
    {
      {
        type = "character-running-speed",
        modifier = 0.3
      }
    },
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.b-upgrade-turret-reward"}
    }
  },
  --tier one science shit
  {
    type = "technology",
    name = "biter-progress-tier-one-science",
    icon = "__frontier-td__/graphics/technology/tier-one-science-pack.png",
    icon_size = 256,
    prerequisites = {"b-upgrade-turret-reward"},
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-one-science-pack"
      }
    },
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-one-science"}
    }
  },
  {
    type = "technology",
    name = "laser-turrets",
    icon = "__frontier-td__/graphics/technology/laser-research-icon.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-one-laser-turret"
      },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-two-laser-turret"
      -- },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-three-laser-turret"
      -- },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-four-laser-turret"
      -- },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-five-laser-turret"
      -- }
    },
    prerequisites = {"biter-progress-tier-one-science"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"tier-one-science-pack", 1},
      },
      time = 20
    }
  },
  {
    type = "technology",
    name = "weapon-shooting-speed-1",
    icons = util.technology_icon_constant_speed(weapon_shooting_speed_1_icon),
    effects =
    {
      {
        type = "gun-speed",
        ammo_category = "bullet",
        modifier = 0.1
      },
      {
        type = "gun-speed",
        ammo_category = "shotgun-shell",
        modifier = 0.1
      }
    },
    prerequisites = {"biter-progress-tier-one-science"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"tier-one-science-pack", 1}
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "weapon-shooting-speed-2",
    icons = util.technology_icon_constant_speed(weapon_shooting_speed_1_icon),
    effects =
    {
      {
        type = "gun-speed",
        ammo_category = "bullet",
        modifier = 0.2
      },
      {
        type = "gun-speed",
        ammo_category = "shotgun-shell",
        modifier = 0.2
      }
    },
    prerequisites = {"weapon-shooting-speed-1","biter-progress-tier-one-science"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"tier-one-science-pack", 1}
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "physical-projectile-damage-1",
    icons = util.technology_icon_constant_damage(physical_projectile_damage_1_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "bullet",
        modifier = 0.1
      },
      {
        type = "turret-attack",
        turret_id = "gun-turret",
        modifier = 0.1
      },
      {
        type = "ammo-damage",
        ammo_category = "shotgun-shell",
        modifier = 0.1
      }
    },
    prerequisites = {"biter-progress-tier-one-science"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"tier-one-science-pack", 1}
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "physical-projectile-damage-2",
    icons = util.technology_icon_constant_damage(physical_projectile_damage_1_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "bullet",
        modifier = 0.2
      },
      {
        type = "turret-attack",
        turret_id = "gun-turret",
        modifier = 0.2
      },
      {
        type = "ammo-damage",
        ammo_category = "shotgun-shell",
        modifier = 0.2
      }
    },
    prerequisites = {"physical-projectile-damage-1","biter-progress-tier-one-science"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"tier-one-science-pack", 1}
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "worker-robots-speed-1",
    icons = util.technology_icon_constant_movement_speed("__base__/graphics/technology/worker-robots-speed.png"),
    effects =
    {
      {
        type = "worker-robot-speed",
        modifier = 0.35
      }
    },
    prerequisites = {"biter-progress-tier-one-science"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"tier-one-science-pack", 1},
      },
      time = 25
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "bigger-backpack-1",
    icons = util.technology_icon_constant_capacity("__base__/graphics/technology/toolbelt.png"),
    prerequisites = {"biter-progress-tier-one-science"},
    effects =
    {
      {
        type = "character-inventory-slots-bonus",
        modifier = 10
      }
    },
    unit =
    {
      count = 25,
      ingredients =
      {
        {"tier-one-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "bigger-backpack-2",
    icons = util.technology_icon_constant_capacity("__base__/graphics/technology/toolbelt.png"),
    prerequisites = {"bigger-backpack-1"},
    effects =
    {
      {
        type = "character-inventory-slots-bonus",
        modifier = 10
      }
    },
    unit =
    {
      count = 50,
      ingredients =
      {
        {"tier-one-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "walkspeed-1",
    icons = util.technology_icon_constant_capacity("__frontier-td__/graphics/technology/walkspeed.png"),
    prerequisites = {"biter-progress-tier-one-science"},
    effects =
    {
      {
        type = "character-running-speed",
        modifier = 0.45
      }
    },
    unit =
    {
      count = 25,
      ingredients =
      {
        {"tier-one-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "yellow-loader",
    icons = {
      {
        icon = "__aai-loaders__/graphics/technology/loader-tech-icon" .. "" .. ".png" ,
        icon_size = 256
      },
      {
        icon = "__aai-loaders__/graphics/technology/loader-tech-icon_mask" .. "" .. ".png",
        icon_size = 256, tint = {255, 217, 85}}
    },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "aai-loader"
      },
    },
    prerequisites = {"biter-progress-tier-one-science"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"tier-one-science-pack", 1},
      },
      time = 30
    }
  },
  {
    type = "technology",
    name = "laser-shooting-speed-1",
    icons = util.technology_icon_constant_speed(laser_shooting_speed_icon),
    effects =
    {
      {
        type = "gun-speed",
        ammo_category = "laser",
        modifier = 0.1
      }
    },
    prerequisites = {"laser-turrets"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"tier-one-science-pack", 1},
      },
      time = 25
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "laser-shooting-speed-2",
    icons = util.technology_icon_constant_speed(laser_shooting_speed_icon),
    effects =
    {
      {
        type = "gun-speed",
        ammo_category = "laser",
        modifier = 0.2
      }
    },
    prerequisites = {"laser-shooting-speed-1"},
    unit =
    {
      count = 75,
      ingredients =
      {
        {"tier-one-science-pack", 1},
      },
      time = 25
    },
    upgrade = true
  },
  --tier two science shit
  {
    type = "technology",
    name = "biter-progress-tier-two-science",
    icon = "__frontier-td__/graphics/technology/tier-two-science-pack.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-two-science-pack"
      }
    },
    prerequisites = {"automation","biter-progress-tier-one-science"},
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-two-science"}
    }
  },
  {
    type = "technology",
    name = "bigger-backpack-3",
    icons = util.technology_icon_constant_capacity("__base__/graphics/technology/toolbelt.png"),
    prerequisites = {"bigger-backpack-2"},
    effects =
    {
      {
        type = "character-inventory-slots-bonus",
        modifier = 10
      }
    },
    unit =
    {
      count = 75,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "bigger-backpack-4",
    icons = util.technology_icon_constant_capacity("__base__/graphics/technology/toolbelt.png"),
    prerequisites = {"bigger-backpack-3"},
    effects =
    {
      {
        type = "character-inventory-slots-bonus",
        modifier = 10
      }
    },
    unit =
    {
      count = 125,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 25
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "worker-robots-speed-2",
    icons = util.technology_icon_constant_movement_speed("__base__/graphics/technology/worker-robots-speed.png"),
    effects =
    {
      {
        type = "worker-robot-speed",
        modifier = 0.45
      }
    },
    prerequisites = {"worker-robots-speed-1"},
    unit =
    {
      count = 50,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 25
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "chem-plant",
    icon = "__frontier-td__/graphics/technology/chemical-plant.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "chemical-plant"
      }
    },
    prerequisites = {"biter-progress-tier-two-science","steel-processing"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 25
    }
  },
  {
    type = "technology",
    name = "compressed-coal",
    icon = "__frontier-td__/graphics/technology/compressed-coal.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "compressed-coal"
      }
    },
    prerequisites = {"chem-plant"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 30
    }
  },
  {
    type = "technology",
    name = "red-belts",
    icon = "__base__/graphics/technology/logistics-2.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "fast-transport-belt"
      },
      {
        type = "unlock-recipe",
        recipe = "fast-underground-belt"
      },
      {
        type = "unlock-recipe",
        recipe = "fast-splitter"
      },
      {
        type = "unlock-recipe",
        recipe = "aai-fast-loader"
      }
    },
    prerequisites = {"biter-progress-tier-two-science","yellow-loader"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 30
    }
  },
  {
    type = "technology",
    name = "flamer-turrets",
    icon = "__frontier-td__/graphics/technology/flamer-research-icon.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-one-flamer-turret"
      },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-two-flamer-turret"
      -- },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-three-flamer-turret"
      -- },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-four-flamer-turret"
      -- },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-five-flamer-turret"
      -- }
    },
    prerequisites = {"biter-progress-tier-two-science"},
    unit =
    {
      count = 300,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 20
    }
  },
  {
    type = "technology",
    name = "electric-furnace",
    icon = "__frontier-td__/graphics/technology/electric-furnace.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "electric-furnace"
      },
    },
    prerequisites = {"biter-progress-tier-two-science"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 20
    }
  },
  {
    type = "technology",
    name = "walkspeed-2",
    icons = util.technology_icon_constant_capacity("__frontier-td__/graphics/technology/walkspeed.png"),
    prerequisites = {"walkspeed-1","biter-progress-tier-two-science"},
    effects =
    {
      {
        type = "character-running-speed",
        modifier = 0.6
      }
    },
    unit =
    {
      count = 50,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
    {
    type = "technology",
    name = "physical-projectile-damage-3",
    icons = util.technology_icon_constant_damage(physical_projectile_damage_1_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "bullet",
        modifier = 0.3
      },
      {
        type = "turret-attack",
        turret_id = "gun-turret",
        modifier = 0.3
      },
      {
        type = "ammo-damage",
        ammo_category = "shotgun-shell",
        modifier = 0.3
      }
    },
    prerequisites = {"physical-projectile-damage-2"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1}
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "physical-projectile-damage-4",
    icons = util.technology_icon_constant_damage(physical_projectile_damage_2_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "bullet",
        modifier = 0.4
      },
      {
        type = "turret-attack",
        turret_id = "gun-turret",
        modifier = 0.4
      },
      {
        type = "ammo-damage",
        ammo_category = "shotgun-shell",
        modifier = 0.4
      }
    },
    prerequisites = {"physical-projectile-damage-3","biter-progress-tier-three-science"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1}
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "physical-projectile-damage-5",
    icons = util.technology_icon_constant_damage(physical_projectile_damage_2_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "bullet",
        modifier = 0.4
      },
      {
        type = "turret-attack",
        turret_id = "gun-turret",
        modifier = 0.4
      },
      {
        type = "ammo-damage",
        ammo_category = "shotgun-shell",
        modifier = 0.4
      }
    },
    prerequisites = {"physical-projectile-damage-4","biter-progress-tier-four-science"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1}
      },
      time = 20
    },
    upgrade = true
  },
    {
    type = "technology",
    name = "weapon-shooting-speed-3",
    icons = util.technology_icon_constant_speed(weapon_shooting_speed_1_icon),
    effects =
    {
      {
        type = "gun-speed",
        ammo_category = "bullet",
        modifier = 0.3
      },
      {
        type = "gun-speed",
        ammo_category = "shotgun-shell",
        modifier = 0.3
      }
    },
    prerequisites = {"weapon-shooting-speed-2"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1}
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "laser-shooting-speed-3",
    icons = util.technology_icon_constant_speed(laser_shooting_speed_icon),
    effects =
    {
      {
        type = "gun-speed",
        ammo_category = "laser",
        modifier = 0.3
      }
    },
    prerequisites = {"laser-shooting-speed-2"},
    unit =
    {
      count = 75,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 25
    },
    upgrade = true
  },
  --tier three science shit
  {
    type = "technology",
    name = "biter-progress-tier-three-science",
    icon = "__frontier-td__/graphics/technology/tier-three-science-pack.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-three-science-pack"
      }
    },
    prerequisites = {"biter-progress-tier-two-science","electric-energy-distribution-1","steam-power","electric-furnace"},
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-three-science"}
    }
  },
  {
    type = "technology",
    name = "electromagnetic-plant",
    icon = "__space-age__/graphics/technology/electromagnetic-plant.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "electromagnetic-plant"
      },
    },
    prerequisites = {"biter-progress-tier-three-science","steel-processing","advanced-circuit","concrete"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
      },
      time = 20
    }
  },
  {
    type = "technology",
    name = "worker-robots-speed-3",
    icons = util.technology_icon_constant_movement_speed("__base__/graphics/technology/worker-robots-speed.png"),
    effects =
    {
      {
        type = "worker-robot-speed",
        modifier = 0.5
      }
    },
    prerequisites = {"worker-robots-speed-2"},
    unit =
    {
      count = 75,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
      },
      time = 25
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "tesla-turrets",
    icon = "__frontier-td__/graphics/technology/tesla-research-icon.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-one-tesla-turret"
      },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-two-tesla-turret"
      -- },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-three-tesla-turret"
      -- },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-four-tesla-turret"
      -- },
      -- {
      --   type = "unlock-recipe",
      --   recipe = "tier-five-tesla-turret"
      -- }
    },
    prerequisites = {"biter-progress-tier-three-science"},
    unit =
    {
      count = 350,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
      },
      time = 20
    }
  },
  {
    type = "technology",
    name = "electric-weapons-damage-1",
    icons = util.technology_icon_constant_damage(electric_weapons_damage_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "tesla",
        modifier = 0.5
      },
      {
        type = "ammo-damage",
        ammo_category = "electric",
        modifier = 0.5
      },
      {
        type = "ammo-damage",
        ammo_category = "beam",
        modifier = 0.5
      }
    },
    prerequisites = {"tesla-turrets"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "laser-shooting-speed-4",
    icons = util.technology_icon_constant_speed(laser_shooting_speed_icon),
    effects =
    {
      {
        type = "gun-speed",
        ammo_category = "laser",
        modifier = 0.4
      }
    },
    prerequisites = {"laser-shooting-speed-3"},
    unit =
    {
      count = 150,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
      },
      time = 25
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "laser-shooting-speed-5",
    icons = util.technology_icon_constant_speed(laser_shooting_speed_icon),
    effects =
    {
      {
        type = "gun-speed",
        ammo_category = "laser",
        modifier = 0.4
      }
    },
    prerequisites = {"laser-shooting-speed-4","biter-progress-tier-four-science"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1},
      },
      time = 25
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "construction-robotics",
    icon = "__base__/graphics/technology/construction-robotics.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "roboport"
      },
      {
        type = "unlock-recipe",
        recipe = "passive-provider-chest"
      },
      {
        type = "unlock-recipe",
        recipe = "storage-chest"
      },
    },
    prerequisites = {"biter-progress-tier-three-science", "advanced-circuit","steel-processing","electric-engine"},
    unit =
    {
      count = 100,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
      },
      time = 30
    }
  },
  --tier four science shit
  {
    type = "technology",
    name = "biter-progress-tier-four-science",
    icon = "__frontier-td__/graphics/technology/tier-four-science-pack.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-four-science-pack"
      }
    },
    prerequisites = {"biter-progress-tier-three-science","electric-engine","concrete","battery"},
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-four-science"}
    }
  },
  {
    type = "technology",
    name = "crusher",
    icon = "__frontier-td__/graphics/technology/crusher.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "fine-stone"
      },
      {
        type = "unlock-recipe",
        recipe = "crusher"
      },
    },
    prerequisites = {"biter-progress-tier-four-science","steel-processing","advanced-circuit","electric-engine"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1},
      },
      time = 20
    }
  },
  {
    type = "technology",
    name = "ice-making",
    icon = "__frontier-td__/graphics/technology/ice-making.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "ice-making"
      },
    },
    prerequisites = {"biter-progress-tier-four-science","crusher"},
    unit =
    {
      count = 250,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1},
      },
      time = 20
    }
  },
  {
    type = "technology",
    name = "electric-weapons-damage-2",
    icons = util.technology_icon_constant_damage(electric_weapons_damage_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "tesla",
        modifier = 0.7
      },
      {
        type = "ammo-damage",
        ammo_category = "electric",
        modifier = 0.7
      },
      {
        type = "ammo-damage",
        ammo_category = "beam",
        modifier = 0.7
      }
    },
    prerequisites = {"electric-weapons-damage-1","biter-progress-tier-four-science"},
    unit =
    {
      count = 250,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  --tier five science shit
  {
    type = "technology",
    name = "biter-progress-tier-five-science",
    icon = "__frontier-td__/graphics/technology/tier-five-science-pack.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-five-science-pack"
      }
    },
    prerequisites = {"biter-progress-tier-four-science","processing-unit","ice-making"},
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-five-science"}
    }
  },
  {
    type = "technology",
    name = "electric-weapons-damage-3",
    icons = util.technology_icon_constant_damage(electric_weapons_damage_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "tesla",
        modifier = 1
      },
      {
        type = "ammo-damage",
        ammo_category = "electric",
        modifier = 1
      },
      {
        type = "ammo-damage",
        ammo_category = "beam",
        modifier = 1
      }
    },
    prerequisites = {"electric-weapons-damage-2","biter-progress-tier-five-science"},
    unit =
    {
      count = 300,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1},
        {"tier-five-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  --unlocked by script the first time the force gets a boss-reward-item (control.lua)
  {
    type = "technology",
    name = "ut-poison-cannon-one",
    icon = "__frontier-td__/graphics/entity/cannon-turret/cannon-turret-tech.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "ut-poison-cannon-one"
      },
      {
        type = "unlock-recipe",
        recipe = "ut-acid-shooter"
      }
    },
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.ut-poison-cannon-one"}
    }
  },
  --biter module 1 is in the modules tech (base-data-updates.lua), 2 and 3 have their own
  {
    type = "technology",
    name = "biter-module-2",
    icon = "__base__/graphics/technology/efficiency-module-2.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "biter-module-2"
      }
    },
    prerequisites = {"modules","biter-progress-tier-four-science"},
    unit =
    {
      count = 250,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1},
      },
      time = 20
    }
  },
  {
    type = "technology",
    name = "biter-module-3",
    icon = "__base__/graphics/technology/efficiency-module-3.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "biter-module-3"
      }
    },
    prerequisites = {"biter-module-2","biter-progress-tier-five-science"},
    unit =
    {
      count = 300,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1},
        {"tier-five-science-pack", 1},
      },
      time = 20
    }
  },
  --our own stronger explosives (replace the disabled vanilla ones): rockets, grenades and landmines
  {
    type = "technology",
    name = "stronger-explosives-1",
    icons = util.technology_icon_constant_damage(stronger_explosives_3_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "rocket",
        modifier = 0.35
      },
      {
        type = "ammo-damage",
        ammo_category = "grenade",
        modifier = 0.35
      },
      {
        type = "ammo-damage",
        ammo_category = "landmine",
        modifier = 0.35
      },
      {
        type = "turret-attack",
        turret_id = "ut-poison-cannon-one",
        modifier = 0.35
      }
    },
    prerequisites = {"biter-progress-tier-two-science"},
    unit =
    {
      count = 125,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "stronger-explosives-2",
    icons = util.technology_icon_constant_damage(stronger_explosives_3_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "rocket",
        modifier = 0.5
      },
      {
        type = "ammo-damage",
        ammo_category = "grenade",
        modifier = 0.5
      },
      {
        type = "ammo-damage",
        ammo_category = "landmine",
        modifier = 0.5
      },
      {
        type = "turret-attack",
        turret_id = "ut-poison-cannon-one",
        modifier = 0.5
      }
    },
    prerequisites = {"stronger-explosives-1","biter-progress-tier-three-science"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  {
    type = "technology",
    name = "stronger-explosives-3",
    icons = util.technology_icon_constant_damage(stronger_explosives_3_icon),
    effects =
    {
      {
        type = "ammo-damage",
        ammo_category = "rocket",
        modifier = 0.7
      },
      {
        type = "ammo-damage",
        ammo_category = "grenade",
        modifier = 0.7
      },
      {
        type = "ammo-damage",
        ammo_category = "landmine",
        modifier = 0.7
      },
      {
        type = "turret-attack",
        turret_id = "ut-poison-cannon-one",
        modifier = 0.7
      }
    },
    prerequisites = {"stronger-explosives-2","biter-progress-tier-four-science"},
    unit =
    {
      count = 300,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1},
      },
      time = 20
    },
    upgrade = true
  },
  --our own agriculture: agricultural tower and money tree seeds (prototypes/money-tree.lua)
  {
    type = "technology",
    name = "agriculture",
    icon = "__space-age__/graphics/technology/agriculture.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "agricultural-tower"
      },
      {
        type = "unlock-recipe",
        recipe = "money-tree-seeds"
      },
    },
    -- the techs that unlock the agricultural tower's ingredients (steel, electronic/advanced circuits, electric engines, landfill)
    prerequisites = {"biter-progress-tier-four-science", "steel-processing", "electronics", "advanced-circuit", "electric-engine", "landfill"},
    unit =
    {
      count = 300,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
        {"tier-four-science-pack", 1},
      },
      time = 30
    }
  },
})
