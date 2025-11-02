-- states/menu.lua
local Slab = require "lib.Slab"

local menu = {}
local btnState = 0  -- Button state: 0=normal, 16=hover, 48=pressed

-- Load: Initialize Slab UI
function menu.load(args)
	Slab.Initialize(args)
end

-- Update: Handle Slab updates and UI logic
function menu.update(dt)
	-- Frame Update: Update Slab UI system
	Slab.Update(dt)

	-- Dimensions: Get current window size
	local winWidth, winHeight = love.graphics.getDimensions()

	-- Window Config: Set up full-screen window
	local window = {
		AutoSizeWindow = false,
		X = 0,
		Y = 0,
		W = winWidth,
		H = winHeight,
		ConstrainPosition = true,
		BgColor = {0.3, 0.4, 0.4},
	}
	Slab.BeginWindow("StartMenu", window)

	-- Fonts: Load and set up fonts
	local font = {
		med = love.graphics.newFont("assets/fonts/alagard.ttf", 48),
		large = love.graphics.newFont("assets/fonts/alagard.ttf", 96),
	}
	Slab.PushFont(font.large)

	-- Title: Render centered title text
	local textX = winWidth / 2 - (Slab.GetTextWidth("Battle Tactics Arena") / 2)
	local textY = winHeight / 4
	Slab.SetCursorPos(textX, textY)
	Slab.Text("Battle Tactics Arena")
	Slab.PopFont()

	-- Button Config: Set up button image properties
	local button = {
		Path = "assets/sprites/ui/button.png",
		W = winWidth / 2,
		H = winHeight / 4,
		SubX = btnState,
		SubY = 0,
		SubW = 16,
		SubH = 8,
	}
	local buttonX = winWidth / 2 - button.W / 2
	local buttonY = 3 * winHeight / 4 - button.H / 2
	Slab.SetCursorPos(buttonX, buttonY)
	Slab.Image("Play", button)

	-- State Update: Determine button state based on interaction
	btnState = Slab.IsControlHovered() and 16 or 0
	if Slab.IsMouseDown(1) and Slab.IsControlHovered() then
		btnState = 48
	end
	if Slab.IsMouseReleased(1) and Slab.IsControlHovered() then
		States.switch("game")
	end

	-- Button Text: Render centered button text with press offset
	Slab.PushFont(font.med)
	local textW = Slab.GetTextWidth("Play")
	local textH = font.med:getHeight()
	local textX = buttonX + (button.W - textW) / 2
	local textY = buttonY + (button.H - textH) / 2 + (btnState == 48 and 32 or 0)
	Slab.SetCursorPos(textX, textY)
	Slab.Text("Play")
	Slab.PopFont()
	Slab.EndWindow()
end

-- Draw: Render Slab UI elements
function menu.draw()
	Slab.Draw()
end

return menu
