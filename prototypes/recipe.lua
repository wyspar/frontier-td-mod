local towerCoinCosts = require('models.tower-coin-costs')

local recipes = {}
for tower, towerData in pairs(towerCoinCosts) do
  if tower and towerData and towerData.cost and data.raw.item[tower] then
    table.insert(recipes, {
      type = "recipe",
      name = tower,
      enabled = string.find(tower, "gun%-turret") ~= nil,
      ingredients = {
        {
          type = "item",
          name = "coin",
          amount = towerData.cost
        }
      },
      results = {
        {
          type = "item",
          name = tower,
          amount = 1
        }
      }
    })
  end
end

data:extend(recipes)
data:extend({
  {
    type = "recipe",
    name = "compressed-coal",
    enabled = false,
    category = "chemistry",
    energy_required = 3,
    ingredients =
    {
      {type = "item", name = "coal", amount = 2},
      {type = "fluid", name = "water", amount = 25}
    },
    results = {{type="item", name="small-electric-pole-iron", amount=1}}
  },
  {
    type = "recipe",
    name = "small-electric-pole-iron",
    enabled = false,
    category = "electronics",
    ingredients =
    {
      {type = "item", name = "iron-stick", amount = 2},
      {type = "item", name = "copper-cable", amount = 1}
    },
    results = {{type="item", name="small-electric-pole-iron", amount=1}}
  },
  {
    type = "recipe",
    name = "tier-one-science-pack",
    enabled = false,
    energy_required = 2,
    ingredients =
    {
      {type = "item", name = "iron-ore", amount = 1},
      {type = "item", name = "copper-ore", amount = 1},
      {type = "item", name = "stone", amount = 1},
      {type = "item", name = "coal", amount = 1},
    },
    results = {{type="item", name="tier-one-science-pack", amount=4}},
    allow_productivity = true
  },
  {
    type = "recipe",
    name = "tier-two-science-pack",
    enabled = false,
    energy_required = 4,
    ingredients =
    {
      {type = "item", name = "medium-electric-pole", amount = 1},
      {type = "item", name = "steam-turbine", amount = 1},
      {type = "item", name = "heat-pipe", amount = 2},
    },
    results = {{type="item", name="tier-two-science-pack", amount=3}},
    allow_productivity = true
  },
  {
    type = "recipe",
    name = "tier-three-science-pack",
    enabled = false,
    energy_required = 6,
    category = "crafting-with-fluid",
    ingredients =
    {
      {type = "item", name = "iron-chest", amount = 1},
      {type = "fluid", name = "water", amount = 100}
    },
    results = {{type="item", name="tier-three-science-pack", amount=3}},
    allow_productivity = true
  },
})
