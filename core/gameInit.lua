-- core/gameInit.lua
local Character             = require "core.character"
local GameState             = require "core.gameState"
local Map                   = require "core.map"
local GameLogic             = require "core.gameLogic"
local AssetRegistry         = require "core.assetRegistry"
local CharactersConfig      = require "config.characters"

local gameInit = {}

gameInit.Character = Character
gameInit.GameState = GameState
gameInit.Map = Map
gameInit.GameLogic = GameLogic
gameInit.AssetRegistry = AssetRegistry
gameInit.CharactersConfig = CharactersConfig

-- Create instances
gameInit.registry = AssetRegistry.new()
gameInit.tilesets = gameInit.registry  -- tilesets are now in registry
gameInit.activeFX = {}

-- Load them
gameInit.registry:loadFX()
gameInit.registry:loadCharacters()
gameInit.registry:loadTilesets()

function gameInit.init(game, characters, state)
    gameInit.GameLogic.GameHelpers.init(characters, state, game, gameInit.registry, gameInit.activeFX, gameInit.GameLogic.Combat)
end

return gameInit
