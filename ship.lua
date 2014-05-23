local ShipLib = {} -- public interface

-- Below this are the array based/global functions for Ships

ShipLib.load = function()
  ships = {}
  deadShips = {}
  ejectButtons = {UD = "Y",DD = "A",LD = "X",RD = "B", SELECT = "R"}

  shipPicture = love.graphics.newImage("assets/ArcShip.png")

  ShipLib.makeNewShips()
end

ShipLib.makeNewShips = function ()
  ship1 = ShipLib.newShip(SCREEN_WIDTH/4, (SCREEN_HEIGHT - BordersLib.BottomBar)/4, 'Player 1', 1)
  ship2 = ShipLib.newShip(3*SCREEN_WIDTH/4, (SCREEN_HEIGHT - BordersLib.BottomBar)/4, 'Player 2', 2)
  ship3 = ShipLib.newShip(3*SCREEN_WIDTH/4, 3*(SCREEN_HEIGHT - BordersLib.BottomBar)/4, 'Player 3', 3)
  ship4 = ShipLib.newShip(SCREEN_WIDTH/4, 3*(SCREEN_HEIGHT - BordersLib.BottomBar)/4, 'Player 4', 4)
  ship5 = ShipLib.newShip(SCREEN_WIDTH/2, (SCREEN_HEIGHT - BordersLib.BottomBar)/2, 'Player 5', 5)
  table.insert(ships, ship1)
  table.insert(ships, ship2)
  table.insert(ships, ship3)
  table.insert(ships, ship4)
  table.insert(ships, ship5)
  for i,ship1 in ipairs(ships) do
    for j,ship2 in ipairs(ships) do
      if ship1.number ~= ship2.number then
        -- love.physics.newWeldJoint( ship1.b, ship2.b, 0, 0, 0, 0, 10, true )
      end
    end
  end

  local newItem = {}
  for i,ship in ipairs(savedState) do
    for j,item in ipairs(ship.items) do
      print (i .. j..item.name..ship.name)
      newitem = ItemLib.newItem(0, 0, item.other, item.button, item.name)
      table.insert(items, newitem)
      ItemLib.attemptItemPickup(newitem, ships[ship.number])
    end
  end
end

