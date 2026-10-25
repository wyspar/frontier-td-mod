local map3 = {}
-- same waves as map1, the generated wave tables are in map1-waves.lua
local mapWaveData = require("scripts.maps.map1-waves")

-- all x/y in this file are relative to the slot (0-350 into the slot), not world positions.
-- volcano map with TWO spawners, in the bottom left and bottom right corners. the biter paths of a difficulty are a
-- list of paths, one per spawner (map.getPathList in map.lua). a wave is not doubled: every spawn is split between the
-- spawners (sendToSlotSpawners in control.lua), so the same wave just comes from both sides.
-- the paths stay in the bottom half (the top half is room to build, ores on both sides): each one goes up its side,
-- through a switchback, crosses the other path above the lava diamond in the middle and comes down the other side of
-- the diamond to the silo (bottom middle)

map3.mapNormalBiterPaths = {
  {
    -- left spawner, up the left side
    {x = 22, y = 328},
    {x = 22, y = 200},
    -- switchback: down, across and back up (cliffs inside the loops)
    {x = 75, y = 200},
    {x = 75, y = 300},
    {x = 125, y = 300},
    {x = 125, y = 215},
    -- crosses the other path above the lava diamond
    {x = 175, y = 190},
    -- down the right side of the diamond to the silo
    {x = 208, y = 212},
    {x = 208, y = 285},
    {x = 188, y = 302},
  },
  {
    -- right spawner, up the right side
    {x = 328, y = 328},
    {x = 328, y = 200},
    -- switchback
    {x = 275, y = 200},
    {x = 275, y = 300},
    {x = 225, y = 300},
    {x = 225, y = 215},
    -- crosses the other path above the lava diamond
    {x = 175, y = 190},
    -- down the left side of the diamond to the silo
    {x = 142, y = 212},
    {x = 142, y = 285},
    {x = 162, y = 302},
  },
}

-- shorter: no second switchback
map3.mapHardBiterPaths = {
  {
    -- left spawner
    {x = 22, y = 328},
    {x = 22, y = 200},
    -- skips the second switchback
    {x = 75, y = 200},
    {x = 125, y = 215},
    -- crosses above the lava diamond
    {x = 175, y = 190},
    {x = 208, y = 212},
    {x = 208, y = 285},
    {x = 188, y = 302},
  },
  {
    -- right spawner
    {x = 328, y = 328},
    {x = 328, y = 200},
    -- skips the second switchback
    {x = 275, y = 200},
    {x = 225, y = 215},
    -- crosses above the lava diamond
    {x = 175, y = 190},
    {x = 142, y = 212},
    {x = 142, y = 285},
    {x = 162, y = 302},
  },
}

map3.mapEasyWaves = mapWaveData.easyWaves

map3.mapNormalWaves = mapWaveData.normalWaves

map3.mapHardWaves = mapWaveData.hardWaves

--1 is normal, --2 is easy, --3 is hard, --4 is test
map3.mapBiterWaveData = {
  [1] = map3.mapNormalWaves,
  [2] = map3.mapEasyWaves,
  [3] = map3.mapHardWaves,
  [4] = map3.mapNormalWaves
}

map3.mapBiterPaths = {
  [1] = map3.mapNormalBiterPaths,
  [2] = map3.mapNormalBiterPaths,
  [3] = map3.mapHardBiterPaths,
  [4] = map3.mapNormalBiterPaths,
}

