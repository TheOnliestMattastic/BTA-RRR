-- states/menu.lua
local menu = {}
local ui = require("config.ui")
local btnState = 0  -- Button state: 0=normal, 1=hover, 3=pressed
local buttonImg
local buttonQuads = {}
local isPressed = false
local buttonFrameW, buttonFrameH
local fontLarge, fontMed

local VIRTUAL_WIDTH = 1024
local VIRTUAL_HEIGHT = 768
local menuCanvas
local scale, translateX, translateY

local function computeScale()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    scale = math.min(w / VIRTUAL_WIDTH, h / VIRTUAL_HEIGHT)
    translateX = (w - VIRTUAL_WIDTH * scale) / 2
    translateY = (h - VIRTUAL_HEIGHT * scale) / 2
end

-- Load: Initialize UI
function menu.load()
	menuCanvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	buttonImg = love.graphics.newImage(ui.button_2.path)
	buttonFrameW = ui.button_2.frameW
	buttonFrameH = ui.button_2.frameH
	-- Create quads for button frames (assuming horizontal layout)
	for i = 0, 3 do
		buttonQuads[i] = love.graphics.newQuad(i * buttonFrameW, 0, buttonFrameW, buttonFrameH, buttonImg)
	end
	fontLarge = love.graphics.newFont(ui.fontLarge.path, ui.fontLarge.size)
	fontMed = love.graphics.newFont(ui.fontMed.path, ui.fontMed.size)
end

-- Update: Handle UI logic
function menu.update(dt)
	computeScale()

	-- Dimensions: Use virtual size
	local winWidth, winHeight = VIRTUAL_WIDTH, VIRTUAL_HEIGHT

	-- Button properties
	local buttonW = winWidth / 2
	local buttonH = winHeight / 4
	local buttonX = winWidth / 2 - buttonW / 2
	local buttonY = 3 * winHeight / 4 - buttonH / 2

	-- Check mouse position in virtual coords
	local mx, my = love.mouse.getPosition()
	local vx = (mx - translateX) / scale
	local vy = (my - translateY) / scale

	-- Determine button state
	local hovered = vx >= buttonX and vx <= buttonX + buttonW and vy >= buttonY and vy <= buttonY + buttonH
	btnState = hovered and 1 or 0
	if love.mouse.isDown(1) and hovered or love.keyboard.isDown("return") then
		btnState = 3
	end
end

-- Draw: Render UI elements
function menu.draw()
	computeScale()

	love.graphics.setCanvas(menuCanvas)
	love.graphics.clear(0.3, 0.4, 0.4)  -- menu background

	-- Title
	love.graphics.setFont(fontLarge)
	local title = "Battle Tactics Arena"
	local textW = fontLarge:getWidth(title)
	local textX = VIRTUAL_WIDTH / 2 - textW / 2
	local textY = VIRTUAL_HEIGHT / 4
	love.graphics.print(title, textX, textY)

	-- Button
	local buttonW = VIRTUAL_WIDTH / 2
	local buttonH = VIRTUAL_HEIGHT / 4
	local buttonX = VIRTUAL_WIDTH / 2 - buttonW / 2
	local buttonY = 3 * VIRTUAL_HEIGHT / 4 - buttonH / 2

	-- Draw button background (stretched quad)
	love.graphics.draw(buttonImg, buttonQuads[btnState], buttonX, buttonY, 0, buttonW / buttonFrameW, buttonH / buttonFrameH)

	-- Button text
	love.graphics.setFont(fontMed)
	local playText = "Play"
	local playW = fontMed:getWidth(playText)
	local playH = fontMed:getHeight()
	local playX = buttonX + (buttonW - playW) / 2
	local playY = buttonY + (buttonH - playH) / 2 + (btnState == 3 and 1 or 0)  -- Slight press offset
	love.graphics.print(playText, playX, playY)

	love.graphics.setCanvas()

	-- Draw scaled canvas centered
	if scale and scale > 0 then
		love.graphics.draw(menuCanvas, translateX, translateY, 0, scale, scale)
	end
end

function menu.resize(w, h)
    computeScale()
end

function menu.mousepressed(x, y, button)
    if button ~= 1 then return end
    computeScale()
    local vx = (x - translateX) / scale
    local vy = (y - translateY) / scale
    local buttonW = VIRTUAL_WIDTH / 2
    local buttonH = VIRTUAL_HEIGHT / 4
    local buttonX = VIRTUAL_WIDTH / 2 - buttonW / 2
    local buttonY = 3 * VIRTUAL_HEIGHT / 4 - buttonH / 2
    if vx >= buttonX and vx <= buttonX + buttonW and vy >= buttonY and vy <= buttonY + buttonH then
        isPressed = true
    end
end

function menu.mousereleased(x, y, button)
    if button ~= 1 or not isPressed then return end
    computeScale()
    local vx = (x - translateX) / scale
    local vy = (y - translateY) / scale
    local buttonW = VIRTUAL_WIDTH / 2
    local buttonH = VIRTUAL_HEIGHT / 4
    local buttonX = VIRTUAL_WIDTH / 2 - buttonW / 2
    local buttonY = 3 * VIRTUAL_HEIGHT / 4 - buttonH / 2
    if vx >= buttonX and vx <= buttonX + buttonW and vy >= buttonY and vy <= buttonY + buttonH then
        switchState("game")
    end
    isPressed = false
end

function menu.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end	-- Determine button state
    if key == "return" then
        switchState("game")
    end
end

return menu
