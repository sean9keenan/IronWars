local BordersLib = {}

BordersLib.walls = {}

BordersLib.BottomBar = 50

BordersLib.loadBlock = function ()

	block = {}
	-- 'static' makes it not move
	block.b = love.physics.newBody(world, 400, 400, 'static')
	-- set size to 200,50 (x,y)
	block.s = love.physics.newRectangleShape(200, 50)
	-- add to the world
	block.f = love.physics.newFixture(block.b, block.s)
	block.f:setUserData('Block')
end

BordersLib.loadWallSegment = function(def)
  local wall = {}
  if #def.pairs == 2 then
    wall.s = love.physics.newChainShape(false,def.pairs[1].x, def.pairs[1].y, def.pairs[2].x, def.pairs[2].y)
  elseif #def.pairs == 3 then
    wall.s = love.physics.newChainShape(false,def.pairs[1].x, def.pairs[1].y, def.pairs[2].x, def.pairs[2].y, def.pairs[3].x, def.pairs[3].y)
  elseif #def.pairs == 4 then
    wall.s = love.physics.newChainShape(false,def.pairs[1].x, def.pairs[1].y, def.pairs[2].x, def.pairs[2].y, def.pairs[3].x, def.pairs[3].y, def.pairs[4].x, def.pairs[4].y)
  elseif #def.pairs == 5 then
    wall.s = love.physics.newChainShape(false,def.pairs[1].x, def.pairs[1].y, def.pairs[2].x, def.pairs[2].y, def.pairs[3].x, def.pairs[3].y, def.pairs[4].x, def.pairs[4].y, def.pairs[5].x, def.pairs[5].y)
  else
    return false
  end
  wall.b = love.physics.newBody(world, def.x, def.y, def.type or 'static')

  wall.f = love.physics.newFixture(wall.b, wall.s)
  wall.f:setRestitution(0)
  wall.counter = globalTick
  wall.display = true
  wall.doHide = def.doHide or false
  wall.timeDisplay = def.timeDisplay
  wall.timeHide = def.timeHide
  wall.b:setMass(def.mass or 20)
  wall.b:setBullet(true)
  wall.b:setLinearDamping(def.linearDamping or 4.00)
  wall.other = def
  -- wall.b:setAngularDamping(3.50)

  if (def.enemyTransparent) then
    wall.f:setCategory(3)
  end
  if (def.enemyBulletTransparent) then
    wall.f:setMask(3)
  end
  if (def.friendlyBulletTransparent) then
    wall.f:setCategory(2)
  end
  if (def.friendlyTransparent) then
    wall.f:setCategory(8)
  end
  if (def.movingTransparent) then
    wall.f:setMask(1)
  end
  wall.reflect = true
  table.insert(BordersLib.walls, wall)
  return wall
end


BordersLib.loadBorder = function()
  border = {}
  border.b = love.physics.newBody(world, 1, 1, 'static')
  border.s = love.physics.newChainShape(true,
                                        -- Upper left corner
                                        BUFFER/2, BUFFER/2,
                                        -- Upper right corner
                                        SCREEN_WIDTH - 1 + BUFFER/2, BUFFER/2,
                                        -- Lower right corner
                                        SCREEN_WIDTH - 1 + BUFFER/2, SCREEN_HEIGHT - 1 + BUFFER/2 - BordersLib.BottomBar,
                                        -- Lower left corner
                                        BUFFER/2, SCREEN_HEIGHT - 1 + BUFFER/2 - BordersLib.BottomBar,
                                        -- Back to the upper left, but cannot
                                        -- intersect with the other corner.
                                        BUFFER/2, 1 + BUFFER/2)
    border.f = love.physics.newFixture(border.b, border.s)
    border.f:setRestitution(0)
end

BordersLib.update = function(dt)
  local newWalls = {}
  for i,wall in ipairs(BordersLib.walls) do
    if globalTick >= 0 and globalTick < (wall.other.destroyTime or 10000000000000) then
      if wall.doHide then
        -- Display/Hide logic
        wall.counter = wall.counter - 1
        if (wall.display) then
          -- Display mode
          if wall.counter < 0 then
            wall.counter = wall.timeHide or 100
            wall.display = false
          end
        else
          -- Hide Mode
          if wall.counter < 0 then
            wall.counter = wall.timeDisplay or 100
            wall.display = true
          end
        end
      end
      table.insert(newWalls, wall)
    else
      wall.defined = false
      wall.f:destroy()
    end
  end
  BordersLib.walls = newWalls

  if (LevelsInfo.l[globalLevel].walls) then
    for i,wallDef in ipairs(LevelsInfo.l[globalLevel].walls) do
      if globalTick < 0 then
        wallDef.defined = false
      end
      if (globalTick > wallDef.time and not wallDef.defined) then
        BordersLib.loadWallSegment(wallDef)
        wallDef.defined = true
      end
    end
  end
end

BordersLib.draw = function(dt)
  -- love.graphics.polygon('line', block.b:getWorldPoints(block.s:getPoints()))
  love.graphics.setLine(2, "smooth")
  love.graphics.polygon('line', border.b:getWorldPoints(border.s:getPoints()))
  for i,wall in ipairs(BordersLib.walls) do
    if wall.display then
      love.graphics.line(wall.b:getWorldPoints(wall.s:getPoints()))
    end
  end
end


return BordersLib