-- core/gameUI.lua
local GameUI = {}

local VIRTUAL_WIDTH = 1024
local VIRTUAL_HEIGHT = 768

-- Draw message overlay
function GameUI.drawMessage(game, fontSmaller)
    if game.message then
        love.graphics.setFont(fontSmaller)
        love.graphics.printf(game.message, VIRTUAL_WIDTH / 4, 0, VIRTUAL_WIDTH / 2, "center")
    end
end

-- Draw character stats with faceset
function GameUI.drawCharacterStats(faceset, name, x, y, scaleFace, fontSmall, uiImages, barImage)
    if faceset then
        -- Draw faceset
        local offset = faceset:getWidth() * scaleFace + 32  -- map.tileSize
        love.graphics.draw(faceset, x, y - offset, 0, scaleFace, scaleFace)
        love.graphics.setFont(fontSmall)

        -- Draw name
        local offsetStats = offset + 16  -- map.tileSize / 2
        love.graphics.print(name, x + offsetStats, y - offset)

        -- Draw bar (if provided)
        if barImage then
            love.graphics.draw(barImage, x + offsetStats, y - offset + fontSmall:getHeight(name))
        end
    end
end

-- Draw active character stats
function GameUI.drawActiveStats(activeFaceset, activeName, fontSmall, uiImages)
    GameUI.drawCharacterStats(activeFaceset, activeName, 32, VIRTUAL_HEIGHT, 4, fontSmall, uiImages, uiImages.bar_1)
end

-- Draw target character stats
function GameUI.drawTargetStats(targetFaceset, targetName, fontSmall)
    local offset = targetFaceset:getWidth() * 4 + 32
    love.graphics.draw(targetFaceset, VIRTUAL_WIDTH - offset, VIRTUAL_HEIGHT - offset, 0, 4, 4)
    love.graphics.setFont(fontSmall)
    local textX = fontSmall:getWidth(targetName) + offset + 16
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
