local map2 = {}
-- same waves as map1, the generated wave tables are in map1-waves.lua
local mapWaveData = require("scripts.maps.map1-waves")

-- all x/y in this file are relative to the slot (0-200 into the slot), not world positions.
-- the whole slot is filled with trees (generate_structures in map.lua), except on entities, ores,
-- path tiles, a circle around every waypoint and a corridor between waypoints

-- spawner in the top left, along the top, then two full loops around the outside of the water ring
-- (waterOutlineTiles, center 155,44, water out to radius 20) at radius 26, leaving it on its south east side
-- and going down the right side to the silo
map2.mapNormalBiterPaths = {
  {
    x = 16,
    y = 16
  },
  {
    x = 50,
    y = 16
  },
  {
    x = 100,
    y = 30
  },
  -- around the water ring twice, clockwise, starting on its west side
  {
    x = 129,
    y = 44
  },
  {
    x = 137,
    y = 26
  },
  {
    x = 155,
    y = 18
  },
  {
    x = 173,
    y = 26
  },
  {
    x = 181,
    y = 44
  },
  {
    x = 173,
    y = 62
  },
  {
    x = 155,
    y = 70
  },
  {
    x = 137,
    y = 62
  },
  {
    x = 129,
    y = 44
  },
  {
    x = 137,
    y = 26
  },
  {
    x = 155,
    y = 18
  },
  {
    x = 173,
    y = 26
  },
  {
    x = 181,
    y = 44
  },
  {
    x = 173,
    y = 62
  },
  {
    x = 155,
    y = 70
  },
  {
    x = 137,
    y = 62
  },
  -- then on around the top a third time to the south east side, so the exit is on the right
  {
    x = 129,
    y = 44
  },
  {
    x = 137,
    y = 26
  },
  {
    x = 155,
    y = 18
  },
  {
    x = 173,
    y = 26
  },
  {
    x = 181,
    y = 44
  },
  {
    x = 173,
    y = 62
  },
  -- off the ring, down the right side to the silo
  {
    x = 182,
    y = 100
  },
  {
    x = 182,
    y = 140
  },
  {
    x = 178,
    y = 172
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
    x = 192,
    y = 192
  },
  {
    name = "portal-1",
    x = 189,
    y = 185
  },
  {
    name = "portal-2",
    x = 196,
    y = 185
  },
  {
    name = "iron-ore",
    x = 85,
    y = 182,
    amount = 1000000,
    isOreTile = true,
    size=16
  },
  {
    name = "copper-ore",
    x = 119,
    y = 182,
    amount = 1000000,
    isOreTile = true,
    size=16
  },
  {
    name = "coal",
    x = 17,
    y = 182,
    amount = 1000000,
    isOreTile = true,
    size=16
  },
  {
    name = "stone",
    x = 51,
    y = 182,
    amount = 1000000,
    isOreTile = true,
    size=16
  },
  {
    name = "calcite",
    x = 15,
    y = 45,
    amount = 1000000,
    isOreTile = true,
    size=5
  },
  {
    name = "attack-market",
    x = 186,
    y = 195
  },
  {
    name = "weapons-market",
    x = 186,
    y = 189
  },
}

map2.waterCompleteTiles = {
  {
    x = 170,
    y = 200,
    radius = 10
  },
  {
    x = 0,
    y = 140,
    radius = 8
  },
}

map2.waterOutlineTiles = {
  {
    x = 155,
    y = 44,
    radius = 20,
    innerRadius = 17, 
    innerTile = "foundation",
    outerTile = "water"
  },
}

map2.mapName = "map-2-trees"
map2.mapLabel = "Deep Forest"
map2.mapTile = "grass-1"
map2.mapIcon = "entity/tree-01"

return map2
