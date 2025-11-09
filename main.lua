-- main.lua
local Window = {
	width = 1024,
	height = 768
}

local menu = require "states.menu"
local game = require "states.game"
local currentState = nil

function switchState(stateName)
if stateName == "menu" then
 currentState = menu
		if menu.load then menu.load() end
elseif stateName == "game" then
 currentState = game
 if game.load then game.load() end
	else
		error("Unknown state: " .. tostring(stateName))
	end
end

function love.load()
	-- loading libraries / modules

	-- setting window/resolution info
	love.window.setMode(Window.width, Window.height, {resizable = true, minwidth=1024, minheight=768})
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- setting game States
	switchState("menu")
end

function love.draw()
    --drawing background
    love.graphics.setBackgroundColor(0, 0, 0)
    -- drawing current state
    if currentState and currentState.draw then currentState.draw() end
end

function love.update(dt)
    if currentState and currentState.update then currentState.update(dt) end
end

function love.mousepressed(x, y, button, istouch)
    if currentState and currentState.mousepressed then currentState.mousepressed(x, y, button, istouch) end
end

function love.mousereleased(x, y, button, istouch)
    if currentState and currentState.mousereleased then currentState.mousereleased(x, y, button, istouch) end
end

function love.mousemoved(x, y, dx, dy)
    if currentState and currentState.mousemoved then currentState.mousemoved(x, y, dx, dy) end
end

function love.keypressed(key)
    if currentState and currentState.keypressed then currentState.keypressed(key) end
end

function love.keyreleased(key)
    if currentState and currentState.keyreleased then currentState.keyreleased(key) end
end

function love.resize(w, h)
    Window.width = w
    Window.height = h
    if currentState and currentState.resize then currentState.resize(w, h) end
end
