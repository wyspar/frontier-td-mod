local projectile = {
  type = "projectile",
  name = "bullet-projectile-tier-two",

  flags = {"not-on-map"},
  hidden = true,
  acceleration = 0,

  animation = {
    filename = "__base__/graphics/entity/bullet/bullet.png",
    draw_as_glow = true,
    width = 3,
    height = 50,
    priority = "high",
    scale = 0.5
  },

  action = {
    type = "direct",
    action_delivery = {
      type = "instant",
      target_effects = {
        {
          type = "damage",
          damage = {
            amount = 5,
            type = "physical"
          },
          force = "enemy"
        }
      }
    }
  }
}

data:extend({projectile})