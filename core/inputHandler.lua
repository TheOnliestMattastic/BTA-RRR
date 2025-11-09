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
	}, InputHandler)
end

-- Input: Vim-style movement (hjkl)
-- Returns: direction string or nil
function InputHandler:getVimDirection(key)
	if key == "h" then return "left"
	elseif key == "j" then return "down"
	elseif key == "k" then return "up"
	elseif key == "l" then return "right"
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
	if direction == "up" or direction == "k" then
		self.keyboardFocusButton = math.max(0, self.keyboardFocusButton - 1)
	elseif direction == "down" or direction == "j" then
		self.keyboardFocusButton = math.min(3, self.keyboardFocusButton + 1)
	end
end

return InputHandler
