local Slab = require "lib.Slab.Slab"

local ui = {}
local options = {
	ConstrainPosition = false,
	AutoSizeWindow = false,
	X = 0,
	Y = 0,
	W = winWidth,
	H = winHeight,
}

function ui.initialize(args)
    Slab.Initialize(args)
end

function ui.update(dt)
    options.W = winWidth
    options.H = winHeight
    Slab.Update(dt)
    Slab.BeginWindow('Background', options)
    Slab.Text("Hello")
    Slab.EndWindow()
end

function ui.draw()
    Slab.Draw()
end

return ui
