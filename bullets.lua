local BulletsLib = {}

BulletsLib.load = function ()
  bullets = {}
end

BulletsLib.draw = function ()
  new_bullets = {}
  for _, bullet in ipairs(bullets) do
    -- userData = bullet.f:getUserData()
    if bullet.isAlive then
      if bullet.enemy then love.graphics.setColor( 255, 0, 0, 255 ) end
      if LevelsInfo.l[globalLevel].allColor then love.graphics.setColor(LevelsInfo.l[globalLevel].allColor) end
      if bullet.type == 1 then
        love.graphics.circle('fill', bullet.b:getX(), bullet.b:getY(), bullet.s:getRadius())
      else
        love.graphics.polygon('fill', bullet.b:getWorldPoints(bullet.s:getPoints()))
      end
      if bullet.enemy then love.graphics.setColor( 255, 255, 255, 255 ) end
      table.insert(new_bullets, bullet)
    else
      bullet.f:destroy();
    end
  end
  bullets = new_bullets
end

BulletsLib.update = function(dt)
  for i,bullet in ipairs(bullets) do
    if bullet.minSpeed >= 0 then
      v_x, v_y = bullet.b:getLinearVelocity()
      if (v_x^2 + v_y^2 < bullet.minSpeed) then
        bullet.isAlive = false
      end
    end
  end
end

BulletsLib.fire = function(obj, angle, other)
  local type = other.type or 1
  local clipSize = other.clipSize or 1
  local rate = other.rate or 20
  local speed = other.speed or 1000
  local number = other.number or 1
  local angleSeperation = other.angleSeperation or .15

  if isValidFire(other, rate, clipSize) then
    for i=1,number do
      BulletsLib.fireBullet(obj, speed, angle - angleSeperation*(number-1)/2 + angleSeperation*(i-1), other)
      if bullet.audio then
        love.audio.play(bullet.audio)
      end
    end
  end

end

function getXYFromAngle(speed, angle)
  return math.cos(angle) * speed, math.sin(angle) * speed
end

--Only call this function once per fire update!
--This function limits the rate, but if they haven't fired in the "recharge time"
--they will fire immediately
function isValidFire(other, frequency, clipSize)
  other.clipsUnloaded = other.clipsUnloaded or 0
  other.lastFire = other.lastFire or -100000000000
  temp = ((globalTick - other.lastFire) % frequency == 0 or (globalTick - other.lastFire) > frequency)
  if temp then
    other.clipsUnloaded = other.clipsUnloaded + 1
    if other.clipsUnloaded >= clipSize then
      other.lastFire = globalTick
      other.clipsUnloaded = 0
    end
  end
  return temp
end


BulletsLib.closestBullet = function (x, y)
  small_mag = nil
  small_x = nil
  small_y = nil
  for _, bullet in ipairs(bullets) do
    if bullet.s ~= nil then
      bullet_x, bullet_y = bullet.b:getWorldCenter();
      mag_sqrd = (bullet_x - x)^2 + (bullet_y - y)^2
      if (small_mag == nil or small_mag > mag_sqrd) then
        small_mag = mag_sqrd
        v_x, v_y = bullet.b:getLinearVelocity()
        small_x = bullet_x + v_x/10
        small_y = bullet_y + v_y/10
      end
    end
  end
  return small_x, small_y
end


BulletsLib.fireBullet = function(obj, speed, angle, other)
  bullet = {}
    -- set x,y position (400,200) and let it move and hit other objects
    -- ("dynamic")
    bullet.b = love.physics.newBody(world,
                                    obj.b:getX(),
                                    obj.b:getY(),
                                    "dynamic")
    -- make it pretty light
    if LevelsInfo.l[globalLevel].friendlyFire then
      bullet.b:setMass(-1)
      -- bullet.b:setMass(other.mass or 1)
    else
      bullet.b:setMass(other.mass or 1)
    end
    if LevelsInfo.l[globalLevel].randomFiringAngle then
      math.randomseed(os.time() + angle + (lastRand or 0))
      math.random();math.random();
      lastRand = math.random() * 1000;
      angle = math.random() * 2 * math.pi
    end
    -- give it a radius of 50
    other.type = other.type or 1
    if other.type == 1 then
      bullet.s = love.physics.newCircleShape(other.radius or 3)
    else
      if (other.type == 2) then
        bullet.s = love.physics.newRectangleShape(2, 6)
      else
        bullet.s = love.physics.newRectangleShape(2, 80)
      end
      if (other.type == 4) then
        bullet.b:setAngle(angle)
      else
        bullet.b:setAngle(angle + math.pi/2)
      end
    end
    -- connect body to shape
    bullet.f = love.physics.newFixture(bullet.b, bullet.s)
    bullet.f:setRestitution(0)
    -- give it a name, which we'll access later
    bullet.f:setUserData(bullet)
    x, y = getXYFromAngle(speed, angle)
    bullet.b:setLinearVelocity(x, y)
    bullet.b:setBullet(true)

    bullet.b:setLinearDamping(other.linearDamping or 0.00)

    bullet.minSpeed = other.minSpeed or -10

    if (other.enemy) then
      bullet.f:setCategory(3)
      bullet.f:setMask(3) --Makes bullets not collide with other bullets
    else
      bullet.f:setCategory(2)
      if (LevelsInfo.l[globalLevel].friendlyFire) then
        bullet.f:setCategory(obj.number + 3)
      end
      bullet.f:setMask(2) --Makes bullets not collide with other bullets
    end

    bullet.type = other.type
    bullet.object = 'BULLET'
    bullet.isAlive = true     -- Denotes that the bullet is still "live" set in the user Data
    bullet.health = other.health or 1
    if (other.enemy) then
      bullet.damage = other.damage or 10
    else
      bullet.damage = other.damage or 100
    end
    bullet.enemy = other.enemy
    bullet.ship = obj

    if other.audio then
      bullet.audio = love.audio.newSource( "assets/sound/".. other.audio ..".mp3", "static" )
    else
      -- bullet.audio = love.audio.newSource( "assets/sound/Fire_Hispeed.wav", "static" )
    end

    table.insert(bullets, bullet)
end

return BulletsLib