ShipLib.update = function(dt)
  for i, ship in ipairs(ships) do
    -- Movement
    local currentJoystick = ship.number
    if LevelsInfo.l[globalLevel].stickOffset then
      currentJoystick = (LevelsInfo.l[globalLevel].stickOffset + currentJoystick) % 5 + 1
    end
    local lstickx,lsticky = dong.ls(currentJoystick)
    if (ShipLib.isUnderMaxSpeed(ship)) then
      if love.keyboard.isDown('right') then ship.b:applyForce(5000, 0) end
      if love.keyboard.isDown('left') then ship.b:applyForce(-5000, 0) end
      if love.keyboard.isDown('up') then ship.b:applyForce(0, -5000) end
      if love.keyboard.isDown('down') then ship.b:applyForce(0, 5000) end
      if (lstickx ~= nil) then
        if (math.abs(lstickx) < .2) then lstickx = 0 end
        if (math.abs(lsticky) < .2) then lsticky = 0 end
        ship.lstickx = lstickx
        ship.lsticky = lsticky
        ship.b:applyForce(lstickx*5000, lsticky*5000)
      end
    end

    -- Rotate the ship
    ShipLib.updateAngle(ship)

    if LevelsInfo.l[globalLevel].buttonOffset then
      currentJoystick = (LevelsInfo.l[globalLevel].buttonOffset + ship.number) % 5 + 1
    end
    for _,button in ipairs(dong.buttons) do
      if dong.isDown(currentJoystick,button) then
        -- print("Button Pressed")
        if button == "RB" then button = "B" end
        if button == "LB" then button = "Y" end
        if ship.buttons[button] ~= nil then
          ItemLib.useItem(ship.buttons[button])
        end
        if (ejectButtons[button]) then
          ItemLib.ejectButton(ship.buttons[ejectButtons[button]])
          newItems = {}
          for i,item in ipairs(ship.items) do
            if item ~= ship.buttons[ejectButtons[button]] then
              table.insert(newItems, item)
            end
          end
          ship.items = newItems
          ship.buttons[ejectButtons[button]] = nil
        end
      end
    end

    -- local rightTrigger = dong.rt(currentJoystick)
    -- if (rightTrigger and rightTrigger < 0) then
    --   button = "A"
    --   if ship.buttons[button] ~= nil then
    --     ItemLib.useItem(ship.buttons[button])
    --   end
    --   if (ejectButtons[button]) then
    --     ItemLib.ejectButton(ship.buttons[ejectButtons[button]])
    --     newItems = {}
    --     for i,item in ipairs(ship.items) do
    --       if item ~= ship.buttons[ejectButtons[button]] then
    --         table.insert(newItems, item)
    --       end
    --     end
    --     ship.items = newItems
    --     ship.buttons[ejectButtons[button]] = nil
    --   end
    -- end


    if ship.isRadialShooting and ship.radialShootingOthers then
      local rstickx,rsticky = dong.rs(currentJoystick)
      if rstickx ~= nil then
        if ((rstickx^2 + rsticky^2) > .25) then
          BulletsLib.fire(ship, math.atan2(rsticky, rstickx), ship.radialShootingOthers)
        end
      end
    end

    -- Shield
    ItemLib.shieldUpdate(ship)

    -- Shooting
    angles = {}
    if love.keyboard.isDown("d") then table.insert(angles,math.pi * 4/2) end
    if love.keyboard.isDown("a") then table.insert(angles,math.pi * 2/2) end
    if love.keyboard.isDown("w") then table.insert(angles,math.pi * 3/2) end
    if love.keyboard.isDown("s") then table.insert(angles,math.pi * 1/2) end

    -- Fix for shooting on AWSD
    size = table.getn(angles)
    if size ~= 0 then
      outAngle = 0
      for _, angle in ipairs(angles) do
        outAngle = outAngle + angle
      end
      outAngle = (outAngle/size) % (2 * math.pi)
      BulletsLib.fire(ship, outAngle, {type=1; angleSeperation = .15; number = 1; speed = 1000000000})
    end

    ShipLib.forceInbounds(ship)

    if ship.weld ~= nil then
      -- love.physics.newWeldJoint( ship.b, ship.weld.b, 100, 100, 0, 0, true )
      ship.weld = nil
    end

  end
end

ShipLib.draw = function ()
  new_ships = {}
  for _, ship in ipairs(ships) do
    if (ShipLib.drawShip(ship)) then
      table.insert(new_ships, ship)
    else
      table.insert(deadShips, ship)
    end
  end
  ships = new_ships
end

ShipLib.forceInbounds = function (ship)
  -- Make sure ships stay in bounds (hack for glitch)
  if (ship.b:getX() < 0) then
    ship.b:setX(3)
  elseif (ship.b:getX() > SCREEN_WIDTH) then
    ship.b:setX(SCREEN_WIDTH -3)
  end

  if (ship.b:getY() < 0) then
    ship.b:setY(3)
  elseif (ship.b:getY() > (SCREEN_HEIGHT - BordersLib.BottomBar)) then
    ship.b:setY(SCREEN_HEIGHT -3 - BordersLib.BottomBar)
  end

end

ShipLib.shipsLeft = function ()
  return table.getn(ships)
end

ShipLib.closestShip = function (x, y)
  small_mag = nil
  small_x = nil
  small_y = nil
  for _, ship in ipairs(ships) do
    ship_x, ship_y = ship.b:getWorldPoints(ship.s:getPoints());
    mag_sqrd = (ship_x - x)^2 + (ship_y - y)^2
    if (small_mag == nil or small_mag > mag_sqrd) then
      small_mag = mag_sqrd
      small_x = ship_x
      small_y = ship_y
    end
  end
  return small_x, small_y
end

-- Below this are all of the single Ship functions, above are array based functions

