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
