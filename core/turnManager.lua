-- core/turnManager.lua
local TurnManager = {}

-- Calculate initiative for all characters (D&D style: d20 + SPD modifier)
function TurnManager.rollInitiative(characters)
	local initiatives = {}
	
	for i, char in ipairs(characters) do
		-- Roll d20 (1-20) and add SPD stat as modifier
		local diceRoll = math.random(1, 20)
		local initiative = diceRoll + (char.spd or 0)
		initiatives[i] = {
			index = i,
			character = char,
			initiative = initiative,
			diceRoll = diceRoll
		}
	end
	
	-- Sort by initiative (highest first)
	table.sort(initiatives, function(a, b)
		return a.initiative > b.initiative
	end)
	
	return initiatives
end

-- Reorder characters based on initiative rolls
function TurnManager.setTurnOrder(state, characters, initiativeRolls)
	state.turnOrder = {}
	for i, roll in ipairs(initiativeRolls) do
		state.turnOrder[i] = characters[roll.index]
	end
end

-- Get the active character index based on turn
function TurnManager.getActiveIndex(state, characters)
    return (state.turn - 1) % #state.turnOrder + 1
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
