local map1 = {}
-- the generated wave tables are in map1-waves.lua
local mapWaveData = require("scripts.maps.map1-waves")

-- all x/y in this file are relative to the slot (0-350 into the slot), not world positions.
-- desert map: sand with dunes (groundPatchTiles), sand rocks all over (generate_structures in map.lua) and cliff
-- formations (cliffAreas) instead of water. the silo is in the middle, the spawner in the bottom right corner

-- along the bottom, up the left side and in to the silo from the west
map1.mapNormalBiterPaths = {
  {
    x = 330,
    y = 330
  },
  -- west along the bottom
  {
    x = 282,
    y = 324
  },
  {
    x = 234,
    y = 338
  },
  {
    x = 226,
    y = 275
  },
  {
    x = 177,
    y = 238
  },
  {
    x = 144,
    y = 245
  },
  {
    x = 126,
    y = 268
  },
  {
    x = 98,
    y = 308
  },
  {
    x = 79,
    y = 332
  },
  -- up the left side
  {
    x = 25,
    y = 324
  },
  {
    x = 14,
    y = 287
  },
  {
    x = 14,
    y = 233
  },
  -- in to the silo from the west
  {
    x = 35,
    y = 175
  },
  {
    x = 70,
    y = 175
  },
  {
    x = 150,
    y = 175
  },
}

map1.mapEasyWaves = mapWaveData.easyWaves

map1.mapNormalWaves = mapWaveData.normalWaves

-- shorter: cuts through the middle of the map straight up to the silo
map1.mapHardBiterPaths = {
  {
    x = 330,
    y = 330
  },
  {
    x = 282,
    y = 324
  },
  {
    x = 234,
    y = 338
  },
  {
    x = 226,
    y = 275
  },
  {
    x = 191,
    y = 235
  },
  {
    x = 142,
    y = 247
  },
  {
    x = 150,
    y = 175
  },
}

map1.mapHardWaves = mapWaveData.hardWaves

map1.mapTestWaves = {
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
  -- [2] = {
  --   waveDuration = 1,
  --   groups = {
  --     {name = "big-wriggler-pentapod", count = 2, interval = 1, startDelay = 0},
  --   },
  -- },
  -- [3] = {
  --   waveDuration = 1,
  --   groups = {
  --     {name = "big-strafer-pentapod", count = 2, interval = 1, startDelay = 0},
  --   },
  -- },
}

--1 is normal, --2 is easy, --3 is hard, --4 is test
map1.mapBiterWaveData = {
  [1] = map1.mapNormalWaves,
  [2] = map1.mapEasyWaves,
  [3] = map1.mapHardWaves,
  [4] = map1.mapTestWaves
}

map1.mapBiterPaths = {
  [1] = map1.mapNormalBiterPaths,
  [2] = map1.mapNormalBiterPaths,
  [3] = map1.mapHardBiterPaths,
  [4] = map1.mapNormalBiterPaths,
}

map1.DefaultMapStructures = {
  {
    name = "rocket-silo", --center of map for this map
    x = 175,
    y = 175
  },
  {
    name = "portal-1",
    x = 182,
    y = 172
  },
  {
    name = "portal-2",
    x = 182,
    y = 179
  },
  -- ores in a 2x2 block in the top right corner, 41x41 each (8 big mining drills fit along a side), 1 tile seams
  {
    name = "copper-ore",
    x = 286,
    y = 21,
    amount = 1000000,
    isOreTile = true,
    size=20
  },
  {
    name = "stone",
    x = 328,
    y = 21,
    amount = 1000000,
    isOreTile = true,
    size=20
  },
  {
    name = "iron-ore",
    x = 286,
    y = 63,
    amount = 1000000,
    isOreTile = true,
    size=20
  },
  {
    name = "coal",
    x = 328,
    y = 63,
    amount = 1000000,
    isOreTile = true,
    size=20
  },
  {
    name = "calcite",
    x = 70,
    y = 250,
    amount = 1000000,
    isOreTile = true,
    size=9
  },
  {
    name = "attack-market",
    x = 178,
    y = 168
  },
  {
    name = "weapons-market",
    x = 172,
    y = 168
  },
}

-- small oasis next to the base, water for offshore pumps
map1.waterCompleteTiles = {
  {
    x = 255,
    y = 120,
    radius = 9
  },
}

-- raised cliff formations, each circle is part of one (overlapping circles make one bigger formation).
-- the cliffs go around the outside of them on a 4x4 grid, see generateCliffs in map.lua.
-- they border the biter paths: every cliff is 9+ tiles from the middle of both paths (normal and hard),
-- 30+ tiles from the silo and clear of the ores, spawner and oasis. the calcite is on top of the bottom left one
map1.cliffAreas = {
  -- north of where the biters walk in to the silo from the west
  {x = 80, y = 125, radius = 42},
  {x = 140, y = 120, radius = 34},
  -- inside the bottom left loop of the path
  {x = 70, y = 250, radius = 45},
  -- bottom middle, between the path and the bottom edge
  {x = 175, y = 300, radius = 40},
  -- east, along the turn of the path before it heads to the silo
  {x = 280, y = 220, radius = 50},
  {x = 300, y = 265, radius = 43},
}

-- dunes: other sand tiles on top of the sand-1 map tile
map1.groundPatchTiles = {
  {tile = "sand-2", x = 60, y = 40, radius = 30},
  {tile = "sand-3", x = 240, y = 130, radius = 25},
  {tile = "sand-2", x = 300, y = 280, radius = 35},
  {tile = "red-desert-0", x = 150, y = 320, radius = 28},
  {tile = "sand-3", x = 40, y = 300, radius = 30},
  {tile = "sand-2", x = 200, y = 220, radius = 20},
  {tile = "sand-3", x = 120, y = 200, radius = 22},
  {tile = "red-desert-0", x = 250, y = 30, radius = 20},
  {tile = "sand-2", x = 20, y = 170, radius = 18},
  {tile = "sand-3", x = 330, y = 190, radius = 22},
}

map1.mapName = "map-1-sand"  
map1.mapLabel = "Sand Dunes"
map1.mapTile = "sand-1"
map1.mapIcon = "item/stone"

return map1