-- core/inputHandler.lua
-- Centralized input handling for menu and game states
-- Supports mouse, keyboard, and Vim-style navigation (hjkl)

local InputHandler = {}
InputHandler.__index = InputHandler

-- Init: Create input handler for a game state
function InputHandler.new(context)
	return setmetatable({
		context = context,  -- Reference to game or menu state
		isButtonPressed = false,  -- Track press-on-release for buttons
		keyboardFocusButton = 0,  -- Track keyboard focus on action menu (0=Navigate, 1=Actions, etc.)
		uiFocus = "menu",  -- "map" or "menu" - which UI element has focus for hjkl navigation
		mapCursorX = nil,  -- Map cursor position (if nil, will snap to activeChar)
		mapCursorY = nil,
	}, InputHandler)
end

-- Input: Vim-style movement (hjkl)
-- Returns: direction string or nil
function InputHandler:getVimDirection(key)
	if key == "h" then return "left"
	elseif key == "j" then return "down"
	elseif key == "k" then return "up"
	elseif key == "l" then return "right"
	elseif key == "up" then return "up"
	elseif key == "down" then return "down"
	elseif key == "left" then return "left"
	elseif key == "right" then return "right"
	end
	return nil
end

-- Input: WASD movement (alternative)
-- Returns: direction string or nil
function InputHandler:getArrowDirection(key)
	if key == "a" then return "left"
	elseif key == "w" then return "up"
	elseif key == "d" then return "right"
	elseif key == "s" then return "down"
	elseif key == "up" then return "up"
	elseif key == "down" then return "down"
	elseif key == "left" then return "left"
	elseif key == "right" then return "right"
	end
	return nil
end

-- Input: Get direction from key (prioritize Vim, fallback to WASD/arrows)
function InputHandler:getDirection(key)
	return self:getVimDirection(key) or self:getArrowDirection(key)
end

-- Action: Move selected character in given direction (game state only)
function InputHandler:moveCharacter(direction)
	if not self.context.selected then return end
	
	local char = self.context.selected
	local newX, newY = char.x, char.y
	
	if direction == "up" then newY = newY - 1
	elseif direction == "down" then newY = newY + 1
	elseif direction == "left" then newX = newX - 1
	elseif direction == "right" then newX = newX + 1
	end
	
	char:moveTo(newX, newY)
end

-- Action: End turn (game state only)
function InputHandler:endTurn()
	if self.context.state then
		self.context.state:endTurn()
		self.context.message = "Turn ended"
	end
end

-- Input: Track button press on release (menu state)
function InputHandler:setButtonPressed(pressed)
	self.isButtonPressed = pressed
end

-- Input: Query if button is pressed (menu state)
function InputHandler:isPressed()
	return self.isButtonPressed
end

-- Action: Navigate menu up/down via keyboard (j/k)
function InputHandler:navigateMenu(direction)
	if direction == "up" then
		self.keyboardFocusButton = math.max(0, self.keyboardFocusButton - 1)
	elseif direction == "down" then
		self.keyboardFocusButton = math.min(3, self.keyboardFocusButton + 1)
	end
end

-- Action: Toggle focus between map and action menu (Tab key)
function InputHandler:toggleFocus()
	if self.uiFocus == "map" then
		self.uiFocus = "menu"
		self.keyboardFocusButton = 0  -- Reset menu focus to top button
	else
		self.uiFocus = "map"
		-- Initialize map cursor to activeChar position if not already set
		if not self.mapCursorX and self.context.activeChar then
			self.mapCursorX = self.context.activeChar.x
			self.mapCursorY = self.context.activeChar.y
		end
	end
end

-- Action: Move map cursor in given direction (hjkl when uiFocus == "map")
function InputHandler:moveMapCursor(direction)
	-- Initialize cursor to activeChar position on first move
	if not self.mapCursorX and self.context.activeChar then
		self.mapCursorX = self.context.activeChar.x
		self.mapCursorY = self.context.activeChar.y
	end
	
	if direction == "up" then
		self.mapCursorY = math.max(0, self.mapCursorY - 1)
	elseif direction == "down" then
		self.mapCursorY = self.mapCursorY + 1
	elseif direction == "left" then
		self.mapCursorX = math.max(0, self.mapCursorX - 1)
	elseif direction == "right" then
		self.mapCursorX = self.mapCursorX + 1
	end
end

-- Query: Get current focus ("map" or "menu")
function InputHandler:getFocus()
	return self.uiFocus
end

-- Query: Get map cursor position
function InputHandler:getMapCursor()
	return self.mapCursorX, self.mapCursorY
end

return InputHandler
