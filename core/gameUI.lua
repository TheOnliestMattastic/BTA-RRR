-- core/gameUI.lua
local GameUI = {}

local VIRTUAL_WIDTH = 1024
local VIRTUAL_HEIGHT = 768
local TILESIZE = 32

-- Draw message overlay
function GameUI.drawMessage(game, fontSmall)
    if game.message then
        love.graphics.setFont(fontSmall)
        love.graphics.printf(game.message, VIRTUAL_WIDTH / 4, 0, VIRTUAL_WIDTH / 2, "center")
    end
end

-- Draw active character stats
function GameUI.drawActiveStats(activeFaceset, activeChar, fontTiny, fontSmall, uiImages)
	-- Faceset
	local facesetScale = 4
	local facesetX = TILESIZE
	local facesetY = VIRTUAL_HEIGHT - TILESIZE - activeFaceset:getHeight() * facesetScale
    if activeFaceset then
       love.graphics.draw(activeFaceset, facesetX, facesetY, 0, facesetScale, facesetScale)
	end

	-- Name
	local nameX = facesetX + activeFaceset:getWidth() * facesetScale + TILESIZE / 4
	love.graphics.setFont(fontSmall)
	if activeChar.class then
		love.graphics.print(activeChar.class, nameX, facesetY)
	end

	-- AP
	local apScale = 1.9
	local apX = facesetX + activeFaceset:getWidth() * facesetScale
	local apY = VIRTUAL_HEIGHT - TILESIZE - uiImages.receptacle:getHeight() * apScale
	if uiImages then
		love.graphics.draw(uiImages.receptacle, apX, apY, 0, apScale, apScale)
	end

	-- Hearts
	local heartsX = apX + uiImages.receptacle:getWidth() * apScale + TILESIZE / 8
	local heartsY = apY
	local heartSpacing = 4
	local heartsPerRow = 4

	if uiImages.heart and activeChar then
		-- Calculate number of heart containers based on maxHP (1 heart = 4 HP)
		local heartsToShow = math.ceil(activeChar.maxHP / 4)

		-- Create quads for each frame (5 frames: empty, 1/4, 1/2, 3/4, full)
		local heartW = 16
		local heartH = 16
		local heartQuads = {
			love.graphics.newQuad(0, 0, heartW, heartH, uiImages.heart:getDimensions()),      -- Frame 1: empty
			love.graphics.newQuad(16, 0, heartW, heartH, uiImages.heart:getDimensions()),     -- Frame 2: 1/4
			love.graphics.newQuad(32, 0, heartW, heartH, uiImages.heart:getDimensions()),     -- Frame 3: 1/2
			love.graphics.newQuad(48, 0, heartW, heartH, uiImages.heart:getDimensions()),     -- Frame 4: 3/4
			love.graphics.newQuad(64, 0, heartW, heartH, uiImages.heart:getDimensions()),     -- Frame 5: full
		}

		-- Draw each heart container
		for i = 1, heartsToShow do
			-- Calculate row and column for grid layout
			local row = math.floor((i - 1) / heartsPerRow)
			local col = (i - 1) % heartsPerRow
			local x = heartsX + col * (heartW + heartSpacing)
			local y = heartsY + row * (heartH + heartSpacing)

			-- Determine heart frame based on HP
			-- 1 HP = 1/4 heart, so 4 HP = 1 full heart
			local hpPerHeart = 4
			local hpThreshold = (i - 1) * hpPerHeart
			local heartFrame = 1  -- Default empty frame

			if activeChar.hp > hpThreshold then
				-- Heart has some HP
				local hpInThisHeart = activeChar.hp - hpThreshold
				if hpInThisHeart >= 4 then
					heartFrame = 5  -- Full heart
				elseif hpInThisHeart >= 3 then
					heartFrame = 4  -- 3/4 full
				elseif hpInThisHeart >= 2 then
					heartFrame = 3  -- Half heart
				elseif hpInThisHeart >= 1 then
					heartFrame = 2  -- 1/4 full
				end
			end

			-- Draw the heart with the appropriate frame quad
			love.graphics.draw(uiImages.heart, heartQuads[heartFrame], x, y, 0)
		end

		-- Stats text below hearts
		local statsX = heartsX
		local heartRows = math.ceil(heartsToShow / heartsPerRow)
		-- local heartsBottomY = heartsY + (heartRows - 1) * (heartH + heartSpacing) + heartH

		-- Determine bottom alignment point (same as faceset/receptacle)
		local bottomY = VIRTUAL_HEIGHT - TILESIZE
		
		-- Build stats lines
		local statsLines = {
			string.format("PWR: %d", activeChar.pwr or 0),
			string.format("DEF: %d", activeChar.def or 0),
			string.format("DEX: %d", activeChar.dex or 0),
			string.format("SPD: %d", activeChar.spd or 0),
			string.format("RNG: %d", activeChar.rng or 0),
		}
		
		-- Calculate line height and total height needed
		love.graphics.setFont(fontTiny)
		local lineHeight = fontTiny:getHeight() + 2
		local totalStatsHeight = #statsLines * lineHeight
		
		-- Calculate starting Y so last line aligns to bottomY
		local startY = bottomY - totalStatsHeight
		
		-- Draw each stat line
		for idx, line in ipairs(statsLines) do
			local y = startY + (idx - 1) * lineHeight
			love.graphics.print(line, statsX, y)
		end
	end
	
