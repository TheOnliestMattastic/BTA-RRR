-- states/game.lua
-- Main gameplay state: Turn-based tactical combat on a grid map
local gameInit = require "core.gameInit"
local TurnManager = require "core.turnManager"
local GameUI = require "core.gameUI"
local InputHandler = require "core.inputHandler"

-- Game state and entities
local game = {}
local characters = {}
local charsByName = {}
local map
local state

-- Selection and targeting
game.selected = nil
game.activeChar = nil
game.targetChar = nil
game.message = nil

-- UI and rendering
local fontXLarge, fontLarge, fontMed, fontSmall, fontTiny_2
local CharactersConfig
local VIRTUAL_WIDTH = 1024
local VIRTUAL_HEIGHT = 768
local gameCanvas
local scale, translateX, translateY

-- Input handling
local inputHandler
local inputFocus = "keyboard" -- "keyboard" or "mouse" - which input system has focus

-- Utility: Calculate scaling to fit virtual resolution in window
local function computeScale()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    scale = math.min(w / VIRTUAL_WIDTH, h / VIRTUAL_HEIGHT)
    translateX = (w - VIRTUAL_WIDTH * scale) / 2
    translateY = (h - VIRTUAL_HEIGHT * scale) / 2
end

-- Dependency references from game initialization module
local registry = gameInit.registry
local tilesets = gameInit.tilesets
local activeFX = gameInit.activeFX
local GameHelpers = gameInit.GameLogic.GameHelpers
local facesets = registry.facesets
local uiImages = registry.ui
local fonts = registry.fonts

