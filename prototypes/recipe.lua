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
    name = "small-electric-pole-iron",
    enabled = false,
    category = "electronics",
    ingredients =
    {
      {type = "item", name = "iron-plate", amount = 1},
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
      {type = "item", name = "engine-unit", amount = 1},
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
