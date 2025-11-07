-- core/gameUI.lua
local GameUI = {}

local VIRTUAL_WIDTH = 1024
local VIRTUAL_HEIGHT = 768

-- Heart display quads (created once)
local heartQuads = {}

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
        local margin = 8
        local statLineHeight = 15
        local heartSpacing = 18
        local heartsPerRow = 4

        -- Calculate faceset dimensions and position
        local facesetWidth = activeFaceset:getWidth() * facesetScale
        local facesetHeight = activeFaceset:getHeight() * facesetScale
        local facesetX = facesetMargin
        local facesetY = VIRTUAL_HEIGHT - facesetHeight - facesetMargin

        -- Draw faceset
        love.graphics.draw(activeFaceset, facesetX, facesetY, 0, facesetScale, facesetScale)
        love.graphics.setFont(fontMed)

        -- Calculate stats panel position
        local statsX = facesetX + facesetWidth + margin
        local nameY = facesetY
        love.graphics.print(activeChar.class, statsX, nameY)

        if uiImages then
            -- Draw receptacle (scaled by 2)
            local receptacleScale = 1.75
            local receptacleWidth = 38 * receptacleScale
            local receptacleHeight = 66 * receptacleScale
            local receptacleX = facesetX + facesetWidth + margin
            local receptacleY = facesetY + facesetHeight - receptacleHeight
            love.graphics.draw(uiImages.receptacle, receptacleX, receptacleY, 0, receptacleScale, receptacleScale)

            -- Health bar (hearts) - two rows of 4 containers each
            local heartImage = uiImages.heart
            if #heartQuads == 0 then
                for i = 1, 5 do
                    heartQuads[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, heartImage:getDimensions())
                end
            end
            local numHearts = math.min(8, math.ceil(activeChar.maxHP / 4))
            local heartsX = receptacleX + receptacleWidth + margin
            local heartsY = nameY + fontMed:getHeight(activeChar.class) + margin
            for i = 1, numHearts do
                local hpRemaining = activeChar.hp - (i-1)*4
                local fillLevel = math.max(0, math.min(4, hpRemaining))
                local frame = math.floor(fillLevel) + 1
                local row = math.floor((i-1) / heartsPerRow) + 1
                local col = ((i-1) % heartsPerRow) + 1
                local x = heartsX + (col-1) * heartSpacing
                local y = heartsY + (row-1) * heartSpacing
                love.graphics.draw(heartImage, heartQuads[frame], x, y)
            end

            -- Attributes (positioned below hearts, to the right of receptacle, last row aligned to faceset bottom)
            love.graphics.setFont(fontTiny)
            local fontHeight = fontTiny:getHeight()
            local lastTextY = facesetY + facesetHeight - fontHeight
            local statsY = lastTextY - 4 * statLineHeight
            local attrX = receptacleX + receptacleWidth + margin
            love.graphics.print("PWR: " .. activeChar.pwr, attrX, statsY + 0 * statLineHeight)
            love.graphics.print("DEF: " .. activeChar.def, attrX, statsY + 1 * statLineHeight)
            love.graphics.print("DEX: " .. activeChar.dex, attrX, statsY + 2 * statLineHeight)
            love.graphics.print("SPD: " .. activeChar.spd, attrX, statsY + 3 * statLineHeight)
            love.graphics.print("RNG: " .. activeChar.rng, attrX, statsY + 4 * statLineHeight)
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
