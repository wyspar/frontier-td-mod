-- settings of other mods, changed after every mod's settings.lua has run

-- aai loaders: no lubricant. "expensive" is aai's mode without fluid use, its more expensive recipes do not matter
-- here, base-data-updates.lua sets our own aai-loader and aai-fast-loader recipes after aai makes them.
-- locked to that mode and hidden, so a player can not switch it back to lubricated
local aaiLoadersMode = data.raw["string-setting"]["aai-loaders-mode"]
if aaiLoadersMode then
  aaiLoadersMode.default_value = "expensive"
  aaiLoadersMode.allowed_values = {"expensive"}
  aaiLoadersMode.hidden = true
end

-- only does something in the lubricated mode
local aaiLubricantRecipe = data.raw["string-setting"]["aai-loaders-lubricant-recipe"]
if aaiLubricantRecipe then
  aaiLubricantRecipe.hidden = true
end
