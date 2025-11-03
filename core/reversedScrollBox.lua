-- reversedScrollBox.lua
-- A module for creating a reversed scrollable list box using LÖVE's built-in drawing functions.
-- The list starts with the bottom items visible and scrolls upward to reveal items above.

local ReversedScrollBox = {}
ReversedScrollBox.__index = ReversedScrollBox

-- Constructor
function ReversedScrollBox:new(x, y, w, h, options)
    local instance = setmetatable({}, self)
    instance.x = x or 0
    instance.y = y or 0
    instance.w = w or 200
    instance.h = h or 300
    instance.items = {} -- List of items, each {text = "string", height = number, drawFn = function(x,y,w,h)}
    instance.scrollY = 0 -- Positive: scrolled up (reveals top), Negative: scrolled down
    instance.itemHeight = options and options.itemHeight or 20
    instance.scrollSpeed = options and options.scrollSpeed or 20
    instance.isDragging = false
    instance.dragStartY = 0
    instance.scrollStartY = 0
    instance.maxScroll = 0 -- Will be calculated based on total height
    instance.minScroll = 0 -- Usually 0
    return instance
end

-- Add an item to the list
function ReversedScrollBox:addItem(item)
    -- item can be a string or a table {text = "", height = , drawFn = function(x,y,w,h)}
    if type(item) == "string" then
        item = {text = item, height = self.itemHeight}
    end
    item.height = item.height or self.itemHeight
    table.insert(self.items, item)
    self:calculateMaxScroll()
end

-- Calculate the maximum scroll value (how far up we can scroll)
function ReversedScrollBox:calculateMaxScroll()
    local totalHeight = 0
    for _, item in ipairs(self.items) do
        totalHeight = totalHeight + item.height
    end
    self.maxScroll = math.max(0, totalHeight - self.h)
    -- Clamp scrollY
    self.scrollY = math.max(self.minScroll, math.min(self.maxScroll, self.scrollY))
end

-- Update function (handle input)
function ReversedScrollBox:update(dt)
    local mx, my = love.mouse.getPosition()
    local inBounds = mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h

    -- Mouse wheel scrolling
    if inBounds then
        local wheelX, wheelY = love.wheelmoved()
        if wheelY ~= 0 then
            self.scrollY = self.scrollY - wheelY * self.scrollSpeed
            self.scrollY = math.max(self.minScroll, math.min(self.maxScroll, self.scrollY))
        end
    end

    -- Dragging
    if self.isDragging then
        local dy = my - self.dragStartY
        self.scrollY = self.scrollStartY - dy
        self.scrollY = math.max(self.minScroll, math.min(self.maxScroll, self.scrollY))
    end
end

-- Handle mouse press
function ReversedScrollBox:mousepressed(x, y, button)
    if button == 1 and x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h then
        self.isDragging = true
        self.dragStartY = y
        self.scrollStartY = self.scrollY
        return true -- Consumed
    end
    return false
end

-- Handle mouse release
function ReversedScrollBox:mousereleased(x, y, button)
    if button == 1 then
        self.isDragging = false
    end
end

-- Draw the scroll box
function ReversedScrollBox:draw()
    -- Set scissor for clipping
    love.graphics.setScissor(self.x, self.y, self.w, self.h)

    -- Draw background (optional)
    love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1, 1)

    -- Translate for scrolling
    love.graphics.push()
    love.graphics.translate(0, self.scrollY)

    -- Draw items from bottom to top
    local currentY = self.y + self.h - self.scrollY -- Start from bottom
    for i = #self.items, 1, -1 do
        local item = self.items[i]
        local itemY = currentY - item.height
        if itemY + item.height > self.y and itemY < self.y + self.h then -- Visible
            if item.drawFn then
                item.drawFn(self.x, itemY, self.w, item.height)
            else
                love.graphics.printf(item.text, self.x, itemY, self.w, "left")
            end
        end
        currentY = currentY - item.height
    end

    love.graphics.pop()

    -- Draw scrollbar (simple vertical bar)
    if self.maxScroll > 0 then
        local barHeight = (self.h / (self.h + self.maxScroll)) * self.h
        local barY = self.y + (self.scrollY / self.maxScroll) * (self.h - barHeight)
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
        love.graphics.rectangle("fill", self.x + self.w - 10, barY, 10, barHeight)
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- Reset scissor
    love.graphics.setScissor()
end

return ReversedScrollBox
