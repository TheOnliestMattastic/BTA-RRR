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
        -- Layout constants
        local facesetScale = 4
        local facesetMargin = 32
        local panelMargin = 8
        local barSpacing = 22
        local statsStartOffset = 40
        local statLineHeight = 15

        -- Calculate faceset dimensions and position
        local facesetWidth = activeFaceset:getWidth() * facesetScale
        local facesetHeight = activeFaceset:getHeight() * facesetScale
        local facesetX = facesetMargin
        local facesetY = VIRTUAL_HEIGHT - facesetHeight - facesetMargin

        -- Draw faceset
        love.graphics.draw(activeFaceset, facesetX, facesetY, 0, facesetScale, facesetScale)
        love.graphics.setFont(fontMed)

        -- Calculate stats panel position
        local statsX = facesetX + facesetWidth + panelMargin
        local nameY = facesetY
        love.graphics.print(activeChar.class, statsX, nameY)

        -- Draw bars
        local barsY = facesetY + fontMed:getHeight(activeChar.class)
        if uiImages then
            -- Health bar
            love.graphics.draw(uiImages.bar_1, statsX, barsY, 0, 2, 1.5)
            -- Action points
            love.graphics.draw(uiImages.bar_2, statsX, barsY + barSpacing, 0, 1.6, 1)

            -- Attributes
            love.graphics.setFont(fontTiny)
            local statsY = barsY + statsStartOffset
            love.graphics.print("PWR: " .. activeChar.pwr, statsX, statsY + 0 * statLineHeight)
            love.graphics.print("DEF: " .. activeChar.def, statsX, statsY + 1 * statLineHeight)
            love.graphics.print("DEX: " .. activeChar.dex, statsX, statsY + 2 * statLineHeight)
            love.graphics.print("SPD: " .. activeChar.spd, statsX, statsY + 3 * statLineHeight)
			love.graphics.print("RNG: " .. activeChar.rng, statsX, statsY + 4 * statLineHeight)
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
