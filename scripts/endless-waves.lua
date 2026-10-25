-- endless mode waves (the "Endless" checkbox in the difficulty vote). a wave is made when it is first needed,
-- there is no last wave, the round only ends when the silo dies.
-- the rules follow tools/generate-map1-waves.pl (which makes the 300 normal waves): the same enemy families and
-- unlock waves, special waves with one family, flying waves every 20, behemoths ramped in, a boss every 50.
-- instead of fixed counts every wave gets a point budget and spends it on the enemies it is allowed to use.
-- every wave is 60 seconds. wave 1 is always one small biter, wave 2 is 11 small biters on normal
local endless = {}

local WAVE_DURATION = 60

-- enemies cost their max health / 15 points, so a small biter is 1.
-- max health from prototypes/entity/enemies.lua, base-data-updates.lua (flyers) and the base game
local ENEMY_HEALTH = {
  ["small-biter"] = 15, ["medium-biter"] = 50, ["big-biter"] = 375, ["behemoth-biter"] = 3000,
  ["small-spitter"] = 200, ["medium-spitter"] = 400, ["big-spitter"] = 1000, ["behemoth-spitter"] = 5000,
  ["small-physical-biter"] = 60, ["medium-physical-biter"] = 250, ["big-physical-biter"] = 1000, ["behemoth-physical-biter"] = 9000,
  ["small-fire-biter"] = 60, ["medium-fire-biter"] = 300, ["big-fire-biter"] = 1200, ["behemoth-fire-biter"] = 10000,
  ["small-laser-biter"] = 60, ["medium-laser-biter"] = 300, ["big-laser-biter"] = 1200, ["behemoth-laser-biter"] = 10000,
  ["small-explosion-biter"] = 60, ["medium-explosion-biter"] = 300, ["big-explosion-biter"] = 1200, ["behemoth-explosion-biter"] = 10000,
  ["small-flyer"] = 100, ["medium-flyer"] = 350, ["big-flyer"] = 1500, ["behemoth-flyer"] = 6000, ["ultra-flyer"] = 35000,
}
local HEALTH_PER_POINT = 15

-- by mapModule.difficulties id (1 normal, 2 easy, 3 hard, 4 test). the points are the perl script's countFactor
local DIFFICULTY_POINTS = {[1] = 1.3, [2] = 0.8, [3] = 1.75, [4] = 1.3}
local FIRST_MEDIUM_WAVE = {[1] = 6, [2] = 7, [3] = 3, [4] = 6}

-- budget = (BUDGET_BASE + (wave - 2)^2) * difficulty points / (1 + BUDGET_HEALTH_GROWTH * wave).
-- control.lua makes every enemy tankier each wave (ENEMY_HEALTH_GROWTH_PER_WAVE), the division takes the normal
-- growth back out so the enemy count does not grow on top of it at full speed (the perl script does the same).
-- it is the normal growth on every difficulty, so hard always gets more points than normal, and its enemies are
-- also tankier. on normal this follows the strength of the 300 scripted waves and keeps growing after them
local BUDGET_BASE = 9.1
local BUDGET_POWER = 2
local BUDGET_HEALTH_GROWTH = 0.04

-- every 50 waves, one after the other. after boss-biter-6 they start over with one more boss each time
local BOSSES = {"boss-biter-1", "ultra-flyer", "boss-biter-3", "boss-biter-4", "boss-biter-5", "boss-biter-6"}

local SIZES = {"small", "medium", "big", "behemoth"}
local FAMILIES = {
  spitter = {small = "small-spitter", medium = "medium-spitter", big = "big-spitter", behemoth = "behemoth-spitter"},
}
for _, family in ipairs({"physical", "fire", "laser", "explosion"}) do
  FAMILIES[family] = {}
  for _, size in ipairs(SIZES) do
    FAMILIES[family][size] = size .. "-" .. family .. "-biter"
  end
end

-- from this wave on the family is in the mixed waves
local FAMILY_UNLOCKS = {
  {wave = 30, family = "spitter"},
  {wave = 51, family = "physical"},
  {wave = 80, family = "fire"},
  {wave = 130, family = "laser"},
  {wave = 180, family = "explosion"},
}
-- the waves before these bosses only use one family (flying waves still come first every 20 waves).
-- after 200 the 20 waves before every boss are special, the family goes round SPECIAL_FAMILY_CYCLE
local SPECIAL_WAVES = {
  {first = 30, last = 49, family = "spitter"},
  {first = 80, last = 99, family = "fire"},
  {first = 130, last = 149, family = "laser"},
  {first = 180, last = 199, family = "explosion"},
}
local SPECIAL_FAMILY_CYCLE = {"spitter", "physical", "fire", "laser", "explosion"}

