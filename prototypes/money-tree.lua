-- Money Tree (coin-tree): a gold tinted tree-01 that grows from Money Tree Seeds like a yumako tree
-- and gives coins when it is harvested (by hand or by an agricultural tower).
-- it is a "plant" (space age), not a "tree", so the no-wood/coin chance change for trees in
-- data-final-fixes.lua does not touch it. scripts/money-tree.lua makes sure only fully grown trees pay out

local MONEY_TREE_COINS = 30
local SEED_COIN_COST = 5

local goldTint = {r = 1, g = 0.78, b = 0.1, a = 1}
local goldTrunkTint = {r = 1, g = 0.85, b = 0.45, a = 1}

local moneyTree = table.deepcopy(data.raw["tree"]["tree-01"])
moneyTree.type = "plant"
moneyTree.name = "coin-tree"
-- vanilla trees have localised_name = {"entity-name.tree"} ("Tree"), the copy would keep it
moneyTree.localised_name = {"entity-name.coin-tree"}
moneyTree.localised_description = {"entity-description.coin-tree"}
moneyTree.flags = {"placeable-neutral", "placeable-off-grid", "breaths-air"}
moneyTree.hidden_in_factoriopedia = false
moneyTree.factoriopedia_alternative = nil
moneyTree.autoplace = {
  -- never spawns on its own, only planted
  probability_expression = 0,
  -- empty = every tile, like the yumako tree in base-data-updates.lua. water and out-of-map
  -- are still blocked by the collision mask below
  tile_restriction = {}
}
-- same as a tree (can't be on water), out-of-map tiles collide with everything anyway
moneyTree.collision_mask = {layers = {item = true, object = true, player = true, water_tile = true}}
moneyTree.growth_ticks = data.raw.plant["yumako-tree"].growth_ticks
moneyTree.harvest_emissions = {pollution = 0}
moneyTree.emissions_per_second = nil
moneyTree.surface_conditions = nil
moneyTree.minable = {
  mining_particle = "wooden-particle",
  mining_time = 0.5,
  results = {{type = "item", name = "coin", amount = MONEY_TREE_COINS}}
}
moneyTree.map_color = {r = 0.9, g = 0.7, b = 0.1, a = 1}
moneyTree.agricultural_tower_tint = {
  primary = goldTint,
  secondary = {r = 0.8, g = 0.6, b = 0.15, a = 1}
}

-- gold leaves (colors tints the leaves) and a golden trunk
moneyTree.colors = {goldTint}
for _, variation in pairs(moneyTree.variations or {}) do
  if variation.trunk then
    variation.trunk.tint = goldTrunkTint
  end
end

moneyTree.icons = {
  {icon = moneyTree.icon or "__base__/graphics/icons/tree-01.png", icon_size = moneyTree.icon_size or 64, tint = goldTint}
}
moneyTree.icon = nil

local seeds = {
  type = "item",
  name = "money-tree-seeds",
  -- an item that places an entity uses that entity's name unless it has its own (like the space age seeds)
  localised_name = {"item-name.money-tree-seeds"},
  localised_description = {"item-description.money-tree-seeds"},
  icons = {
    {icon = "__space-age__/graphics/icons/tree-seed.png", icon_size = 64, tint = goldTint}
  },
  subgroup = "nauvis-agriculture",
  order = "a[seeds]-c[money-tree-seeds]",
  plant_result = "coin-tree",
  place_result = "coin-tree",
  inventory_move_sound = data.raw.item["tree-seed"].inventory_move_sound,
  pick_sound = data.raw.item["tree-seed"].pick_sound,
  drop_sound = data.raw.item["tree-seed"].drop_sound,
  stack_size = 50,
  weight = 1 * kg
}

local seedsRecipe = {
  type = "recipe",
  name = "money-tree-seeds",
  enabled = false, -- unlocked by the agriculture tech (prototypes/technology.lua)
  energy_required = 1,
  ingredients = {
    {type = "item", name = "coin", amount = SEED_COIN_COST}
  },
  results = {{type = "item", name = "money-tree-seeds", amount = 1}}
}

data:extend({moneyTree, seeds, seedsRecipe})
