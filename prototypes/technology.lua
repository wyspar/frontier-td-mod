data:extend({
  {
    type = "technology",
    name = "biter-progress-automation-science",
    icon = "__base__/graphics/technology/automation-science-pack.png",
    icon_size = 256,

    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "automation-science-pack"
      }
    },

    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-automation-science"}
    }
  },
  {
    type = "technology",
    name = "biter-progress-logistic-science",
    icon = "__base__/graphics/technology/logistic-science-pack.png",
    icon_size = 256,

    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "logistic-science-pack"
      }
    },

    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-logistic-science"}
    }
  },
  {
    type = "technology",
    name = "biter-progress-military-science",
    icon = "__base__/graphics/technology/military-science-pack.png",
    icon_size = 256,

    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "military-science-pack"
      }
    },

    research_trigger =
    {
      type = "scripted",
      trigger_description = {"technology-description.biter-progress-military-science"}
    }
  }
})