-- how the budget is split between the sizes of a family
local SIZE_WEIGHTS = {small = 3, medium = 3, big = 2, behemoth = 2}
-- behemoths not before wave 56 and not in a family's first 12 waves, then their share ramps up over 20 waves
local BEHEMOTH_WAVE = 56
local BEHEMOTH_FAMILY_DELAY = 12
local BEHEMOTH_RAMP_WAVES = 20

local function points(name)
  return math.max(1, math.floor((ENEMY_HEALTH[name] or HEALTH_PER_POINT) / HEALTH_PER_POINT + 0.5))
end

function endless.getBudget(wave, difficulty)
  local difficultyPoints = DIFFICULTY_POINTS[tonumber(difficulty)] or DIFFICULTY_POINTS[1]
  local base = BUDGET_BASE + math.max(0, wave - 2) ^ BUDGET_POWER
  return math.max(1, math.floor(base * difficultyPoints / (1 + BUDGET_HEALTH_GROWTH * wave) + 0.5))
end

local function familyUnlockWave(family)
  for _, unlock in ipairs(FAMILY_UNLOCKS) do
    if unlock.family == family then
      return unlock.wave
    end
  end
  return 0
end

local function behemothWave(family)
  return math.max(BEHEMOTH_WAVE, familyUnlockWave(family) + BEHEMOTH_FAMILY_DELAY)
end

