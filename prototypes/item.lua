local item_sounds = require("__base__.prototypes.item_sounds")
local item_effects = require("__space-age__.prototypes.item-effects")
local item_tints = require("__base__.prototypes.item-tints")

local basicGunTurret = table.deepcopy(data.raw.item["gun-turret"])
basicGunTurret.name = "infinite-gun-turret"
basicGunTurret.place_result = "infinite-gun-turret"
basicGunTurret.subgroup = "gun-turrets"
basicGunTurret.order = "a[basic-gun-turret]"
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
tierTwoGunTurret.subgroup = "gun-turrets"
tierTwoGunTurret.order = "b[tier-two-gun-turret]" 
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
tierThreeGunTurret.subgroup = "gun-turrets"
tierThreeGunTurret.order = "c[tier-three-gun-turret]" 
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
tierFourGunTurret.subgroup = "gun-turrets"
tierFourGunTurret.order = "d[tier-four-gun-turret]" 
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
tierFiveGunTurret.subgroup = "gun-turrets"
tierFiveGunTurret.order = "e[tier-five-gun-turret]" 
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
tierOneLaserTurret.subgroup = "laser-turrets"
tierOneLaserTurret.order = "a[tier-one-laser-turret]"
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
tierTwoLaserTurret.subgroup = "laser-turrets"
tierTwoLaserTurret.order = "b[tier-two-laser-turret]"
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
tierThreeLaserTurret.subgroup = "laser-turrets"
tierThreeLaserTurret.order = "c[tier-three-laser-turret]"
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
tierFourLaserTurret.subgroup = "laser-turrets"
tierFourLaserTurret.order = "d[tier-four-laser-turret]"
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
tierFiveLaserTurret.subgroup = "laser-turrets"
tierFiveLaserTurret.order = "e[tier-five-laser-turret]"
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
tierOneTeslaTurret.subgroup = "tesla-turrets"
tierOneTeslaTurret.order = "a[tier-one-tesla-turret]"
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
tierTwoTeslaTurret.subgroup = "tesla-turrets"
tierTwoTeslaTurret.order = "b[tier-two-tesla-turret]"
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
tierThreeTeslaTurret.subgroup = "tesla-turrets"
tierThreeTeslaTurret.order = "c[tier-three-tesla-turret]"
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
tierFourTeslaTurret.subgroup = "tesla-turrets"
tierFourTeslaTurret.order = "d[tier-four-tesla-turret]"
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
tierFiveTeslaTurret.subgroup = "tesla-turrets"
tierFiveTeslaTurret.order = "e[tier-five-tesla-turret]"
tierFiveTeslaTurret.icon = nil
tierFiveTeslaTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-five-tesla-turret.png",
    icon_size = 64
  }
}

--tiered flamer turrets
local tierOneFlamerTurret = table.deepcopy(data.raw.item["flamethrower-turret"])
tierOneFlamerTurret.name = "tier-one-flamer-turret"
tierOneFlamerTurret.place_result = "tier-one-flamer-turret"
tierOneFlamerTurret.subgroup = "flamer-turrets"
tierOneFlamerTurret.order = "a[tier-one-flamer-turret]"
tierOneFlamerTurret.icon = nil
tierOneFlamerTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-one-flamer-turret.png",
    icon_size = 64
  }
}

local tierTwoFlamerTurret = table.deepcopy(data.raw.item["flamethrower-turret"])
tierTwoFlamerTurret.name = "tier-two-flamer-turret"
tierTwoFlamerTurret.place_result = "tier-two-flamer-turret"
tierTwoFlamerTurret.subgroup = "flamer-turrets"
tierTwoFlamerTurret.order = "b[tier-two-flamer-turret]"
tierTwoFlamerTurret.icon = nil
tierTwoFlamerTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-two-flamer-turret.png",
    icon_size = 64
  }
}

local tierThreeFlamerTurret = table.deepcopy(data.raw.item["flamethrower-turret"])
tierThreeFlamerTurret.name = "tier-three-flamer-turret"
tierThreeFlamerTurret.place_result = "tier-three-flamer-turret"
tierThreeFlamerTurret.subgroup = "flamer-turrets"
tierThreeFlamerTurret.order = "c[tier-three-flamer-turret]"
tierThreeFlamerTurret.icon = nil
tierThreeFlamerTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-three-flamer-turret.png",
    icon_size = 64
  }
}

