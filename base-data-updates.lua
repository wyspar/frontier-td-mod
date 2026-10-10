local frep = require("__fdsl__.lib.recipe")
local ftech = require("__fdsl__.lib.technology")

local nauvisAndGlebaPressure = {
  property = "pressure",
  min = 1000,
  max = 2000
}

local tree_plant = data.raw.plant["tree-plant"]
tree_plant.minable.results = {{type="item", name="wood", amount=10}}
  tree_plant.growth_ticks = 5 * minute
tree_plant.harvest_emissions = {pollution=0}

data.raw.plant["jellystem"].autoplace.tile_restriction = {}
data.raw.plant["yumako-tree"].autoplace.tile_restriction = {}

--Tower changes
data.raw.item["agricultural-tower"].weight = 100 * kg

--only things players can make here (no gleba carbon fiber or spoilage), unlocked by our agriculture tech
data.raw.recipe["agricultural-tower"].ingredients =
{
  {type = "item", name = "steel-plate", amount = 50},
  {type = "item", name = "electronic-circuit", amount = 50},
  {type = "item", name = "advanced-circuit", amount = 20},
  {type = "item", name = "electric-engine-unit", amount = 2},
  {type = "item", name = "landfill", amount = 50}
}


local agricultural_tower = data.raw["agricultural-tower"]["agricultural-tower"]
agricultural_tower.energy_usage = "500kW"
agricultural_tower.crane_energy_usage = "500kW"

--Assembler changes
table.insert(data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories, "organic-or-assembling")
data.raw['assembling-machine']['assembling-machine-2'].crafting_speed = 1
data.raw['assembling-machine']['assembling-machine-3'].crafting_speed = 2

-- The quality mod's "quality-factoriopedia" tip simulation looks for the vanilla
-- assembling-machine-3 crafting speed label ("1.25") and crashes when it's missing.
local qualityFactoriopediaTip = data.raw["tips-and-tricks-item"] and data.raw["tips-and-tricks-item"]["quality-factoriopedia"]
if qualityFactoriopediaTip and qualityFactoriopediaTip.simulation and qualityFactoriopediaTip.simulation.init then
  local init = qualityFactoriopediaTip.simulation.init
  init = init:gsub('data = "1%.25"', 'data = "2"')
  init = init:gsub(
    'return game%.simulation%.move_cursor%(%{position = target, speed = 0%.15%}%)',
    'if not target then return true end return game.simulation.move_cursor({position = target, speed = 0.15})'
  )
  qualityFactoriopediaTip.simulation.init = init
end

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
data.raw.recipe["crusher"].surface_conditions = {nauvisAndGlebaPressure}
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
biolab.researching_speed = 6

local biolab_recipe = data.raw.recipe["biolab"]
biolab_recipe.ingredients = {
  {type = "item", name = "iron-gear-wheel", amount = 10},
  {type = "item", name = "iron-stick", amount = 10},
  {type = "item", name = "copper-plate", amount = 10},
  {type = "item", name = "electronic-circuit", amount = 10},
}
biolab_recipe.category = "electronics"

--big mining drill (5x5) mines a 7x7 area instead of 13x13, 1 tile past the drill on every side.
--the drill is an odd size so the area has to be odd too, radius x.49 = (2 * x + 1) tiles across
local bigMiner_entity = data.raw["mining-drill"]["big-mining-drill"]
bigMiner_entity.resource_searching_radius = 3.49

local bigMiner_recipe = data.raw.recipe["big-mining-drill"]
bigMiner_recipe.ingredients = {
  {type = "item", name = "iron-plate", amount = 12},
  {type = "item", name = "iron-gear-wheel", amount = 6},
  {type = "item", name = "electronic-circuit", amount = 4},
}
bigMiner_recipe.energy_required = 10
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
electricFurnace_recipe.category = "electronics"
electricFurnace_recipe.allow_productivity = true

data.raw.recipe['chemical-plant'].category = "electronics"
data.raw.recipe['assembling-machine-3'].category = "electronics"

local concrete_recipe = data.raw.recipe['concrete']
concrete_recipe.ingredients =
{
  {type = "item", name = "stone-brick", amount = 5},
  {type = "item", name = "calcite", amount = 1},
  {type = "fluid", name = "water", amount = 100}
}

