-- player classes: every player in a running round picks one class in a window that only goes away once they chose.
-- the class is kept per round in slot.playerClasses[player_index] (cleared when a round starts and when the slot
-- resets), so leaving and joining back during the round keeps it. classes cannot be changed once chosen.
--  * Speed Demon: faster crafting and running, a free vehicle machine gun when chosen
--  * Adventure Capitalist: interest on the coins in their inventory every wave
--  * Turret Broker: part of the coins back when they craft or upgrade a turret
local mapModule = require('scripts.map')

local playerClasses = {}

local CLASS_GUI = "player_class_gui"
local CHOOSE_BUTTON_PREFIX = "player_class_choose_"

-- every character runs this much faster than vanilla (control.lua sets it on join and respawn)
local BASE_RUNNING_SPEED_MODIFIER = 1

local SPEED_DEMON_CRAFTING_BONUS = 1 -- +100%, crafts twice as fast
local SPEED_DEMON_RUNNING_BONUS = 1 -- +100% on top of the base modifier
-- most coins the Adventure Capitalist gets per wave and the Turret Broker gets per craft or upgrade
local CLASS_MAX_COINS = 200
-- interest per wave on the coins in the main inventory, rounded down, at most CLASS_MAX_COINS per wave
local INTEREST_PERCENT = 5
-- percent of the coins spent on crafting or upgrading a turret that come back, at most CLASS_MAX_COINS each time
local BROKER_REFUND_PERCENT = 20

playerClasses.CLASSES = {
  {
    id = "speed-demon",
    label = "Speed Demon",
    description = "2x crafting speed, +100% movement speed, and a free Vehicle Machine Gun."
  },
  {
    id = "adventure-capitalist",
    label = "Adventure Capitalist",
    description = "Earn " .. INTEREST_PERCENT .. "% interest on your coins every wave (at most " .. CLASS_MAX_COINS .. " coins per wave)."
  },
  {
    id = "turret-broker",
    label = "Turret Broker",
    description = "Get " .. BROKER_REFUND_PERCENT .. "% of the coins back whenever you craft or upgrade a turret (at most " .. CLASS_MAX_COINS .. " coins each time)."
  },
}

local function getClassData(classId)
  for _, class in ipairs(playerClasses.CLASSES) do
    if class.id == classId then
      return class
    end
  end
  return nil
end

local function getRoundSlot(player)
  local slot = mapModule.getSlotByForceName(player.force.name)
  if slot and slot.isGameStarted and not slot.isDead then
    return slot
  end
  return nil
end

-- the class of the player in their slot's running round, or nil
function playerClasses.getClass(player)
  local slot = player and player.valid and getRoundSlot(player)
  return slot and slot.playerClasses and slot.playerClasses[player.index] or nil
end

local function destroyGui(player)
  if player.gui.screen[CLASS_GUI] then
    player.gui.screen[CLASS_GUI].destroy()
  end
end

-- no close button and never player.opened, so escape does not close it either
local function openGui(player)
  if player.gui.screen[CLASS_GUI] then
    return
  end

  local frame = player.gui.screen.add({type = "frame", name = CLASS_GUI, caption = "Choose your class", direction = "vertical"})
  local warning = frame.add({type = "label", caption = "Classes cannot be changed once chosen."})
  warning.style.font = "default-bold"
  warning.style.font_color = {r = 1, g = 0.6, b = 0.2}
  warning.style.bottom_margin = 8

  for _, class in ipairs(playerClasses.CLASSES) do
    local row = frame.add({type = "flow", direction = "horizontal"})
    row.style.vertical_align = "center"
    row.style.bottom_margin = 4
    local button = row.add({type = "button", name = CHOOSE_BUTTON_PREFIX .. class.id, caption = class.label})
    button.style.width = 200
    local description = row.add({type = "label", caption = class.description})
    description.style.single_line = false
    description.style.maximal_width = 350
  end

  frame.force_auto_center()
end

