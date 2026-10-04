-- local explosion_animations = require("__space-age__.prototypes.entity.explosion-animations")
-- local sounds = require("__base__.prototypes.entity.sounds")
require ("__base__.prototypes.entity.biter-animations")

-- keep these in sync with the biter scales/tints in enemies.lua
local biterTint1 = {0.5, 0.5, 0.5, 1}
local biterTint2 = {0.15, 0.15, 0.15, 0.7}

local biterScales = {
  ["small-biter"] = 0.25,
  ["medium-biter"] = 0.5,
  ["big-biter"] = 0.75,
  ["behemoth-biter"] = 1.2,
}

for biterName, scale in pairs(biterScales) do
  local explosion = data.raw["explosion"][biterName .. "-die"]
  if explosion then
    explosion.scale = scale
  end

  -- the dying/decaying body is drawn by the corpse, not the explosion
  local corpse = data.raw["corpse"][biterName .. "-corpse"]
  if corpse then
    add_biter_die_animation(scale, biterTint1, biterTint2, corpse)
  end
end

-- my biters from enemies.lua get their own copies of the vanilla corpse/die explosion
-- so changing their scale does not change the vanilla biters
-- keep these in sync with the scales/tints in enemies.lua
local physicalBiterTint1 = {0.1, 0.1, 0.9, 1}
local physicalBiterTint2 = {0.15, 0.15, 0.15, 0.7}

local customBiters = {
  ["small-physical-biter"] = {
    copyFrom = "small-biter",
    scale = 0.25,
    tint1 = physicalBiterTint1,
    tint2 = physicalBiterTint2
  },
  ["medium-physical-biter"] = {
    copyFrom = "medium-biter",
    scale = 0.5,
    tint1 = physicalBiterTint1,
    tint2 = physicalBiterTint2
  },
  ["big-physical-biter"] = {
    copyFrom = "big-biter",
    scale = 0.75,
    tint1 = physicalBiterTint1,
    tint2 = physicalBiterTint2
  },
  ["behemoth-physical-biter"] = {
    copyFrom = "behemoth-biter",
    scale = 1.2,
    tint1 = physicalBiterTint1,
    tint2 = physicalBiterTint2
  },
  ["boss-biter-1"] = {
    copyFrom = "behemoth-biter",
    scale = 2,
    tint1 = {0.5, 0.5, 0.5, 1},
    tint2 = {0.15, 0.15, 0.15, 0.7}
  },
}

local newPrototypes = {}

for biterName, biter in pairs(customBiters) do
  -- creates "<biterName>-die"
  local explosion = table.deepcopy(data.raw["explosion"][biter.copyFrom .. "-die"])
  explosion.name = biterName .. "-die"
  explosion.scale = biter.scale
  table.insert(newPrototypes, explosion)

  -- creates "<biterName>-corpse"
  local corpse = table.deepcopy(data.raw["corpse"][biter.copyFrom .. "-corpse"])
  corpse.name = biterName .. "-corpse"
  add_biter_die_animation(biter.scale, biter.tint1, biter.tint2, corpse)
  table.insert(newPrototypes, corpse)
end

data:extend(newPrototypes)
