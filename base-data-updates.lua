local frep = require("__fdsl__.lib.recipe")
local ftech = require("__fdsl__.lib.technology")

local nauvisAndGlebaPressure = {
  property = "pressure",
  min = 1000,
  max = 2000
}

ftech.add_unlock("tree-seeding", "agricultural-tower")
ftech.remove_unlock("tree-seeding", "wood-processing")
data.raw.recipe["wood-processing"].energy_required = 0.5
ftech.remove_unlock("agriculture", "agricultural-tower")

local tree_plant = data.raw.plant["tree-plant"]
tree_plant.minable.results = {{type="item", name="wood", amount=10}}
  tree_plant.growth_ticks = 5 * minute
tree_plant.harvest_emissions = {pollution=0}

data.raw.plant["jellystem"].autoplace.tile_restriction = {}
data.raw.plant["yumako-tree"].autoplace.tile_restriction = {}

--Tower changes
data.raw.item["agricultural-tower"].weight = 100 * kg

--frep.remove_ingredient("agricultural-tower", "landfill")
--frep.replace_ingredient("agricultural-tower", "electronic-circuit", "processing-unit")
frep.replace_ingredient("agricultural-tower", "steel-plate", "carbon-fiber")
--frep.replace_ingredient("agricultural-tower", "spoilage", {type="item", name="pentapod-egg", amount=1})


local agricultural_tower = data.raw["agricultural-tower"]["agricultural-tower"]
agricultural_tower.energy_usage = "500kW"
agricultural_tower.crane_energy_usage = "500kW"

--Assembler changes
table.insert(data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories, "organic-or-assembling")

frep.set_surface_condition("agricultural-tower", nauvisAndGlebaPressure)
frep.set_surface_condition("pentapod-egg", nauvisAndGlebaPressure)
frep.set_surface_condition("biochamber", nauvisAndGlebaPressure)
frep.set_surface_condition("foundry", nauvisAndGlebaPressure)
frep.set_surface_condition("big-mining-drill", nauvisAndGlebaPressure)
frep.set_surface_condition("turbo-transport-belt", nauvisAndGlebaPressure)
frep.set_surface_condition("turbo-underground-belt", nauvisAndGlebaPressure)
frep.set_surface_condition("turbo-splitter", nauvisAndGlebaPressure)
frep.set_surface_condition("metallurgic-science-pack", nauvisAndGlebaPressure)
frep.set_surface_condition("agricultural-science-pack", nauvisAndGlebaPressure)
frep.set_surface_condition("electromagnetic-science-pack", nauvisAndGlebaPressure)
frep.set_surface_condition("cryogenic-science-pack", nauvisAndGlebaPressure)
frep.set_surface_condition("promethium-science-pack", nauvisAndGlebaPressure)
frep.set_surface_condition("quantum-processor", nauvisAndGlebaPressure)
data.raw.recipe["electromagnetic-plant"].surface_conditions = {nauvisAndGlebaPressure}
data.raw.recipe["recycler"].surface_conditions = {nauvisAndGlebaPressure}
data.raw.recipe["electromagnetic-science-pack"].surface_conditions = {nauvisAndGlebaPressure}
data.raw.recipe["electromagnetic-plant"].surface_conditions = {nauvisAndGlebaPressure}
data.raw.recipe["cryogenic-plant"].surface_conditions = {nauvisAndGlebaPressure}
data.raw.recipe["fusion-reactor"].surface_conditions = {nauvisAndGlebaPressure}
data.raw.recipe["fusion-generator"].surface_conditions = {nauvisAndGlebaPressure}

data.raw.recipe["light-armor"].enabled = false
data.raw.recipe["light-armor"].hidden = true
-- data.raw.recipe["firearm-magazine"].enabled = false
-- data.raw.recipe["firearm-magazine"].hidden = true
data.raw.recipe["underground-belt"].enabled = true
data.raw.recipe["splitter"].enabled = true
data.raw.recipe["iron-stick"].enabled = true

local biolab = data.raw.lab["biolab"]
biolab.inputs = {
  "tier-one-science-pack",
  "tier-two-science-pack",
  "tier-three-science-pack",
  "tier-four-science-pack",
  "tier-five-science-pack",
}

