local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

data:extend({
  {
    type = "electric-pole",
    name = "small-electric-pole-iron",
    icon = "__frontier-td__/graphics/icons/small-electric-pole-iron.png",
    quality_indicator_scale = 0.75,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.1, result = "small-electric-pole-iron"},
    max_health = 125,
    corpse = "small-electric-pole-remnants",
    dying_explosion = "small-electric-pole-explosion",
    collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
    selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
    damaged_trigger_effect = hit_effects.entity({{-0.2, -2.2}, {0.2, 0.2}}),
    drawing_box_vertical_extension = 2.2,
    maximum_wire_distance = 7.5,
    supply_area_distance = 2.5,
    impact_category = "metal",
    open_sound = sounds.electric_network_open,
    close_sound = sounds.electric_network_close,
    fast_replaceable_group = "electric-pole",
    pictures =
    {
      layers =
      {
        {
          filename = "__frontier-td__/graphics/entity/small-electric-pole-iron/small-electric-pole-iron.png",
          priority = "extra-high",
          width = 72,
          height = 220,
          direction_count = 4,
          shift = util.by_pixel(1.5, -42.5),
          scale = 0.5
        },
        {
          filename = "__base__/graphics/entity/small-electric-pole/small-electric-pole-shadow.png",
          priority = "extra-high",
          width = 256,
          height = 52,
          direction_count = 4,
          shift = util.by_pixel(51, 3),
          draw_as_shadow = true,
          scale = 0.5
        }
      }
    },
    connection_points =
    {
      {
        shadow =
        {
          copper = util.by_pixel(98.5, 2.5),
          red = util.by_pixel(111.0, 4.5),
          green = util.by_pixel(85.5, 4.0)
        },
        wire =
        {
          copper = util.by_pixel(0.0, -82.5),
          red = util.by_pixel(13.0, -81.0),
          green = util.by_pixel(-12.5, -81.0)
        }
      },
      {
        shadow =
        {
          copper = util.by_pixel(99.5, 4.0),
          red = util.by_pixel(110.0, 9.0),
          green = util.by_pixel(92.5, -4.0)
        },
        wire =
        {
          copper = util.by_pixel(1.5, -81.0),
          red = util.by_pixel(12.0, -76.0),
          green = util.by_pixel(-6.0, -89.5)
        }
      },
      {
        shadow =
        {
          copper = util.by_pixel(100.5, 5.5),
          red = util.by_pixel(102.5, 14.5),
          green = util.by_pixel(103.5, -3.5)
        },
        wire =
        {
          copper = util.by_pixel(2.5, -79.5),
          red = util.by_pixel(4.0, -71.0),
          green = util.by_pixel(5.0, -89.5)
        }
      },
      {
        shadow =
        {
          copper = util.by_pixel(98.5, -1.5),
          red = util.by_pixel(88.0, 3.5),
          green = util.by_pixel(106.0, -9.0)
        },
        wire =
        {
          copper = util.by_pixel(0.5, -86.5),
          red = util.by_pixel(-10.5, -81.5),
          green = util.by_pixel(8.0, -93.5)
        }
      }
    },
    radius_visualisation_picture =
    {
      filename = "__base__/graphics/entity/small-electric-pole/electric-pole-radius-visualization.png",
      width = 12,
      height = 12,
      priority = "extra-high-no-scale"
    },
    water_reflection =
    {
      pictures =
      {
        filename = "__base__/graphics/entity/small-electric-pole/small-electric-pole-reflection.png",
        priority = "extra-high",
        width = 12,
        height = 28,
        shift = util.by_pixel(5, 40),
        variation_count = 4,
        scale = 5
      },
      rotate = false,
      orientation_to_variation = true
    }
  },
  {
    type = "container",
    name = "bigass-steel-chest",
    icon = "__base__/graphics/icons/steel-chest.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.2, result = "steel-chest"},
    max_health = 350,
    corpse = "steel-chest-remnants",
    dying_explosion = "steel-chest-explosion",
    open_sound = sounds.metallic_chest_open,
    close_sound = sounds.metallic_chest_close,
    resistances =
    {
      {
        type = "fire",
        percent = 90
      },
      {
        type = "impact",
        percent = 60
      }
    },
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    damaged_trigger_effect = hit_effects.entity(),
    fast_replaceable_group = "container",
    inventory_size = 1000,
    impact_category = "metal",
    icon_draw_specification = {scale = 0.7},
    picture =
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/steel-chest/steel-chest.png",
          priority = "extra-high",
          width = 64,
          height = 80,
          shift = util.by_pixel(-0.25, -0.5),
          scale = 0.5
        },
        {
          filename = "__base__/graphics/entity/steel-chest/steel-chest-shadow.png",
          priority = "extra-high",
          width = 110,
          height = 46,
          shift = util.by_pixel(12.25, 8),
          draw_as_shadow = true,
          scale = 0.5
        }
      }
    },
    circuit_connector = circuit_connector_definitions["chest"],
    circuit_wire_max_distance = default_circuit_wire_max_distance
  },
  {
    type = "market",
    name = "drug-market",
    icon = "__base__/graphics/icons/market.png",
    flags = {"placeable-neutral", "player-creation"},
    hidden = true,
    allow_access_to_all_forces = true,
    order = "d-a-a",
    subgroup = "other",
    max_health = 150,
    corpse = "big-remnants",
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    picture =
    {
      filename = "__frontier-td__/graphics/entity/drugsmarket.png",
      width = 156,
      height = 127,
      shift = {0.95, 0.2}
    },
    icons = {
    {
        icon = "__base__/graphics/icons/market.png",
        icon_size = 64
    }
  }
  },
  {
    type = "market",
    name = "attack-market",
    icon = "__base__/graphics/icons/market.png",
    flags = {"placeable-neutral", "player-creation"},
    hidden = true,
    allow_access_to_all_forces = true,
    order = "d-a-a",
    subgroup = "other",
    max_health = 150,
    corpse = "big-remnants",
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    picture =
    {
      filename = "__frontier-td__/graphics/entity/attackmarket.png",
      width = 156,
      height = 127,
      shift = {0.95, 0.2}
    }
  },
  {
    type = "market",
    name = "weapons-market",
    icon = "__base__/graphics/icons/market.png",
    flags = {"placeable-neutral", "player-creation"},
    hidden = true,
    allow_access_to_all_forces = true,
    order = "d-a-a",
    subgroup = "other",
    max_health = 150,
    corpse = "big-remnants",
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    picture =
    {
      filename = "__frontier-td__/graphics/entity/weaponsmarket.png",
      width = 156,
      height = 127,
      shift = {0.95, 0.2}
    }
  },
  {
    type = "market",
    name = "land-market",
    icon = "__base__/graphics/icons/market.png",
    flags = {"placeable-neutral", "player-creation"},
    hidden = true,
    allow_access_to_all_forces = true,
    order = "d-a-a",
    subgroup = "other",
    max_health = 150,
    corpse = "big-remnants",
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    damaged_trigger_effect = hit_effects.entity(),
    open_sound = sounds.machine_open,
    close_sound = sounds.machine_close,
    picture =
    {
      filename = "__frontier-td__/graphics/entity/landmarket.png",
      width = 156,
      height = 127,
      shift = {0.95, 0.2}
    }
  },
})
