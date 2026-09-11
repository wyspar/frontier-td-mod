local mainSurface = "frontier"
local function getBiterKillsByForce(force)
  local kills = 0
  local surface = game.surfaces[mainSurface]
  local stats = force.get_kill_count_statistics(surface)
  local inputCounts = stats.input_counts

  kills = kills + (inputCounts["small-biter"] or 0)
  kills = kills + (inputCounts["medium-biter"] or 0)
  kills = kills + (inputCounts["big-biter"] or 0)
  kills = kills + (inputCounts["behemoth-biter"] or 0)
  kills = kills + (inputCounts["small-spitter"] or 0)
  kills = kills + (inputCounts["medium-spitter"] or 0)
  kills = kills + (inputCounts["big-spitter"] or 0)
  kills = kills + (inputCounts["behemoth-spitter"] or 0)
  kills = kills + (inputCounts["small-wriggler-pentapod"] or 0)
  kills = kills + (inputCounts["medium-wriggler-pentapod"] or 0)
  kills = kills + (inputCounts["big-wriggler-pentapod"] or 0)
  kills = kills + (inputCounts["small-stomper-pentapod"] or 0)
  kills = kills + (inputCounts["medium-stomper-pentapod"] or 0)
  kills = kills + (inputCounts["big-stomper-pentapod"] or 0)
  kills = kills + (inputCounts["small-strafer-pentapod"] or 0)
  kills = kills + (inputCounts["medium-strafer-pentapod"] or 0)
  kills = kills + (inputCounts["big-strafer-pentapod"] or 0)
  --bosses
  kills = kills + (inputCounts["boss-biter-1"] or 0)

  --modded shit
  kills = kills + (inputCounts["small-physical-biter"] or 0)
  kills = kills + (inputCounts["medium-physical-biter"] or 0)
  kills = kills + (inputCounts["big-physical-biter"] or 0)
  kills = kills + (inputCounts["behemoth-physical-biter"] or 0)
  kills = kills + (inputCounts["small-armoured-biter"] or 0)
  kills = kills + (inputCounts["medium-armoured-biter"] or 0)
  kills = kills + (inputCounts["big-armoured-biter"] or 0)
  kills = kills + (inputCounts["behemoth-armoured-biter"] or 0)
  kills = kills + (inputCounts["small-flyer"] or 0)
  kills = kills + (inputCounts["medium-flyer"] or 0)
  kills = kills + (inputCounts["big-flyer"] or 0)
  kills = kills + (inputCounts["behemoth-flyer"] or 0)
  kills = kills + (inputCounts["ultra-flyer"] or 0)

  -- for _, surface in pairs(game.surfaces) do
    
  -- end

  return kills
end

local kill_requirements = {
  ["biter-progress-automation-science"] = 10,
  ["biter-progress-logistics"] = 50,
  ["biter-progress-military"] = 200,
}

script.on_nth_tick(60, function()
	for _, force in pairs(game.forces) do
		if force.name ~= "enemy" and force.name ~= "neutral" then
			local kills = getBiterKillsByForce(force)

			for name, required_kills in pairs(kill_requirements) do
				local technology = force.technologies[name]

				if technology and not technology.researched then
					if kills >= required_kills then
						force.script_trigger_research(name)
					end
				end
			end
		end
	end
end)


script.on_event(defines.events.on_gui_opened, function(event)
  local player = game.get_player(event.player_index)
  local entity = event.entity

  if player.gui.relative["infinite_turret_upgrade"] then
    return
  end

  -- if entity and entity.name == "infinite-gun-turret" then
  --   local button = player.gui.relative.add{
  --     type = "button",
  --     name = "infinite_turret_upgrade",
  --     caption = "Upgrade Turret",
  --     anchor = {
  --       gui = defines.relative_gui_type.turret_gui,
  --       position = defines.relative_gui_position.right
  --     }
  --   }
  --   button.style.margin = 4
  --   return
  -- end

end)

script.on_event(defines.events.on_gui_click, function(event)
  if event.element.name == "infinite_turret_upgrade" then
    local player = game.get_player(event.player_index)
    local turret = player.opened

    if not turret or not turret.valid then
      return
    end

    if turret.name ~= "infinite-gun-turret" then
      return
    end

    local surface = turret.surface
    local position = turret.position
    local force = turret.force

    turret.destroy()

    surface.create_entity{
      name = "tier-two-gun-turret",
      position = position,
      force = force
    }
    return
  end
end)

script.on_event(defines.events.on_gui_closed, function(event)
  local player = game.get_player(event.player_index)

  if player.gui.relative["infinite_turret_upgrade"] then
    player.gui.relative["infinite_turret_upgrade"].destroy()
  end
end)

local turret_upgrades = {
  ["infinite-gun-turret"] = {
    name = "tier-two-gun-turret",
    cost = 3
  },

  ["tier-two-gun-turret"] = {
    name = "tier-three-gun-turret",
    cost = 20
  },

  ["tier-three-gun-turret"] = {
    name = "tier-four-gun-turret",
    cost = 50
  },

  ["tier-four-gun-turret"] = {
    name = "tier-five-gun-turret",
    cost = 200
  }
}

script.on_event(defines.events.on_player_selected_area, function(event)
  if event.item ~= "turret-upgrade-tool" then
    return
  end

  local player = game.get_player(event.player_index)

  if not player or not player.valid then
    return
  end

  local inventory = player.get_main_inventory()

  if not inventory then
    return
  end

  local total_cost = 0
  local upgrade_count = 0

  for _, turret in pairs(event.entities) do
    if turret.valid then
      local upgrade = turret_upgrades[turret.name]

      if upgrade then
        total_cost = total_cost + upgrade.cost
        upgrade_count = upgrade_count + 1
      end
    end
  end

  if upgrade_count == 0 then
    return
  end

  local coins = inventory.get_item_count("coin")

  if coins < total_cost then
    player.print(
      "Not enough coins! Need "
      .. total_cost
      .. ", have "
      .. coins
    )

    return
  end

  inventory.remove{
    name = "coin",
    count = total_cost
  }

  for _, old_turret in pairs(event.entities) do
    if old_turret.valid then

      local upgrade = turret_upgrades[old_turret.name]

      if upgrade then

        local surface = old_turret.surface
        local position = old_turret.position
        local force = old_turret.force
        local direction = old_turret.direction
        local health = old_turret.health

        local new_turret = surface.create_entity{
          name = upgrade.name,
          position = position,
          force = force,
          direction = direction
        }

        if new_turret then
          new_turret.health = math.min(
            health,
            new_turret.max_health
          )

          old_turret.destroy()
        end
      end
    end
  end
end)

