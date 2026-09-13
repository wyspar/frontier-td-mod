local item_sounds = require("__base__.prototypes.item_sounds")
local item_effects = require("__space-age__.prototypes.item-effects")

local basicGunTurret = table.deepcopy(data.raw.item["gun-turret"])
basicGunTurret.name = "infinite-gun-turret"
basicGunTurret.place_result = "infinite-gun-turret"
basicGunTurret.order = "a[turret]-a[basic-gun-turret]"
basicGunTurret.icon = nil
basicGunTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/infinite-gun-turret.png",
    icon_size = 64,
  }
}

--tiered gun turrets
local tierTwoGunTurret = table.deepcopy(data.raw.item["gun-turret"])
tierTwoGunTurret.name = "tier-two-gun-turret"
tierTwoGunTurret.place_result = "tier-two-gun-turret"
tierTwoGunTurret.order = "a[turret]-a[tier-two-gun-turret]" 
tierTwoGunTurret.icon = nil
tierTwoGunTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-two-gun-turret.png",
    icon_size = 64
    -- tint = {r = 0.1, g = 1, b = 0.1, a = 1.0}
  }
}

local tierThreeGunTurret = table.deepcopy(data.raw.item["gun-turret"])
tierThreeGunTurret.name = "tier-three-gun-turret"
tierThreeGunTurret.place_result = "tier-three-gun-turret"
tierThreeGunTurret.order = "a[turret]-a[tier-three-gun-turret]" 
tierThreeGunTurret.icon = nil
tierThreeGunTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-three-gun-turret.png",
    icon_size = 64
  }
}

local tierFourGunTurret = table.deepcopy(data.raw.item["gun-turret"])
tierFourGunTurret.name = "tier-four-gun-turret"
tierFourGunTurret.place_result = "tier-four-gun-turret"
tierFourGunTurret.order = "a[turret]-a[tier-four-gun-turret]" 
tierFourGunTurret.icon = nil
tierFourGunTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-four-gun-turret.png",
    icon_size = 64
  }
}

local tierFiveGunTurret = table.deepcopy(data.raw.item["gun-turret"])
tierFiveGunTurret.name = "tier-five-gun-turret"
tierFiveGunTurret.place_result = "tier-five-gun-turret"
tierFiveGunTurret.order = "a[turret]-a[tier-five-gun-turret]" 
tierFiveGunTurret.icon = nil
tierFiveGunTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-five-gun-turret.png",
    icon_size = 64
  }
}

--tiered laser turrets
local tierOneLaserTurret = table.deepcopy(data.raw.item["laser-turret"])
tierOneLaserTurret.name = "tier-one-laser-turret"
tierOneLaserTurret.place_result = "tier-one-laser-turret"
tierOneLaserTurret.order = "a[turret]-a[tier-one-laser-turret]"
tierOneLaserTurret.icon = nil
tierOneLaserTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-one-laser-turret.png",
    icon_size = 64
  }
}

local tierTwoLaserTurret = table.deepcopy(data.raw.item["laser-turret"])
tierTwoLaserTurret.name = "tier-two-laser-turret"
tierTwoLaserTurret.place_result = "tier-two-laser-turret"
tierTwoLaserTurret.order = "a[turret]-a[tier-two-laser-turret]"
tierTwoLaserTurret.icon = nil
tierTwoLaserTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-two-laser-turret.png",
    icon_size = 64
  }
}

local tierThreeLaserTurret = table.deepcopy(data.raw.item["laser-turret"])
tierThreeLaserTurret.name = "tier-three-laser-turret"
tierThreeLaserTurret.place_result = "tier-three-laser-turret"
tierThreeLaserTurret.order = "a[turret]-a[tier-three-laser-turret]"
tierThreeLaserTurret.icon = nil
tierThreeLaserTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-three-laser-turret.png",
    icon_size = 64
  }
}

local tierFourLaserTurret = table.deepcopy(data.raw.item["laser-turret"])
tierFourLaserTurret.name = "tier-four-laser-turret"
tierFourLaserTurret.place_result = "tier-four-laser-turret"
tierFourLaserTurret.order = "a[turret]-a[tier-four-laser-turret]"
tierFourLaserTurret.icon = nil
tierFourLaserTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-four-laser-turret.png",
    icon_size = 64
  }
}

local tierFiveLaserTurret = table.deepcopy(data.raw.item["laser-turret"])
tierFiveLaserTurret.name = "tier-five-laser-turret"
tierFiveLaserTurret.place_result = "tier-five-laser-turret"
tierFiveLaserTurret.order = "a[turret]-a[tier-five-laser-turret]"
tierFiveLaserTurret.icon = nil
tierFiveLaserTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-five-laser-turret.png",
    icon_size = 64
  }
}

