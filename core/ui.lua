local Slab = require "lib.Slab.Slab"

local ui = {}

function ui.initialize(args)
    Slab.Initialize(args)
end

function ui.update(dt)
    Slab.Update(dt)
    Slab.BeginWindow('MyFirstWindow', {Title = "My First Window"})
    Slab.Text("Hello World")
    Slab.EndWindow()
end

function ui.draw()
    Slab.Draw()
end

return ui
