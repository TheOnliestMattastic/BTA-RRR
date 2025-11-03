-- states/game.lua
local gameInit = require "core.gameInit"
local Slab = require "lib.Slab"
local game = {}
local characters = {}
local charsByName = {}
local map
local state
local chatBox
game.selected = nil
game.message = nil

local VIRTUAL_WIDTH = 1024
local VIRTUAL_HEIGHT = 768
local gameCanvas
local scale, translateX, translateY

local function computeScale()
    scale = math.min(winWidth / VIRTUAL_WIDTH, winHeight / VIRTUAL_HEIGHT)
    translateX = (winWidth - VIRTUAL_WIDTH * scale) / 2
    translateY = (winHeight - VIRTUAL_HEIGHT * scale) / 2
end

-- Initialize dependencies
local registry = gameInit.registry
local tilesets = gameInit.tilesets
local activeFX = gameInit.activeFX
local GameHelpers = gameInit.GameLogic.GameHelpers

function game.load(args)
    -- Build map layout from a tileset spritesheet (use TilesetRegistry)
    -- Get the tileset (tag must match config/tilesets.lua)
    local tilesetTag = "grass"
    local tileset = tilesets:getTileset(tilesetTag)
    local CharactersConfig = gameInit.CharactersConfig
    local Character = gameInit.Character
    local GameState = gameInit.GameState
    local Map = gameInit.Map

    -- Check for tileset.image
    if not tileset or not tileset.image then
        error("Tileset or tileset.image is nil for " .. tilesetTag)
        return
    end

    -- compute how many frames (cols/rows) the tileset contains
    local atlasCols = math.floor(tileset.image:getWidth() / tileset.frameW)
    local atlasRows = math.floor(tileset.image:getHeight() / tileset.frameH)
    if atlasCols == 0 or atlasRows == 0 then
        error("Tileset has zero width or height frames. Check frameW/frameH in config/tilesets.lua for " .. tilesetTag)
        return
    end

    -- choose map size
    local tileSize = 32
    local mapCols = 18
    local mapRows = 16

    -- seed rng once (optional)
    math.randomseed(os.time())

    -- build randomized layout where each cell is a string "col,row" matching Map expectations
    local layout = {}
    for row = 1, mapRows do
        layout[row] = {}
        for col = 1, mapCols do
            local tileCoordinates = math.random(1, atlasCols) .. "," .. math.random(1, atlasRows)
            layout[row][col] = tileCoordinates
        end
    end

    if not tileset then
        error("Tileset not found: " .. tostring(tilesetTag))
    end

     if not tileset then
        error("Tileset is nil after tilesets:getTileset()")
        return
    end

    -- Initialize map and handle potential errors
    map = Map.new(tileSize, layout, tilesets, tilesetTag)
    gameCanvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    state = GameState.new()

    gameInit.init(game, characters, state)

    if not map then
        error("Map is nil after Map.new()")
        return
    end

	Slab.Initialize(args)

    -- Create characters
    local ninjaStats = CharactersConfig.ninjaBlack.stats
    local stats = {}
    for k, v in pairs(ninjaStats) do stats[k] = v end
    stats.team = 0
    local ninjaBlack = Character.new("ninjaBlack", 2, 4, stats, CharactersConfig.ninjaBlack.tags)
    ninjaBlack:setAnimations(registry:getCharacter("ninjaBlack"))
    table.insert(characters, ninjaBlack)
    charsByName.ninjaBlack = ninjaBlack

    local gladiatorStats = CharactersConfig.gladiatorBlue.stats
    stats = {}
    for k, v in pairs(gladiatorStats) do stats[k] = v end
    stats.team = 1
    local gladiatorBlue = Character.new("gladiatorBlue", 4, 6, stats, CharactersConfig.gladiatorBlue.tags)
    gladiatorBlue:setAnimations(registry:getCharacter("gladiatorBlue"))
    table.insert(characters, gladiatorBlue)
    charsByName.gladiatorBlue = gladiatorBlue
    -- etc...
end