--tiered electric turrets
local tierOneTeslaTurret = table.deepcopy(data.raw.item["tesla-turret"])
tierOneTeslaTurret.name = "tier-one-tesla-turret"
tierOneTeslaTurret.place_result = "tier-one-tesla-turret"
tierOneTeslaTurret.order = "a[turret]-a[tier-one-tesla-turret]"
tierOneTeslaTurret.icon = nil
tierOneTeslaTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-one-tesla-turret.png",
    icon_size = 64
  }
}

local tierTwoTeslaTurret = table.deepcopy(data.raw.item["tesla-turret"])
tierTwoTeslaTurret.name = "tier-two-tesla-turret"
tierTwoTeslaTurret.place_result = "tier-two-tesla-turret"
tierTwoTeslaTurret.order = "a[turret]-a[tier-two-tesla-turret]"
tierTwoTeslaTurret.icon = nil
tierTwoTeslaTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-two-tesla-turret.png",
    icon_size = 64
  }
}

local tierThreeTeslaTurret = table.deepcopy(data.raw.item["tesla-turret"])
tierThreeTeslaTurret.name = "tier-three-tesla-turret"
tierThreeTeslaTurret.place_result = "tier-three-tesla-turret"
tierThreeTeslaTurret.order = "a[turret]-a[tier-three-tesla-turret]"
tierThreeTeslaTurret.icon = nil
tierThreeTeslaTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-three-tesla-turret.png",
    icon_size = 64
  }
}

local tierFourTeslaTurret = table.deepcopy(data.raw.item["tesla-turret"])
tierFourTeslaTurret.name = "tier-four-tesla-turret"
tierFourTeslaTurret.place_result = "tier-four-tesla-turret"
tierFourTeslaTurret.order = "a[turret]-a[tier-four-tesla-turret]"
tierFourTeslaTurret.icon = nil
tierFourTeslaTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-four-tesla-turret.png",
    icon_size = 64
  }
}

local tierFiveTeslaTurret = table.deepcopy(data.raw.item["tesla-turret"])
tierFiveTeslaTurret.name = "tier-five-tesla-turret"
tierFiveTeslaTurret.place_result = "tier-five-tesla-turret"
tierFiveTeslaTurret.order = "a[turret]-a[tier-five-tesla-turret]"
tierFiveTeslaTurret.icon = nil
tierFiveTeslaTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-five-tesla-turret.png",
    icon_size = 64
  }
}

data:extend({
  {
    type = "item",
    name = "small-electric-pole-iron",
    icon = "__frontier-td__/graphics/icons/small-electric-pole-iron.png",
    icon_size = 64,
    subgroup = "energy-pipe-distribution",
    order = "a[energy]-s[small-electric-pole-iron]",
    inventory_move_sound = item_sounds.electric_small_inventory_move,
    pick_sound = item_sounds.electric_small_inventory_pickup,
    drop_sound = item_sounds.electric_small_inventory_move,
    place_result = "small-electric-pole-iron",
    stack_size = 50
  },
  {
    type = "item",
    name = "bigass-steel-chest",
    icon = "__base__/graphics/icons/steel-chest.png",
    icon_size = 64,
    subgroup = "storage",
    hidden = true,
    order = "a[items]-b[bigass-steel-chest]",
    inventory_move_sound = item_sounds.metal_chest_inventory_move,
    pick_sound = item_sounds.metal_chest_inventory_pickup,
    drop_sound = item_sounds.metal_chest_inventory_move,
    place_result = "bigass-steel-chest",
    stack_size = 50
  },
  {
    type = "item",
    name = "boss-reward-item",
    icon = "__frontier-td__/graphics/icons/boss-reward-item.png",
    icon_size = 64,
    subgroup = "intermediate-product",
    order = "a[intermediate-product]-b[boss-reward-item]",
    inventory_move_sound = item_sounds.science_inventory_move,
    pick_sound = item_sounds.science_inventory_pickup,
    drop_sound = item_sounds.science_inventory_move,
    stack_size = 200
  },
  basicGunTurret,
  tierTwoGunTurret,
  tierThreeGunTurret,
  tierFourGunTurret,
  tierFiveGunTurret,
  tierOneLaserTurret,
  tierTwoLaserTurret,
  tierThreeLaserTurret,
  tierFourLaserTurret,
  tierFiveLaserTurret,
  tierOneTeslaTurret,
  tierTwoTeslaTurret,
  tierThreeTeslaTurret,
  tierFourTeslaTurret,
  tierFiveTeslaTurret
})
