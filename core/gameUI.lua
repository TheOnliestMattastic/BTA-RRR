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

        -- Calculate stats panel position
        local statsX = facesetX + facesetWidth + margin
        local nameY = facesetY

        if uiImages then
            -- Draw receptacle (scaled by 2)
            local receptacleScale = 1.75
            local receptacleWidth = 38 * receptacleScale
            local receptacleHeight = 66 * receptacleScale
            local receptacleX = facesetX + facesetWidth + margin
            local receptacleY = facesetY + facesetHeight - receptacleHeight

            -- Draw action points
            local apRectWidth = 38.5
            local apRectHeight = 14
            local apX = receptacleX + 3 * (receptacleWidth - apRectWidth) / 4 - 1
            local apStartY = receptacleY + receptacleHeight - apRectHeight - 24

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

            -- Attributes (positioned below hearts, to the right of receptacle, last row aligned to faceset bottom)
            local fontHeight = fontTiny:getHeight()
            local lastTextY = facesetY + facesetHeight - fontHeight
            local statsY = lastTextY - 4 * statLineHeight
            local attrX = receptacleX + receptacleWidth + margin

            -- Draw background panel
            if uiImages.panel_1 then
                local panelImage = uiImages.panel_1
                local panelW, panelH = 144, 144  -- from config
                -- Calculate bounding box
                local padding = 32  -- tilesize padding inside panel
                local approxTextWidth = fontTiny:getWidth("SPD: 99")  -- approximate max text width
                local activeLeft = facesetX
                local activeRight = math.max(facesetX + facesetWidth, receptacleX + receptacleWidth, heartsX + heartSpacing * 4, attrX + approxTextWidth)
                local activeTop = nameY
                local activeBottom = facesetY + facesetHeight
                -- Ensure panel doesn't enter the center gap (leave square gap centered)
                local centerX = VIRTUAL_WIDTH / 2
                local gapSize = 144  -- square gap
                local gapLeft = centerX - gapSize / 2
                activeRight = math.min(activeRight, gapLeft - margin)
                -- Add padding to the panel area
                local panelLeft = activeLeft - margin - padding
                local panelTop = activeTop - margin - padding
                local panelRight = activeRight + margin + padding
                local panelBottom = activeBottom + margin + padding
                local panelScaleX = (panelRight - panelLeft) / panelW
                local panelScaleY = (panelBottom - panelTop) / panelH
                love.graphics.setColor(1, 1, 1, 0.6)  -- increased transparency
                love.graphics.draw(panelImage, panelLeft, panelTop, 0, panelScaleX, panelScaleY)
                love.graphics.setColor(1, 1, 1, 1)
            end

            -- Draw receptacle
            love.graphics.draw(uiImages.receptacle, receptacleX, receptacleY, 0, receptacleScale, receptacleScale)

            -- Draw action points
            for i = 1, activeChar.ap do
                local y = apStartY - (i-1) * apRectHeight
                love.graphics.draw(uiImages.actionPointRect, apX, y, 0, 1.75, 1.4)
            end

            -- Draw hearts
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

            -- Draw attributes
            love.graphics.setFont(fontTiny)
            love.graphics.print("PWR: " .. activeChar.pwr, attrX, statsY + 0 * statLineHeight)
            love.graphics.print("DEF: " .. activeChar.def, attrX, statsY + 1 * statLineHeight)
            love.graphics.print("DEX: " .. activeChar.dex, attrX, statsY + 2 * statLineHeight)
            love.graphics.print("SPD: " .. activeChar.spd, attrX, statsY + 3 * statLineHeight)
            love.graphics.print("RNG: " .. activeChar.rng, attrX, statsY + 4 * statLineHeight)
        end

        -- Draw faceset
        love.graphics.draw(activeFaceset, facesetX, facesetY, 0, facesetScale, facesetScale)
        love.graphics.setFont(fontMed)
        love.graphics.print(activeChar.class, statsX, nameY)
    end
end

