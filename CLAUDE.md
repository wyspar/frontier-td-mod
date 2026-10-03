# CLAUDE.md

This file guides Claude Code when working in this repository.

## What this is

**Frontier Tower Defense** (`frontier-td`) is a Factorio 2.0 mod (Lua) that holds the content and the scenario logic for a multiplayer tower-defense game. Players join map "slots" on a shared `frontier` surface, vote on a map and a difficulty, and defend a rocket silo from scripted biter waves. They earn coins from kills and spend them on tiered turrets.

- Dependencies (`info.json`): `base`, `space-age`, `fdsl` (recipe/tech helper library, used as `require("__fdsl__.lib.recipe")` / `.technology`), `aai-loaders`.
- There is no build step, test suite or linter. You test by launching Factorio with the mod enabled. The repo lives directly in `%APPDATA%/Factorio/mods/frontier-td_1.0.0`, so the game loads it as-is. Any Lua error shows up in game or in `factorio-current.log`.
- Asset paths use `__frontier-td__/graphics/...`.
- `todo-and-ideas.txt` is the author's running design notes and TODO list. Read it for intent and known issues.

## Factorio load stages

Code runs in two separate stages, and they cannot share state:

1. **Data stage**: `settings.lua` (all commented out), `data.lua`, then `data-final-fixes.lua`. These define prototypes.
2. **Control stage**: `control.lua` and its `require`s in `scripts/` and `models/`. This is the runtime game logic. Persistent state must live in `storage` (Factorio 2.0's replacement for `global`).

`models/tower-coin-costs.lua` is plain data, and **both stages use it**: `prototypes/recipe.lua` and `data.lua` (data stage), and `control.lua` (runtime).

## Data stage layout

`data.lua` controls the load order:
- `prototypes/entity/` covers `entities.lua` (markets, poles, etc.), `explosions.lua`, `remnants.lua` and `enemies.lua` (boss biter and the `*-physical-biter` units).
- `prototypes/item-groups.lua`, `item.lua`, `recipe.lua` and `categories/recipe-category.lua`.
- `prototypes/projectiles/`: one bullet projectile per gun-turret tier.
- `prototypes/beams/`: laser and tesla beams in one colour per tier.
- `prototypes/entity/myTurrets/{physical,laser,electric,fire}/`: the turrets, one **near-identical copy-pasted file per tier**. The files mostly differ in tint, cooldown, range and damage. When you change a turret family, change all five tier files consistently.
- `base-data-updates.lua`: tweaks to vanilla and Space Age prototypes (uses `fdsl` helpers, adds surface conditions, buffs/nerfs).
- Then `data.lua` **disables every vanilla technology** except a small whitelist (`enabledTechnologies`) and loads `prototypes/technology.lua`, which holds the mod's own tech tree.
- Last, `data.lua` defines the `turret-upgrade-tool` selection tool, its shortcut and the `ALT+Q` custom input.

### Turret tiers and naming conventions
- Families: gun (`infinite-gun-turret` = T1 "Basic Gun Turret", then `tier-two..five-gun-turret`), laser, tesla and flamer (`tier-one..five-<family>-turret`).
- Tier colours: T1 gray, T2 green, T3 blue, T4 red, T5 white.
- `models/tower-coin-costs.lua` maps each turret to `{cost, upgradeToName}`. It drives:
  - recipes: only the T1 turrets get a recipe, paid for in `coin` (`prototypes/recipe.lua`). The `infinite-gun-turret` recipe is enabled from the start.
  - the upgrade tool's entity whitelist (`data.lua`).
  - runtime upgrade pricing (`on_player_selected_area` in `control.lua`). Upgrading costs the *next* tier's `cost`.
- To add a turret, you need: an entity file, `require` lines in `data.lua`, an item in `prototypes/item.lua`, an icon in `graphics/icons/`, locale entries in `[entity-name]` and `[item-name]`, an entry in `tower-coin-costs.lua`, and usually a tech unlock.

### Technology
- `prototypes/technology.lua` defines the custom tree (turret unlocks, damage/speed bonuses, backpack, walkspeed, etc.).
- `biter-progress-tier-*-science` and `b-upgrade-turret-reward` are **script-triggered** techs. `control.lua` completes them with `force.script_trigger_research`, based on biter kill counts (`kill_requirements`) or on the first use of the upgrade tool.

## Control stage architecture

- `control.lua` (~2.8k lines) holds all event handlers, the GUI and the wave engine. It is one big file of `local function`s followed by `script.on_event` handlers.
- `scripts/map.lua` (`mapModule`) covers:
  - slot geometry (`slotDefinitions`: 8 slots, 200×200, laid out along x at 250-tile spacing)
  - difficulties (`1` = Normal, `2` = Easy, `3` = Hard)
  - the map registry (`allMaps`, `getMapByName`)
  - land generation (`generateSlotLand`) and reset (`resetMapSlot`)
  - spawn lookup
  - boss and enemy coin rewards
  - vote tallying (`getWinningMapNameAndMapDifficulty`)
- `scripts/maps/map1.lua` (`"map-1-sand"`, "Sand Dunes") holds biter waypoint paths and wave tables per difficulty (`mapBiterPaths[difficulty]`, `mapBiterWaveData[difficulty]`), plus default structures and water tiles. Its coordinates are **slot-relative**; `mapModule.getRelativeSlotPosition` converts them to world positions. To add a map, create `scripts/maps/mapN.lua` with the same fields and register it in `map.allMaps` and `map.getMapByName`.
- `scripts/building.lua` (`preventBuilding`) refunds and destroys anything a player builds outside their own slot or on `red-refined-concrete` (the biter path / protected tiles).
- `scripts/market.lua` holds the market offer tables and `fillMarket` / remove helpers. Some tables are empty or work in progress.

### Key runtime state (`storage`)
- `storage.mapSlots[id]` holds per-slot state. On init it is created from `slotDefinitions`. Fields:
  - occupancy: `isOccupied`, `slotOwnerIndex`
  - round state: `isGameStarted`, `isDead`, `isEndless`, `isPvp`, `enemyForce`
  - wave state: `currentWave`, `totalWaves`, `waveTimer` (in ticks), `waveStartTick`, `waveGroups`
  - map setup: `mapName`, `difficulty`, `mapWaveData`, `mapBiterPaths`
  - votes: `mapVotes`, `mapDifficultyVotes`
  - identity: `forceName = "mapSlotDef_<id>"` and `mapTagId`. Never reset these two.
- **Slot 1 is the public slot.** It is always marked occupied, has no owner, and is where players start and get sent back to after a game ends.
- `storage.biter_paths[unit_group.unique_id]` tracks the waypoint index of each biter group. `on_ai_command_completed` advances the group along the path. At the end of the path the group attacks that force's `rocket-silo`.
- `storage.delayedTickActions` is a list of `{tick, callback}` entries run from `on_tick`. ⚠️ These are closures stored in `storage`. Factorio cannot serialize functions, so treat this mechanism with care when you touch save/load behaviour.
- `storage.turretUpgradeRewarded[force.index]`.

### Game flow
1. `on_player_created` puts the player in the public slot and gives them the top `menu_bar` GUI.
2. The play button leads to map selection, then difficulty voting (`createMapSelectionGui`, `createDifficultyGui`). Once everyone has voted, or someone presses `force_start_game_button`, `startRoundForForce` generates the slot land, places the silo and map tag, and calls `startWave`.
3. `on_tick` → `processWave` spawns `waveGroups` over `waveDuration` and advances to the next wave when the timer reaches zero. After the last wave, `checkForWinnerSlot` polls every 600 ticks until no enemy units remain. It then announces the win, resets the slot and moves players back to slot 1.
4. Silo death (`on_entity_died`) ends the round for that slot. Boss and biter kills pay out coins (split among the force's connected players).
5. PvP: two slots linked through `isPvp` / `enemyForce` vote together and start together.
6. Leaving: ownership passes to another player on the force, and an inventory snapshot is dropped at spawn (`createSnapshotInventory`). If a slot sits empty, it is hard-reset after a delay.

Chat commands: `/suicide`, `/dropinv`, `/canceldropinv`.

## Conventions
- Indentation is mixed (tabs and 2 spaces). Match the surrounding block.
- Prefer early `return` guards with `.valid` checks on players and entities, as the existing code does.
- Look slots up with `mapModule.getSlotByForceName(force.name)` and `mapModule.getSlotDefinitionById(id)` (or `mapModule.slotDefinitions[id]`).
- The surface name is hard-coded as `"frontier"` (`main_surface_name`) in both `control.lua` and `map.lua`.
- New player-facing names go in `locale/en/strings.cfg`.
