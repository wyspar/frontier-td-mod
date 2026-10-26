--mini foundry (map 3 only, unlocked by the mini foundry tech in prototypes/technology.lua):
--a 3x3 copy of the space age foundry with its graphics scaled down, +33% productivity built in.
--loaded after base-data-updates.lua, its recipe costs the same as assembling machine 1 there

local SCALE = 3 / 5
--the foundry icon, darker, so the mini foundry can be told apart from the foundry (entity, item and tech)
local ICON_TINT = {r = 0.55, g = 0.55, b = 0.55, a = 1}

--scales every sprite (scale and shift) and every position in the foundry's graphics down to the 3x3 size.
--seen: table.deepcopy keeps shared tables shared, so a sprite used twice must only be scaled once
local function scaleGraphics(value, seen)
  if type(value) ~= "table" then
    return
  end
  seen = seen or {}
  if seen[value] then
    return
  end
  seen[value] = true
  if value.filename or value.filenames or value.stripes then
    value.scale = (value.scale or 1) * SCALE
  end
  for key, child in pairs(value) do
    if type(child) == "table" then
      local isPosition = (key == "shift" or (type(key) == "string" and key:sub(-9) == "_position"))
        and type(child[1]) == "number" and type(child[2]) == "number"
      if isPosition then
        value[key] = {child[1] * SCALE, child[2] * SCALE}
      else
        scaleGraphics(child, seen)
      end
    end
  end
end

local foundry = data.raw["assembling-machine"]["foundry"]
local assembler = data.raw["assembling-machine"]["assembling-machine-1"]

local miniFoundryIcons = {
  {icon = foundry.icon, icon_size = foundry.icon_size or 64, tint = ICON_TINT}
}

local miniFoundry = table.deepcopy(foundry)
miniFoundry.name = "mini-foundry"
miniFoundry.icon = nil
miniFoundry.icons = miniFoundryIcons
miniFoundry.minable = {mining_time = 0.2, result = "mini-foundry"}
miniFoundry.fast_replaceable_group = "mini-foundry"
miniFoundry.next_upgrade = nil
miniFoundry.max_health = 250
miniFoundry.collision_box = {{-1.2, -1.2}, {1.2, 1.2}}
miniFoundry.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
miniFoundry.drawing_box_vertical_extension = (foundry.drawing_box_vertical_extension or 0) * SCALE
miniFoundry.effect_receiver = {base_effect = {productivity = 0.33}}
miniFoundry.module_slots = 2
miniFoundry.crafting_speed = 2
miniFoundry.energy_usage = "1000kW"
miniFoundry.icon_draw_specification = {scale = 1.2, shift = {0, -0.2}}
miniFoundry.icons_positioning = {
  {inventory_index = defines.inventory.crafter_modules, shift = {0, 0.75}}
}
--3x3 like the assembling machine: its circuit connector, remnants and explosion
miniFoundry.circuit_connector = table.deepcopy(assembler.circuit_connector)
miniFoundry.circuit_wire_max_distance = assembler.circuit_wire_max_distance
miniFoundry.corpse = assembler.corpse
miniFoundry.dying_explosion = assembler.dying_explosion

scaleGraphics(miniFoundry.graphics_set)
scaleGraphics(miniFoundry.water_reflection)

--the animation plays at animation_speed * crafting_speed: at crafting speed 2 (the foundry is 4) the foundry's slow
--animation looked frozen, so it plays ANIMATION_SPEEDUP times faster. the crafting speed stays the same
local ANIMATION_SPEEDUP = 3
local function speedUpAnimations(value, seen)
  if type(value) ~= "table" or seen[value] then
    return
  end
  seen[value] = true
  if value.animation_speed then
    value.animation_speed = value.animation_speed * ANIMATION_SPEEDUP
  end
  for _, child in pairs(value) do
    speedUpAnimations(child, seen)
  end
end
speedUpAnimations(miniFoundry.graphics_set, {})

--the same 4 pipes (2 inputs south, 2 outputs north), on the edge of the 3x3 instead of the 5x5
for _, fluidBox in pairs(miniFoundry.fluid_boxes) do
  for _, connection in pairs(fluidBox.pipe_connections) do
    connection.position = {connection.position[1], connection.position[2] > 0 and 1 or -1}
  end
end

local foundryItem = data.raw.item["foundry"]
local miniFoundryItem = table.deepcopy(foundryItem)
miniFoundryItem.name = "mini-foundry"
miniFoundryItem.icon = nil
miniFoundryItem.icons = table.deepcopy(miniFoundryIcons)
miniFoundryItem.place_result = "mini-foundry"
miniFoundryItem.order = "c[mini-foundry]"

data:extend({
  miniFoundry,
  miniFoundryItem,
  {
    type = "recipe",
    name = "mini-foundry",
    enabled = false,
    -- by hand, in assemblers and in both foundries
    categories = {"crafting", "metallurgy"},
    energy_required = data.raw.recipe["assembling-machine-1"].energy_required or 0.5,
    ingredients = table.deepcopy(data.raw.recipe["assembling-machine-1"].ingredients),
    results = {{type = "item", name = "mini-foundry", amount = 1}}
  },
})
