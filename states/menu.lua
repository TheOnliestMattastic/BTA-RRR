-- states/menu.lua
local menu = {}
local btnState = 0  -- Button state: 0=normal, 16=hover, 48=pressed
local buttonImg
local buttonQuads = {}
local wasPressed = false

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
function menu.load(args)
	menuCanvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	buttonImg = love.graphics.newImage("assets/sprites/ui/button.png")
	-- Assume button.png has frames at x=0,16,48 for normal,hover,pressed
	buttonQuads[0] = love.graphics.newQuad(0, 0, 16, 8, buttonImg)
	buttonQuads[16] = love.graphics.newQuad(16, 0, 16, 8, buttonImg)
	buttonQuads[48] = love.graphics.newQuad(48, 0, 16, 8, buttonImg)
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
	btnState = hovered and 16 or 0
	if love.mouse.isDown(1) and hovered then
		btnState = 48
		wasPressed = true
	end
	if wasPressed and not love.mouse.isDown(1) and hovered then
		States.switch("game")
		wasPressed = false
	end
end

-- Draw: Render UI elements
function menu.draw()
	computeScale()

	love.graphics.setCanvas(menuCanvas)
	love.graphics.clear(0.3, 0.4, 0.4)  -- menu background

	-- Fonts
	local fontLarge = love.graphics.newFont("assets/fonts/alagard.ttf", 96)
	local fontMed = love.graphics.newFont("assets/fonts/alagard.ttf", 48)

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
	love.graphics.draw(buttonImg, buttonQuads[btnState], buttonX, buttonY, 0, buttonW / 16, buttonH / 8)

	-- Button text
	love.graphics.setFont(fontMed)
	local playText = "Play"
	local playW = fontMed:getWidth(playText)
	local playH = fontMed:getHeight()
	local playX = buttonX + (buttonW - playW) / 2
	local playY = buttonY + (buttonH - playH) / 2 + (btnState == 48 and 4 or 0)  -- Slight press offset
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

return menu
