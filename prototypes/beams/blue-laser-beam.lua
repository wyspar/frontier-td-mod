local blueBeam = table.deepcopy(data.raw["beam"]["laser-beam"])

blueBeam.name = "blue-laser-beam"
blueBeam.action.action_delivery.target_effects[1].damage.amount = 5
local beam = blueBeam.graphics_set.beam

local blueTint = {0.0, 0.2, 1.0}
local blueLightTint =  {0.6, 0.8, 1.0}

-- beam.head.layers[1].tint = blueTint
-- beam.head.layers[2].tint = blueTint

-- beam.tail.layers[1].tint = blueTint
-- beam.tail.layers[2].tint = blueTint

-- beam.body[1].layers[1].tint = blueTint
-- beam.body[1].layers[2].tint = blueTint

for _, layer in ipairs(beam.head.layers) do
    layer.tint = layer.draw_as_light and blueLightTint or blueTint
end

for _, layer in ipairs(beam.tail.layers) do
    layer.tint = layer.draw_as_light and blueLightTint or blueTint
end

for _, body in ipairs(beam.body) do
    for _, layer in ipairs(body.layers) do
        layer.tint = layer.draw_as_light and blueLightTint or blueTint
    end
end

local ground = blueBeam.graphics_set.ground

ground.head.tint = {0.1, 0.3, 1.0}
ground.tail.tint = {0.1, 0.3, 1.0}
ground.body.tint = {0.1, 0.3, 1.0}

data:extend({
    blueBeam
})