local tierFourFlamerTurret = table.deepcopy(data.raw.item["flamethrower-turret"])
tierFourFlamerTurret.name = "tier-four-flamer-turret"
tierFourFlamerTurret.place_result = "tier-four-flamer-turret"
tierFourFlamerTurret.subgroup = "flamer-turrets"
tierFourFlamerTurret.order = "d[tier-four-flamer-turret]"
tierFourFlamerTurret.icon = nil
tierFourFlamerTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-four-flamer-turret.png",
    icon_size = 64
  }
}

local tierFiveFlamerTurret = table.deepcopy(data.raw.item["flamethrower-turret"])
tierFiveFlamerTurret.name = "tier-five-flamer-turret"
tierFiveFlamerTurret.place_result = "tier-five-flamer-turret"
tierFiveFlamerTurret.subgroup = "flamer-turrets"
tierFiveFlamerTurret.order = "e[tier-five-flamer-turret]"
tierFiveFlamerTurret.icon = nil
tierFiveFlamerTurret.icons = {
  {
    icon = "__frontier-td__/graphics/icons/tier-five-flamer-turret.png",
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
  {
    type = "tool",
    name = "tier-one-science-pack",
    localised_description = {"item-description.science-pack"},
    icon = "__frontier-td__/graphics/icons/tier-one-science-pack.png",
    icon_size = 64,
    subgroup = "science-pack",
    color_hint = { text = "O" },
    order = "a[tier-one-science-pack]",
    inventory_move_sound = item_sounds.science_inventory_move,
    pick_sound = item_sounds.science_inventory_pickup,
    drop_sound = item_sounds.science_inventory_move,
    stack_size = 200,
    weight = 1,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount-key",
    factoriopedia_durability_description_key = "description.factoriopedia-science-pack-remaining-amount-key",
    durability_description_value = "description.science-pack-remaining-amount-value",
    random_tint_color = item_tints.bluish_science
  },
  {
    type = "tool",
    name = "tier-two-science-pack",
    localised_description = {"item-description.science-pack"},
    icon = "__frontier-td__/graphics/icons/tier-two-science-pack.png",
    icon_size = 64,
    subgroup = "science-pack",
    color_hint = { text = "T" },
    order = "b[tier-two-science-pack]",
    inventory_move_sound = item_sounds.science_inventory_move,
    pick_sound = item_sounds.science_inventory_pickup,
    drop_sound = item_sounds.science_inventory_move,
    stack_size = 200,
    weight = 1,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount-key",
    factoriopedia_durability_description_key = "description.factoriopedia-science-pack-remaining-amount-key",
    durability_description_value = "description.science-pack-remaining-amount-value",
    random_tint_color = item_tints.bluish_science
  },
  {
    type = "tool",
    name = "tier-three-science-pack",
    localised_description = {"item-description.science-pack"},
    icon = "__frontier-td__/graphics/icons/tier-three-science-pack.png",
    icon_size = 64,
    subgroup = "science-pack",
    color_hint = { text = "T" },
    order = "c[tier-three-science-pack]",
    inventory_move_sound = item_sounds.science_inventory_move,
    pick_sound = item_sounds.science_inventory_pickup,
    drop_sound = item_sounds.science_inventory_move,
    stack_size = 200,
    weight = 1,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount-key",
    factoriopedia_durability_description_key = "description.factoriopedia-science-pack-remaining-amount-key",
    durability_description_value = "description.science-pack-remaining-amount-value",
    random_tint_color = item_tints.bluish_science
  },
  {
    type = "tool",
    name = "tier-four-science-pack",
    localised_description = {"item-description.science-pack"},
    icon = "__frontier-td__/graphics/icons/tier-four-science-pack.png",
    icon_size = 64,
    subgroup = "science-pack",
    color_hint = { text = "O" },
    order = "d[tier-four-science-pack]",
    inventory_move_sound = item_sounds.science_inventory_move,
    pick_sound = item_sounds.science_inventory_pickup,
    drop_sound = item_sounds.science_inventory_move,
    stack_size = 200,
    weight = 1,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount-key",
    factoriopedia_durability_description_key = "description.factoriopedia-science-pack-remaining-amount-key",
    durability_description_value = "description.science-pack-remaining-amount-value",
    random_tint_color = item_tints.bluish_science
  },
  {
    type = "tool",
    name = "tier-five-science-pack",
    localised_description = {"item-description.science-pack"},
    icon = "__frontier-td__/graphics/icons/tier-five-science-pack.png",
    icon_size = 64,
    subgroup = "science-pack",
    color_hint = { text = "O" },
    order = "e[tier-five-science-pack]",
    inventory_move_sound = item_sounds.science_inventory_move,
    pick_sound = item_sounds.science_inventory_pickup,
    drop_sound = item_sounds.science_inventory_move,
    stack_size = 200,
    weight = 1,
    durability = 1,
    durability_description_key = "description.science-pack-remaining-amount-key",
    factoriopedia_durability_description_key = "description.factoriopedia-science-pack-remaining-amount-key",
    durability_description_value = "description.science-pack-remaining-amount-value",
    random_tint_color = item_tints.bluish_science
  },
  {
    type = "item",
    name = "compressed-coal",
    icon = "__frontier-td__/graphics/icons/compressed-coal.png",
    icon_size = 64,
    --dark_background_icon = "__base__/graphics/icons/coal-dark-background.png",
    fuel_category = "chemical",
    fuel_value = "9.2MJ",
    subgroup = "raw-resource",
    order = "c[compressed-coal]",
    inventory_move_sound = item_sounds.resource_inventory_move,
    pick_sound = item_sounds.resource_inventory_pickup,
    drop_sound = item_sounds.resource_inventory_move,
    stack_size = 100,
    weight = 2 * kg,
    random_tint_color = item_tints.yellowing_coal
  },
  {
    type = "item",
    name = "fine-stone",
    icon = "__frontier-td__/graphics/icons/fine-stone.png",
    icon_size = 64,
    subgroup = "raw-resource",
    order = "c[fine-stone]",
    inventory_move_sound = item_sounds.resource_inventory_move,
    pick_sound = item_sounds.resource_inventory_pickup,
    drop_sound = item_sounds.resource_inventory_move,
    stack_size = 100,
    weight = 2 * kg,
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
  tierFiveTeslaTurret,
  tierOneFlamerTurret,
  tierTwoFlamerTurret,
  tierThreeFlamerTurret,
  tierFourFlamerTurret,
  tierFiveFlamerTurret
})


--poison turrets
local utPoisonCannonOne = table.deepcopy(data.raw.item["gun-turret"])
utPoisonCannonOne.name = "ut-poison-cannon-one"
utPoisonCannonOne.place_result = "ut-poison-cannon-one"
utPoisonCannonOne.subgroup = "poison-turrets"
utPoisonCannonOne.order = "a[ut-poison-cannon-one]"
utPoisonCannonOne.stack_size = 10
utPoisonCannonOne.icon = nil
utPoisonCannonOne.icons = {
  {
    icon = "__frontier-td__/graphics/entity/cannon-turret/cannon-turret-icon.png",
    icon_size = 64,
    tint = {0.3, 0.1, 0.7, 1}
  }
}

data:extend({
  utPoisonCannonOne
})

--acid turrets
local utAcidShooter = table.deepcopy(data.raw.item["gun-turret"])
utAcidShooter.name = "ut-acid-shooter"
utAcidShooter.place_result = "ut-acid-shooter"
utAcidShooter.subgroup = "acid-turrets"
utAcidShooter.order = "a[ut-acid-shooter]"
utAcidShooter.stack_size = 10
utAcidShooter.icon = nil
utAcidShooter.icons = {
  {
    icon = "__space-age__/graphics/icons/rocket-turret.png",
    icon_size = 64,
    tint = {0.35, 1, 0.2, 1}
  }
}

data:extend({
  utAcidShooter
})

--portals have no recipe, they come from the map and can be picked up and moved
local function portalItem(name, order)
  return {
    type = "item",
    name = name,
    icon = "__frontier-td__/graphics/icons/" .. name .. ".png",
    icon_size = 64,
    subgroup = "other",
    order = order,
    place_result = name,
    stack_size = 1
  }
end

data:extend({
  portalItem("portal-1", "z[portal-1]"),
  portalItem("portal-2", "z[portal-2]"),
})
