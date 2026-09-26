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

data:extend({
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
        recipe = "heating-tower"
      },
      {
        type = "unlock-recipe",
        recipe = "steam-turbine"
      },
      {
        type = "unlock-recipe",
        recipe = "heat-exchanger"
      },
      {
        type = "unlock-recipe",
        recipe = "heat-pipe"
      }
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
  --tier one science shit
  {
    type = "technology",
    name = "biter-progress-tier-one-science",
    icon = "__frontier-td__/graphics/technology/tier-one-science-pack.png",
    icon_size = 256,
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
      {
        type = "unlock-recipe",
        recipe = "tier-two-laser-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-three-laser-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-four-laser-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-five-laser-turret"
      }
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
    prerequisites = {"bigger-backpack-1","biter-progress-tier-one-science"},
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
        modifier = 0.9
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
      },
      {
        type = "unlock-recipe",
        recipe = "steel-plate"
      },
      {
        type = "unlock-recipe",
        recipe = "steel-chest"
      }
    },
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-two-science"}
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
    prerequisites = {"biter-progress-tier-two-science"},
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
      {
        type = "unlock-recipe",
        recipe = "tier-two-flamer-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-three-flamer-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-four-flamer-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-five-flamer-turret"
      }
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
        modifier = 0.9
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
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-three-science"}
    }
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
      {
        type = "unlock-recipe",
        recipe = "tier-two-tesla-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-three-tesla-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-four-tesla-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-five-tesla-turret"
      }
    },
    prerequisites = {"biter-progress-tier-three-science"},
    unit =
    {
      count = 500,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
      },
      time = 20
    }
  },
})
