local EnemyLib = {} -- public interface

-- Below this are the array based/global functions for enemies

EnemyLib.load = function()
  enemies = {}
  boss = nil
end

EnemyLib.update = function(dt)
  -- Enemies
  for _, enemy in ipairs(enemies) do
    EnemyLib.updateEnemy(enemy)
  end

  generateEnemies()
end

EnemyLib.draw = function ()
  new_enemies = {}
  for _, enemy in ipairs(enemies) do
    if (EnemyLib.drawEnemy(enemy)) then
      table.insert(new_enemies, enemy)
    end
  end
  enemies = new_enemies
end

function generateEnemies()
  for _, newEnemy in ipairs(LevelsInfo.l[globalLevel].enemies) do
    if (newEnemy.time <= globalTick + 20 and newEnemy.isEntryAnimated == false and not newEnemy.bossSpawn) then
      newEnemy.isEntryAnimated = true
      EffectLib.startEffect(2, newEnemy.x, newEnemy.y)
    end
    if (newEnemy.time <= globalTick and newEnemy.isActivated == false) then
      newEnemy.isActivated = true
      local localEnemy = EnemyLib.newEnemy(newEnemy.x, newEnemy.y, newEnemy.type, 'Enemy', newEnemy)
      table.insert(enemies, localEnemy)
    end
  end

  -- if (globalTick % 100 == 0) then
  --   table.insert(enemies, EnemyLib.newEnemy(400, 400, (globalTick % 300)/100,'Enemy'))
  -- end
end


-- Below this are all of the single Enemy functions, above are array based functions

EnemyLib.randCount = 0
EnemyLib.count = 0

EnemyLib.newEnemy = function(initial_x, initial_y, type, name, others)
  initial_x = initial_x or 0
  initial_y = initial_y or 0
  name = name or 'EnemyLibObject'

  if others.bossSpawn and (boss ~= nil) then
    e_x, e_y = boss.b:getWorldPoints(boss.s:getPoints());
    print ("BOSS SPAWN!")
    initial_x = e_x
    initial_y = e_y
  end

  enemy = {}
  -- set x,y position (400,200) and let it move and hit other objects
  -- ("dynamic")
  enemy.b = love.physics.newBody(world, initial_x, initial_y, "dynamic")
  -- make it pretty light
  enemy.b:setMass(others.mass or 20)
  enemy.s = love.physics.newRectangleShape(others.width or 50, others.height or 30)
  -- connect body to shape
  enemy.f = love.physics.newFixture(enemy.b, enemy.s)
  -- make it bouncy
  enemy.f:setRestitution(0.2)
  -- give it a name, which we'll access later
  enemy.f:setUserData(enemy)
  -- Control the rotation
  enemy.b:setLinearDamping(others.linearDamping or 4.00)
  enemy.b:setAngularDamping(3.50)
  enemy.b:setAngle(0)

  enemy.f:setMask(3)

  enemy.isAlive = true
  enemy.type = type

  enemy.object = 'ENEMY'
  enemy.speedSquared = 500 * 500

  enemy.counter = others.counter or 0
  enemy.randCount = others.startRandCount or 0
  enemy.others = others
  enemy.lastFire = 0
  enemy.health = others.health or 100
  enemy.totalHealth = others.health
  enemy.damage = others.damage or 100
  enemy.shooting = others.shooting
  if enemy.shooting == nil then
    enemy.shooting = {enemy = false}
  else
    enemy.shooting.enemy = true
  end

  EnemyLib.count = EnemyLib.count + 1

  love.audio.play(love.audio.newSource( "assets/sound/enemySpawn.wav", "static" ))

  if others.isBoss then
    boss = enemy
    print ("THE BOSS HAS BEEN SPAWNED WOO")
  end

  return enemy
end