-- Draw target character stats
function GameUI.drawTargetStats(targetFaceset, targetChar, fontTiny, fontMed, uiImages)
    if not targetChar then return end
    local offset = targetFaceset:getWidth() * 4 + 32
    local facesetX = VIRTUAL_WIDTH - offset
    local facesetY = VIRTUAL_HEIGHT - offset

    love.graphics.setFont(fontMed)
    local nameY = facesetY
    local textX = fontMed:getWidth(targetChar.class) + offset + 8

    local margin = 8
    local statLineHeight = 15

    if uiImages then
        -- Health bar (hearts) - two rows of 4 containers each, to the left of faceset
        local heartImage = uiImages.heart
        if #heartQuads == 0 then
            for i = 1, 5 do
                heartQuads[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, heartImage:getDimensions())
            end
        end
        local numHearts = math.min(8, math.ceil(targetChar.maxHP / 4))
        local heartSpacing = 18
        local heartsX = facesetX - margin - heartSpacing * 4  -- to the left, 4 columns
        local heartsY = nameY + fontMed:getHeight(targetChar.class) + margin

        -- Attributes (positioned below hearts, last row aligned to faceset bottom)
        local fontHeight = fontTiny:getHeight()
        local lastTextY = facesetY + targetFaceset:getHeight() * 4 - fontHeight
        local statsY = lastTextY - 4 * statLineHeight
        local attrX = heartsX  -- align with hearts

        -- Draw background panel
        if uiImages.panel_1 then
            local panelImage = uiImages.panel_1
            local panelW, panelH = 144, 144  -- from config
            -- Calculate bounding box
            local padding = 32  -- tilesize padding inside panel
            local approxTextWidth = fontTiny:getWidth("SPD: 99")  -- approximate max text width
            local targetLeft = heartsX
            local targetRight = math.max(facesetX + targetFaceset:getWidth() * 4, attrX + approxTextWidth)
            local targetTop = nameY
            local targetBottom = facesetY + targetFaceset:getHeight() * 4
            -- Ensure panel doesn't enter the center gap (leave square gap centered)
            local centerX = VIRTUAL_WIDTH / 2
            local gapSize = 144  -- square gap
            local gapRight = centerX + gapSize / 2
            targetLeft = math.max(targetLeft, gapRight + margin)
            -- Add padding to the panel area
            local panelLeft = targetLeft - margin - padding
            local panelTop = targetTop - margin - padding
            local panelRight = targetRight + margin + padding
            local panelBottom = targetBottom + margin + padding
            local panelScaleX = (panelRight - panelLeft) / panelW
            local panelScaleY = (panelBottom - panelTop) / panelH
            love.graphics.setColor(1, 1, 1, 0.6)  -- increased transparency
            love.graphics.draw(panelImage, panelLeft, panelTop, 0, panelScaleX, panelScaleY)
            love.graphics.setColor(1, 1, 1, 1)
        end

        -- Draw hearts
        for i = 1, numHearts do
            local hpRemaining = targetChar.hp - (i-1)*4
            local fillLevel = math.max(0, math.min(4, hpRemaining))
            local frame = math.floor(fillLevel) + 1
            local row = math.floor((i-1) / 4) + 1
            local col = ((i-1) % 4) + 1
            local x = heartsX + (col-1) * heartSpacing
            local y = heartsY + (row-1) * heartSpacing
            love.graphics.draw(heartImage, heartQuads[frame], x, y)
        end

        -- Draw attributes
        love.graphics.setFont(fontTiny)
        love.graphics.print("PWR: " .. targetChar.pwr, attrX, statsY + 0 * statLineHeight)
        love.graphics.print("DEF: " .. targetChar.def, attrX, statsY + 1 * statLineHeight)
        love.graphics.print("DEX: " .. targetChar.dex, attrX, statsY + 2 * statLineHeight)
        love.graphics.print("SPD: " .. targetChar.spd, attrX, statsY + 3 * statLineHeight)
        love.graphics.print("RNG: " .. targetChar.rng, attrX, statsY + 4 * statLineHeight)
    end

    -- Draw character name (after panel so it's on top)
    love.graphics.setFont(fontMed)
    love.graphics.print(targetChar.class, VIRTUAL_WIDTH - textX, nameY)

    -- Draw faceset
    love.graphics.draw(targetFaceset, facesetX, facesetY, 0, 4, 4)
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
