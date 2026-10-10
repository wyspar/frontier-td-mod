local market = {}
market.custom_events = {
  ['playerItemsMarket'] = 'playerItemsMarket',
}

local attackMarketItems = {

}

--pvp only: buy biters that are sent down the other team's biter path (force "enemy-sent", they give no coins or boss rewards)
--the offer index is the position in this list, on_market_item_purchased in control.lua looks it up with market.getSendBiterOffer
market.sendBiterOffers = {
  { biterName = 'big-spitter',             count = 1, price = { { name = 'tier-two-science-pack', count = 12 } } },
  { biterName = 'behemoth-spitter',        count = 1, price = { { name = 'tier-three-science-pack', count = 5 } } },
  { biterName = 'behemoth-physical-biter', count = 1, price = { { name = 'tier-three-science-pack', count = 15 } } },
  { biterName = 'behemoth-fire-biter',     count = 1, price = { { name = 'tier-four-science-pack', count = 20 } } },
  { biterName = 'boss-biter-1',            count = 1, price = { { name = 'tier-five-science-pack', count = 50 } } },
}

function market.getSendBiterOffer(offerIndex)
  return market.sendBiterOffers[offerIndex]
end

--fills only this attack market, the send biter offers are only added in pvp
function market.fillAttackMarket(entity, isPvp)
  if not entity or not entity.valid then
    return
  end

  entity.clear_market_items()
  if not isPvp then
    return
  end

  for _, sendOffer in ipairs(market.sendBiterOffers) do
    entity.add_market_item({
      price = sendOffer.price,
      offer = {
        type = 'nothing',
        effect_description = { 'frontier-td-market.send-biters', sendOffer.count, { 'entity-name.' .. sendOffer.biterName } }
      }
    })
  end
end

local weaponMarketItems = {
  { price = { { name = 'coin', count = 45 } },    offer = { type = 'give-item', item = 'submachine-gun', count = 1 } },
  { price = { { name = 'coin', count = 200 } },   offer = { type = 'give-item', item = 'vehicle-machine-gun', count = 1 } },
  { price = { { name = 'coin', count = 20 } },    offer = { type = 'give-item', item = 'slowdown-capsule', count = 1 } },
  { 
		price = { { name = 'coin', count = 100 } },  
		offer = { type = 'give-item', item = 'fission-reactor-equipment', count = 1 } 
	},
  { 
		price = { { name = 'coin', count = 175 },{ name = 'fission-reactor-equipment', count = 1 } },  
		offer = { type = 'give-item', item = 'fusion-reactor-equipment', count = 1 } 
	},
  { price = { { name = 'coin', count = 50 } },   offer = { type = 'give-item', item = 'personal-roboport-equipment', count = 1 } },
  { 
		price = { { name = 'coin', count = 100 },{ name = 'personal-roboport-equipment', count = 1 } },   
		offer = { type = 'give-item', item = 'personal-roboport-mk2-equipment', count = 1 } 
	},
  { price = { { name = 'coin', count = 10 } },    offer = { type = 'give-item', item = 'construction-robot', count = 5 } },
  { price = { { name = 'coin', count = 1 } },    offer = { type = 'give-item', item = 'mech-armor', count = 1 } },
  { price = { { name = 'coin', count = 5 } },    offer = { type = 'give-item', item = 'toolbelt-equipment', count = 1 } },
  { 
		price = { { name = 'coin', count = 50 },{ name = 'productivity-module', count = 1 } },    
		offer = { type = 'give-item', item = 'productivity-module-3', count = 1 } 
	},
	{ 
		price = { { name = 'coin', count = 40 },{ name = 'speed-module', count = 1 } },    
		offer = { type = 'give-item', item = 'speed-module-3', count = 1 } 
	},
  { price = { { name = 'coin', count = 20 } },    offer = { type = 'give-item', item = 'exoskeleton-equipment', count = 1 } },
}

--the slowdown capsule price doubles for a force every time someone on it buys one (20, 40, 80, ...),
--capped at SLOWDOWN_CAPSULE_MAX_PRICE. it goes back to the base price when the slot is set up for a new round
local SLOWDOWN_CAPSULE_ITEM = 'slowdown-capsule'
local SLOWDOWN_CAPSULE_BASE_PRICE = 20
local SLOWDOWN_CAPSULE_MAX_PRICE = 128000

function market.getSlowdownCapsulePrice(forceName)
  storage.slowdownCapsulePrice = storage.slowdownCapsulePrice or {}
  return storage.slowdownCapsulePrice[forceName] or SLOWDOWN_CAPSULE_BASE_PRICE
end

