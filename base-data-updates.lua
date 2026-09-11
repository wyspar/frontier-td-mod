local frep = require("__fdsl__.lib.recipe")
local ftech = require("__fdsl__.lib.technology")

local nauvisAndGlebaPressure = {
  {
    property = "pressure",
    min = 1000,
    max = 2000
  }
}

-------------------------------------------------------------------------- Tree changes

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

frep.set_surface_condition("agricultural-tower", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("pentapod-egg", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("biochamber", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("foundry", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("big-mining-drill", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("turbo-transport-belt", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("turbo-underground-belt", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("turbo-splitter", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("metallurgic-science-pack", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("agricultural-science-pack", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("electromagnetic-science-pack", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("cryogenic-science-pack", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("promethium-science-pack", {property="pressure", min=1000, max=2000})
frep.set_surface_condition("quantum-processor", {property="pressure", min=1000, max=2000})
data.raw.recipe["electromagnetic-plant"].surface_conditions = nauvisAndGlebaPressure
data.raw.recipe["recycler"].surface_conditions = nauvisAndGlebaPressure
data.raw.recipe["electromagnetic-science-pack"].surface_conditions = nauvisAndGlebaPressure
data.raw.recipe["electromagnetic-plant"].surface_conditions = nauvisAndGlebaPressure
data.raw.recipe["cryogenic-plant"].surface_conditions = nauvisAndGlebaPressure
data.raw.recipe["fusion-reactor"].surface_conditions = nauvisAndGlebaPressure
data.raw.recipe["fusion-generator"].surface_conditions = nauvisAndGlebaPressure

data.raw.recipe["light-armor"].enabled = false
data.raw.recipe["light-armor"].hidden = true
-- data.raw.recipe["firearm-magazine"].enabled = false
-- data.raw.recipe["firearm-magazine"].hidden = true


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
    recipe = "lab"
  },
  {
    type = "unlock-recipe",
    recipe = "inserter"
  },
  {
    type = "unlock-recipe",
    recipe = "small-electric-pole"
  },
  {
    type = "unlock-recipe",
    recipe = "small-electric-pole-iron"
  }
}

data.raw["linked-container"]["linked-chest"].inventory_size = 48
data.raw["linked-container"]["linked-chest"].gui_mode = "all"
data.raw["linked-container"]["linked-chest"].max_health = 350
data.raw["linked-container"]["linked-chest"].impact_category = "metal"

--data.raw.entities["linked-chest"].gui_mode = "all"