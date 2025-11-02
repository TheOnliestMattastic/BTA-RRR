local UIRegistry = require "core.uiRegistry"
local Slab = require "lib.Slab"

local menu = {}
local registry = UIRegistry.new()
registry:loadUI()

local button = love.graphics.newImage("assets/sprites/ui/button.png")


function menu.load(args)
	Slab.Initialize(args)

end

function menu.update(dt)
	local window = {
		AutoSizeWindow = false,
		X = 0,
		Y = 0,
		W = winWidth,
		H = winHeight,
		BgColor = {.3, .4, .4},
		ConstrainPosition = true,
	}
	local textX = winWidth / 2 - (Slab.GetTextWidth("Battle Tactics Arena") / 2)
	local textY = winHeight / 4
	local isHovered = btnState and 16 or 0
	local button = {
		Image = button,
		W = winWidth / 2,
		H = winHeight / 4,
		SubX = isHovered,
		SubY = 0,
		SubW = 16,
		SubH = 8,
	}
	local buttonX = winWidth / 2 - button.W / 2
	local buttonY = 3 * winHeight / 4 - button.H / 2


	Slab.Update(dt)
	Slab.BeginWindow("StartMenu", window)
	Slab.SetCursorPos(textX, textY)
	Slab.Text("Battle Tactics Arena")
	Slab.SetCursorPos(buttonX, buttonY)
	Slab.Image("Start", button)
	btnState = Slab.IsControlHovered()
	if Slab.IsControlClicked() then
		States.switch("game")
	end
	Slab.EndWindow()
end

function menu.draw()
	Slab.Draw()
end

function menu.mousepressed(x, y, button)

end

return menu
