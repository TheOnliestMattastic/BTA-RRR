-- states/game.lua
local gameInit = require "core.gameInit"

local game = {}
local characters = {}
local charsByName = {}
local map
local state
game.selected = nil
game.message = nil

local VIRTUAL_WIDTH = 1024
local VIRTUAL_HEIGHT = 768
local gameCanvas
local scale, translateX, translateY

local function computeScale()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    scale = math.min(w / VIRTUAL_WIDTH, h / VIRTUAL_HEIGHT)
    translateX = (w - VIRTUAL_WIDTH * scale) / 2
    translateY = (h - VIRTUAL_HEIGHT * scale) / 2
end

-- Initialize dependencies
local registry = gameInit.registry
local tilesets = gameInit.tilesets
local activeFX = gameInit.activeFX
local GameHelpers = gameInit.GameLogic.GameHelpers

function game.load()
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

end

function game.draw()

    computeScale()

	-- Draw to canvas
	love.graphics.setCanvas(gameCanvas)
	love.graphics.clear(0.3, 0.4, 0.4)  -- game background

	-- Draw map --
	local mx, my = love.mouse.getPosition()
	local vmx = (mx - translateX) / scale
	local vmy = (my - translateY) / scale
	map:draw(vmx, vmy)

	-- Highlight movement range for selected character --
	map:highlightMovementRange(game.selected, function(col, row) return GameHelpers.findCharacterAt(col, row) ~= nil end)

	for _, character in ipairs(characters) do
		-- Character:draw will handle anim drawing if character has anim/sheet set
		pcall(function() character:draw(map.tileSize, map.offsetX, map.offsetY) end)
	end

    for _,activeEffect in ipairs(activeFX) do
        activeEffect.fx.anim:draw(activeEffect.fx.image, activeEffect.x * map.tileSize + map.offsetX, activeEffect.y * map.tileSize + map.offsetY)
    end

	-- Fonts: Load and set up fonts
	local font = {
		smaller = love.graphics.newFont("assets/fonts/alagard.ttf", 24),
		small = love.graphics.newFont("assets/fonts/alagard.ttf", 36),
		med = love.graphics.newFont("assets/fonts/alagard.ttf", 48),
		large = love.graphics.newFont("assets/fonts/alagard.ttf", 96),
	}

	-- Turn Menu --
	local currentTeam = state:currentTeam()
	local activeTeamNum = (currentTeam == "green") and 0 or 1
	local activeChar = nil
	for _, char in ipairs(characters) do
		if char.team == activeTeamNum then
			activeChar = char
			break
		end
	end
	local activeName = activeChar and activeChar.name
	local targetName = game.selected and game.selected.name

	-- For upcoming characters
	local characterOrder = {"ninjaBlack", "gladiatorBlue"}
	local function getCharForTurn(offset)
		local turn = state.turn + offset
		local index = (turn % 2 == 1) and 1 or 2
		return characterOrder[index]
	end
	local nextName = getCharForTurn(2)
	local secondName = getCharForTurn(3)
	local thirdName = getCharForTurn(4)
	local fourthName = getCharForTurn(5)

	-- Active Character
	if activeName then
		local faceset = love.graphics.newImage("assets/sprites/chars/" .. activeName .. "/Faceset.png")
		local offset = map.tileSize * 1.5
		love.graphics.draw(
			faceset,
			map.tileSize,
			3 * VIRTUAL_HEIGHT / 4 + offset,
			0,
			3,
			3
		)
	end

	-- Target
	if targetName then
		local faceset = love.graphics.newImage("assets/sprites/chars/" .. targetName .. "/Faceset.png")
		local offsetH = map.tileSize * 1.5
		local offsetW = faceset:getWidth() * 3 + map.tileSize
		love.graphics.draw(
			faceset,
			VIRTUAL_WIDTH - offsetW,
			3 * VIRTUAL_HEIGHT / 4 + offsetH,
			0,
			3,
			3
		)
	end

	-- Upcoming characters
	local upcomingNames = {nextName, secondName, thirdName, fourthName}
	local offset
	for i, name in ipairs(upcomingNames) do
		local faceset = love.graphics.newImage("assets/sprites/chars/" .. name .. "/Faceset.png")
		if i == 1 then
			offset = faceset:getHeight() * 2.5 + map.tileSize
		end
		love.graphics.draw(
			faceset,
			map.tileSize,
			3 * VIRTUAL_HEIGHT / 4 - offset * i,
			0,
			2.5,
			2.5
		)
	end

	-- Character Menu
	love.graphics.setFont(font.small)
	love.graphics.printf("Character Stats", 0, 3 * VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH / 2, "center")
	love.graphics.printf("Target Stats", VIRTUAL_WIDTH / 2, 3 * VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH / 2, "center")

    -- Draw message overlay
    if game.message then
        love.graphics.setFont(font.smaller)
        love.graphics.printf(game.message, VIRTUAL_WIDTH / 4, 0, VIRTUAL_WIDTH / 2, "center")
    end

    love.graphics.setCanvas()

    -- Draw scaled canvas centered
    if scale and scale > 0 then
        love.graphics.draw(gameCanvas, translateX, translateY, 0, scale, scale)
    end
end

function game.mousereleased(x, y, button)
    if button ~= 1 or scale <= 0 then return end
    local vx = (x - translateX) / scale
    local vy = (y - translateY) / scale
end

function game.resize(w, h)
    computeScale()
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

function game.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end

return game
