-- highest wave every player has reached, kept by player NAME (not player_index) so the records can be carried to
-- another save. one record per map, difficulty and mode (endless or the 300 waves).
--  * in the save: storage.waveRecords (survives saving and loading)
--  * export: rewritten whenever a record goes up, script-output/frontier-td/highest-waves.json (only on the server
--    in multiplayer). a mod can write files but never read them, so to carry the records to a new save an admin
--    pastes that file into /importwaverecords, which keeps the higher wave of every record
--  * /highscores shows them in game
local mapModule = require('scripts.map')

local waveRecords = {}

local EXPORT_FILE = "frontier-td/highest-waves.json"
local FORMAT_VERSION = 1

local function getRecords()
  storage.waveRecords = storage.waveRecords or {}
  return storage.waveRecords
end

local function difficultyLabel(difficulty)
  local data = mapModule.difficulties[tonumber(difficulty)]
  return data and data.label or tostring(difficulty)
end

local function mapLabel(mapName)
  local mapData = mapModule.getMapByName(mapName)
  return mapData and mapData.mapLabel or tostring(mapName)
end

-- one record per map, difficulty and mode, for example "map-3-volcano|Hard|endless"
local function recordKey(mapName, difficulty, isEndless)
  return tostring(mapName) .. "|" .. difficulty .. "|" .. (isEndless and "endless" or "waves")
end

-- the json file. in multiplayer only the server writes it, singleplayer writes it locally
function waveRecords.export()
  local data = {
    version = FORMAT_VERSION,
    players = getRecords(),
  }
  local json = helpers.table_to_json(data)
  if game.is_multiplayer() then
    helpers.write_file(EXPORT_FILE, json, false, 0)
  else
    helpers.write_file(EXPORT_FILE, json, false)
  end
end

-- the slot's connected players reached waveNumber, keeps it for everyone it is a new best for.
-- returns true if any record went up
local function updateRecords(players, waveNumber, mapName, difficulty, isEndless)
  local records = getRecords()
  local label = difficultyLabel(difficulty)
  local key = recordKey(mapName, label, isEndless)
  local improved = false

  for _, player in pairs(players) do
    if player.valid then
      records[player.name] = records[player.name] or {}
      local record = records[player.name][key]
      if not record or waveNumber > (record.wave or 0) then
        records[player.name][key] = {
          wave = waveNumber,
          map = mapName,
          difficulty = label,
          endless = isEndless == true,
        }
        improved = true
      end
    end
  end

  return improved
end

-- called when a wave starts. rounds where an admin jumped waves with /setwave do not count (slot.waveRecordsOff)
function waveRecords.onWaveStarted(slot)
  if not slot or slot.waveRecordsOff or not slot.mapName or (slot.currentWave or 0) < 1 then
    return
  end
  local force = game.forces[tostring(slot.forceName)]
  if not force then
    return
  end
  if updateRecords(force.connected_players, slot.currentWave, slot.mapName, slot.difficulty, slot.isEndless) then
    waveRecords.export()
  end
end

-- merges an exported json file into this save: every record keeps the higher wave.
-- returns the number of records that were added or went up, or nil and an error message
function waveRecords.import(jsonText)
  if not jsonText or jsonText == "" then
    return nil, "Paste the contents of " .. EXPORT_FILE .. " after the command."
  end
  local ok, data = pcall(helpers.json_to_table, jsonText)
  if not ok or type(data) ~= "table" or type(data.players) ~= "table" then
    return nil, "That is not a highest-waves.json file."
  end

  local records = getRecords()
  local changed = 0
  for playerName, playerRecords in pairs(data.players) do
    if type(playerName) == "string" and type(playerRecords) == "table" then
      for key, record in pairs(playerRecords) do
        local wave = type(record) == "table" and tonumber(record.wave)
        if type(key) == "string" and wave and wave >= 1 then
          records[playerName] = records[playerName] or {}
          local current = records[playerName][key]
          if not current or wave > (current.wave or 0) then
            records[playerName][key] = {
              wave = math.floor(wave),
              map = tostring(record.map),
              difficulty = tostring(record.difficulty),
              endless = record.endless == true,
            }
            changed = changed + 1
          end
        end
      end
    end
  end

  waveRecords.export()
  return changed
end