local biolab_recipe = data.raw.recipe["biolab"]
biolab_recipe.ingredients = {
  {type = "item", name = "iron-gear-wheel", amount = 10},
  {type = "item", name = "iron-stick", amount = 10},
  {type = "item", name = "copper-plate", amount = 10},
  {type = "item", name = "electronic-circuit", amount = 10},
}

local bigMiner_recipe = data.raw.recipe["big-mining-drill"]
bigMiner_recipe.ingredients = {
  {type = "item", name = "iron-plate", amount = 12},
  {type = "item", name = "iron-gear-wheel", amount = 6},
  {type = "item", name = "electronic-circuit", amount = 4},
}
bigMiner_recipe.energy_required = 20
bigMiner_recipe.category = "electronics"

local heatEx_recipe = data.raw.recipe["heat-exchanger"]
heatEx_recipe.ingredients = {
  {type = "item", name = "iron-plate", amount = 4},
  {type = "item", name = "boiler", amount = 1},
  {type = "item", name = "copper-plate", amount = 4},
}

local steamTurbine_recipe = data.raw.recipe["steam-turbine"]
steamTurbine_recipe.ingredients = {
  {type = "item", name = "steam-engine", amount = 1},
  {type = "item", name = "copper-plate", amount = 10},
}

local heatPipe_recipe = data.raw.recipe["heat-pipe"]
heatPipe_recipe.ingredients = {
  {type = "item", name = "pipe", amount = 2},
  {type = "item", name = "copper-plate", amount = 2},
}

--red belt buffs??
local redBelt_recipe = data.raw.recipe["fast-transport-belt"]
redBelt_recipe.ingredients = {
  {type = "item", name = "iron-gear-wheel", amount = 2},
  {type = "item", name = "transport-belt", amount = 1}
}

local redUnderground_recipe = data.raw.recipe["fast-underground-belt"]
redUnderground_recipe.ingredients = {
  {type = "item", name = "fast-transport-belt", amount = 5},
  {type = "item", name = "underground-belt", amount = 2}
}

local electricFurnace_recipe = data.raw.recipe['electric-furnace']
electricFurnace_recipe.ingredients = {
  {type = "item", name = "steel-plate", amount = 5},
  {type = "item", name = "electronic-circuit", amount = 5}
}

local heatingTower_recipe = data.raw.recipe['heating-tower']
heatingTower_recipe.ingredients = {
  {type = "item", name = "iron-plate", amount = 5},
  {type = "item", name = "heat-pipe", amount = 4},
  {type = "item", name = "copper-plate", amount = 5},
  {type = "item", name = "stone-furnace", amount = 1}
}

local mediumPowerPole_recipe = data.raw.recipe['medium-electric-pole']
mediumPowerPole_recipe.ingredients =
{
  {type = "item", name = "steel-plate", amount = 1},
  {type = "item", name = "copper-cable", amount = 2},
  {type = "item", name = "small-electric-pole-iron", amount = 1}
}

data.raw.technology["electronics"].effects =
{
  {
    type = "unlock-recipe",
    recipe = "copper-cable"
  },
  {
    type = "unlock-recipe",
    recipe = "electronic-circuit"
  },
  {
    type = "unlock-recipe",
    recipe = "inserter"
  },
  -- {
  --   type = "unlock-recipe",
  --   recipe = "small-electric-pole"
  -- },
  {
    type = "unlock-recipe",
    recipe = "small-electric-pole-iron"
  },
  {
    type = "unlock-recipe",
    recipe = "biolab"
  }
}

local bigMiner_tech = data.raw.technology["big-mining-drill"]
bigMiner_tech.prerequisites = {"electronics","biter-progress-tier-one-science"}
bigMiner_tech.unit =
{
  count = 50,
  ingredients =
  {
    {"tier-one-science-pack", 1}
  },
  time = 20
}
bigMiner_tech.research_trigger = nil

local automation_tech = data.raw.technology["automation"]
automation_tech.prerequisites = {"electronics","biter-progress-tier-one-science"}
automation_tech.unit =
{
  count = 25,
  ingredients =
  {
    {"tier-one-science-pack", 1}
  },
  time = 20
}

local automationTwo_tech = data.raw.technology["automation-2"]
automationTwo_tech.prerequisites = {"automation","biter-progress-tier-two-science"}
automationTwo_tech.unit =
{
  count = 50,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1}
  },
  time = 20
}