EnemyLib.updateEnemy = function(enemy)

  -- Enemies that move towards the closest ship
  e_x, e_y = enemy.b:getWorldPoints(enemy.s:getPoints());
  s_x, s_y = ShipLib.closestShip(e_x, e_y);
  if enemy.type >= 1 and enemy.type <= 5 then
    speed = enemy.others.speed or 3000
    if (s_x ~= nil) then
      x = e_x - s_x;
      y = e_y - s_y;
      if enemy.type <= 2 or enemy.type == 4 then
        mag = math.sqrt(x*x + y*y);
      else
        mag = enemy.others.approach or 400;
      end
      if enemy.type == 4 then
        speed = speed * -1 * (enemy.others.runMultiplier or 1)
      end
      -- Apply force towards the enemy
      enemy.b:applyForce(-x/mag*speed, -y/mag*speed);
    end
  elseif (enemy.type == 0 or enemy.others.randomRate or enemy.others.randomThrust) then
    math.randomseed(os.time() + EnemyLib.randCount)
    math.random();math.random();math.random();
    enemy.randCount = enemy.randCount + math.random(1, (enemy.others.randomAddition or 1))
    EnemyLib.randCount = EnemyLib.randCount + 1
    if (enemy.randCount % (enemy.others.randomRate or 50) == 0) then
      local speed = enemy.others.randomThrust or 300000
      x = math.random(-speed,speed)
      y = math.random(-speed,speed)
      enemy.b:applyForce(x, y)
    end
  end
  ShipLib.updateAngle(enemy) --Use the Ship Lib to update the angle

  -- Shield
  ItemLib.useShield(enemy.others.shield, enemy)
  ItemLib.shieldUpdate(enemy)

  -- Safe/Run logic
  enemy.counter = enemy.counter - 1
  if (enemy.type == 4) then
    -- Running mode
    if enemy.counter < 0 then
      enemy.counter = enemy.others.timeInSafe or 50
      enemy.type = 5
    end
  elseif (enemy.type == 5) then
    -- Safe Mode
    if enemy.counter < 0 then
      enemy.counter = enemy.others.timeInRun or 50
      enemy.type = 4
    end
    if enemy.shootSinceShot then
      enemy.shootSinceShot = false
      BulletsLib.fire(enemy, 0, enemy.others.shootingIfShot or {rate = 100; mass = 10; number = 50; angleSeperation = math.pi/25; speed = 100000; enemy = true})
    end
  end

  -- Bullet Firing
  if enemy.shooting.enemy then
    local angle = enemy.b:getAngle() + (LevelsInfo.l[globalLevel].firingAngle or 0)
    BulletsLib.fire(enemy, angle - math.pi/2, enemy.shooting)
  end

  -- Bullet Avoidance logic
  if (enemy.type == 2 or enemy.type == 4 or enemy.others.bulletAversion) and globalTick % 1 == 0 then
    bulletAversion = enemy.others.bulletAversion or 200
    b_x, b_y = BulletsLib.closestBullet(e_x, e_y);
    if b_x ~= nil then
      bullet_dst_x = (e_x - b_x)
      bullet_dst_y = (e_y - b_y)
      mag_bullet = bullet_dst_y^2 + bullet_dst_x^2
      if mag_bullet < 50000 then
        mag_bullet = math.sqrt(mag_bullet)
        x_bul = (bullet_dst_x)/mag_bullet*bulletAversion
        y_bul = (bullet_dst_y)/mag_bullet*bulletAversion
        enemy.b:applyLinearImpulse(x_bul, y_bul)
      end
    end
  end

  if not enemy.others.unfreezable then
    enemy.b:setLinearDamping(globalFrozen * (enemy.others.linearDamping or 4.00))
  end

  ShipLib.forceInbounds(enemy)
end

-- This function draws the enemy
EnemyLib.drawEnemy = function(enemy)
  if enemy ~= nil then
    -- enemy = enemy.f:getUserData()
    if enemy.isAlive then

      love.graphics.setLine(2, "smooth")
      local color = enemy.color or LevelsInfo.enemyColors[enemy.type + 1]
      if (enemy.shieldHealth and enemy.shieldHealth > 0) then
        Tools.setColor(color, Tools.glowEffect(128, 255, 50))
      else
        love.graphics.setColor(color)
      end

      if LevelsInfo.l[globalLevel].allColor then love.graphics.setColor(LevelsInfo.l[globalLevel].allColor) end

      love.graphics.polygon((enemy.others.style or 'line'), enemy.b:getWorldPoints(enemy.s:getPoints()))

      if (enemy.others.isBoss) then

        Tools.setColor({255, 0, 0}, 40)
        love.graphics.rectangle('fill', 0,  0, enemy.health / enemy.totalHealth * SCREEN_WIDTH , BordersLib.BottomBar)

      end

      love.graphics.setColor(255, 255, 255, 255)
      return true
    else

      if enemy.health <= 0 and enemy.others and enemy.others.spawnOnDead then
        for i, spawn in ipairs(enemy.others.spawnOnDead) do
          x, y = enemy.b:getWorldPoints(enemy.s:getPoints());
          local localEnemy = EnemyLib.newEnemy(x, y, spawn.type, 'Enemy', spawn)
          table.insert(enemies, localEnemy)
        end
      end
      if enemy.health <= 0 then
        love.audio.play(love.audio.newSource( "assets/sound/Enemy_explode.wav", "static" ))
      end
      x, y = enemy.b:getWorldPoints(enemy.s:getPoints())
      EffectLib.startEffect(1, x, y)
      enemy.f:destroy()
      EnemyLib.count = EnemyLib.count - 1
      return false
    end
  end
end

EnemyLib.isUnderMaxSpeed = function(enemy)
  v_x, v_y = enemy.b:getLinearVelocity()
  speedSquared = v_x * v_x + v_y * v_y
  return true--(enemy.speedSquared > speedSquared)
end

EnemyLib.damage = function(enemy, damage)
  if (enemy.type == 5) then
    if not enemy.others.dontShoot then
      enemy.shootSinceShot = true
    end
  else
    enemy.shieldHealth = enemy.shieldHealth or 0
    enemy.shieldHealth = enemy.shieldHealth - damage
    if enemy.shieldHealth < 0 then
      enemy.health = enemy.health + enemy.shieldHealth
      enemy.shieldHealth = 0
    end
  end
end

return EnemyLib
