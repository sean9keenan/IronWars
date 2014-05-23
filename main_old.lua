function love.load()
  player = {
    grid = {
      x = 256,
      y = 256,
    },
    position = {
      x = 200,
      y = 200,
    },
    width = 32,
    height = 32,
    speed = 1,
    speed_step = 0.01
  }
end

function love.update(dt)
  if love.keyboard.isDown('down') then
    player.grid.y = player.grid.y + player.height
  end
  if love.keyboard.isDown('up') then
    player.grid.y = player.grid.y - player.height
  end
  if love.keyboard.isDown('right') then
    player.grid.x = player.grid.x + player.width
  end
  if love.keyboard.isDown('left') then
    player.grid.x = player.grid.x - player.width
  end
  if love.keyboard.isDown('1') then
    player.speed = player.speed - player.speed_step
  end
  if love.keyboard.isDown('2') then
    player.speed = player.speed + player.speed_step
  end

  player.position.y = player.position.y + ((player.grid.y - player.position.y) * dt * player.speed)
  player.position.x = player.position.x + ((player.grid.x - player.position.x)  * dt * player.speed)
  -- Use these for instantaneous position updating.
  -- player.position.y = player.grid.y
  -- player.position.x = player.grid.x
end

function love.draw()
  love.graphics.rectangle('fill',
                          player.position.x,
                          player.position.y,
                          player.width,
                          player.height)
end
