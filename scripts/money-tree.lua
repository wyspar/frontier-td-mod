-- Money Tree (prototypes/money-tree.lua): only a fully grown coin-tree gives its coins.
-- mining one that is still growing gives the seeds back instead, so planting and
-- instantly mining it again can't turn 5 coins into 25
local moneyTree = {}

-- from on_player_mined_entity and on_robot_mined_entity
function moneyTree.onMined(event)
  local entity = event.entity
  if not entity or not entity.valid or entity.name ~= "coin-tree" or not event.buffer then
    return
  end
  if entity.tick_grown and entity.tick_grown > game.tick then
    event.buffer.clear()
    event.buffer.insert({name = "money-tree-seeds", count = 1})
  end
end

return moneyTree
