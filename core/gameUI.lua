-- core/gameUI.lua
local GameUI = {}

local VIRTUAL_WIDTH = 1024
local VIRTUAL_HEIGHT = 768

-- Draw message overlay
function GameUI.drawMessage(game, fontSmall)
    if game.message then
        love.graphics.setFont(fontSmall)
        love.graphics.printf(game.message, VIRTUAL_WIDTH / 4, 0, VIRTUAL_WIDTH / 2, "center")
    end
end

-- Draw active character stats
function GameUI.drawActiveStats(activeFaceset, activeChar, fontTiny, fontMed, uiImages)
    if activeFaceset then
        -- Draw faceset
        local offset = activeFaceset:getWidth() * 4 + 32  -- map.tileSize
        love.graphics.draw(activeFaceset, 32, VIRTUAL_HEIGHT - offset, 0, 4, 4)
        love.graphics.setFont(fontMed)

        -- Draw name
        local offsetStats = offset + 8  -- map.tileSize / 4
        love.graphics.print(activeChar.class, offsetStats, VIRTUAL_HEIGHT - offset)

        -- Draw bars
		local offsetY = offset - fontMed:getHeight(activeChar.class)
        if uiImages then
			-- Health bar
            love.graphics.draw(uiImages.bar_1, offsetStats, VIRTUAL_HEIGHT - offsetY, 0, 2, 1.5)
			-- Action points
            love.graphics.draw(uiImages.bar_2, offsetStats, VIRTUAL_HEIGHT - offsetY + 22, 0, 1.6, 1)
			-- Panel - top
			love.graphics.setColor(0.75, 0.75, 0.75, 1)
			love.graphics.draw(uiImages.patternPanelTop, offsetStats, VIRTUAL_HEIGHT - offsetY + 40, 0, 2.3, 1)
			love.graphics.setColor(1, 1, 1, 1)
			-- Stats
			love.graphics.setFont(fontTiny)
			love.graphics.print("PWR:" .. activeChar.pwr, offsetStats, VIRTUAL_HEIGHT - offsetY + 60)
			love.graphics.print("DEF:" .. activeChar.def, offsetStats, VIRTUAL_HEIGHT - offsetY + 75)
			love.graphics.print("DEX:" .. activeChar.dex, offsetStats, VIRTUAL_HEIGHT - offsetY + 90)
			love.graphics.print("SPD:" .. activeChar.spd, offsetStats, VIRTUAL_HEIGHT - offsetY + 105)
			love.graphics.print("RNG:" .. activeChar.rng, offsetStats, VIRTUAL_HEIGHT - offsetY + 120)
			-- Panel - bottom
			love.graphics.setColor(0.75, 0.75, 0.75, 1)
			love.graphics.draw(uiImages.patternPanelBottom, offsetStats, VIRTUAL_HEIGHT - 49, 0, 1.29, 1)
			love.graphics.setColor(1, 1, 1, 1)
		end
    end
end

-- Draw target character stats
function GameUI.drawTargetStats(targetFaceset, targetName, fontMed)
    local offset = targetFaceset:getWidth() * 4 + 32
    love.graphics.draw(targetFaceset, VIRTUAL_WIDTH - offset, VIRTUAL_HEIGHT - offset, 0, 4, 4)
    love.graphics.setFont(fontMed)
    local textX = fontMed:getWidth(targetName) + offset + 8
    love.graphics.print(targetName, VIRTUAL_WIDTH - textX, VIRTUAL_HEIGHT - offset)
end

-- Draw upcoming characters
function GameUI.drawUpcoming(upcomingFacesets, upcomingYs)
    for i, faceset in ipairs(upcomingFacesets) do
        if faceset then
            love.graphics.draw(faceset, 32, upcomingYs[i], 0, 1.5, 1.5)
        end
    end
end

-- Prepare upcoming facesets and positions
function GameUI.prepareUpcomingFacesets(upcomingNames, facesets)
    local upcomingFacesets = {}
    local upcomingYs = {}
    local facesetHeight = 0
    local previousY = 0
    for i, name in ipairs(upcomingNames) do
        local faceset = facesets[name]
        if faceset then
            upcomingFacesets[i] = faceset
            facesetHeight = faceset:getHeight() * 1.5
            local spacing = 32  -- map.tileSize
            local y
            if i == 1 then
                y = 3 * VIRTUAL_HEIGHT / 4 - (facesetHeight + spacing)
            else
                y = previousY - (facesetHeight + spacing / 4)
            end
            upcomingYs[i] = y
            previousY = y
        end
    end
    return upcomingFacesets, upcomingYs
end

return GameUI