function game.update(dt)

    -- Check win/loss and clamp AP --
    state:clampAP()
    state:checkWin()

    -- Update char and anim --
    for _, character in ipairs(characters) do
        if character.update then pcall(character.update, character, dt) end
    end

    -- Update FX--
    for _, activeEffect in ipairs(activeFX) do
    	if activeEffect.fx and activeEffect.fx.anim and activeEffect.fx.anim.update then pcall(activeEffect.fx.anim.update, activeEffect.fx.anim, dt) end
    end

    -- Remove completed FX
    local toRemove = {}
    for i, activeEffect in ipairs(activeFX) do
        if activeEffect.fx.anim.status == "paused" then
            table.insert(toRemove, 1, i)
        end
    end
    for _, i in ipairs(toRemove) do
        table.remove(activeFX, i)
    end

	-- Compute scaling for virtual screen
	computeScale()

	-- Override mouse position for Slab to use virtual coords
	local originalGetPosition = love.mouse.getPosition
	love.mouse.getPosition = function()
		local mx, my = originalGetPosition()
		return (mx - translateX) / scale, (my - translateY) / scale
	end

	Slab.Update(dt)


	-- Restore
	love.mouse.getPosition = originalGetPosition

	-- Fonts: Load and set up fonts
	local font = {
		smaller = love.graphics.newFont("assets/fonts/alagard.ttf", 24),
		small = love.graphics.newFont("assets/fonts/alagard.ttf", 36),
		med = love.graphics.newFont("assets/fonts/alagard.ttf", 48),
		large = love.graphics.newFont("assets/fonts/alagard.ttf", 96),
	}

	-- Dimensions: Use virtual size
	local winWidth, winHeight = VIRTUAL_WIDTH, VIRTUAL_HEIGHT

	-- Turn Tracker
	local window = {
		AutoSizeWindow = false,
		AllowResize = false,
		AllowFocus = false,
		NoOutline = true,
		X = map.tileSize,
		Y = map.tileSize,
		W = winWidth / 3,
		H = 3 * winHeight / 4 - map.tileSize * 2,
		ConstrainPosition = true,
		BgColor = {0, 0, 0, 0},
	}
	Slab.PushFont(font.smaller)
	Slab.BeginWindow("Turn Order", window)
	Slab.BeginLayout("Order List")

	Slab.Image("Tenth Character", {Path = "assets/sprites/chars/knightGold/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.Image("Ninth Character", {Path = "assets/sprites/chars/ninjaMasked/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.Image("Eighth Character", {Path = "assets/sprites/chars/tenguRed/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.Image("Seventh Character", {Path = "assets/sprites/chars/samuraiArmoredBlue/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.Image("Sixth Character", {Path = "assets/sprites/chars/mageBlack/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.Image("Fifth Character", {Path = "assets/sprites/chars/lionBro/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.Image("Fourth Character", {Path = "assets/sprites/chars/samuraiRed/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.Image("Third Character", {Path = "assets/sprites/chars/fighterBlue/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.Image("Second Character", {Path = "assets/sprites/chars/gladiatorBlue/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.Image("Next Character", {Path = "assets/sprites/chars/ninjaBlack/Faceset.png", Scale = 2.5})
	Slab.SameLine()
	Slab.Text("Character Name")

	Slab.EndLayout()
	Slab.EndWindow()
	Slab.PopFont()

	-- Character Menu
	window = {
		AutoSizeWindow = false,
		AllowResize = false,
		AllowFocus = false,
		X = 0,
		Y = 3 * winHeight / 4,
		W = winWidth,
		H = winHeight / 4,
		ConstrainPosition = true,
		BgColor = {0, 0, 0, 0},
		NoOutline = true,
	}
	local layout = {
		Columns = 2,
		AlignX = "center",
		AlignRowY = "center"
	}
	Slab.PushFont(font.small)
	Slab.BeginWindow("Character Menu", window)
	Slab.BeginLayout("Character Card", layout)
	Slab.SetLayoutColumn(1)
	Slab.Text("Character Stats")
	Slab.SetLayoutColumn(2)
	Slab.Text("Target Stats")
	Slab.EndLayout()
	Slab.EndWindow()
	Slab.PopFont()



    -- Draw message overlay
	window = {
		X = winWidth / 2,
		Y = 0,
		AllowResize = false,
		BgColor = {0, 0, 0, 0},
		NoOutline = true,
	}
    if game.message then
        Slab.PushFont(font.smaller)
        Slab.BeginWindow('MessageOverlay', window)
        Slab.Text(game.message)
        Slab.EndWindow()
        Slab.PopFont()
    end


end

function game.draw()

    computeScale()

-- Draw to canvas
love.graphics.setCanvas(gameCanvas)
love.graphics.clear(0.3, 0.4, 0.4)  -- game background

-- Draw map --
local mx, my = love.mouse.getPosition()
    -- Adjust mouse for virtual coords
local vmx = (mx - translateX) / scale
local vmy = (my - translateY) / scale
map:draw(vmx, vmy)

-- Highlight movement range for selected character --
map:highlightMovementRange(game.selected, function(col, row) return GameHelpers.findCharacterAt(col, row) ~= nil end)

for _, character in ipairs(characters) do
-- Character:draw will handle anim drawing if character has anim/sheet set
    pcall(function() character:draw(map.tileSize, map.offsetX, map.offsetY) end)
        -- highlight selected
    if game.selected == character then
love.graphics.setColor(1, 1, 0, 0.5)
    love.graphics.rectangle("line", character.x * map.tileSize + map.offsetX, character.y * map.tileSize + map.offsetY, map.tileSize, map.tileSize)
        love.graphics.setColor(1,1,1,1)
       end
    end

    for _,activeEffect in ipairs(activeFX) do
        activeEffect.fx.anim:draw(activeEffect.fx.image, activeEffect.x * map.tileSize + map.offsetX, activeEffect.y * map.tileSize + map.offsetY)
    end

    -- Draw Slab UI to canvas
    -- Mouse already overridden in update, but for draw, override again if needed
    local originalGetPosition2 = love.mouse.getPosition
    love.mouse.getPosition = function()
        local mx, my = originalGetPosition2()
        return (mx - translateX) / scale, (my - translateY) / scale
    end

    Slab.Draw()

    love.mouse.getPosition = originalGetPosition2

    love.graphics.setCanvas()

    -- Draw scaled canvas centered
    if scale and scale > 0 then
        love.graphics.draw(gameCanvas, translateX, translateY, 0, scale, scale)
    end
end

function game.mousepressed(x, y, button)
    if state.over then return end
    computeScale()
    if button ~= 1 or scale <= 0 then return end

    -- Convert to virtual coordinates
    local vx = (x - translateX) / scale
    local vy = (y - translateY) / scale
    local hovered = map:getHoveredTile(vx, vy)
    if not hovered then return end
    local col, row = hovered[1], hovered[2]

    local clicked = GameHelpers.findCharacterAt(col, row)

    if GameHelpers.handleSelection(clicked) then return end

    -- If clicked same as selected -> deselect
    if clicked == game.selected then
        game.selected = nil
        game.message = nil
        return
    end

    -- If clicked an ally -> select them
    if clicked and game.selected:isAllyOf(clicked) then
        game.selected = clicked
        game.message = "Selected buddy: " .. tostring(clicked.class or "unit")
        return
    end

    -- At this point, either clicked is enemy (attack target) or empty tile

    -- Move selected character to empty tile
    if not clicked then
        local dist = math.max(math.abs(col - game.selected.x), math.abs(row - game.selected.y))
        if dist <= game.selected.spd then
            game.selected:moveTo(col, row)
            game.message = "Moving to (" .. col .. ", " .. row .. ")"
        else
            game.message = "Out of movement range"
        end
        return
    end

    -- Check if selected can attack target
    local canAttack, reason = game.selected:canBasicAttack(clicked)
    if not canAttack then
        game.message = reason or "Cannot attack"
        return
    end

    -- Perform attack
    GameHelpers.performAttack(game.selected, clicked)
end

return game
