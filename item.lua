local ItemLib = {}


ItemLib.load = function()
  items = {}
  smallestItemCountOnShip = 0
  globalFrozen = 1
end

ItemLib.update = function(dt)
  generateItems()
  ItemLib.updateAllItemStates()
end

ItemLib.draw = function ()
  new_items = {}
  for _, item in ipairs(items) do
    if (ItemLib.drawItem(item)) then
      table.insert(new_items, item)
    end
  end
  items = new_items
end

ItemLib.drawItem = function(item)
  if item ~= nil then
    userData = item.f:getUserData()
    if userData.isAlive then
    local offset = 1
      if userData.button == "A" then
        love.graphics.setColor( 0, 255, 0, 255 )
        offset = 2
      elseif userData.button == "B" then
        love.graphics.setColor( 255, 0, 0, 255 )
        offset = 3
      elseif userData.button == "X" then
        love.graphics.setColor( 0, 0, 255, 255 )
        offset = 4
      elseif userData.button == "Y" then
        love.graphics.setColor( 255, 255, 0, 255 )
        offset = 5
      else
        love.graphics.setColor( 255, 255, 255, 255 )
      end
      if LevelsInfo.l[globalLevel].allColor then love.graphics.setColor(LevelsInfo.l[globalLevel].allColor) end
      if userData.color then
        love.graphics.setColor(userData.color)
      end
      if (item.ship ~= nil) then
        item.b:setPosition(SCREEN_WIDTH / 5 * (item.ship.number - 1) + 50*offset,  SCREEN_HEIGHT - BordersLib.BottomBar/2)
        item.b:setAngle(0)
      end
      love.graphics.polygon('fill', item.b:getWorldPoints(item.s:getPoints()))
      love.graphics.setColor( 255, 255, 255, 255 )
      return true
    else
      x, y = item.b:getWorldPoints(item.s:getPoints())
      EffectLib.startEffect(1, x, y)
      item.f:destroy()
      return false
    end
  end
end

ItemLib.newItem = function (initial_x, initial_y, other, button, name)
  initial_x = initial_x or 0
  initial_y = initial_y or 0

  item = {}
  item.name = name or 'ItemLibObject'
  -- set x,y position (400,200) and let it move and hit other objects
  -- ("dynamic")
  item.b = love.physics.newBody(world, initial_x, initial_y, "dynamic")
  -- make it pretty light
  item.b:setMass(20)
  item.s = love.physics.newRectangleShape(20, 20)
  -- connect body to shape
  item.f = love.physics.newFixture(item.b, item.s)
  -- make it bouncy
  item.f:setRestitution(0.2)
  -- give it a name, which we'll access later
  item.f:setUserData(item)
  -- Control the rotation
  item.b:setLinearDamping(4.00)
  item.b:setAngularDamping(3.50)
  item.b:setAngle(0)

  item.isAlive = true
  item.type = type
  item.shooting = other.shooting
  item.boost = other.boost
  item.other = other
  item.shield = other.shield
  if (item.shield) then
    item.shield.lastUse = nil
  end
  item.frozen = other.frozen
  if (item.frozen) then
    item.frozen.lastUse = nil
  end
  if item.shooting then
    item.shooting.lastFire = -100000000000
  end

  item.pickupSound = love.audio.newSource( "assets/sound/pickupItem.mp3", "static" )

  item.object = 'ITEM'

  item.button = button

  return item
end