function market.resetSlowdownCapsulePrice(forceName)
  storage.slowdownCapsulePrice = storage.slowdownCapsulePrice or {}
  storage.slowdownCapsulePrice[forceName] = nil
end

function market.isSlowdownCapsuleOffer(entity, offerIndex)
  local item = weaponMarketItems[offerIndex]
  return entity.name == 'weapons-market' and item ~= nil and item.offer.item == SLOWDOWN_CAPSULE_ITEM
end

--fills one weapons market, with the slowdown capsule at its force's current price
local function fillWeaponsMarket(entity)
  local slowdownPrice = market.getSlowdownCapsulePrice(entity.force.name)
  for _, item in ipairs(weaponMarketItems) do
    if item.offer.item == SLOWDOWN_CAPSULE_ITEM then
      entity.add_market_item({ price = { { name = 'coin', count = slowdownPrice } }, offer = item.offer })
    else
      entity.add_market_item(item)
    end
  end
end

--doubles the force's slowdown capsule price and refills that force's weapons markets so they show it
function market.doubleSlowdownCapsulePrice(surface, force)
  storage.slowdownCapsulePrice = storage.slowdownCapsulePrice or {}
  local price = math.min(market.getSlowdownCapsulePrice(force.name) * 2, SLOWDOWN_CAPSULE_MAX_PRICE)
  storage.slowdownCapsulePrice[force.name] = price
  for _, entity in pairs(surface.find_entities_filtered({name = 'weapons-market', force = force})) do
    if entity.valid then
      entity.clear_market_items()
      fillWeaponsMarket(entity)
    end
  end
  return price
end

local landMarket_Items = {
}

local playerItemsMarket_items = {
  { price = { { name = 'iron-gear-wheel', count = 1 } },     offer = { type = 'give-item', item = 'raw-fish', count = 1 } },
  { price = { { name = 'iron-plate', count = 3 } },     offer = { type = 'give-item', item = 'firearm-magazine', count = 1 } },
  { price = { { name = 'iron-plate', count = 2 },{ name = 'steel-plate', count = 1 },{ name = 'copper-plate', count = 1 } },     offer = { type = 'give-item', item = 'piercing-rounds-magazine', count = 1 } },
  { price = { { name = 'iron-plate', count = 15 } },    offer = { type = 'give-item', item = 'pistol', count = 1 } },
  { price = { { name = 'iron-gear-wheel', count = 15 } },    offer = { type = 'give-item', item = 'submachine-gun', count = 1 } },
  --{ price = { { name = 'coin', count = 32 } },    offer = { type = 'give-item', item = 'cluster-grenade', count = 1 } },
  -- { price = { { name = 'coin', count = 80 } },    offer = { type = 'give-item', item = 'car', count = 1 } },
  -- { price = { { name = 'coin', count = 1200 } },  offer = { type = 'give-item', item = 'tank', count = 1 } },
  -- { price = { { name = 'coin', count = 3 } },     offer = { type = 'give-item', item = 'cannon-shell', count = 1 } },
  -- { price = { { name = 'coin', count = 7 } },     offer = { type = 'give-item', item = 'explosive-cannon-shell', count = 1 } },
  {
    price = {
      { name = 'iron-plate', count = 1, quality = "normal" },
      { name = 'copper-plate', count = 1, quality = "normal" },
    },
    offer = { type = 'give-item', item = 'shotgun-shell', count = 1, quality = "uncommon" }
  },
  {
    price = {
      { name = 'iron-plate', count = 10, quality = "normal" },
      { name = 'copper-plate', count = 10, quality = "normal" },
    },
    offer = { type = 'give-item', item = 'shotgun', count = 1, quality = "uncommon" }
  },
  {
    price = {
      { name = 'coin', count = 6}
    },
    offer = { type = 'give-item', item = 'piercing-shotgun-shell', count = 1, quality = "uncommon" }
  },
  {
    price = {
      { name = 'coin', count = 250}
    },
    offer = { type = 'give-item', item = 'combat-shotgun', count = 1, quality = "uncommon" }
  },
  { price = { { name = 'coin', count = 50 } },   offer = { type = 'give-item', item = 'flamethrower', count = 1 } },
  { price = { { name = 'coin', count = 1 } },    offer = { type = 'give-item', item = 'flamethrower-ammo', count = 1 } },
  { price = { { name = 'coin', count = 125 } },   offer = { type = 'give-item', item = 'rocket-launcher', count = 1 } },
  { price = { { name = 'coin', count = 2 } },     offer = { type = 'give-item', item = 'rocket', count = 1 } },
  { price = { { name = 'coin', count = 7 } },     offer = { type = 'give-item', item = 'explosive-rocket', count = 1 } },
  { price = { { name = 'coin', count = 25 } },    offer = { type = 'give-item', item = 'poison-capsule', count = 1 } },
  { price = { { name = 'coin', count = 5 } },     offer = { type = 'give-item', item = 'defender-capsule', count = 1 } },
  { price = { { name = 'iron-plate', count = 10 } },    offer = { type = 'give-item', item = 'light-armor', count = 1 } },
  { price = { { name = 'coin', count = 25 } },   offer = { type = 'give-item', item = 'heavy-armor', count = 1 } },
  {
    price = {
      { name = 'electronic-circuit', count = 100, quality = "uncommon" },
      { name = 'advanced-circuit', count = 100, quality = "normal" },
    },
    offer = { type = 'give-item', item = 'modular-armor', count = 1, quality = "uncommon" }
  },
  -- { price = { { name = 'coin', count = 350 } },   offer = { type = 'give-item', item = 'modular-armor', count = 1 } },
  -- { price = { { name = 'coin', count = 1500 } },  offer = { type = 'give-item', item = 'power-armor', count = 1 } },
  -- { price = { { name = 'coin', count = 12000 } }, offer = { type = 'give-item', item = 'power-armor-mk2', count = 1 } },
  -- { price = { { name = 'coin', count = 50 } },    offer = { type = 'give-item', item = 'solar-panel-equipment', count = 1 } },
  -- { price = { { name = 'coin', count = 2250 } },  offer = { type = 'give-item', item = 'fission-reactor-equipment', count = 1 } },
  -- { price = { { name = 'coin', count = 100 } },   offer = { type = 'give-item', item = 'battery-equipment', count = 1 } },
  -- { price = { { name = 'coin', count = 200 } },   offer = { type = 'give-item', item = 'energy-shield-equipment', count = 1 } },
  -- { price = { { name = 'coin', count = 850 } },   offer = { type = 'give-item', item = 'personal-laser-defense-equipment', count = 1 } },
  -- { price = { { name = 'coin', count = 175 } },   offer = { type = 'give-item', item = 'exoskeleton-equipment', count = 1 } },
  -- { price = { { name = 'coin', count = 125 } },   offer = { type = 'give-item', item = 'night-vision-equipment', count = 1 } },
  -- { price = { { name = 'coin', count = 200 } },   offer = { type = 'give-item', item = 'belt-immunity-equipment', count = 1 } },
  -- { price = { { name = 'coin', count = 250 } },   offer = { type = 'give-item', item = 'personal-roboport-equipment', count = 1 } },
  -- { price = { { name = 'coin', count = 350 } },   offer = { type = 'give-item', item = 'roboport', count = 1 } },
  -- { price = { { name = 'coin', count = 50 } },    offer = { type = 'give-item', item = 'storage-chest', count = 1 } },
  -- { price = { { name = 'coin', count = 35 } },    offer = { type = 'give-item', item = 'construction-robot', count = 1 } },
}

