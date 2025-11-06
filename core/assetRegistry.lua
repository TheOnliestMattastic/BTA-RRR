-- core/assetRegistry.lua
local anim8 = require "lib/anim8"

-- compatibility: Lua 5.1 has global `unpack`, 5.2+ exposes `table.unpack`
local _unpack = table and table.unpack or unpack

local AssetRegistry = {}
AssetRegistry.__index = AssetRegistry

local function loadImage(path)
    local img = love.graphics.newImage(path)
    img:setFilter("nearest", "nearest")
    return img
end

local function makeAnimation(image, frameW, frameH, frames, duration)
    local grid = anim8.newGrid(frameW, frameH, image:getWidth(), image:getHeight())
    -- frames is a list like {"1-5", 1} or {"1-4", "1-2"}
    local anim = anim8.newAnimation(grid(_unpack(frames)), duration, "pauseAtEnd")
    return anim
end

function AssetRegistry.new()
    local self = setmetatable({}, AssetRegistry)
    self.tilesets = {}
    self.fx = {}         -- tag -> { image, protoAnim }
    self.characters = {} -- class -> { image, grid, animDefs }
    self.facesets = {}   -- class -> image
    self.ui = {}         -- tag -> image
    self.fonts = {}      -- tag -> font
    return self
end

-- Load tilesets from config/tilesets.lua
function AssetRegistry:loadTilesets(configModule)
    local cfg = require(configModule or "config.tilesets")
    for tag, def in pairs(cfg) do
        local image = loadImage(def.path)
        self.tilesets[tag] = {
            image  = image,
            frameW = def.frameW,
            frameH = def.frameH,
            grid   = anim8.newGrid(def.frameW, def.frameH, image:getWidth(), image:getHeight())
        }
    end
end

-- Get tileset by tag
function AssetRegistry:getTileset(tag)
    local entry = self.tilesets[tag]
    if not entry then return nil end
    return {
        image  = entry.image,
        frameW = entry.frameW,
        frameH = entry.frameH,
        grid   = entry.grid
    }
end

-- Load FX from config/fx.lua
function AssetRegistry:loadFX(configModule)
    local cfg = require(configModule or "config.fx")
    for tag, def in pairs(cfg) do
        local image = loadImage(def.path)
        local anim  = makeAnimation(image, def.frameW, def.frameH, def.frames, def.duration)
        self.fx[tag] = { image=image, protoAnim=anim }
    end
end

-- Load character animations from config/characters.lua
function AssetRegistry:loadCharacters(configModule)
	local cfg = require(configModule or "config.characters")
	for class, def in pairs(cfg) do
		local image = loadImage(def.path)
		local grid = anim8.newGrid(def.frameW, def.frameH, image:getWidth(), image:getHeight())

		-- Store animation definitions to create them dynamically based on direction
		self.characters[class] = {
			image=image,
			grid=grid,
			animDefs=def.animations
		}
	end
end

-- Load facesets from config/characters.lua
function AssetRegistry:loadFacesets(configModule)
	local cfg = require(configModule or "config.characters")
	for class, def in pairs(cfg) do
		if def.faceset then
			self.facesets[class] = loadImage(def.faceset)
		end
	end
end

-- Load UI elements from config/ui.lua
function AssetRegistry:loadUI(configModule)
    local cfg = require(configModule or "config.ui")
    for tag, def in pairs(cfg) do
        if def.path and (def.frameW or def.frames) then
            self.ui[tag] = loadImage(def.path)
        end
    end
end

-- Load fonts from config/ui.lua
function AssetRegistry:loadFonts(configModule)
	local cfg = require(configModule or "config.ui")
	for tag, def in pairs(cfg) do
		if def.path and def.size then
			self.fonts[tag] = love.graphics.newFont(def.path, def.size)
        end
    end
end

-- Get FX clone by tag
function AssetRegistry:getFX(tag)
    local entry = self.fx[tag]
    if not entry then return nil end
    return { image=entry.image, anim=entry.protoAnim:clone() }
end

-- Get character data by class (image, grid, animation definitions)
function AssetRegistry:getCharacter(class)
    local entry = self.characters[class]
    if not entry then return nil end
    return {
        image=entry.image,
        grid=entry.grid,
        animDefs=entry.animDefs
    }
end

-- Get faceset image by class
function AssetRegistry:getFaceset(class)
    return self.facesets[class]
end

-- Get UI image by tag
function AssetRegistry:getUI(tag)
    return self.ui[tag]
end

-- Get font by tag
function AssetRegistry:getFont(tag)
    return self.fonts[tag]
end

return AssetRegistry