local electricUnit_recipe = data.raw.recipe['electric-engine-unit']
electricUnit_recipe.category = nil
electricUnit_recipe.ingredients =
{
  {type = "item", name = "engine-unit", amount = 1},
  {type = "item", name = "electronic-circuit", amount = 1},
  {type = "item", name = "advanced-circuit", amount = 1}
}

local redChip_recipe = data.raw.recipe['advanced-circuit']
redChip_recipe.ingredients =
{
  {type = "item", name = "electronic-circuit", amount = 1},
  {type = "item", name = "compressed-coal", amount = 2},
  {type = "item", name = "copper-cable", amount = 5}
}

local blueChip_recipe = data.raw.recipe['processing-unit']
blueChip_recipe.category = "electronics"
blueChip_recipe.ingredients =
{
  {type = "item", name = "electronic-circuit", amount = 10},
  {type = "item", name = "advanced-circuit", amount = 2},
  {type = "item", name = "copper-cable", amount = 6}
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
mediumPowerPole_recipe.allow_productivity = true

local crusher_recipe = data.raw.recipe['crusher']
crusher_recipe.ingredients =
{
  {type = "item", name = "advanced-circuit", amount = 10},
  {type = "item", name = "steel-plate", amount = 10},
  {type = "item", name = "electric-engine-unit", amount = 10}
}

local electromagneticPlant_recipe = data.raw.recipe['electromagnetic-plant']
electromagneticPlant_recipe.ingredients =
{
  {type = "item", name = "advanced-circuit", amount = 25},
  {type = "item", name = "steel-plate", amount = 25},
  {type = "item", name = "concrete", amount = 25}
}

local aaiLoader = data.raw.recipe["aai-loader"]
if aaiLoader then
  aaiLoader.ingredients = {
    {type = "item", name = "transport-belt", amount = 1},
    {type = "item", name = "iron-gear-wheel", amount = 25},
    {type = "item", name = "electronic-circuit", amount = 25}
  }
  aaiLoader.energy_required = 2
end

local aaiFastLoader = data.raw.recipe["aai-fast-loader"]
if aaiFastLoader then
  aaiFastLoader.ingredients = {
    {type = "item", name = "fast-transport-belt", amount = 1},
    {type = "item", name = "aai-loader", amount = 1},
    {type = "item", name = "electronic-circuit", amount = 25}
  }
  aaiFastLoader.energy_required = 2
end

local battery_recipe = data.raw.recipe['battery']
battery_recipe.ingredients =
{
  {type = "item", name = "iron-plate", amount = 1},
  {type = "item", name = "copper-plate", amount = 1}
}

local roboport_recipe = data.raw.recipe['roboport']
roboport_recipe.ingredients =
{
  {type = "item", name = "steel-plate", amount = 25},
  {type = "item", name = "iron-gear-wheel", amount = 15},
  {type = "item", name = "electric-engine-unit", amount = 4},
  {type = "item", name = "advanced-circuit", amount = 15}
}
roboport_recipe.category = "electronics"

local speedMod_recipe = data.raw.recipe['speed-module']
speedMod_recipe.ingredients =
{
  {type = "item", name = "advanced-circuit", amount = 3},
  {type = "item", name = "electronic-circuit", amount = 3}
}
speedMod_recipe.energy_required = 10

local prodMod_recipe = data.raw.recipe['productivity-module']
prodMod_recipe.ingredients =
{
  {type = "item", name = "advanced-circuit", amount = 3},
  {type = "item", name = "electronic-circuit", amount = 3}
}
prodMod_recipe.energy_required = 10

local bulkInserter_recipe = data.raw.recipe['bulk-inserter']
bulkInserter_recipe.ingredients =
{
  {type = "item", name = "iron-gear-wheel", amount = 10},
  {type = "item", name = "electronic-circuit", amount = 10},
  {type = "item", name = "advanced-circuit", amount = 1},
  {type = "item", name = "fast-inserter", amount = 1}
}

local landfill_recipe = data.raw.recipe['landfill']
landfill_recipe.ingredients =
{
  {type = "item", name = "stone", amount = 10}
}
landfill_recipe.allow_productivity = true

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

local steel_tech = data.raw.technology["steel-processing"]
steel_tech.prerequisites = {"biter-progress-tier-one-science"}
steel_tech.effects =
{
  {
    type = "unlock-recipe",
    recipe = "steel-plate"
  },
  {
    type = "unlock-recipe",
    recipe = "engine-unit"
  },
  {
    type = "unlock-recipe",
    recipe = "steel-chest"
  }
}
steel_tech.unit =
{
  count = 35,
  ingredients =
  {
    {"tier-one-science-pack", 1}
  },
  time = 20
}

local steelAxe_tech = data.raw.technology["steel-axe"]
steelAxe_tech.prerequisites = {"biter-progress-tier-one-science","steel-processing"}
steelAxe_tech.effects =
{
  {
    type = "character-mining-speed",
    modifier = 2
  }
}
steelAxe_tech.research_trigger =
{
  type = "craft-item",
  item = "steel-plate",
  count = 25
}

local fastInserter_tech = data.raw.technology["fast-inserter"]
fastInserter_tech.prerequisites = {"automation"}
fastInserter_tech.unit =
{
  count = 50,
  ingredients =
  {
    {"tier-one-science-pack", 1},
  },
  time = 20
}

local inserterCapacity1_tech = data.raw.technology["inserter-capacity-bonus-1"]
inserterCapacity1_tech.prerequisites = {"fast-inserter"}
inserterCapacity1_tech.effects =
{
  {
    type = "inserter-stack-size-bonus",
    modifier = 1 -- result of 2
  },
  {
    type = "bulk-inserter-capacity-bonus",
    modifier = 3 -- result of 5
  }
}
inserterCapacity1_tech.unit =
{
  count = 100,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
  },
  time = 20
}