local electricPoles_tech = data.raw.technology["electric-energy-distribution-1"]
electricPoles_tech.effects =
{
  {
    type = "unlock-recipe",
    recipe = "medium-electric-pole"
  },
}
electricPoles_tech.prerequisites = {"biter-progress-tier-two-science"}
electricPoles_tech.unit =
{
  count = 75,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
  },
  time = 20
}

local heatingTower_tech = data.raw.technology["heating-tower"]
heatingTower_tech.prerequisites = {"biter-progress-tier-three-science"}
heatingTower_tech.unit =
{
  count = 200,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
    {"tier-three-science-pack", 1},
  },
  time = 20
}
heatingTower_tech.research_trigger = nil

data.raw["linked-container"]["linked-chest"].inventory_size = 48
data.raw["linked-container"]["linked-chest"].gui_mode = "all"
data.raw["linked-container"]["linked-chest"].max_health = 350
data.raw["linked-container"]["linked-chest"].impact_category = "metal"

local heatEx_entity = data.raw.boiler['heat-exchanger']
heatEx_entity.energy_source.min_working_temperature = 200
heatEx_entity.energy_source.minimum_glow_temperature = 200
heatEx_entity.target_temperature = 200
heatEx_entity.energy_consumption = "16MW"

local steamTurbine_entity = data.raw.generator['steam-turbine']
steamTurbine_entity.fluid_usage_per_tick = 2.4

local heatingTower_entity = data.raw.reactor['heating-tower']
heatingTower_entity.consumption = "32MW"
heatingTower_entity.energy_source.effectivity = 2

local stoneFurnace_entity = data.raw.furnace['stone-furnace']
stoneFurnace_entity.crafting_speed = 2

local electricFurnace_item = data.raw.item['electric-furnace']
electricFurnace_item.icon = "__frontier-td__/graphics/icons/electric-furnace.png"
local electricFurnace_entity = data.raw.furnace['electric-furnace']
electricFurnace_entity.crafting_speed = 6
electricFurnace_entity.graphics_set.animation =
{
  layers =
  {
    {
      filename = "__frontier-td__/graphics/entity/electric-furnace.png",
      priority = "high",
      width = 239,
      height = 219,
      shift = util.by_pixel(0.75, 5.75),
      scale = 0.25
    },
    {
      filename = "__base__/graphics/entity/electric-furnace/electric-furnace-shadow.png",
      priority = "high",
      width = 227,
      height = 171,
      draw_as_shadow = true,
      shift = util.by_pixel(11.25, 7.75),
      scale = 0.25
    }
  }
}
electricFurnace_entity.collision_box = {{-0.7, -0.7}, {0.7, 0.7}}
electricFurnace_entity.selection_box = {{-0.8, -1}, {0.8, 1}}
electricFurnace_entity.graphics_set.working_visualisations = 
{
  {
    fadeout = true,
    animation =
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/electric-furnace/electric-furnace-heater.png",
          priority = "high",
          width = 60,
          height = 56,
          frame_count = 12,
          animation_speed = 0.5,
          draw_as_glow = true,
          shift = util.by_pixel(1.25, 18.75),
          scale = 0.25
        },
        {
          filename = "__base__/graphics/entity/electric-furnace/electric-furnace-light.png",
          blend_mode = "additive",
          width = 202,
          height = 202,
          repeat_count = 12,
          draw_as_glow = true,
          shift = util.by_pixel(1, 0),
          scale = 0.25,
        },
      }
    },
  },
  {
    fadeout = true,
    animation =
    {
      filename = "__base__/graphics/entity/electric-furnace/electric-furnace-ground-light.png",
      blend_mode = "additive",
      width = 166,
      height = 124,
      draw_as_light = true,
      shift = util.by_pixel(3, 69),
      scale = 0.25,
    },
  },
  {
    animation =
    {
      filename = "__base__/graphics/entity/electric-furnace/electric-furnace-propeller-1.png",
      priority = "high",
      width = 37,
      height = 25,
      frame_count = 4,
      animation_speed = 0.5,
      shift = util.by_pixel(-10, -6),
      scale = 0.25
    }
  },
  {
    animation =
    {
      filename = "__base__/graphics/entity/electric-furnace/electric-furnace-propeller-2.png",
      priority = "high",
      width = 23,
      height = 15,
      frame_count = 4,
      animation_speed = 0.5,
      shift = util.by_pixel(2.5, -16),
      scale = 0.25
    }
  }
}