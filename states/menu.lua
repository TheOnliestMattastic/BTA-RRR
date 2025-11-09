-- states/menu.lua
-- Main menu state: Title screen with start button
local menu = {}
local gameInit = require("core.gameInit")

-- Button state tracking
local btnState = 0  -- 0=normal, 1=hover, 3=pressed
local buttonImg
local buttonQuads = {}
local isPressed = false
local buttonFrameW, buttonFrameH

-- UI and scaling
local fonts = gameInit.registry.fonts
local fontXLarge, fontLarge
local VIRTUAL_WIDTH = 1024
local VIRTUAL_HEIGHT = 768
local menuCanvas
local scale, translateX, translateY

-- Utility: Calculate scaling to fit virtual resolution in window
local function computeScale()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    scale = math.min(w / VIRTUAL_WIDTH, h / VIRTUAL_HEIGHT)
    translateX = (w - VIRTUAL_WIDTH * scale) / 2
    translateY = (h - VIRTUAL_HEIGHT * scale) / 2
end

-- Init: Load button assets and fonts
function menu.load()
	menuCanvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
	local uiConfig = require("config.ui")
	buttonImg = love.graphics.newImage(uiConfig.button_2.path)
	buttonFrameW = uiConfig.button_2.frameW
	buttonFrameH = uiConfig.button_2.frameH
	
	-- Create quads for each button state (normal, hover, pressed)
	for i = 0, 3 do
		buttonQuads[i] = love.graphics.newQuad(i * buttonFrameW, 0, buttonFrameW, buttonFrameH, buttonImg)
	end
	fontXLarge = fonts.fontXLarge
	fontLarge = fonts.fontLarge
end

-- Update: Handle mouse and keyboard input for button state
function menu.update(dt)
	computeScale()

	-- Button dimensions (centered, half screen width/quarter screen height)
	local buttonW = VIRTUAL_WIDTH / 2
	local buttonH = VIRTUAL_HEIGHT / 4
	local buttonX = VIRTUAL_WIDTH / 2 - buttonW / 2
	local buttonY = 3 * VIRTUAL_HEIGHT / 4 - buttonH / 2

	-- Convert screen coords to virtual coords
	local mx, my = love.mouse.getPosition()
	local vx = (mx - translateX) / scale
	local vy = (my - translateY) / scale

	-- Determine button state based on hover and input
	local hovered = vx >= buttonX and vx <= buttonX + buttonW and vy >= buttonY and vy <= buttonY + buttonH
	btnState = hovered and 1 or 0
	if (love.mouse.isDown(1) and hovered) or love.keyboard.isDown("return") then
		btnState = 3
	end
end

-- Draw: Render title and start button
function menu.draw()
	computeScale()

	love.graphics.setCanvas(menuCanvas)
	love.graphics.clear(0.3, 0.4, 0.4)  -- menu background

	-- Draw: Title text
	love.graphics.setFont(fontXLarge)
	local title = "Battle Tactics Arena"
	local textW = fontXLarge:getWidth(title)
	local textX = VIRTUAL_WIDTH / 2 - textW / 2
	local textY = VIRTUAL_HEIGHT / 4
	love.graphics.print(title, textX, textY)

	-- Draw: Start button background with current state
	local buttonW = VIRTUAL_WIDTH / 2
	local buttonH = VIRTUAL_HEIGHT / 4
	local buttonX = VIRTUAL_WIDTH / 2 - buttonW / 2
	local buttonY = 3 * VIRTUAL_HEIGHT / 4 - buttonH / 2
	love.graphics.draw(buttonImg, buttonQuads[btnState], buttonX, buttonY, 0, buttonW / buttonFrameW, buttonH / buttonFrameH)

	-- Draw: Button text with press offset
	love.graphics.setFont(fontLarge)
	local playText = "Play"
	local playW = fontLarge:getWidth(playText)
	local playH = fontLarge:getHeight()
	local playX = buttonX + (buttonW - playW) / 2
	local playY = buttonY + (buttonH - playH) / 2 + (btnState == 3 and 1 or 0)  -- Slight press offset
	love.graphics.print(playText, playX, playY)

	love.graphics.setCanvas()

	-- Draw: Scale and center canvas to window
	if scale and scale > 0 then
		love.graphics.draw(menuCanvas, translateX, translateY, 0, scale, scale)
	end
end

-- Handle window resize
function menu.resize(w, h)
    computeScale()
end

-- Input: Track button press (activates on release)
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

-- Input: Activate button on release (if originally pressed on button)
function menu.mousereleased(x, y, button)
    if button ~= 1 or not isPressed then return end
    computeScale()
    local vx = (x - translateX) / scale
    local vy = (y - translateY) / scale
    local buttonW = VIRTUAL_WIDTH / 2
    local buttonH = VIRTUAL_HEIGHT / 4
    local buttonX = VIRTUAL_WIDTH / 2 - buttonW / 2
    local buttonY = 3 * VIRTUAL_HEIGHT / 4 - buttonH / 2
    
    -- Only activate if released over the button
    if vx >= buttonX and vx <= buttonX + buttonW and vy >= buttonY and vy <= buttonY + buttonH then
        switchState("game")
    end
    isPressed = false
end

-- Input: Handle keyboard shortcuts
function menu.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "return" then
        switchState("game")
    end
end

return menu