local function specialFamily(wave)
  for _, special in ipairs(SPECIAL_WAVES) do
    if wave >= special.first and wave <= special.last then
      return special.family
    end
  end
  if wave >= 200 and wave % 50 >= 30 then
    return SPECIAL_FAMILY_CYCLE[math.floor(wave / 50) % #SPECIAL_FAMILY_CYCLE + 1]
  end
  return nil
end

-- {name, weight} of every size the family can use this wave:
-- no small after 50, no medium after 100 (medium spitters stay), behemoths ramped in
local function familyPool(family, wave)
  local pool = {}
  for _, size in ipairs(SIZES) do
    local allowed = true
    local weight = SIZE_WEIGHTS[size]
    if size == "small" then
      allowed = wave < 50
    elseif size == "medium" then
      allowed = wave <= 100 or family == "spitter"
    elseif size == "behemoth" then
      local firstWave = behemothWave(family)
      allowed = wave >= firstWave
      weight = weight * math.min(1, (wave - firstWave + 1) / BEHEMOTH_RAMP_WAVES)
    end
    if allowed then
      pool[#pool + 1] = {name = FAMILIES[family][size], weight = weight}
    end
  end
  return pool
end

-- what a normal wave can spend its budget on: a note for /wave and one or more pools. the budget is split evenly
-- between the pools (one per family in a mixed wave), then between a pool's enemies by weight
local function wavePools(wave, difficulty)
  if wave % 20 == 0 then
    local pool = {}
    if wave < 50 then pool[#pool + 1] = {name = "small-flyer", weight = 3} end
    if wave >= 40 and wave <= 100 then pool[#pool + 1] = {name = "medium-flyer", weight = 3} end
    if wave >= 60 then
      pool[#pool + 1] = {name = "big-flyer", weight = 2}
      pool[#pool + 1] = {name = "behemoth-flyer", weight = 2 * math.min(1, (wave - 59) / BEHEMOTH_RAMP_WAVES)}
    end
    if wave >= 220 then pool[#pool + 1] = {name = "ultra-flyer", weight = 1} end
    return "flying wave", {pool}
  end

  -- 2-15: small biters, mediums from the difficulty's first medium wave, 15 is big biters only
  if wave <= 15 then
    if wave == 15 then
      return "big biters", {{{name = "big-biter", weight = 1}}}
    end
    local pool = {{name = "small-biter", weight = 3}}
    if wave >= (FIRST_MEDIUM_WAVE[tonumber(difficulty)] or FIRST_MEDIUM_WAVE[1]) then
      pool[#pool + 1] = {name = "medium-biter", weight = 2}
    end
    return "", {pool}
  end

  -- 16-29: medium biters, big biters from 22 with a growing share
  if wave < 30 then
    local pool = {{name = "medium-biter", weight = 3}}
    if wave >= 22 then
      pool[#pool + 1] = {name = "big-biter", weight = 1 + (wave - 22) / 8}
    end
    return "", {pool}
  end

  local special = specialFamily(wave)
  if special then
    return "special: " .. special .. " only", {familyPool(special, wave)}
  end

  local pools = {}
  local familyNames = {}
  for _, unlock in ipairs(FAMILY_UNLOCKS) do
    if unlock.wave <= wave then
      pools[#pools + 1] = familyPool(unlock.family, wave)
      familyNames[#familyNames + 1] = unlock.family
    end
  end
  return "mix: " .. table.concat(familyNames, ", "), pools
end

-- spawn groups for count enemies over the wave (see processWave in control.lua): whole enemies per second go in a
-- stream (interval 1, count = per second * duration), the rest come in bursts spread through the wave.
-- the tougher the enemy, the fewer bursts, so big ones come in small packs instead of one at a time
local function addGroups(groups, name, count)
  local perSecond = math.floor(count / WAVE_DURATION)
  if perSecond >= 1 then
    groups[#groups + 1] = {name = name, count = perSecond * WAVE_DURATION, interval = 1, startDelay = 0}
    count = count - perSecond * WAVE_DURATION
  end
  if count <= 0 then
    return
  end

  local cost = points(name)
  local maxBursts = (cost <= 5 and 10) or (cost <= 30 and 8) or (cost <= 150 and 6) or 4
  local bursts = math.min(count, maxBursts)
  for i = 1, bursts do
    local size = math.floor(count / bursts) + ((i <= count % bursts) and 1 or 0)
    groups[#groups + 1] = {
      name = name,
      count = size,
      interval = 0,
      -- spread over the first 55 seconds so everything is out before the next wave
      startDelay = math.floor((WAVE_DURATION - 5) * (i - 0.5) / bursts)
    }
  end
end

-- one wave in the same format as the map wave tables: {waveDuration, groups, note}
function endless.buildWave(wave, difficulty)
  if wave <= 1 then
    return {
      waveDuration = WAVE_DURATION,
      note = "first wave: one small biter",
      groups = {{name = "small-biter", count = 1, interval = 0, startDelay = 10}},
    }
  end

  if wave % 50 == 0 then
    local bossNumber = wave / 50 - 1
    local boss = BOSSES[bossNumber % #BOSSES + 1]
    local count = 1 + math.floor(bossNumber / #BOSSES)
    return {
      waveDuration = WAVE_DURATION,
      note = "boss wave",
      groups = {{name = boss, count = count, interval = 0, startDelay = 5}},
    }
  end

  local note, pools = wavePools(wave, difficulty)
  local budget = endless.getBudget(wave, difficulty)
  local share = budget / #pools
  local counts = {}
  local order = {}

  local function add(name, count)
    if count <= 0 then
      return
    end
    if not counts[name] then
      counts[name] = 0
      order[#order + 1] = name
    end
    counts[name] = counts[name] + count
  end

  for _, pool in ipairs(pools) do
    local totalWeight = 0
    local cheapest = nil
    for _, enemy in ipairs(pool) do
      totalWeight = totalWeight + enemy.weight
      if not cheapest or points(enemy.name) < points(cheapest) then
        cheapest = enemy.name
      end
    end

    local leftover = share
    for _, enemy in ipairs(pool) do
      local count = math.floor(share * enemy.weight / totalWeight / points(enemy.name))
      add(enemy.name, count)
      leftover = leftover - count * points(enemy.name)
    end
    -- what could not buy a whole enemy of its size goes to the cheapest one of the pool
    add(cheapest, math.floor(leftover / points(cheapest)))
  end

  -- never an empty wave, even when the budget is less than the cheapest enemy
  if #order == 0 then
    add(pools[1][1].name, 1)
  end

  local groups = {}
  for _, name in ipairs(order) do
    addGroups(groups, name, counts[name])
  end

  return {
    waveDuration = WAVE_DURATION,
    note = (note ~= "" and note or nil),
    groups = groups,
  }
end

return endless
