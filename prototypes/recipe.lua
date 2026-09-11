local infiniteGunTurretRecipe = table.deepcopy(data.raw.recipe["gun-turret"])

infiniteGunTurretRecipe.name = "infinite-gun-turret"
infiniteGunTurretRecipe.results = {
  {
      type = "item",
      name = "infinite-gun-turret",
      amount = 1
  }
}

data:extend({
  {
    type = "recipe",
    name = "small-electric-pole-iron",
    enabled = false,
    category = "electronics",
    ingredients =
    {
      {type = "item", name = "iron-plate", amount = 1},
      {type = "item", name = "copper-cable", amount = 1}
    },
    results = {{type="item", name="small-electric-pole-iron", amount=1}}
  },
  infiniteGunTurretRecipe
})