local miningProd1_tech = data.raw.technology["mining-productivity-1"]
miningProd1_tech.prerequisites = {"biter-progress-tier-one-science"}
miningProd1_tech.effects =
{
  {
    type = "mining-drill-productivity-bonus",
    modifier = 0.5
  }
}
miningProd1_tech.unit =
{
  count = 50,
  ingredients =
  {
    {"tier-one-science-pack", 1},
  },
  time = 20
}

local miningProd2_tech = data.raw.technology["mining-productivity-2"]
miningProd2_tech.prerequisites = {"mining-productivity-1"}
miningProd2_tech.effects =
{
  {
    type = "mining-drill-productivity-bonus",
    modifier = 1
  }
}
miningProd2_tech.unit =
{
  count = 100,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
  },
  time = 20
}

local automationTwo_tech = data.raw.technology["automation-2"]
automationTwo_tech.prerequisites = {"automation","biter-progress-tier-two-science", "steel-processing"}
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
electricPoles_tech.prerequisites = {"biter-progress-tier-two-science", "steel-processing"}
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

local landfill_tech = data.raw.technology["landfill"]
landfill_tech.prerequisites = {"biter-progress-tier-two-science"}
landfill_tech.unit =
{
  count = 50,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
  },
  time = 20
}
local heatingTower_tech = data.raw.technology["heating-tower"]
heatingTower_tech.prerequisites = {"biter-progress-tier-three-science","steam-power"}
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

local concrete_tech = data.raw.technology["concrete"]
concrete_tech.prerequisites = {"biter-progress-tier-three-science"}
concrete_tech.effects =
{
  {
    type = "unlock-recipe",
    recipe = "concrete"
  }
}
concrete_tech.unit =
{
  count = 75,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
    {"tier-three-science-pack", 1},
  },
  time = 20
}

local electricEngine_tech = data.raw.technology["electric-engine"]
electricEngine_tech.prerequisites = {"biter-progress-tier-three-science", "steel-processing","electronics","advanced-circuit"}
electricEngine_tech.unit =
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

local battery_tech = data.raw.technology["battery"]
battery_tech.prerequisites = {"biter-progress-tier-three-science"}
battery_tech.unit =
{
  count = 100,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
    {"tier-three-science-pack", 1},
  },
  time = 20
}

local redChip_tech = data.raw.technology["advanced-circuit"]
redChip_tech.prerequisites = {"biter-progress-tier-three-science","electronics","compressed-coal"}
redChip_tech.unit =
{
  count = 125,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
    {"tier-three-science-pack", 1},
  },
  time = 20
}

