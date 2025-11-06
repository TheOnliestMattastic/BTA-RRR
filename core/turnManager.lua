-- core/turnManager.lua
local TurnManager = {}

-- Get the active character index based on turn
function TurnManager.getActiveIndex(state, characters)
    return (state.turn - 1) % #characters + 1
end

-- Get the active character
function TurnManager.getActiveCharacter(state, characters)
    local idx = TurnManager.getActiveIndex(state, characters)
    return characters[idx]
end

-- Get upcoming character names (for UI display)
function TurnManager.getUpcomingNames(state, characters, count)
    count = count or 8
    local turnIndex = TurnManager.getActiveIndex(state, characters)
    local names = {}
    for i = 1, count do
        local idx = ((turnIndex + i - 1) % #characters) + 1
        names[i] = characters[idx] and characters[idx].class
    end
    return names
end

return TurnManager