-- the best records, highest wave first: every player's record for each map/difficulty/mode.
-- filter (optional) only keeps records whose map name, map label, difficulty or player name contains it
function waveRecords.getTop(count, filter)
  local list = {}
  filter = filter and filter:lower() or nil
  for playerName, playerRecords in pairs(getRecords()) do
    for _, record in pairs(playerRecords) do
      local text = (playerName .. " " .. tostring(record.map) .. " " .. mapLabel(record.map) .. " " .. tostring(record.difficulty)):lower()
      if not filter or text:find(filter, 1, true) then
        list[#list + 1] = {player = playerName, wave = record.wave, map = record.map, difficulty = record.difficulty, endless = record.endless}
      end
    end
  end
  table.sort(list, function(a, b)
    if a.wave ~= b.wave then
      return a.wave > b.wave
    end
    return a.player < b.player
  end)
  local top = {}
  for i = 1, math.min(count, #list) do
    top[i] = list[i]
  end
  return top, #list
end

function waveRecords.describe(record)
  return mapLabel(record.map) .. ", " .. tostring(record.difficulty) .. ", " .. (record.endless and "endless" or "300 waves")
end

-- the top 10 in chat, for /highscores and the Highscores button. filter (optional) only shows records whose
-- player, map or difficulty contains it. player nil (server console) prints to everyone
function waveRecords.printHighscores(player, filter)
  local print = function(message)
    if player and player.valid then
      player.print(message)
    else
      game.print(message)
    end
  end

  local top, total = waveRecords.getTop(10, filter)
  if total == 0 then
    print(filter and ("No wave records for \"" .. filter .. "\".") or "No wave records yet.")
    return
  end

  print("Highest waves" .. (filter and (" (" .. filter .. ")") or "") .. ":")
  for i, record in ipairs(top) do
    print("  " .. i .. ". " .. record.player .. " - wave " .. record.wave .. " (" .. waveRecords.describe(record) .. ")")
  end
  if total > #top then
    print("  ... " .. (total - #top) .. " more, the full list is in script-output/" .. EXPORT_FILE)
  end
end

-- Highscores button on the top menu bar, right of the Frontier button
local HIGHSCORES_BUTTON = "highscores_button"

-- adds the button if the player's menu bar does not have it yet (new menu bars, and existing saves without
-- rebuilding the bar, which would remove the wave buttons of a running round)
function waveRecords.ensureHighscoresButton(player)
  local menuBar = player and player.valid and player.gui.top.menu_bar
  if not menuBar or menuBar[HIGHSCORES_BUTTON] then
    return
  end

  local index = nil
  if menuBar.open_mainMenu_button then
    index = menuBar.open_mainMenu_button.get_index_in_parent() + 1
  end
  local button = menuBar.add({
    type = "sprite-button",
    name = HIGHSCORES_BUTTON,
    sprite = "virtual-signal/signal-star",
    caption = "Highscores",
    tooltip = "Highest waves reached (/highscores)",
    index = index
  })
  button.style.width = 60
  button.style.height = 60
  button.style.padding = 5
  button.style.font = "default-bold"
  button.style.font_color = {r = 1, g = 1, b = 1}
end

-- import window: a big text box to paste the whole highest-waves.json into. used instead of the chat line,
-- which is too short for a big file (text boxes like this one also take huge blueprint strings)
local IMPORT_GUI = "wave_records_import_gui"
local IMPORT_TEXT = "wave_records_import_text"
local IMPORT_BUTTON = "wave_records_import_button"
local IMPORT_CLOSE = "wave_records_import_close"

function waveRecords.openImportGui(player)
  if player.gui.screen[IMPORT_GUI] then
    player.gui.screen[IMPORT_GUI].destroy()
  end

  local frame = player.gui.screen.add({type = "frame", name = IMPORT_GUI, direction = "vertical"})
  local titlebar = frame.add({type = "flow", direction = "horizontal"})
  titlebar.add({type = "label", caption = "Import wave records", style = "frame_title"})
  local dragger = titlebar.add({type = "empty-widget", style = "draggable_space_header"})
  dragger.style.horizontally_stretchable = true
  dragger.style.height = 24
  dragger.style.right_margin = 4
  dragger.drag_target = frame
  titlebar.add({type = "sprite-button", name = IMPORT_CLOSE, sprite = "utility/close", style = "frame_action_button"})

  frame.add({
    type = "label",
    caption = "Paste the whole " .. EXPORT_FILE .. " from the other game (script-output folder). Every record keeps the higher wave."
  })
  local text = frame.add({type = "text-box", name = IMPORT_TEXT})
  text.style.width = 600
  text.style.height = 300
  text.word_wrap = true

  frame.add({type = "button", name = IMPORT_BUTTON, caption = "Import"})
  frame.force_auto_center()
  text.focus()
end

-- returns true if the click was on the Highscores button or the import window
function waveRecords.onGuiClick(element, player)
  if element.name == HIGHSCORES_BUTTON then
    waveRecords.printHighscores(player)
    return true
  end

  if element.name == IMPORT_CLOSE then
    if player.gui.screen[IMPORT_GUI] then
      player.gui.screen[IMPORT_GUI].destroy()
    end
    return true
  end

  if element.name == IMPORT_BUTTON then
    local frame = player.gui.screen[IMPORT_GUI]
    if not frame then
      return true
    end
    if not player.admin then
      player.print("Only admins can import wave records.")
      frame.destroy()
      return true
    end
    local changed, errorMessage = waveRecords.import(frame[IMPORT_TEXT].text)
    if changed then
      player.print("Imported wave records: " .. changed .. " added or improved.")
      frame.destroy()
    else
      -- keep the window open so the text can be fixed
      player.print(errorMessage)
    end
    return true
  end

  return false
end

waveRecords.EXPORT_FILE = EXPORT_FILE

return waveRecords
