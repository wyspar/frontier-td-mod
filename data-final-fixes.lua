-- data.raw["electric-turret"]["laser-turret"].attack_parameters.damage_modifier = 0.25
-- data.raw["ammo-turret"]["gun-turret"].attack_parameters.damage_modifier = 0.25

-- biter modules (prototypes/biter-modules.lua) go in every machine that takes modules and work with every recipe.
-- a list of allowed module categories gets "biter-module" added, no list already means every category.
-- their effects are consumption and (negative) speed, so those have to be allowed too
local biterModuleEffects = {"consumption", "speed"}

local function addBiterModuleCategory(prototype)
  if prototype.allowed_module_categories then
    table.insert(prototype.allowed_module_categories, "biter-module")
  end
end

for _, recipe in pairs(data.raw.recipe) do
  addBiterModuleCategory(recipe)
  recipe.allow_consumption = true
  recipe.allow_speed = true
end

for _, machineType in pairs({"assembling-machine", "furnace", "rocket-silo"}) do
  for _, machine in pairs(data.raw[machineType] or {}) do
    if machine.module_slots and machine.module_slots > 0 then
      addBiterModuleCategory(machine)
      -- no allowed_effects means every effect is allowed
      if machine.allowed_effects then
        if type(machine.allowed_effects) == "string" then
          machine.allowed_effects = {machine.allowed_effects}
        end
        for _, neededEffect in pairs(biterModuleEffects) do
          local hasEffect = false
          for _, effect in pairs(machine.allowed_effects) do
            if effect == neededEffect then
              hasEffect = true
            end
          end
          if not hasEffect then
            table.insert(machine.allowed_effects, neededEffect)
          end
        end
      end
    end
  end
end

-- beacons would only spread the extra power use, the biters only spawn from modules inside the machine
for _, beacon in pairs(data.raw.beacon) do
  if not beacon.allowed_module_categories then
    beacon.allowed_module_categories = {}
    for categoryName, _ in pairs(data.raw["module-category"]) do
      if categoryName ~= "biter-module" then
        table.insert(beacon.allowed_module_categories, categoryName)
      end
    end
  end
end

local laserTurret = data.raw["electric-turret"]["laser-turret"]
laserTurret.energy_source = {
  type = "void"
}

-- trees give no wood any more, mining one has a 15% chance to give 1 coin instead.
-- every "tree" prototype (all vanilla/space age trees and dead trees, also map-2-trees' forest).
-- gleba's yumako/jellystem are "plant" prototypes, not trees, so they keep their fruit
local TREE_COIN_CHANCE = 0.15

for _, tree in pairs(data.raw["tree"]) do
  if tree.minable then
    tree.minable.result = nil
    tree.minable.count = nil
    tree.minable.results = {
      {type = "item", name = "coin", amount = 1, probability = TREE_COIN_CHANCE}
    }
  end
end

-- every enemy corpse (biters, spitters, flyers, bosses, modded and space age units) disappears after
-- ENEMY_CORPSE_TICKS instead of the vanilla 15 minutes. building remnants are left alone.
-- armoured biter corpses are also removed from script after the same time (scripts/biter-modules.lua)
local ENEMY_CORPSE_TICKS = 20 * 60

for _, unitType in pairs({"unit", "spider-unit", "segmented-unit"}) do
  for _, unit in pairs(data.raw[unitType] or {}) do
    -- corpse can be one name or a list of names
    local corpseNames = type(unit.corpse) == "table" and unit.corpse or {unit.corpse}
    for _, corpseName in pairs(corpseNames) do
      local corpse = data.raw["corpse"][corpseName]
      if corpse then
        corpse.time_before_removed = ENEMY_CORPSE_TICKS
      end
    end
  end
end
