local map2 = {}
-- same waves as map1, the generated wave tables are in map1-waves.lua
local mapWaveData = require("scripts.maps.map1-waves")

-- all x/y in this file are relative to the slot (0-350 into the slot), not world positions.
-- the whole slot is filled with trees (generate_structures in map.lua), except on entities, ores,
-- path tiles, a circle around every waypoint and a corridor between waypoints

-- layout of the old 200x200 version scaled by 1.75 for the 350x350 slots. the spawner (top left) and the silo base
-- (bottom right: silo, portals, markets, pond) keep their distance to their corner instead of being scaled

-- spawner in the top left, along the top, then two full loops around the outside of the water ring
-- (waterOutlineTiles, center 271,77, water out to radius 28) at radius 32, leaving it on its south east side
-- and going down the right side to the silo
map2.mapNormalBiterPaths = {
  {
    x = 18,
    y = 18
  },
  {
    x = 88,
    y = 18
  },
  {
    x = 175,
    y = 52
  },
  -- around the water ring twice, clockwise, starting on its west side. 16 points per lap so the path hugs the ring
  {
    x = 239,
    y = 77
  },
  {
    x = 241,
    y = 65
  },
  {
    x = 248,
    y = 54
  },
  {
    x = 259,
    y = 47
  },
  {
    x = 271,
    y = 45
  },
  {
    x = 283,
    y = 47
  },
  {
    x = 294,
    y = 54
  },
  {
    x = 301,
    y = 65
  },
  {
    x = 303,
    y = 77
  },
  {
    x = 301,
    y = 89
  },
  {
    x = 294,
    y = 100
  },
  {
    x = 283,
    y = 107
  },
  {
    x = 271,
    y = 109
  },
  {
    x = 259,
    y = 107
  },
  {
    x = 248,
    y = 100
  },
  {
    x = 241,
    y = 89
  },
  {
    x = 239,
    y = 77
  },
  {
    x = 241,
    y = 65
  },
  {
    x = 248,
    y = 54
  },
  {
    x = 259,
    y = 47
  },
  {
    x = 271,
    y = 45
  },
  {
    x = 283,
    y = 47
  },
  {
    x = 294,
    y = 54
  },
  {
    x = 301,
    y = 65
  },
  {
    x = 303,
    y = 77
  },
  {
    x = 301,
    y = 89
  },
  {
    x = 294,
    y = 100
  },
  {
    x = 283,
    y = 107
  },
  {
    x = 271,
    y = 109
  },
  {
    x = 259,
    y = 107
  },
  {
    x = 248,
    y = 100
  },
  {
    x = 241,
    y = 89
  },
  -- then on around the top a third time to the south east side, so the exit is on the right
  {
    x = 239,
    y = 77
  },
  {
    x = 241,
    y = 65
  },
  {
    x = 248,
    y = 54
  },
  {
    x = 259,
    y = 47
  },
  {
    x = 271,
    y = 45
  },
  {
    x = 283,
    y = 47
  },
  {
    x = 294,
    y = 54
  },
  {
    x = 301,
    y = 65
  },
  {
    x = 303,
    y = 77
  },
  {
    x = 301,
    y = 89
  },
  {
    x = 294,
    y = 100
  },
  -- off the ring, down the right side to the silo
  {
    x = 318,
    y = 175
  },
  {
    x = 318,
    y = 245
  },
  {
    x = 328,
    y = 322
  },
}

map2.mapEasyWaves = mapWaveData.easyWaves

map2.mapNormalWaves = mapWaveData.normalWaves

--maybe later make it harder on the forest map
map2.mapHardBiterPaths = map2.mapNormalBiterPaths

map2.mapHardWaves = mapWaveData.hardWaves

map2.mapTestWaves = {
  [1] = {
    waveDuration = 30,
    groups = {
      {name = "boss-biter-6", count = 1, interval = 0, startDelay = 0},
      {name = "ultra-flyer", count = 1, interval = 0, startDelay = 5},
      {name = "boss-biter-5", count = 1, interval = 0, startDelay = 10},
      {name = "boss-biter-4", count = 1, interval = 0, startDelay = 15},
      {name = "boss-biter-3", count = 1, interval = 0, startDelay = 20},
      {name = "boss-biter-1", count = 1, interval = 0, startDelay = 25},
    },
  },
}

--1 is normal, --2 is easy, --3 is hard, --4 is test
map2.mapBiterWaveData = {
  [1] = map2.mapNormalWaves,
  [2] = map2.mapEasyWaves,
  [3] = map2.mapHardWaves,
  [4] = map2.mapTestWaves
}

map2.mapBiterPaths = {
  [1] = map2.mapNormalBiterPaths,
  [2] = map2.mapNormalBiterPaths,
  [3] = map2.mapHardBiterPaths,
  [4] = map2.mapNormalBiterPaths,
}

map2.DefaultMapStructures = {
  {
    name = "rocket-silo",
    x = 342,
    y = 342
  },
  {
    name = "portal-1",
    x = 339,
    y = 335
  },
  {
    name = "portal-2",
    x = 346,
    y = 335
  },
  {
    name = "iron-ore",
    x = 105,
    y = 328,
    amount = 1000000,
    isOreTile = true,
    size=20
  },
  {
    name = "copper-ore",
    x = 147,
    y = 328,
    amount = 1000000,
    isOreTile = true,
    size=20
  },
  {
    name = "coal",
    x = 21,
    y = 328,
    amount = 1000000,
    isOreTile = true,
    size=20
  },
  {
    name = "stone",
    x = 63,
    y = 328,
    amount = 1000000,
    isOreTile = true,
    size=20
  },
  {
    name = "calcite",
    x = 26,
    y = 79,
    amount = 1000000,
    isOreTile = true,
    size=9
  },
  {
    name = "attack-market",
    x = 336,
    y = 345
  },
  {
    name = "weapons-market",
    x = 336,
    y = 339
  },
}

map2.waterCompleteTiles = {
  -- pond next to the silo, same spot from the corner as before
  {
    x = 320,
    y = 350,
    radius = 10
  },
  {
    x = 0,
    y = 265,
    radius = 14
  },
}

map2.waterOutlineTiles = {
  {
    x = 271,
    y = 77,
    radius = 28,
    innerRadius = 25, 
    innerTile = "foundation",
    outerTile = "water"
  },
}

map2.mapName = "map-2-trees"
map2.mapLabel = "Deep Forest"
map2.mapTile = "grass-1"
map2.mapIcon = "entity/tree-01"

return map2
