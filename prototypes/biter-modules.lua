-- biter modules: every normal craft (green bar, not the productivity bonus bar) of a machine
-- spawns one friendly armoured biter per biter module in it, see scripts/biter-modules.lua.
-- the only effect is extra power consumption, data-final-fixes.lua makes every recipe and
-- module machine (not beacons) accept them

data:extend({
  {
    type = "module-category",
    name = "biter-module"
  }
})

local biterModules = {
  {name = "biter-module-1", tier = 1, consumption = 0.5, moduleIcon = "efficiency-module", biterIcon = "small-biter"},
  {name = "biter-module-2", tier = 2, consumption = 1.0, moduleIcon = "efficiency-module-2", biterIcon = "medium-biter"},
  {name = "biter-module-3", tier = 3, consumption = 2.0, moduleIcon = "efficiency-module-3", biterIcon = "big-biter"},
}

local moduleTint = {0.75, 0.75, 0.75, 1}

-- crafting speed x0.8 = 25% longer crafting time
local CRAFTING_SPEED_EFFECT = -0.2

for _, biterModule in ipairs(biterModules) do
  data:extend({
    {
      type = "module",
      name = biterModule.name,
      icons = {
        {icon = "__base__/graphics/icons/" .. biterModule.moduleIcon .. ".png", icon_size = 64, tint = moduleTint},
        {icon = "__base__/graphics/icons/" .. biterModule.biterIcon .. ".png", icon_size = 64, scale = 0.25, shift = {8, 8}},
      },
      subgroup = "module",
      category = "biter-module",
      tier = biterModule.tier,
      order = "d[biter]-" .. biterModule.tier,
      inventory_move_sound = data.raw.module["speed-module"].inventory_move_sound,
      pick_sound = data.raw.module["speed-module"].pick_sound,
      drop_sound = data.raw.module["speed-module"].drop_sound,
      stack_size = 50,
      weight = 20 * kg,
      effect = {consumption = biterModule.consumption, speed = CRAFTING_SPEED_EFFECT},
    }
  })
end

data:extend({
  {
    type = "recipe",
    name = "biter-module-1",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name = "advanced-circuit", amount = 3},
      {type = "item", name = "electronic-circuit", amount = 3},
    },
    results = {{type = "item", name = "biter-module-1", amount = 1}}
  },
  {
    type = "recipe",
    name = "biter-module-2",
    enabled = false,
    energy_required = 30,
    ingredients = {
      {type = "item", name = "biter-module-1", amount = 4},
      {type = "item", name = "advanced-circuit", amount = 5},
      {type = "item", name = "processing-unit", amount = 5},
    },
    results = {{type = "item", name = "biter-module-2", amount = 1}}
  },
  {
    type = "recipe",
    name = "biter-module-3",
    enabled = false,
    energy_required = 60,
    ingredients = {
      {type = "item", name = "biter-module-2", amount = 4},
      {type = "item", name = "advanced-circuit", amount = 5},
      {type = "item", name = "processing-unit", amount = 5},
    },
    results = {{type = "item", name = "biter-module-3", amount = 1}}
  },
})
