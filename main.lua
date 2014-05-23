LevelsInfo = require 'levels'
ShipLib = require 'ship'
EnemyLib = require 'enemy'
EffectLib = require 'effects'
BordersLib = require 'borders'
BulletsLib = require 'bullets'
ItemLib = require 'item'
GridLib = require 'grid'
Tools = require 'tools'
dong = require("dong")  --https://github.com/josefnpat/dong
-- profiler = require('profiler')

function love.load()
  -- Gravity is being set to 0 in the x direction and 0 in the y direction.
  --
  -- profiler.start()
  if (true) then
    love.graphics.setMode(0, 0, true)
    love.graphics.setMode(love.graphics.getWidth(), love.graphics.getHeight(), true)
  else
    love.graphics.setMode(3*SCREEN_WIDTH/4, 3*SCREEN_HEIGHT/4, false)
  end

  scaleX = love.graphics.getWidth() / SCREEN_WIDTH
  scaleY = love.graphics.getHeight() / SCREEN_HEIGHT

  print (love.graphics.getWidth())
  print (love.graphics.getHeight())
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(beginContact)

  savedState = {}
  -- BordersLib.loadBlock()

  terminatedSounds = {love.audio.newSource( "assets/sound/dead/Terminated.mp3", "static" );
                      love.audio.newSource( "assets/sound/dead/awful.mp3", "static" );
                      love.audio.newSource( "assets/sound/dead/dead.mp3", "static" );
                      love.audio.newSource( "assets/sound/dead/dismantle.mp3", "static" );
                      love.audio.newSource( "assets/sound/dead/tko.mp3", "static" );}

  LevelsInfo.resetLevelsProgress()
  BordersLib.loadBorder()
  BulletsLib.load()
  GridLib.loadGrid()
  EffectLib.init()
  ShipLib.load()
  EnemyLib.load()
  ItemLib.load()


  font = love.graphics.newFont(80)
  font2 = love.graphics.newFont(50)
  font3 = love.graphics.newFont(25)
  love.graphics.setFont(font)
  timesDied = 0

  endGameTick = -1
end

function trackAndPrint(p)
  print (p..(os.clock()-lastClock))
  lastClock = os.clock()
end

function love.update(dt)
  -- Requisite for physics to work
  lastClock = os.clock()
  world:update(dt)
  trackAndPrint("world:update(dt)")
  GridLib.updateGrid(dt)
  trackAndPrint("GridLib.updateGrid(dt)")
  EffectLib.update(dt)
  trackAndPrint("EffectLib.update(dt)")
  ShipLib.update(dt)
  trackAndPrint("ShipLib.update(dt)")
  EnemyLib.update(dt)
  trackAndPrint("EnemyLib.update(dt)")
  ItemLib.update(dt)
  BordersLib.update(dt)
  BulletsLib.update(dt)
  audioUpdates()
  trackAndPrint("ItemLib.update(dt)")
  -- if globalTick % 1 == 0 then
  --   collectgarbage()
  -- end

  updateLevel()

  -- print(collectgarbage("count"))
  collectgarbage()
end

function love.draw()

  love.graphics.scale(scaleX, scaleY)

  -- lastClock = os.clock()
  EffectLib.draw()
  trackAndPrint("EffectLib.draw()")
  GridLib.drawGrid()
  trackAndPrint("GridLib.drawGrid()")
  BordersLib.draw()
  trackAndPrint("BordersLib.draw()")
  ShipLib.draw()
  trackAndPrint("ShipLib.draw()")
  EnemyLib.draw()
  trackAndPrint("EnemyLib.draw()")
  ItemLib.draw()
  trackAndPrint("ItemLib.draw()")
  BulletsLib.draw()
  trackAndPrint("BulletsLib.draw()")


  local minAlive = LevelsInfo.l[globalLevel].minAlive or 1

  if ((ShipLib.shipsLeft() < minAlive) and not gameWon) then
    endGame()
  elseif ((EnemyLib.count == 0 and globalTick > LevelsInfo.l[globalLevel].minLevelLength) or gameWon) then
    nextLevel()
  end
  printLevelStart()

  globalTick = globalTick + 1

  if globalTick > 10 then
    -- profiler.stop()
  end
end

function beginContact(f1, f2, coll)
  a = f1:getUserData() or {}
  b = f2:getUserData() or {}
  contactHandler(a, b);
  if (a.object ~= b.object) then contactHandler(b, a) end
end

function contactHandler(a, b)
  local friendlyFire = LevelsInfo.l[globalLevel].friendlyFire or false
  if (b.object == 'BULLET') then
    if (a.object == 'ENEMY' or a.object == 'SHIP') then
      if b.ship.number ~= (a.number or 0) then
        hit (a, b)
      end
    else
      b.isAlive = false
    end
  end

  if (b.object == 'SHIP' and a.object == 'ENEMY') then
    hit(a, b)
  end

  if (b.object == 'SHIP' and a.object == 'SHIP') then
    b.weld = a
  end

  if (a.object == 'ITEM' and b.object == 'SHIP') then
    ItemLib.attemptItemPickup(a, b)
  end

end

function hit(a, b)
  if (a.object and b.object) then
    EnemyLib.damage(a, b.damage)
    if (a.health <= 0) then a.isAlive = false end
    EnemyLib.damage(b, a.damage)
    -- b.health = b.health - a.damage
    if (b.health <= 0) then b.isAlive = false end
  end
end

function killFicture ( f )
    a = f:getUserData() or {}
    if b.object == "ENEMY" or b.object == "SHIP"then
      a.isAlive = false
    end
    if ((b.object == "ITEM") and (not gameWon) and b.ship ~= nil) then
      a.isAlive = false
    end
    return true