local modules_tech = data.raw.technology["modules"]
modules_tech.prerequisites = {"biter-progress-tier-three-science","electronics","advanced-circuit"}
modules_tech.unit =
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
modules_tech.effects =
{
  {
    type = "unlock-recipe",
    recipe = "speed-module"
  },
  {
    type = "unlock-recipe",
    recipe = "productivity-module"
  },
  --biter module 2 and 3 have their own techs in prototypes/technology.lua
  {
    type = "unlock-recipe",
    recipe = "biter-module-1"
  }
}

local beacon_tech = data.raw.technology["effect-transmission"]
beacon_tech.prerequisites = {"biter-progress-tier-four-science","electronics","advanced-circuit","modules","steel-processing"}
beacon_tech.unit =
{
  count = 50,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
    {"tier-three-science-pack", 1},
    {"tier-four-science-pack", 1},
  },
  time = 20
}

local blueChip_tech = data.raw.technology["processing-unit"]
blueChip_tech.prerequisites = {"biter-progress-tier-four-science","advanced-circuit"}
blueChip_tech.category = nil
blueChip_tech.unit = 
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

local automation3_tech = data.raw.technology["automation-3"]
automation3_tech.prerequisites = {"biter-progress-tier-four-science","electronics","advanced-circuit","modules","steel-processing","automation-2"}
automation3_tech.unit =
{
  count = 150,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
    {"tier-three-science-pack", 1},
    {"tier-four-science-pack", 1},
  },
  time = 25
}

local bulkInserter_tech = data.raw.technology["bulk-inserter"]
bulkInserter_tech.prerequisites = {"biter-progress-tier-four-science","electronics","advanced-circuit"}
bulkInserter_tech.unit =
{
  count = 100,
  ingredients =
  {
    {"tier-one-science-pack", 1},
    {"tier-two-science-pack", 1},
    {"tier-three-science-pack", 1},
    {"tier-four-science-pack", 1},
  },
  time = 20
}

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

local beacon_entity = data.raw.beacon['beacon']
beacon_entity.supply_area_distance = 5
beacon_entity.module_slots = 3
beacon_entity.allowed_effects = {"productivity", "consumption", "speed", "pollution"}

local crusher_entity = data.raw['assembling-machine']['crusher']
crusher_entity.surface_conditions = {nauvisAndGlebaPressure}

local steelChest_entity = data.raw.container['steel-chest']
steelChest_entity.max_health = 100

local ironChest_entity = data.raw.container['iron-chest']
ironChest_entity.max_health = 100

local stoneFurnace_entity = data.raw.furnace['stone-furnace']
stoneFurnace_entity.crafting_speed = 2
stoneFurnace_entity.max_health = 100
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

local ultraFlyer_entity = data.raw.unit['ultra-flyer']
if ultraFlyer_entity then
  ultraFlyer_entity.max_health = 35000
  ultraFlyer_entity.attack_parameters.range = 25
  ultraFlyer_entity.has_belt_immunity = true
end

--flyer health (l9m2-flyer-enemy mod defaults: small 60, medium 120, big 480, behemoth 1920)
local smallFlyer_entity = data.raw.unit['small-flyer']
if smallFlyer_entity then
  smallFlyer_entity.max_health = 100
end

local mediumFlyer_entity = data.raw.unit['medium-flyer']
if mediumFlyer_entity then
  mediumFlyer_entity.max_health = 350
end

local bigFlyer_entity = data.raw.unit['big-flyer']
if bigFlyer_entity then
  bigFlyer_entity.max_health = 1500
end

local behemothFlyer_entity = data.raw.unit['behemoth-flyer']
if behemothFlyer_entity then
  behemothFlyer_entity.max_health = 6000
end

local slowdownSticker = data.raw["sticker"]["slowdown-sticker"]
slowdownSticker.duration_in_ticks = 20 * 60 --10 seconds (60 ticks = 1 second)
--slowdownSticker.target_movement_modifier = 0.5 --how much they're slowed

local stunSticker = data.raw["sticker"]["stun-sticker"]
stunSticker.duration_in_ticks = 20
stunSticker.target_movement_modifier = 0

