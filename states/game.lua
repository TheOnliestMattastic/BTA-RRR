-- states/game.lua
local gameInit = require "core.gameInit"
local TurnManager = require "core.turnManager"
local GameUI = require "core.gameUI"

local game = {}
local characters = {}
local charsByName = {}
local map
local state
game.selected = nil
game.activeChar = nil
game.targetChar = nil
game.message = nil
local fontXLarge, fontLarge, fontMed, fontSmall
local CharactersConfig

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
local facesets = registry.facesets
local uiImages = registry.ui
local fonts = registry.fonts

-- Load: Initialize game state, map, and characters
function game.load()
	-- Build map layout from a tileset spritesheet (use TilesetRegistry)
	-- Get the tileset (tag must match config/tilesets.lua)
	local tilesetTag = "grass"
	local tileset = tilesets:getTileset(tilesetTag)
	CharactersConfig = gameInit.CharactersConfig
	local Character = gameInit.Character
	local GameState = gameInit.GameState
	local Map = gameInit.Map

	-- Validate tileset
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

    -- Initialize map and handle potential errors
    map = Map.new(tileSize, layout, tilesets, tilesetTag)
    gameCanvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    state = GameState.new()

    gameInit.init(game, characters, state)

    -- Create characters
    local ninjaStats = CharactersConfig.ninjaBlack.stats
    local stats = {}
	for k, v in pairs(ninjaStats) do stats[k] = v end
    stats.team = 0

    -- Create characters
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

    -- Calculate initiative and sort turn order
    for _, char in ipairs(characters) do
        char.initiative = char.spd + math.random(1, 20)
    end
    table.sort(characters, function(a, b) return a.initiative > b.initiative end)

    -- Get fonts from registry
    fontXLarge = fonts.fontXLarge
    fontLarge = fonts.fontLarge
    fontMed = fonts.fontMed
    fontSmall = fonts.fontSmall
end

-- Update: Handle game logic and animations
function game.update(dt)
	-- Check win/loss and clamp AP
	state:clampAP()
	state:checkWin()

	-- Update characters
	for _, character in ipairs(characters) do
		if character.update then pcall(character.update, character, dt) end
	end

	-- Update FX
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

	-- Compute scaling for virtual screen
	computeScale()

	-- Draw to canvas
	love.graphics.setCanvas(gameCanvas)
	love.graphics.clear(0.3, 0.4, 0.4)  -- game background

	-- Draw map --
	local mx, my = love.mouse.getPosition()
	local vmx = (mx - translateX) / scale
	local vmy = (my - translateY) / scale
	map:draw(vmx, vmy)

	-- Highlight movement range for active character --
	map:highlightMovementRange(game.selected, function(col, row) return GameHelpers.findCharacterAt(col, row) ~= nil end)

	-- Highlight attack range if target selected --
	if game.targetChar then
		map:highlightAttackRange(game.activeChar)
	end

	for _, character in ipairs(characters) do
		-- Character:draw will handle anim drawing if character has anim/sheet set
		pcall(function() character:draw(map.tileSize, map.offsetX, map.offsetY) end)
	end

	-- Reset color for faceset rendering
	love.graphics.setColor(1, 1, 1, 1)

	for _,activeEffect in ipairs(activeFX) do
        activeEffect.fx.anim:draw(activeEffect.fx.image, activeEffect.x * map.tileSize + map.offsetX, activeEffect.y * map.tileSize + map.offsetY)
    end

	-- Turn Management
	game.activeChar = TurnManager.getActiveCharacter(state, characters)
	game.selected = game.activeChar  -- Auto-select active character
	local activeName = game.activeChar and game.activeChar.class
	local targetName = game.targetChar and game.targetChar.class
	local upcomingNames = TurnManager.getUpcomingNames(state, characters, 8)

	-- Prepare: Faceset data for drawing
	local activeFaceset = facesets[activeName]
	local targetFaceset = facesets[targetName]
	local upcomingFacesets, upcomingYs = GameUI.prepareUpcomingFacesets(upcomingNames, facesets)

    -- Draw UI elements
    GameUI.drawMessage(game, fontSmall)
	if activeFaceset then
		GameUI.drawActiveStats(activeFaceset, activeName, fontMed, uiImages)
	end
	if targetFaceset then
		GameUI.drawTargetStats(targetFaceset, targetName, fontMed)
	end
	if upcomingFacesets then
		GameUI.drawUpcoming(upcomingFacesets, upcomingYs)
	end

	love.graphics.setCanvas()

    -- Draw scaled canvas
    if scale and scale > 0 then
        love.graphics.draw(gameCanvas, translateX, translateY, 0, scale, scale)
    end

end

-- function game.mousereleased(x, y, button)
--     if button ~= 1 or scale <= 0 then return end
--     local vx = (x - translateX) / scale
--     local vy = (y - translateY) / scale
-- end

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

    -- Move selected character to empty tile (only if within highlighted movement range)
    if not clicked then
        local dist = math.abs(col - game.selected.x) + math.abs(row - game.selected.y)
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

    -- Set target and perform attack
    game.targetChar = clicked
    GameHelpers.performAttack(game.selected, clicked)
end

function game.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
end

return game
