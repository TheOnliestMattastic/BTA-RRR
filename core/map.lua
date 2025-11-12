-- core/map.lua
local Map = {}
Map.__index = Map

function Map.new(tileSize, layout, tilesetRegistry, tilesetTag)
    local self = setmetatable({}, Map)

    self.tileSize = tileSize or 32
    self.layout = layout or {} -- 2D array of tile tags (strings)
    self.tileset = tilesetRegistry:getTileset(tilesetTag)

    self.rows = #self.layout
    self.cols = #self.layout[1] or 0
    self.width = self.cols * self.tileSize
    self.height = self.rows * self.tileSize

    -- Position map left-center with 32px padding from turn order menu
    local VIRTUAL_WIDTH = 1024
    local TURN_ORDER_WIDTH = 104  -- Approximate width of turn order UI
    self.offsetX = TURN_ORDER_WIDTH + 32
    self.offsetY = self.tileSize

    -- Breathing animation for cursor tile
    self.breatheTime = 0
    self.breatheSpeed = 2  -- seconds for full breathing cycle
    self.breatheAmount = 2  -- pixels to scale (1-2px)

    return self
end

-- Update: Handle breathing animation
function Map:update(dt)
    self.breatheTime = (self.breatheTime + dt) % self.breatheSpeed
end

-- Draw the map
function Map:draw(mouseX, mouseY, inputFocus, uiImages, inputHandler)
    self.hoveredTileX = nil
    self.hoveredTileY = nil
    for rowIndex, row in ipairs(self.layout) do
        for colIndex, tileTag in ipairs(row) do
            local x = (colIndex - 1) * self.tileSize + self.offsetX
            local y = (rowIndex - 1) * self.tileSize + self.offsetY

            -- Each tileTag corresponds to a frame in the tileset grid
            -- Example: "1,1" means column 1, row 1 in the grid
            local col, row = tileTag:match("(%d+),(%d+)")
            col, row = tonumber(col), tonumber(row)

            -- anim8's grid(col,row) returns a list of quads (frames).
            -- Use the first returned frame as the quad to draw.
            local frames = self.tileset.grid(col, row)
            local quad = nil
            if type(frames) == 'table' then quad = frames[1] end
            if quad then
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(self.tileset.image, quad, x, y)
            else
                -- fallback: draw a placeholder rectangle if quad missing
                love.graphics.setColor(1,0,1,0.5)
                love.graphics.rectangle("fill", x, y, self.tileSize, self.tileSize)
            end

            -- Track: Store hovered tile position for cursor drawing later (mouse focus)
            if inputFocus == "mouse" and self:isHovered(x, y, mouseX, mouseY) then
                self.hoveredTileX = x
                self.hoveredTileY = y
            end
            
            -- Track: Store keyboard cursor position (map focus)
            if inputFocus == "keyboard" and inputHandler then
                local cursorX, cursorY = inputHandler:getMapCursor()
                if cursorX and cursorY and colIndex - 1 == cursorX and rowIndex - 1 == cursorY then
                    self.hoveredTileX = x
                    self.hoveredTileY = y
                end
            end
        end
    end
end

-- Draw: Cursor tile with breathing effect (call this after all other draws)
function Map:drawCursor(uiImages)
    if self.hoveredTileX and self.hoveredTileY and uiImages and uiImages.cursorTile then
        -- Base scale to fit cursor tile to 32x32 tile size (cursorTile is 26x26)
        local baseScale = self.tileSize / uiImages.cursorTile:getWidth()
        
        -- Calculate breathing effect (oscillates 0 to breatheAmount pixels)
        local breatheFactor = (math.sin((self.breatheTime / self.breatheSpeed) * math.pi * 2) + 1) / 2
        local breatheScale = breatheFactor * self.breatheAmount / self.tileSize
        local scale = baseScale + breatheScale
        
        -- Center the scaled sprite on the tile
        local cursorW = uiImages.cursorTile:getWidth()
        local cursorH = uiImages.cursorTile:getHeight()
        local scaledW = cursorW * scale
        local scaledH = cursorH * scale
        local offsetX = (self.tileSize - scaledW) / 2
        local offsetY = (self.tileSize - scaledH) / 2
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(uiImages.cursorTile, self.hoveredTileX + offsetX, self.hoveredTileY + offsetY, 0, scale, scale)
    end
end

function Map:isHovered(x, y, mouseX, mouseY)
     return mouseX > x and mouseX < x + self.tileSize
        and mouseY > y and mouseY < y + self.tileSize
 end

function Map:getHoveredTile(mouseX, mouseY)
    for rowIndex = 1, self.rows do
        for colIndex = 1, self.cols do
            local x = (colIndex - 1) * self.tileSize + self.offsetX
            local y = (rowIndex - 1) * self.tileSize + self.offsetY
            if self:isHovered(x, y, mouseX, mouseY) then
                return {colIndex - 1, rowIndex - 1}
            end
        end
    end
    return nil
end

function Map:highlightMovementRange(selectedChar, isOccupied)
	if not selectedChar then return end
	love.graphics.setColor(0, 1, 0, 0.3)
	for row = 0, self.rows - 1 do
		for col = 0, self.cols - 1 do
			local dist = math.abs(col - selectedChar.x) + math.abs(row - selectedChar.y)
			if dist <= selectedChar.spd and not isOccupied(col, row) then
				love.graphics.rectangle("fill", col * self.tileSize + self.offsetX, row * self.tileSize + self.offsetY, self.tileSize, self.tileSize)
			end
		end
	end
end

function Map:highlightAttackRange(selectedChar)
	if not selectedChar then return end
	love.graphics.setColor(1, 0, 0, 0.3)
	for row = 0, self.rows - 1 do
		for col = 0, self.cols - 1 do
			local dist = math.abs(col - selectedChar.x) + math.abs(row - selectedChar.y)
			if dist <= selectedChar.rng and dist > 0 then
				love.graphics.rectangle("fill", col * self.tileSize + self.offsetX, row * self.tileSize + self.offsetY, self.tileSize, self.tileSize)
			end
		end
	end
end
love.graphics.setColor(1, 1, 1, 1)

return Map