ShipLib.newShip = function(initial_x, initial_y, name, shipNum)
  initial_x = initial_x or 0
  initial_y = initial_y or 0

  ship = {}
  ship.name = name or 'ShipLibObject'
  -- set x,y position (400,200) and let it move and hit other objects
  -- ("dynamic")
  ship.b = love.physics.newBody(world, initial_x, initial_y, "dynamic")
  -- make it pretty light
  ship.b:setMass(20)
  -- ship.s = love.physics.newRectangleShape(50, 30)
  -- ship.s = love.physics.newPolygonShape(0, 0, -50, 50, 50, 50)

  triangleSize = 35
  ship.s = love.physics.newPolygonShape(0, 0, -triangleSize,triangleSize, triangleSize, triangleSize)
  -- connect body to shape
  ship.f = love.physics.newFixture(ship.b, ship.s)
  -- make it bouncy
  ship.f:setRestitution(0.2)
  -- give it a name, which we'll access later
  ship.f:setUserData(ship)
  -- Control the rotation
  ship.b:setLinearDamping(4.00)
  ship.b:setAngularDamping(10.50)
  ship.b:setAngle(0)

  if (LevelsInfo.l[globalLevel].friendlyFire or false) then
    ship.f:setMask(shipNum + 3)
  else
    ship.f:setMask(2, 8)
  end

  ship.isAlive = true
  ship.lastFire = 0
  ship.damage = 100  -- Damage dealt on head on collision
  ship.health = 100  -- Health
  ship.totalHealth = ship.health
  ship.others = {}

  ship.object = 'SHIP'
  ship.speedSquared = 500 * 500
  ship.items = {}
  ship.buttons = {}
  ship.number = shipNum


  return ship
end

-- This function sets the angle for an object that is moving towards the
-- direction that it's currently moving in. It does it slowly so that
-- it never looks too "jerky"
ShipLib.updateAngle = function(ship)
  v_x, v_y = ship.b:getLinearVelocity()

  magnitude = v_x*v_x + v_y*v_y

  -- In the case that the shipect is no longer moving, we don't want
  -- to update its heading
  if (v_x ~= 0 or v_y ~= 0) then
    -- Get the angle it's headed in based on the input velocities
    targetAngle = math.atan2(v_x,-v_y)
    currentAngle = ship.b:getAngle()
    nextAngle = currentAngle - targetAngle

    -- If the angle between the two is more than 180 degrees then
    -- we know that we need to rotate in the other direction
    mag = math.abs(nextAngle)
    if mag > math.pi then
      -- This case can only occur since the target angle is bounded
      -- by -180 to 180 degrees, so we add 360 to it and recompute
      -- the next angle, which gives us a range which is appropriate
      targetAngle = targetAngle + 2*math.pi
      nextAngle = currentAngle - targetAngle
    end
    -- We then set the angle 20% to the new angle we want, so that it
    -- does the transition slowly. We then mod by 2 pi so that our
    -- set angle never exceeds 2pi, which can be an issue when we
    -- try and compute the next angle since our above assumptions
    -- no longer hold
    ship.b:setAngle(ship.b:getAngle() % (2 * math.pi))
    local angleAdjustment = (currentAngle - (nextAngle * 20))
    if LevelsInfo.l[globalLevel].pinballMode then
      ship.b:applyTorque((angleAdjustment)^2 * 10000)
    -- elseif LevelsInfo.l[globalLevel].friendlyFire then
      -- ship.b:setAngle((currentAngle - (nextAngle * .20*(magnitude/200000))) % (2 * math.pi))
    else
      if angleAdjustment < 0 then
        ship.b:applyTorque((-angleAdjustment)^.5 * -(ship.others.torqueMult or 1) * 10000)
      else
        ship.b:applyTorque((angleAdjustment)^.5 * (ship.others.torqueMult or 1) * 10000)
      end
    end
  end
end