local east_Market_Items = {
  {
    price = {
      { name = 'coin', count = 1500 }
    },
    offer = {
      type = 'nothing',
      effect_description = market.custom_events["player-upgrade-build-range"]
    }
  },
}

function market.fillMarket(surface, marketName, entityName)
  for _, entity in pairs(surface.find_entities_filtered({name = entityName})) do
    if entity and entity.valid then
      entity.clear_market_items()
      if marketName == 'attack-market' then
        for _, item in pairs(attackMarketItems) do
          entity.add_market_item(item)
        end
      elseif marketName == 'weapons-market' then
        fillWeaponsMarket(entity)
      end
      -- this is for having multiple of the same market, need to mark it with a name tag / entity name tag
      -- if entity.name_tag == marketName then

      -- end
    end
  end
end

function market.removeItemFromMarket(surface, itemName, marketName, entityName)
  for _, entity in pairs(surface.find_entities_filtered({name = entityName})) do
    if entity and entity.valid then
      if entity.name_tag == marketName then
        local items = entity.get_market_items()
        for index, item in pairs(items) do
          if item.offer.item == itemName then
            entity.remove_market_item(index)
            break
          end
        end
      end
    end
  end
end

function market.removeEffectFromMarket(surface, effectName, marketName, entityName)
  for _, entity in pairs(surface.find_entities_filtered({name = entityName})) do
    if entity and entity.valid then
      if entity.name_tag == marketName then
        local items = entity.get_market_items()
        for index, item in pairs(items) do
          if item.offer.effect_description == effectName then
            entity.remove_market_item(index)
            break
          end
        end
      end
    end
  end
end

return market