local electricStunSticker = data.raw["sticker"]["electric-mini-stun"]
electricStunSticker.duration_in_ticks = 20
electricStunSticker.target_movement_modifier = 0.1


--armoured biters (ArmouredBiters mod, spawned as friendly biters by the biter modules):
--small and medium walk at ARMOURED_BITER_SPEED, big a bit faster than a vanilla behemoth biter
--(distance_per_frame is scaled the same way so the walk animation still matches the speed),
--the big one has 500 hp, their attacks do extra damage, and every attack also hurts the biter itself.
--the self damage uses its own damage type so their resistances never reduce it
local ARMOURED_BITER_SPEED = 0.3
--big armoured biter speed = vanilla behemoth biter speed times this
local BIG_ARMOURED_BITER_SPEED_FACTOR = 1.1
--share of the biter's max health it loses on each of its own attacks
local ARMOURED_BITER_SELF_DAMAGE = 0.33
--how long their corpses stay (time_before_removed), the vanilla default is 15 minutes.
--scripts/biter-modules.lua also destroys them from script after the same 20 seconds as a backup
local ARMOURED_BITER_CORPSE_TICKS = 20 * 60

data:extend({
  {
    type = "damage-type",
    name = "armoured-biter-self-damage"
  }
})

--attack damage multiplier per biter, 2 = +100%. only the damage to the target, not the self damage
local ARMOURED_BITER_DAMAGE_MULTIPLIERS = {
  ["small-armoured-biter"] = 2,
  ["medium-armoured-biter"] = 2,
  ["big-armoured-biter"] = 4,
}

--multiplies the attack damage and adds the self damage
local function adjustAttack(action, damageMultiplier, selfDamage)
  if not action then
    return
  end
  --an action can be one action or a list of them, same for action_delivery and target_effects
  local actions = action.type and {action} or action
  for _, singleAction in pairs(actions) do
    local delivery = singleAction.action_delivery
    local deliveries = (delivery and delivery.type) and {delivery} or (delivery or {})
    for _, singleDelivery in pairs(deliveries) do
      local effects = singleDelivery.target_effects
      effects = (effects and effects.type) and {effects} or (effects or {})
      for _, effect in pairs(effects) do
        if effect.type == "damage" and effect.damage then
          effect.damage.amount = effect.damage.amount * damageMultiplier
        end
      end
      singleDelivery.source_effects = {
        type = "damage",
        damage = {amount = selfDamage, type = "armoured-biter-self-damage"}
      }
    end
  end
end

for biterName, damageMultiplier in pairs(ARMOURED_BITER_DAMAGE_MULTIPLIERS) do
  local biter = data.raw["unit"][biterName]
  if biter then
    local speed = ARMOURED_BITER_SPEED
    if biterName == "big-armoured-biter" then
      biter.max_health = 500
      speed = data.raw["unit"]["behemoth-biter"].movement_speed * BIG_ARMOURED_BITER_SPEED_FACTOR
    end
    biter.distance_per_frame = biter.distance_per_frame * (speed / biter.movement_speed)
    biter.movement_speed = speed
    adjustAttack(biter.attack_parameters.ammo_type.action, damageMultiplier, math.max(1, biter.max_health * ARMOURED_BITER_SELF_DAMAGE))
  end
end

for _, corpseName in pairs({"small_armoured-corpse", "medium-armoured-corpse", "big-armoured-corpse", "behemoth-armoured-corpse"}) do
  local corpse = data.raw["corpse"][corpseName]
  if corpse then
    corpse.time_before_removed = ARMOURED_BITER_CORPSE_TICKS
  end
end

--vehicle machine gun: sold in the weapons market (scripts/market.lua). it uses the submachine gun icon,
--so it gets a slightly darker tint to tell them apart, and it is unhidden so it shows up like a normal item
local vehicleMachineGun = data.raw["gun"]["vehicle-machine-gun"]
vehicleMachineGun.hidden = false
vehicleMachineGun.icons = {
  {
    icon = vehicleMachineGun.icon,
    icon_size = vehicleMachineGun.icon_size or 64,
    tint = {0.72, 0.72, 0.72, 1}
  }
}
vehicleMachineGun.icon = nil
