data:extend({
  --tier one science shit
  {
    type = "technology",
    name = "biter-progress-tier-one-science",
    icon = "__frontier-td__/graphics/technology/tier-one-science-pack.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-one-science-pack"
      }
    },
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-one-science"}
    }
  },
  {
    type = "technology",
    name = "laser-turrets",
    icon = "__frontier-td__/graphics/technology/tier-one-laser-turret.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-one-laser-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-two-laser-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-three-laser-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-four-laser-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-five-laser-turret"
      }
    },
    prerequisites = {"biter-progress-tier-one-science"},
    unit =
    {
      count = 200,
      ingredients =
      {
        {"tier-one-science-pack", 1},
      },
      time = 20
    }
  },

  --tier two science shit
  {
    type = "technology",
    name = "biter-progress-tier-two-science",
    icon = "__frontier-td__/graphics/technology/tier-two-science-pack.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-two-science-pack"
      }
    },
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-two-science"}
    }
  },
  {
    type = "technology",
    name = "flamer-turrets",
    icon = "__frontier-td__/graphics/technology/tier-two-flamer-turret.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-one-flamer-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-two-flamer-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-three-flamer-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-four-flamer-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-five-flamer-turret"
      }
    },
    prerequisites = {"biter-progress-tier-one-science","biter-progress-tier-two-science"},
    unit =
    {
      count = 300,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
      },
      time = 20
    }
  },

  --tier three science shit
  {
    type = "technology",
    name = "biter-progress-tier-three-science",
    icon = "__frontier-td__/graphics/technology/tier-three-science-pack.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-three-science-pack"
      }
    },
    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-tier-three-science"}
    }
  },
  {
    type = "technology",
    name = "tesla-turrets",
    icon = "__frontier-td__/graphics/technology/tier-three-tesla-turret.png",
    icon_size = 256,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "tier-one-tesla-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-two-tesla-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-three-tesla-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-four-tesla-turret"
      },
      {
        type = "unlock-recipe",
        recipe = "tier-five-tesla-turret"
      }
    },
    prerequisites = {"biter-progress-tier-one-science","biter-progress-tier-two-science","biter-progress-tier-three-science"},
    unit =
    {
      count = 500,
      ingredients =
      {
        {"tier-one-science-pack", 1},
        {"tier-two-science-pack", 1},
        {"tier-three-science-pack", 1},
      },
      time = 20
    }
  },
})
