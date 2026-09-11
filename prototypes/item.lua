local item_sounds = require("__base__.prototypes.item_sounds")
local item_effects = require("__space-age__.prototypes.item-effects")

local basicGunTurret = table.deepcopy(data.raw.item["gun-turret"])
basicGunTurret.name = "infinite-gun-turret"
basicGunTurret.place_result = "infinite-gun-turret"
basicGunTurret.order = "a[turret]-a[infinite-gun-turret]"
basicGunTurret.icon = nil
basicGunTurret.icons = nil
basicGunTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/infinite-gun-turret.png",
    icon_size = 64,
  }
}

local siloLaserTurret = table.deepcopy(data.raw.item["laser-turret"])
siloLaserTurret.name = "silo-laser-turret"
siloLaserTurret.place_result = "silo-laser-turret"
siloLaserTurret.order = "a[turret]-a[silo-laser-turret]"

--tier two turrets
local tierTwoGunTurret = table.deepcopy(data.raw.item["gun-turret"])
tierTwoGunTurret.name = "tier-two-gun-turret"
tierTwoGunTurret.place_result = "tier-two-gun-turret"
tierTwoGunTurret.order = "a[turret]-a[tier-two-gun-turret]" 
tierTwoGunTurret.icon = nil
tierTwoGunTurret.icons = nil
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
tierThreeGunTurret.icons = nil
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
tierFourGunTurret.icons = nil
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
tierFiveGunTurret.icons = nil
tierFiveGunTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-five-gun-turret.png",
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
  siloLaserTurret,
  tierTwoGunTurret,
  tierThreeGunTurret,
  tierFourGunTurret,
  tierFiveGunTurret
})
