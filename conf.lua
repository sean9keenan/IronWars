-- Automatically 'require'd by Löve; all globals are available
-- to the main.lua file
-- SCREEN_WIDTH = 1024
-- SCREEN_HEIGHT = 768
BUFFER = 0
SCREEN_WIDTH = 1920 - BUFFER
SCREEN_HEIGHT = 1080 - BUFFER


globalTick = 0
globalLevel = 1

function love.conf(t)
	t.title = "Ultimate Iron wars"
  -- t.screen.width = SCREEN_WIDTH + BUFFER
  -- t.screen.height = SCREEN_HEIGHT + BUFFER
  -- love.window.setMode(0, 0, {fullscreen=true})
end

