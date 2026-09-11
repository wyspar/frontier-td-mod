-- Fix trees not being plantable on Alien Biomes tiles
-- Credit to blooest's fix for this bug report on the Alien Biomes discord!
-- I updated it slightly so that it shouldn't break if AB or another mod fixes this themselves
local tree_plant = data.raw.plant["tree-plant"]

if mods["alien-biomes"] and tree_plant then
  -- convert list of tiles into a dictionary for quick reference
  local ab_fertiles = alien_biomes.list_tiles(alien_biomes.require_tag(alien_biomes.all_tiles(), {"dirt", "grass"}))
  local ab_fertile_map = {}
  for _,tile in pairs(ab_fertiles) do
    ab_fertile_map[tile] = true
  end

  -- make sure this hasn't been fixed by anyone else
  local missing = true
  for _,tile in pairs(tree_plant.autoplace.tile_restriction) do
    if ab_fertile_map[tile] then
      missing = false
      break
    end
  end

  if missing then
    for _,tile in pairs(ab_fertiles) do
      table.insert(tree_plant.autoplace.tile_restriction, tile)
    end
  end
end


data.raw["electric-turret"]["laser-turret"].attack_parameters.damage_modifier = 0.25
data.raw["ammo-turret"]["gun-turret"].attack_parameters.damage_modifier = 0.25


local laserTurret = data.raw["electric-turret"]["laser-turret"]
laserTurret.energy_source = {
  type = "void"
}