end

function loadLevel()
  endGameTick  = endGameTick + 1
  if endGameTick == 50 then
    for i,enemy in ipairs(enemies) do
      enemy.isAlive = false
    end
    for i, item in ipairs(items) do
      if item.ship ~= nil or not gameWon then
        item.isAlive = false
      else
        if gameWon and LevelsInfo.l[globalLevel + 1] ~= nil then
          if not LevelsInfo.l[globalLevel + 1].items then LevelsInfo.l[globalLevel + 1].items = {} end
          item.other.time = 0
          item.other.x = item.b:getX()
          item.other.y = item.b:getY()
          item.isAlive = false
          table.insert(LevelsInfo.l[globalLevel + 1].items, item.other)
        end
      end
    end
    for i,ship in ipairs(ships) do
      ship.isAlive = false
    end
    for i,bullet in ipairs(bullets) do
      bullet.isAlive = false
    end
    globalTick = -2
  end
  if endGameTick > 50 then globalTick = -2 end
  if endGameTick > 100 then
    if gameWon then
      savedState = {}
      for _, ship in ipairs(ships) do
        table.insert(savedState, ship)
      end
      for _, ship in ipairs(deadShips) do
        table.insert(savedState, ship)
      end
    end
    for i,enemy in ipairs(enemies) do
      enemy.f:destroy();
      enemy = nil
    end
    for i, item in ipairs(items) do
      if item.ship ~= nil or not gameWon then
        item.f:destroy();
        item = nil
      end
    end
    for i,ship in ipairs(ships) do
      ship.f:destroy();
      ship = nil
    end
    for i,bullet in ipairs(bullets) do
      bullet.f:destroy();
      bullet = {}
    end
    bullets = {}
    enemies = {}
    ships = {}
    deadShips = {}
    extraSystems = {}
    world:destroy()
    world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(beginContact)
    BordersLib.loadBorder()
    endGameTick = -1
    LevelsInfo.resetLevelsProgress()
    globalTick = -2
    GridLib.loadGrid()
    if gameWon then globalLevel = globalLevel + 1 end
    ShipLib.makeNewShips()
    gameWon = false
  end
end

function endGame()
  gameWon = false
  if endGameTick == 0 then

    math.randomseed(os.time() + globalTick)
    math.random();math.random();
    local soundIndex = math.floor(math.random() * 9 + 1)
    if soundIndex > 5 then soundIndex = 1 end
    love.audio.play(terminatedSounds[soundIndex])
    timesDied = (timesDied or 0) + 1
  end
  printMessage("GAME OVER", SCREEN_HEIGHT - 100)
  love.graphics.setFont(font2)
  printMessage("Restoring from save point...", SCREEN_HEIGHT + 100)
  love.graphics.setFont(font3)
  if timesDied > 60 then
    printMessage("Wow, you were bad at this game "..timesDied.." times", SCREEN_HEIGHT + 200)
  elseif timesDied > 30 then
    printMessage("Really??!? You have died: "..timesDied.." times", SCREEN_HEIGHT + 200)
  elseif timesDied > 10 then
    printMessage("You have died: "..timesDied.." times", SCREEN_HEIGHT + 200)
  end
  love.graphics.setFont(font)
  loadLevel()
end

function nextLevel()
  if (LevelsInfo.l[globalLevel + 1] == nil and not gameWon) then
    printMessage(LevelsInfo.winTopMessage, SCREEN_HEIGHT - 100)
    love.graphics.setFont(font2)
    printMessage(LevelsInfo.winBottomMessage, SCREEN_HEIGHT + 100)
    love.graphics.setFont(font3)
    if timesDied > 60 then
      printMessage("Congratulations! You only died... WAIT, YOU DIED "..timesDied.." times?! Nevermind. Sigh.", SCREEN_HEIGHT + 200)
    end
    love.graphics.setFont(font)
  else
    gameWon = true
    printLevel(globalLevel + 1)
    loadLevel()
  end
end

function printMessage(message, inheight)
  width = love.graphics.getFont():getWidth(message)
  height = love.graphics.getFont():getHeight()
  love.graphics.print(message, (SCREEN_WIDTH - width)/2, (inheight - height)/2)
end

function printLevelStart()
  if (globalTick < 85 and globalTick > 0) then
    printLevel(globalLevel)
  end
end

function printLevel(level)
  printMessage("Level " .. (level), SCREEN_HEIGHT - 100)
  love.graphics.setFont(font2)
  if LevelsInfo.l[level] then
    printMessage(LevelsInfo.l[level].levelMessage, SCREEN_HEIGHT + 100)
  end
  love.graphics.setFont(font)
end

function updateLevel()
  for i=1,10 do
    local number = i % 10
    if (love.keyboard.isDown(number)) then
      globalLevel = i - 1
      nextLevel()
    end
  end
  keyLevelMap = {"z"; "x"}
  for level,key in ipairs(keyLevelMap) do
    if (love.keyboard.isDown(key)) then
      globalLevel = level + 9
      nextLevel()
    end
  end
  for _, item in ipairs(LevelsInfo.dropItems) do
    if (love.keyboard.isDown(item.keyboard) and globalTick > 0) then
      itemCopy = Tools.clone(item)
      table.insert(items, ItemLib.newItem(itemCopy.x, itemCopy.y, itemCopy, itemCopy.button, 'Item'))
    end
  end
end

function audioUpdates()
  if LevelsInfo.l[globalLevel].audio then
    for i,file in ipairs(LevelsInfo.l[globalLevel].audio) do
      if (file.time == globalTick and endGameTick == -1 ) then
        love.audio.play(love.audio.newSource( "assets/sound/".. file.source ..".mp3", "static" ))
      end
    end
  end
end