ItemLib.attemptItemPickup = function(item, ship)

  -- item = item.f:getUserData()
  local itemTypeInShip = false
  if item.ship ~= nil then
    return false
  end
  -- if #ship.items >= smallestItemCountOnShip + 1 then
  --   return false
  -- end
  for _, shipItem in ipairs(ship.items) do
    if (item.button == shipItem.button and (item.other.upgrade or 0) - (shipItem.other.upgrade or 0) <= 0) then
      itemTypeInShip = true
    end
  end
  if not (itemTypeInShip) then
    table.insert(ship.items, item)
    item.ship = ship
    ship.buttons[item.button] = item
    ItemLib.initItem(item)
    if globalTick > 10 then
      love.audio.play(item.pickupSound)
    end
    smallestItemCountOnShip = 1000000
    for i,shipIter in ipairs(ships) do
      if #shipIter.items < smallestItemCountOnShip then
        smallestItemCountOnShip = #shipIter.items
      end
    end
    for i,shipIter in ipairs(deadShips) do
      if #shipIter.items < smallestItemCountOnShip then
        smallestItemCountOnShip = #shipIter.items
      end
    end
  end
end

ItemLib.initItem = function (item)
  if item.shooting ~= nil and item.shooting.radial ~= nil then
    item.ship.radialShootingOthers = item.shooting
    item.ship.isRadialShooting = true
  end
end

ItemLib.useItem = function (item)

  if item.shooting ~= nil then
    local angle = item.ship.b:getAngle() + (LevelsInfo.l[globalLevel].firingAngle or 0)
    BulletsLib.fire(item.ship, angle - math.pi/2, item.shooting)
  end

  if item.boost ~= nil then
    local angle = item.ship.b:getAngle()
    if item.boost.controlled then
      angle = math.atan2(item.ship.lstickx, item.ship.lsticky)
    end
    local speed = (item.boost.speed or 5000)
    item.ship.b:applyForce(5000*math.sin(angle), 5000*math.cos(angle))
  end

  if item.shield ~= nil then
    ItemLib.useShield(item.shield, item.ship)
  end

  if item.frozen ~= nil then
    if ItemLib.rateLimit(item.frozen) then
      globalFrozen = globalFrozen + (item.frozen.damping or 2000)
      printMessage("Damp", SCREEN_HEIGHT)
      item.frozenCounter = 0
    end
  end
end

ItemLib.ejectButton = function (item)
  if item ~= nil then
    item.ship = nil
    item.b:setY(SCREEN_HEIGHT - 3*BordersLib.BottomBar/2)
  end
end

ItemLib.useShield = function (shield, ship)
  if shield == nil then return false end
  if ItemLib.rateLimit(shield) then
    shield.health = shield.health or 100
    ship.shieldHealth = shield.health
    ship.shield = shield
    ship.shield.counter = 0
  end
end

ItemLib.shieldUpdate = function (ship)
  if ship.shield and ship.shieldHealth > 0 then
    ship.shield.counter = ship.shield.counter + 1
    if ship.shield.counter > (ship.shield.duration or 50) then
      ship.shieldHealth = 0
    end
  end
end

ItemLib.rateLimit = function (obj)
  obj.lastUse = obj.lastUse or -100000000000
  obj.cooldown = obj.cooldown or 200
  local temp = ((globalTick - obj.lastUse) % obj.cooldown == 0 or (globalTick - obj.lastUse) > obj.cooldown)
  if temp then
      obj.lastUse = globalTick
  end
  return temp
end

ItemLib.updateAllItemStates = function ()
  for i,item in ipairs(items) do
    if (item.frozenCounter ~= nil and item.frozenCounter ~= -1) then
      item.frozenCounter = item.frozenCounter + 1
      if (item.frozenCounter > (item.frozen.duration or 50)) then
        globalFrozen = globalFrozen - (item.frozen.damping or 2000)
        item.frozenCounter = -1
      end
    end
  end
end

function generateItems()
 for _, newItem in ipairs(LevelsInfo.l[globalLevel].items) do
    if (newItem.time <= globalTick + 20 and newItem.isEntryAnimated == false) then
      newItem.isEntryAnimated = true
      EffectLib.startEffect(3, newItem.x, newItem.y)
    end
    if (newItem.time <= globalTick and newItem.isActivated == false) then
      newItem.isActivated = true
      table.insert(items, ItemLib.newItem(newItem.x, newItem.y, newItem, newItem.button, 'Item'))
    end
  end
end

return ItemLib