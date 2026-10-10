local map1 = {}
-- the generated wave tables are in map1-waves.lua
local mapWaveData = require("scripts.maps.map1-waves")

map1.mapNormalBiterPaths = {
  {
    x = 185,
    y = 185
  },
  {
    x = 161,
    y = 185
  },
  {
    x = 134,
    y = 193
  },
  {
    x = 129,
    y = 157
  },
  {
    x = 101,
    y = 136
  },
  {
    x = 82,
    y = 140
  },
  {
    x = 72,
    y = 153
  },
  {
    x = 56,
    y = 176
  },
  {
    x = 45,
    y = 190
  },
  {
    x = 14,
    y = 185
  },
  {
    x = 8,
    y = 164
  },
  {
    x = 8,
    y = 133
  },
  {
    x = 20,
    y = 100
  },
  {
    x = 40,
    y = 100
  },
  {
    x = 81,
    y = 100
  },
}

map1.mapEasyWaves = mapWaveData.easyWaves

map1.mapNormalWaves = mapWaveData.normalWaves

map1.mapHardBiterPaths = {
  {
    x = 185,
    y = 185
  },
  {
    x = 161,
    y = 185
  },
  {
    x = 134,
    y = 193
  },
  {
    x = 129,
    y = 157
  },
  {
    x = 109,
    y = 134
  },
  {
    x = 81,
    y = 141
  },
  {
    x = 81,
    y = 100
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
    x = 100,
    y = 100
  },
  {
    name = "portal-1",
    x = 107,
    y = 97
  },
  {
    name = "portal-2",
    x = 107,
    y = 104
  },
  {
    name = "iron-ore",
    x = 142,
    y = 57,
    amount = 1000000,
    isOreTile = true,
    size=16
  },
  {
    name = "copper-ore",
    x = 142,
    y = 17,
    amount = 1000000,
    isOreTile = true,
    size=16
  },
  {
    name = "stone",
    x = 182,
    y = 17,
    amount = 1000000,
    isOreTile = true,
    size=16
  },
  {
    name = "coal",
    x = 182,
    y = 57,
    amount = 1000000,
    isOreTile = true,
    size=16
  },
  {
    name = "calcite",
    x = 40,
    y = 141,
    amount = 1000000,
    isOreTile = true,
    size=5
  },
  {
    name = "attack-market",
    x = 103,
    y = 93
  },
  {
    name = "weapons-market",
    x = 97,
    y = 93
  },
}

map1.waterCompleteTiles = {
  {
    x = 180,
    y = 140,
    radius = 38
  },
}

map1.waterOutlineTiles = {
  {
    x = 155,
    y = 172,
    radius = 12,
    innerRadius = 9, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 148,
    y = 172,
    radius = 12,
    innerRadius = 9, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 148,
    y = 165,
    radius = 12,
    innerRadius = 9, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 109,
    y = 149,
    radius = 12,
    innerRadius = 9, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 115,
    y = 149,
    radius = 12,
    innerRadius = 9, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 97,
    y = 163,
    radius = 21,
    innerRadius = 18, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 84,
    y = 192,
    radius = 25,
    innerRadius = 22, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 104,
    y = 186,
    radius = 22,
    innerRadius = 19, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 57,
    y = 128,
    radius = 22,
    innerRadius = 19, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 57,
    y = 128,
    radius = 20,
    innerRadius = 17, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 44,
    y = 154,
    radius = 18,
    innerRadius = 15, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 30,
    y = 119,
    radius = 14,
    innerRadius = 11, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 36,
    y = 131,
    radius = 14,
    innerRadius = 11, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 35,
    y = 170,
    radius = 15,
    innerRadius = 12, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 36,
    y = 160,
    radius = 17,
    innerRadius = 14, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 30,
    y = 134,
    radius = 17,
    innerRadius = 14, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 25,
    y = 145,
    radius = 17,
    innerRadius = 14, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  --right below the silo
  {
    x = 98,
    y = 122,
    radius = 8,
    innerRadius = 5, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 102,
    y = 122,
    radius = 8,
    innerRadius = 5, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 107,
    y = 122,
    radius = 8,
    innerRadius = 5, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 111,
    y = 122,
    radius = 8,
    innerRadius = 5, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 116,
    y = 122,
    radius = 8,
    innerRadius = 5, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
  {
    x = 120,
    y = 122,
    radius = 8,
    innerRadius = 5, 
    innerTile = "dirt-7",
    outerTile = "water"
  },
}

map1.mapName = "map-1-sand"  
map1.mapLabel = "Sand Dunes"
map1.mapTile = "sand-1"
map1.mapIcon = "item/stone"

return map1