end

-- Draw target character stats
function GameUI.drawTargetStats(targetFaceset, targetChar, fontTiny, fontSmall, uiImages)
	-- Faceset
	local facesetScale = 4
	local facesetX = VIRTUAL_WIDTH - TILESIZE - targetFaceset:getWidth() * facesetScale
	local facesetY = VIRTUAL_HEIGHT - TILESIZE - targetFaceset:getHeight() * facesetScale
	if targetFaceset then
		love.graphics.draw(targetFaceset, facesetX, facesetY, 0, facesetScale, facesetScale)
	end

	-- Name
	love.graphics.setFont(fontSmall)
	if targetChar and targetChar.class then
		local nameX = facesetX - fontSmall:getWidth(targetChar.class) - TILESIZE / 4
		love.graphics.print(targetChar.class, nameX, facesetY)
	end

	-- Hearts
	local heartsX = facesetX - uiImages.heart:getWidth() - 4
	local heartsY = VIRTUAL_HEIGHT - TILESIZE - uiImages.receptacle:getHeight() * 1.9 -- AP scale
	local heartSpacing = 4
	local heartsPerRow = 4

	if uiImages.heart and targetChar then
		-- Calculate number of heart containers based on maxHP (1 heart = 4 HP)
		local heartsToShow = math.ceil(targetChar.maxHP / 4)

		-- Create quads for each frame (5 frames: empty, 1/4, 1/2, 3/4, full)
		local heartW = 16
		local heartH = 16
		local heartQuads = {
			love.graphics.newQuad(0, 0, heartW, heartH, uiImages.heart:getDimensions()),      -- Frame 1: empty
			love.graphics.newQuad(16, 0, heartW, heartH, uiImages.heart:getDimensions()),     -- Frame 2: 1/4
			love.graphics.newQuad(32, 0, heartW, heartH, uiImages.heart:getDimensions()),     -- Frame 3: 1/2
			love.graphics.newQuad(48, 0, heartW, heartH, uiImages.heart:getDimensions()),     -- Frame 4: 3/4
			love.graphics.newQuad(64, 0, heartW, heartH, uiImages.heart:getDimensions()),     -- Frame 5: full
		}

		-- Draw each heart container
		for i = 1, heartsToShow do
			-- Calculate row and column for grid layout
			local row = math.floor((i - 1) / heartsPerRow)
			local col = (i - 1) % heartsPerRow
			local x = heartsX + col * (heartW + heartSpacing)
			local y = heartsY + row * (heartH + heartSpacing)

			-- Determine heart frame based on HP
			-- 1 HP = 1/4 heart, so 4 HP = 1 full heart
			local hpPerHeart = 4
			local hpThreshold = (i - 1) * hpPerHeart
			local heartFrame = 1  -- Default empty frame

			if targetChar.hp > hpThreshold then
				-- Heart has some HP
				local hpInThisHeart = targetChar.hp - hpThreshold
				if hpInThisHeart >= 4 then
					heartFrame = 5  -- Full heart
				elseif hpInThisHeart >= 3 then
					heartFrame = 4  -- 3/4 full
				elseif hpInThisHeart >= 2 then
					heartFrame = 3  -- Half heart
				elseif hpInThisHeart >= 1 then
					heartFrame = 2  -- 1/4 full
				end
			end

			-- Draw the heart with the appropriate frame quad
			love.graphics.draw(
				uiImages.heart,
				heartQuads[heartFrame],
				x, y,
				0
			)
		end

		-- Stats text below hearts
		local statsX = heartsX
		local heartRows = math.ceil(heartsToShow / heartsPerRow)
		local heartsBottomY = heartsY + (heartRows - 1) * (heartH + heartSpacing) + heartH

		-- Determine bottom alignment point (same as faceset)
		local bottomY = VIRTUAL_HEIGHT - TILESIZE

		-- Build stats lines
		local statsLines = {
			string.format("PWR: %d", targetChar.pwr or 0),
			string.format("DEF: %d", targetChar.def or 0),
			string.format("DEX: %d", targetChar.dex or 0),
			string.format("SPD: %d", targetChar.spd or 0),
			string.format("RNG: %d", targetChar.rng or 0),
		}

		-- Calculate line height and total height needed
		love.graphics.setFont(fontTiny)
		local lineHeight = fontTiny:getHeight() + 2
		local totalStatsHeight = #statsLines * lineHeight

		-- Calculate starting Y so last line aligns to bottomY
		local startY = bottomY - totalStatsHeight

		-- Draw each stat line
		for idx, line in ipairs(statsLines) do
			local y = startY + (idx - 1) * lineHeight
			love.graphics.print(line, statsX, y)
		end
	end
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
