local towerCoinCosts = require('models.tower-coin-costs')

local recipes = {}
for tower, towerData in pairs(towerCoinCosts) do
  if tower and (tower == "infinite-gun-turret" or string.find(tower, "tier-one", 1, true)) and towerData and towerData.cost and data.raw.item[tower] then
    local towerIngredients = {
      {
        type = "item",
        name = "coin",
        amount = towerData.cost
      }
    }
    table.insert(recipes, {
      type = "recipe",
      name = tower,
      enabled = tower == "infinite-gun-turret",
      ingredients = towerIngredients,
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
    results = {{type="item", name="compressed-coal", amount=1}}
  },
  {
    type = "recipe",
    name = "ice-making",
    enabled = false,
    category = "chemistry",
    energy_required = 10,
    ingredients =
    {
      {type = "item", name = "fine-stone", amount = 1},
      {type = "fluid", name = "water", amount = 100}
    },
    results = {{type="item", name="ice", amount=1}}
  },
  {
    type = "recipe",
    name = "fine-stone",
    enabled = false,
    category = "crushing",
    subgroup="space-crushing",
    energy_required = 2,
    ingredients =
    {
      {type = "item", name = "stone", amount = 3}
    },
    results = {{type="item", name="fine-stone", amount=1}}
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
      {type = "item", name = "long-handed-inserter", amount = 1},
      {type = "item", name = "underground-belt", amount = 1},
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
      {type = "item", name = "medium-electric-pole", amount = 3},
      {type = "item", name = "electric-furnace", amount = 1},
      {type = "fluid", name = "steam", amount = 50}
    },
    results = {{type="item", name="tier-three-science-pack", amount=4}},
    allow_productivity = true
  },
  {
    type = "recipe",
    name = "tier-four-science-pack",
    enabled = false,
    energy_required = 8,
    ingredients =
    {
      {type = "item", name = "concrete", amount = 10},
      {type = "item", name = "electric-engine-unit", amount = 2},
      {type = "item", name = "battery", amount = 5},
    },
    results = {{type="item", name="tier-four-science-pack", amount=3}},
    allow_productivity = true
  },
  {
    type = "recipe",
    name = "tier-five-science-pack",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {type = "item", name = "processing-unit", amount = 1},
      {type = "item", name = "ice", amount = 1},
      {type = "item", name = "calcite", amount = 1},
    },
    results = {{type="item", name="tier-five-science-pack", amount=4}},
    allow_productivity = true
  },
  {
    type = "recipe",
    name = "ut-poison-cannon-one",
    enabled = false, -- unlocked by the ut-poison-cannon-one technology
    energy_required = 5,
    ingredients =
    {
      {type = "item", name = "boss-reward-item", amount = 1},
      {type = "item", name = "coin", amount = 250},
    },
    results = {{type = "item", name = "ut-poison-cannon-one", amount = 1}}
  },
})