map3.DefaultMapStructures = {
  {
    name = "rocket-silo", --bottom middle, where both paths end
    x = 175,
    y = 312
  },
  {
    name = "portal-1",
    x = 182,
    y = 309
  },
  {
    name = "portal-2",
    x = 182,
    y = 316
  },
  -- ores on both sides near the top, 15x15 each (3 big mining drills fit along a side), 1 tile seams,
  -- calcite under the coal (for molten iron and copper from lava)
  -- left side, top to bottom
  {
    name = "stone",
    x = 8,
    y = 17,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  {
    name = "copper-ore",
    x = 8,
    y = 33,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  {
    name = "iron-ore",
    x = 8,
    y = 49,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  {
    name = "coal",
    x = 8,
    y = 65,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  {
    name = "calcite",
    x = 8,
    y = 81,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  -- right side, top to bottom
  {
    name = "stone",
    x = 341,
    y = 17,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  {
    name = "copper-ore",
    x = 341,
    y = 33,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  {
    name = "iron-ore",
    x = 341,
    y = 49,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  {
    name = "coal",
    x = 341,
    y = 65,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  {
    name = "calcite",
    x = 341,
    y = 81,
    amount = 1000000,
    isOreTile = true,
    size=7
  },
  -- below the silo
  {
    name = "calcite",
    x = 175,
    y = 338,
    amount = 1000000,
    isOreTile = true,
    size=9
  },
  {
    name = "attack-market",
    x = 178,
    y = 305
  },
  {
    name = "weapons-market",
    x = 172,
    y = 305
  },
}

-- water for offshore pumps at the top middle (an offshore pump on lava pumps lava)
map3.waterCompleteTiles = {
  {x = 175, y = 12, radius = 8},
}

-- vulcanus cliffs (see generateCliffs in map.lua) inside the switchback loops, they keep the biters in their lanes.
-- every cliff is 9+ tiles from the middle of both paths (normal and hard) and outside the top half
map3.cliffName = "cliff-vulcanus"
map3.cliffAreas = {
  {x = 48, y = 255, radius = 16},
  {x = 100, y = 265, radius = 16},
  {x = 302, y = 255, radius = 18},
  {x = 250, y = 265, radius = 18},
}

-- ground tiles on top of the map tile, later ones are drawn over earlier ones. shape "diamond" is a square turned
-- 45 degrees, radius = middle to a tip. the lava diamond in the middle of the bottom half has hot cracks around it,
-- nothing can walk or build on the lava. the paths go around it 7+ tiles outside the hot cracks
map3.groundPatchTiles = {
  {tile = "volcanic-ash-light", x = 175, y = 0, radius = 48, shape = "diamond"},
  {tile = "volcanic-soil-dark", x = 100, y = 150, radius = 25},
  {tile = "volcanic-soil-dark", x = 250, y = 150, radius = 25},
  {tile = "volcanic-cracks-warm", x = 48, y = 255, radius = 22},
  {tile = "volcanic-cracks-warm", x = 302, y = 255, radius = 22},
  {tile = "volcanic-ash-dark", x = 120, y = 335, radius = 18},
  {tile = "volcanic-ash-dark", x = 230, y = 335, radius = 18},
  {tile = "volcanic-cracks-hot", x = 175, y = 245, radius = 26, shape = "diamond"},
  {tile = "lava", x = 175, y = 245, radius = 20, shape = "diamond"},
  -- small lava diamonds left and right of the pond at the top, halfway between the side and the pond
  {tile = "volcanic-cracks-hot", x = 88, y = 15, radius = 15},
  {tile = "lava", x = 88, y = 15, radius = 11},
  {tile = "volcanic-cracks-hot", x = 262, y = 15, radius = 15},
  {tile = "lava", x = 262, y = 15, radius = 11},
}

-- volcanic rocks and a few cold chimneys (generateRocks in map.lua), kept off the paths, the silo and the ores.
-- not too many, the top half is room to build. a name listed more often is picked more often
map3.rockNames = {
  "big-volcanic-rock", "big-volcanic-rock", "big-volcanic-rock", "big-volcanic-rock", "big-volcanic-rock", "big-volcanic-rock",
  "huge-volcanic-rock", "huge-volcanic-rock", "huge-volcanic-rock",
  "vulcanus-chimney-cold",
}
map3.rockCount = {100, 160}

-- research only on this map: hidden everywhere else, turned on for the slot's force when a round starts here
-- (startRoundForForce in control.lua). the techs themselves are in prototypes/technology.lua and base-data-updates.lua
map3.technologies = {"mini-foundry", "foundry"}

map3.mapName = "map-3-volcano"
map3.mapLabel = "Volcano Valley"
map3.mapTile = "volcanic-folds-warm"
map3.mapIcon = "entity/vulcanus-chimney-cold"

return map3