-- This function draws the ship
ShipLib.drawShip = function(ship)
  if ship ~= nil then
    if ship.f:getUserData().isAlive then

      if (ship.shieldHealth and ship.shieldHealth > 0) then
        -- love.graphics.setColor( 0, 0, 255, Tools.glowEffect(128, 255, 50))
        Tools.setColor(LevelsInfo.shipColors[ship.number], Tools.glowEffect(128, 255, 50))
      else
        love.graphics.setColor(LevelsInfo.shipColors[ship.number])
      end
      if LevelsInfo.l[globalLevel].allColor then love.graphics.setColor(LevelsInfo.l[globalLevel].allColor) end
      -- love.graphics.draw(shipPicture, 100, 100)
      love.graphics.polygon('fill', ship.b:getWorldPoints(ship.s:getPoints()))
      -- love.graphics.setColor( 255, 255, 255, 255 )

      -- Draw bottom bar
      Tools.setColor(LevelsInfo.shipColors[ship.number], 40)
      if LevelsInfo.l[globalLevel].allColor then love.graphics.setColor(LevelsInfo.l[globalLevel].allColor) end
      love.graphics.rectangle('fill', SCREEN_WIDTH / 5 * (ship.number - 1),  SCREEN_HEIGHT - BordersLib.BottomBar, (SCREEN_WIDTH / 5) * ship.health / ship.totalHealth , BordersLib.BottomBar)

      -- Draw bottom bar SHIELD
      if ship.shield and ship.shieldHealth > 0 then
        Tools.setColor(LevelsInfo.shipColors[ship.number], Tools.glowEffect(100, 200, 15))
        love.graphics.rectangle('fill', SCREEN_WIDTH / 5 * (ship.number - 1),  SCREEN_HEIGHT - BordersLib.BottomBar, (SCREEN_WIDTH / 5) * ship.shieldHealth / ship.shield.health , BordersLib.BottomBar)
      end

      love.graphics.setColor( 255, 255, 255, 255 )
      return true
    else
      x, y = ship.b:getWorldPoints(ship.s:getPoints())
      -- EffectLib.startEffect(1, x, y)
      EffectLib.startEffect(4, x, y)
      ship.f:destroy()
      return false
    end
  end
end

ShipLib.isUnderMaxSpeed = function(ship)
  v_x, v_y = ship.b:getLinearVelocity()
  speedSquared = v_x * v_x + v_y * v_y
  return true--(ship.speedSquared > speedSquared)
end

return ShipLib


-- Stick Examples:
--   local stick_offsetl = {x=200,y=150+yoffset}
--   local stick_offsetr = {x=450,y=150+yoffset}

--   love.graphics.print(love.joystick.getName(j),16,16+yoffset)
--   local lstickx,lsticky = dong.ls(j)
--   love.graphics.setColor(255,255,255,127)
--   love.graphics.line(stick_offsetl.x-100,stick_offsetl.y,stick_offsetl.x+100,stick_offsetl.y)
--   love.graphics.line(stick_offsetl.x,stick_offsetl.y-100,stick_offsetl.x,stick_offsetl.y+100)
--   love.graphics.setColor(255,255,255)
--   love.graphics.circle("line",stick_offsetl.x,stick_offsetl.y,100)
--   love.graphics.circle("fill",stick_offsetl.x+lstickx*100,stick_offsetl.y+lsticky*100,4)
--   love.graphics.print("LS",stick_offsetl.x+lstickx*100,stick_offsetl.y+lsticky*100)

--   local ltrigger = dong.lt(j)
--   love.graphics.rectangle("fill",stick_offsetl.x+100,stick_offsetl.y,16,ltrigger*100)
--   love.graphics.print("LT",stick_offsetl.x+116,stick_offsetl.y+ltrigger*100)

--   local rstickx,rsticky = dong.rs(j)
--   love.graphics.setColor(255,255,255,127)
--   love.graphics.line(stick_offsetr.x-100,stick_offsetr.y,stick_offsetr.x+100,stick_offsetr.y)
--   love.graphics.line(stick_offsetr.x,stick_offsetr.y-100,stick_offsetr.x,stick_offsetr.y+100)
--   love.graphics.setColor(255,255,255)
--   love.graphics.circle("line",stick_offsetr.x,stick_offsetr.y,100)
--   love.graphics.circle("fill",stick_offsetr.x+rstickx*100,stick_offsetr.y+rsticky*100,4)
--   love.graphics.print("RS",stick_offsetr.x+rstickx*100,stick_offsetr.y+rsticky*100)

--   local rtrigger = dong.rt(j)
--   love.graphics.rectangle("fill",stick_offsetr.x+100,stick_offsetr.y,16,rtrigger*100)
--   love.graphics.print("RT",stick_offsetr.x+116,stick_offsetr.y+rtrigger*100)

--   for i,button in ipairs(dong.buttons) do
--     if dong.isDown(j,button) then
--       love.graphics.setColor(255,255,255)
--     else
--       love.graphics.setColor(255,255,255,127)
--     end
--     love.graphics.print(button.." ["..i.."]",16,32+(i-1)*16+yoffset)
--     love.graphics.setColor(255,255,255)
--   end