-- Init: Set up map, characters, and game state
function game.load()
    -- Load: Tileset configuration
    local tilesetTag = "grass"
    local tileset = tilesets:getTileset(tilesetTag)
    CharactersConfig = gameInit.CharactersConfig
    local Character = gameInit.Character
    local GameState = gameInit.GameState
    local Map = gameInit.Map

    -- Validate: Tileset exists and has valid dimensions
    if not tileset or not tileset.image then
        error("Tileset or tileset.image is nil for " .. tilesetTag)
        return
    end

    -- Calculate: Number of tile frames in spritesheet grid
    local atlasCols = math.floor(tileset.image:getWidth() / tileset.frameW)
    local atlasRows = math.floor(tileset.image:getHeight() / tileset.frameH)
    if atlasCols == 0 or atlasRows == 0 then
        error("Tileset has zero width or height frames. Check frameW/frameH in config/tilesets.lua for " .. tilesetTag)
        return
    end

    -- Setup: Map dimensions and RNG
    local tileSize = 32
    local mapCols = 16
    local mapRows = 16
    math.randomseed(os.time())

    -- Build: Randomized map layout (each cell is "col,row" coordinates from tileset)
    local layout = {}
    for row = 1, mapRows do
        layout[row] = {}
        for col = 1, mapCols do
            local tileCoordinates = math.random(1, atlasCols) .. "," .. math.random(1, atlasRows)
            layout[row][col] = tileCoordinates
        end
    end

    -- Create: Map, canvas, and game state
    map = Map.new(tileSize, layout, tilesets, tilesetTag)
    gameCanvas = love.graphics.newCanvas(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    state = GameState.new()
    gameInit.init(game, characters, state)

    -- Create: Character 1 (ninjaBlack, Team 0)
    local ninjaStats = CharactersConfig.ninjaBlack.stats
    local stats = {}
    for k, v in pairs(ninjaStats) do stats[k] = v end
    stats.team = 0
    local ninjaBlack = Character.new("ninjaBlack", 2, 4, stats, CharactersConfig.ninjaBlack.tags)
    ninjaBlack:setAnimations(registry:getCharacter("ninjaBlack"))
    table.insert(characters, ninjaBlack)
    charsByName.ninjaBlack = ninjaBlack

    -- Create: Character 2 (gladiatorBlue, Team 1)
    local gladiatorStats = CharactersConfig.gladiatorBlue.stats
    stats = {}
    for k, v in pairs(gladiatorStats) do stats[k] = v end
    stats.team = 1
    local gladiatorBlue = Character.new("gladiatorBlue", 4, 6, stats, CharactersConfig.gladiatorBlue.tags)
    gladiatorBlue:setAnimations(registry:getCharacter("gladiatorBlue"))
    table.insert(characters, gladiatorBlue)
    charsByName.gladiatorBlue = gladiatorBlue

    -- Setup: Initiative order (D&D-style: d20 + SPD)
    local initiativeRolls = TurnManager.rollInitiative(characters)
    TurnManager.setTurnOrder(state, characters, initiativeRolls)

    -- Load: Fonts from registry
    fontXLarge = fonts.fontXLarge
    fontLarge = fonts.fontLarge
    fontMed = fonts.fontMed
    fontSmall = fonts.fontSmall
    fontTiny_2 = fonts.fontTiny_2

    -- Init: Input handler
    inputHandler = InputHandler.new(game)

    -- Init: Hide cursor initially (keyboard has focus)
    love.mouse.setVisible(false)
end

-- Update: Game logic and animations
function game.update(dt)
    -- Check: Win condition and manage AP pools
    state:clampAP(characters)
    state:checkWin()

    -- Update: Character animations and states
    for _, character in ipairs(characters) do
        if character.update then pcall(character.update, character, dt) end
    end

    -- Update: Active visual effects
    for _, activeEffect in ipairs(activeFX) do
        if activeEffect.fx and activeEffect.fx.anim and activeEffect.fx.anim.update then pcall(
            activeEffect.fx.anim.update, activeEffect.fx.anim, dt) end
    end

    -- Cleanup: Remove finished effects
    local toRemove = {}
    for i, activeEffect in ipairs(activeFX) do
        if activeEffect.fx.anim.status == "paused" then
            table.insert(toRemove, 1, i)
        end
    end
    for _, i in ipairs(toRemove) do
        table.remove(activeFX, i)
    end

    -- Update: Map animations (breathing cursor)
    map:update(dt)

    -- Update: Action menu button hover states based on mouse position and keyboard focus
    computeScale()
    local mx, my = love.mouse.getPosition()
    local vmx = (mx - translateX) / scale
    local vmy = (my - translateY) / scale
    GameUI.updateActionMenu(vmx, vmy, uiImages, inputHandler.keyboardFocusButton, inputFocus)
    end

-- Draw: Game world, characters, and UI
function game.draw()
    computeScale()

    -- Draw: Render to virtual canvas
    love.graphics.setCanvas(gameCanvas)
    love.graphics.clear(0.3, 0.4, 0.4) -- game background

    -- Get: Mouse position in virtual coords
    local mx, my = love.mouse.getPosition()
    local vmx = (mx - translateX) / scale
    local vmy = (my - translateY) / scale

    -- Draw: Tilemap
    map:draw(vmx, vmy, inputFocus, uiImages, inputHandler)

    -- Draw: Movement range overlay (only when "Navigate" button is active)
    if GameUI.actionMenuState.activeButton == 0 then
        map:highlightMovementRange(game.selected,
            function(col, row) return GameHelpers.findCharacterAt(col, row) ~= nil end)
    end

    -- Draw: Attack range overlay if target is selected
    if game.targetChar then
        map:highlightAttackRange(game.activeChar)
    end

    -- Draw: All characters and their animations
    for _, character in ipairs(characters) do
        pcall(function() character:draw(map.tileSize, map.offsetX, map.offsetY) end)
    end

    -- Draw: Visual effects (damage numbers, hit flashes, etc.)
    love.graphics.setColor(1, 1, 1, 1)
    for _, activeEffect in ipairs(activeFX) do
        activeEffect.fx.anim:draw(activeEffect.fx.image, activeEffect.x * map.tileSize + map.offsetX,
            activeEffect.y * map.tileSize + map.offsetY)
    end

    -- Draw: Cursor tile (breathing animation overlay) - only when keyboard focus is on map
    if inputFocus == "keyboard" and inputHandler:getFocus() == "map" then
        map:drawCursor(uiImages)
    end

    -- Update: Active character and turn order
    local previousActive = game.activeChar
    game.activeChar = TurnManager.getActiveCharacter(state, characters)
    if game.activeChar ~= previousActive and game.activeChar then
        game.activeChar:gainAP()
    end
    game.selected = game.activeChar -- Auto-select active character at turn start

    -- Get: Names for faceset lookups
    local activeName = game.activeChar and game.activeChar.class
    local targetName = game.targetChar and game.targetChar.class
    local upcomingNames = TurnManager.getUpcomingNames(state, characters, 8)

    -- Prepare: Faceset images and positions
    local activeFaceset = facesets[activeName]
    local targetFaceset = facesets[targetName]
    local upcomingFacesets, upcomingYs = GameUI.prepareUpcomingFacesets(upcomingNames, facesets)

    -- Draw: UI overlays (stats, action menu, turn order)
    GameUI.drawMessage(game, fontSmall)
    if activeFaceset then
        GameUI.drawActiveStats(activeFaceset, game.activeChar, fontTiny_2, fontSmall, uiImages, game.activeChar.ap)
        GameUI.drawActionMenu(game.activeChar, fontMed, uiImages)
    end
    if targetFaceset then
        GameUI.drawTargetStats(targetFaceset, game.targetChar, fontTiny_2, fontSmall, uiImages)
    end
    if upcomingFacesets then
        GameUI.drawUpcoming(upcomingFacesets, upcomingYs)
    end

    -- Draw: Scale and center canvas to fit window
    love.graphics.setCanvas()
    if scale and scale > 0 then
        love.graphics.draw(gameCanvas, translateX, translateY, 0, scale, scale)
    end
end

-- Handle window resize
function game.resize(w, h)
    computeScale()
end

-- Input: Handle mouse move (gain focus when user moves mouse)
function game.mousemoved(x, y)
    if inputFocus ~= "mouse" then
        inputFocus = "mouse"
        love.mouse.setVisible(true)
    end
end

-- Input: Handle left mouse press for actions and buttons
function game.mousepressed(x, y, button)
    if state.over or inputFocus ~= "mouse" then return end
    computeScale()
    if button ~= 1 or scale <= 0 then return end

    -- Convert screen coords to virtual coords
    local vx = (x - translateX) / scale
    local vy = (y - translateY) / scale

    -- Input: Check action menu buttons first (press state for visual feedback)
    local buttonPressed = GameUI.actionMenuMousePressed(vx, vy, uiImages)
    if buttonPressed then return end

    -- Input: Check map tile hover
    local hovered = map:getHoveredTile(vx, vy)
    if not hovered then return end
    local col, row = hovered[1], hovered[2]

    -- Input: Check if clicked on a character
    local clicked = GameHelpers.findCharacterAt(col, row)

    -- Input: Handle character selection (changes selected character)
    if GameHelpers.handleSelection(clicked) then return end

    -- Input: Move to empty tile if within speed range
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

    -- Input: Attempt attack on clicked character
    local canAttack, reason = game.selected:canBasicAttack(clicked)
    if not canAttack then
        game.message = reason or "Cannot attack"
        return
    end

    -- Action: Set target and perform attack
    game.targetChar = clicked
    GameHelpers.performAttack(game.selected, clicked)
end

-- Input: Handle left mouse release for button activation
function game.mousereleased(x, y, button)
    if button ~= 1 or inputFocus ~= "mouse" then return end
    computeScale()
    if scale <= 0 then return end

    -- Convert screen coords to virtual coords
    local vx = (x - translateX) / scale
    local vy = (y - translateY) / scale

    -- Input: Check action menu button release (activation only on release)
    local buttonReleased = GameUI.actionMenuMouseReleased(vx, vy, uiImages)
    if buttonReleased then
        -- Toggle: Deactivate if button is already active, otherwise activate
        if GameUI.actionMenuState.activeButton == buttonReleased then
            GameUI.actionMenuState.activeButton = nil
            game.message = "Button " .. buttonReleased .. " deactivated"
        else
            GameUI.actionMenuState.activeButton = buttonReleased
            game.message = "Button " .. buttonReleased .. " activated"
        end
        -- TODO: Implement actual button actions (attack, heal, defend, etc.)
    end
end

-- Input: Handle keyboard press (for press-on-release button behavior)
function game.keypressed(key)
    if state.over then return end

    -- Gain keyboard focus on any key press
    if inputFocus ~= "keyboard" then
        inputFocus = "keyboard"
        love.mouse.setVisible(false)
        return -- Skip processing this frame's input on focus switch
    end

    -- Menu: Track Enter key press for button (show pressed state) - only when menu focus
    if inputHandler:getFocus() == "menu" and key == "return" then
        GameUI.actionMenuState.isPressed = true
        GameUI.actionMenuState.pressedButton = inputHandler.keyboardFocusButton
    end
end

-- Input: Handle keyboard shortcuts
function game.keyreleased(key)
	if state.over or inputFocus ~= "keyboard" then return end

	-- Global exceptions: Tab and Escape work anytime
	if key == "tab" then
		inputHandler:toggleFocus()
		return
	elseif key == "escape" then
		love.event.quit()
		return
	end

	-- Separate logic based on current focus
	local focus = inputHandler:getFocus()

	if focus == "map" then
		-- Map focus: hjkl navigation and enter to select tile
		local direction = inputHandler:getDirection(key)
		if direction then
			inputHandler:moveMapCursor(direction)
		elseif key == "return" then
			-- Move active character to cursor position
			local cursorX, cursorY = inputHandler:getMapCursor()
			if cursorX and cursorY and game.activeChar then
				local dist = math.abs(cursorX - game.activeChar.x) + math.abs(cursorY - game.activeChar.y)
				if dist <= game.activeChar.spd then
					game.activeChar:moveTo(cursorX, cursorY)
					game.message = "Moved to (" .. cursorX .. ", " .. cursorY .. ")"
				else
					game.message = "Out of movement range"
				end
			end
		end

	elseif focus == "menu" then
		-- Menu focus: j/k navigation, enter to toggle button, space to end turn
		if key == "j" then
			inputHandler:navigateMenu("down")
		elseif key == "k" then
			inputHandler:navigateMenu("up")
		elseif key == "space" then
			inputHandler:endTurn()
		elseif key == "return" then
			-- Toggle current menu button (activate/deactivate on release)
			if GameUI.actionMenuState.isPressed and GameUI.actionMenuState.pressedButton == inputHandler.keyboardFocusButton then
				if GameUI.actionMenuState.activeButton == inputHandler.keyboardFocusButton then
					GameUI.actionMenuState.activeButton = nil
					game.message = "Button " .. (inputHandler.keyboardFocusButton) .. " deactivated"
				else
					GameUI.actionMenuState.activeButton = inputHandler.keyboardFocusButton
					game.message = "Button " .. (inputHandler.keyboardFocusButton) .. " activated"
				end
			end
			GameUI.actionMenuState.isPressed = false
			GameUI.actionMenuState.pressedButton = nil
		end
	end
end

return game
