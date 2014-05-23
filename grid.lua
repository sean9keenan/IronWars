local GridLib = {} -- public interface


--
-- Grid
--

GridLib.loadGrid = function ()
  fpstimer=0
  xSize = 68 / 1.4
  ySize = 40 / 1.4
  originX = -50
  originY = -50
  gridpoint={}
  multiplier = 30 * 1.4
  startMultiplier = 100
  for a=1,xSize do
    gridpoint[a]={}
    for b=1,ySize do
      gridpoint[a][b]={x=multiplier*a+originX + (a-xSize/2)*startMultiplier,y=multiplier*b+originY+ (b-ySize/2)*startMultiplier,xorig=multiplier*a+originX,yorig=multiplier*b+originY,direction=0,velocity=0,dir2=0,vel2=0}
    end
  end
end

GridLib.updateGrid = function (dt)
  fpstimer=fpstimer+dt
  if fpstimer>1/30 then
    fpstimer=fpstimer-1/30
    local newVelocity = 0
    local newAngle = 0
    local newX = 0
    local newY = 0
    for a=1,xSize do
      for b=1,ySize do
        -- if love.mouse.isDown('l') then
          gridpoint[a][b].velocity = 0
          gridpoint[a][b].direction = 0
          for _, ship in ipairs(ships) do
            newVelocity = 500/math.sqrt(math.abs(ship.b:getY()-gridpoint[a][b].y)^2+math.abs(ship.b:getX()-gridpoint[a][b].x)^2)
            -- newVelocity = 500/math.sqrt((ship.b:getY()-gridpoint[a][b].y)^2+(ship.b:getX()-gridpoint[a][b].x)^2)
            newAngle = math.atan2(ship.b:getY()-gridpoint[a][b].y,ship.b:getX()-gridpoint[a][b].x)
            newX = newVelocity * math.cos(newAngle) + gridpoint[a][b].velocity * math.cos(gridpoint[a][b].direction)
            newY = newVelocity * math.sin(newAngle) + gridpoint[a][b].velocity * math.sin(gridpoint[a][b].direction)
            gridpoint[a][b].direction = math.atan2(newY, newX)
            gridpoint[a][b].velocity = math.sqrt(newY^2 + newX^2)
          end
          if gridpoint[a][b].velocity>4 then gridpoint[a][b].velocity=4 end
        -- elseif gridpoint[a][b].velocity>0 then
        --   -- gridpoint[a][b].velocity=gridpoint[a][b].velocity-0.25
        -- end

        gridpoint[a][b].dir2=math.atan2(gridpoint[a][b].yorig-gridpoint[a][b].y,gridpoint[a][b].xorig-gridpoint[a][b].x)
        gridpoint[a][b].vel2=math.sqrt((gridpoint[a][b].yorig-gridpoint[a][b].y)^2+(gridpoint[a][b].xorig-gridpoint[a][b].x)^2)*0.1

        -- if love.mouse.isDown('l') then
          gridpoint[a][b].x=gridpoint[a][b].x+gridpoint[a][b].velocity*math.cos(gridpoint[a][b].direction)+gridpoint[a][b].vel2*math.cos(gridpoint[a][b].dir2)
          gridpoint[a][b].y=gridpoint[a][b].y+gridpoint[a][b].velocity*math.sin(gridpoint[a][b].direction)+gridpoint[a][b].vel2*math.sin(gridpoint[a][b].dir2)
        -- else
        --   gridpoint[a][b].x=gridpoint[a][b].x+gridpoint[a][b].vel2*math.cos(gridpoint[a][b].dir2)
        --   gridpoint[a][b].y=gridpoint[a][b].y+gridpoint[a][b].vel2*math.sin(gridpoint[a][b].dir2)
        -- end
      end
    end
  end
end

GridLib.drawGrid = function ()
  love.graphics.setBlendMode("additive")
  love.graphics.setColor(100,100,100,20)
  for a=1,xSize do
    for b=1,ySize do
      love.graphics.circle("fill",gridpoint[a][b].x,gridpoint[a][b].y,4)
    end
  end

  if (globalTick < 100) then
    opacity = 40 + 100 - globalTick
  end

  for a=1,(xSize - 1) do
    for b=1,(ySize - 1) do
      love.graphics.setColor(100,100,100+155*(gridpoint[a][b].velocity/10),opacity+70*(gridpoint[a][b].velocity/10))
      love.graphics.line(gridpoint[a][b].x,gridpoint[a][b].y,gridpoint[a+1][b].x,gridpoint[a+1][b].y)
      love.graphics.line(gridpoint[a][b].x,gridpoint[a][b].y,gridpoint[a][b+1].x,gridpoint[a][b+1].y)
    end
  end
  love.graphics.setColor(255,255,255,255)
end

return GridLib

