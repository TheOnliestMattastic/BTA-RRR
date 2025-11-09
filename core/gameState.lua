-- core/gameState.lua
local GameState = {}
GameState.__index = GameState

function GameState.new()
    local self = setmetatable({}, GameState)

    -- Turn tracking
    self.turn = 1
    self.turnOrder = {}  -- Set by TurnManager
    self.over = false
    self.winner = nil

    return self
end

-- Get active character from turn order
function GameState:getActiveCharacter()
    if #self.turnOrder == 0 then return nil end
    local idx = (self.turn - 1) % #self.turnOrder + 1
    return self.turnOrder[idx]
end

-- End turn and advance to next character
function GameState:endTurn()
    self.turn = self.turn + 1
end

-- Clamp AP for all characters (max 4)
function GameState:clampAP(characters)
    for _, char in ipairs(characters) do
        char.ap = math.min(char.ap, char.maxAP)
    end
end

-- Update win condition
function GameState:checkWin()
    -- if self.remaining.green <= 0 then
    --     self.over = true
    --     self.winner = "Red"
    -- elseif self.remaining.red <= 0 then
    --     self.over = true
    --     self.winner = "Green"
    -- end
end

return GameState