-- the perks for the player's current class (or none), and the class window if they still have to choose.
-- call it whenever the player's character, force or round changes
function playerClasses.refresh(player)
  if not player or not player.valid then
    return
  end

  local slot = getRoundSlot(player)
  local classId = slot and slot.playerClasses and slot.playerClasses[player.index] or nil

  if player.character then
    local isSpeedDemon = classId == "speed-demon"
    player.character_running_speed_modifier = BASE_RUNNING_SPEED_MODIFIER + (isSpeedDemon and SPEED_DEMON_RUNNING_BONUS or 0)
    player.character_crafting_speed_modifier = isSpeedDemon and SPEED_DEMON_CRAFTING_BONUS or 0
  end

  if slot and not classId and player.connected then
    openGui(player)
  else
    destroyGui(player)
  end
end

function playerClasses.refreshForce(force)
  for _, player in pairs(force.players) do
    playerClasses.refresh(player)
  end
end

local function choose(player, classId)
  local slot = getRoundSlot(player)
  local class = getClassData(classId)
  if not slot or not class then
    destroyGui(player)
    return
  end

  slot.playerClasses = slot.playerClasses or {}
  if slot.playerClasses[player.index] then
    -- already chose, classes cannot be changed
    playerClasses.refresh(player)
    return
  end

  slot.playerClasses[player.index] = classId
  playerClasses.refresh(player)

  if classId == "speed-demon" then
    local inserted = player.insert({name = "vehicle-machine-gun", count = 1})
    if inserted == 0 then
      player.surface.spill_item_stack({position = player.position, stack = {name = "vehicle-machine-gun", count = 1}})
    end
  end

  player.force.print(player.name .. " is a " .. class.label .. ".")
end

-- returns true if the click was on the class window
function playerClasses.onGuiClick(element, player)
  local classId = element.name:match("^" .. CHOOSE_BUTTON_PREFIX .. "(.+)$")
  if not classId then
    return false
  end
  choose(player, classId)
  return true
end

-- a wave started: Adventure Capitalists on the slot get their interest, each one is told their own amount
function playerClasses.onWaveStarted(slot)
  if not slot.playerClasses or (slot.currentWave or 0) < 2 then
    return
  end
  local force = game.forces[tostring(slot.forceName)]
  if not force then
    return
  end

  for _, player in pairs(force.connected_players) do
    local inventory = player.get_main_inventory()
    if inventory and slot.playerClasses[player.index] == "adventure-capitalist" then
      local coins = inventory.get_item_count("coin")
      local interest = math.min(CLASS_MAX_COINS,math.floor(coins * INTEREST_PERCENT / 100))
      if interest > 0 then
        local inserted = player.insert({name = "coin", count = interest})
        if inserted > 0 then
          player.print("Interest: +" .. inserted .. " coins (" .. INTEREST_PERCENT .. "% of your " .. coins .. " coins).")
        end
      end
    end
  end
end

-- a Turret Broker spent spentCoins on turrets: part of it back, shown as flying text at position (only they see it)
function playerClasses.onTurretCoinsSpent(player, spentCoins, position)
  if playerClasses.getClass(player) ~= "turret-broker" then
    return
  end
  local refund = math.min(CLASS_MAX_COINS, math.floor(spentCoins * BROKER_REFUND_PERCENT / 100))
  if refund <= 0 then
    return
  end
  local inserted = player.insert({name = "coin", count = refund})
  if inserted > 0 then
    player.create_local_flying_text({
      text = "+" .. inserted .. " coins (Turret Broker)",
      position = position,
      color = {r = 1, g = 0.85, b = 0.2}
    })
  end
end

-- a handcrafted turret: the coins of its recipe count as spent
function playerClasses.onPlayerCraftedItem(event, towerCoinCosts)
  local player = game.get_player(event.player_index)
  local stack = event.item_stack
  if not player or not player.valid or not stack or not stack.valid_for_read or not towerCoinCosts[stack.name] then
    return
  end

  local coins = 0
  for _, ingredient in pairs(event.recipe.ingredients) do
    if ingredient.name == "coin" then
      coins = coins + ingredient.amount
    end
  end
  playerClasses.onTurretCoinsSpent(player, coins, player.position)
end

return playerClasses
