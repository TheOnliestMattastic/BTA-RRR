# AGENT.md – Battle Tactics Arena: Refactored & Remastered

**BTAR-R** is a 2D turn-based tactical RPG built with Lua and LÖVE2D. Two players alternate turns, spending Action Points to move, attack, or heal on a grid-based map. Features Vim-style keybindings (hjkl) as a learning tool.

## Quick Reference

| Item | Details |
|------|---------|
| **Run** | `./love.appimage .` or `love .` |
| **Resolution** | 1024×768 virtual, scaled to window |
| **Tile Size** | 32×32 pixels |
| **Turn System** | Initiative d20 + SPD; +2 AP per turn (max 4) |
| **Input** | hjkl (Vim), arrows/WASD (fallback), space (end turn), ESC (quit) |

## Directory Structure

```
/assets          → Sprites, tilesets, facesets, UI, fonts
/core            → Game logic modules
/config          → Data definitions (characters, tilesets, FX, UI)
/states          → Game states (menu, game)
/lib             → Third-party libraries (anim8)
main.lua         → Entry point with state machine
conf.lua         → LÖVE config
```

## Core Modules Summary

| Module | Purpose |
|--------|---------|
| **gameInit.lua** | Bootstraps registries and asset loading |
| **character.lua** | Character encapsulation: stats, sprites, animations, damage/heal |
| **gameState.lua** | Turn progression, AP clamping, win conditions |
| **map.lua** | 32×32 tile grid, hover detection, range highlighting |
| **turnManager.lua** | Initiative rolls (d20 + SPD), turn order management |
| **gameLogic.lua** | Combat: range check, hit/miss/dodge rolls, damage calculation |
| **gameUI.lua** | Renders stats panels, action menu, turn order, messages |
| **inputHandler.lua** | Centralized input: Vim-first, WASD/arrow fallback, button tracking |
| **assetRegistry.lua** | Single cache for all assets (tilesets, characters, FX, UI, fonts) |

## Config Files

- **config/characters.lua** – Character classes with stats, sprites, animations
- **config/tilesets.lua** – Tileset sprites for map generation
- **config/fx.lua** – Visual effects with animation frames
- **config/ui.lua** – UI assets, buttons, panels, fonts

## Game Flow

1. **Menu** (`states/menu.lua`) – Start button → Game
2. **Game Init** (`gameInit.lua`) – Load assets, init registries, create map/characters
3. **Game Loop** (`states/game.lua`):
   - Update: Animations, FX, game logic
   - Draw: Map, characters, FX, UI
   - Input: hjkl movement, click to move/attack, space to end turn
   - Win: When a team is eliminated

## Combat System

1. **Range Check**: Target within `attacker.rng`?
2. **Accuracy**: `60 + attacker.dex * 8` vs random 0-100
3. **Dodge**: `defender.dex * 5` vs random 0-100
4. **Damage**: `max(1, attacker.pwr - defender.def)`
5. **Result**: "hit", "miss", or "dodge"

All formulas defined in `gameLogic.CONFIG`.

## AP Economy

- Gain +2 AP per turn
- Clamped to max 4 per character
- Attack costs 1 AP, Heal costs 2 AP
- No movement cost (planned feature)

## Code Practices

- **Modular**: Each module does one thing
- **Local scope**: Use `local` for all variables
- **Data-driven**: Content in `/config`, logic in `/core`
- **OOP**: Metatables with `Module.__index = Module` pattern
- **Comments**: ADHD-friendly reminders (`-- Init:`, `-- Draw:`, etc.)
- **Naming**: `camelCase` functions, `PascalCase` modules, `SCREAMING_SNAKE_CASE` constants
- **Error Handling**: `pcall()` for risky drawing/updates

## Virtual Resolution System

All drawing/input uses fixed **1024×768** virtual coordinates, scaled to window:
```lua
local vx = (screenX - translateX) / scale
local vy = (screenY - translateY) / scale
```

## Adding Content

### New Character Class
1. Add to `config/characters.lua` with stats, animations
2. Place sprite sheet: `assets/sprites/chars/{className}/SpriteSheet.png` (16×16 frames)
3. Place faceset: same directory as `Faceset.png` (38×38)

### New Tileset
1. Add to `config/tilesets.lua`
2. Place sprite sheet in `assets/sprites/tilesets/`

### New UI Element
1. Add sprite to `assets/sprites/ui/`
2. Add entry to `config/ui.lua`
3. Load via `registry:getUI(tag)`

### New Effect
1. Add sprite sheet to `assets/sprites/fx/`
2. Add entry to `config/fx.lua`
3. Trigger in `gameLogic.lua` when needed

## Current State

- ✓ Two-character matchups (ninjaBlack vs gladiatorBlue)
- ✓ Grid-based movement and combat
- ✓ Initiative system
- ✗ Special abilities (planned)
- ✗ AI opponents (planned)
- ✗ Level selection (planned)
- ✗ Audio (planned)
- ✗ Save/load (planned)

## Development Notes

- **Asset Loading**: Registry caches all assets; no redundant I/O
- **Animations**: `anim8` library; reused across characters
- **Grid Queries**: Linear scans for movement/attack range (optimize if needed)
- **Input**: Press-on-release pattern for buttons
- **Refactoring**: Prioritize readability; explain trade-offs when consolidating logic
- **Serena Tools**: Available for symbol search, refactoring, pattern matching

## Key Files to Know

- **main.lua** – State machine and LÖVE callbacks
- **core/gameInit.lua** – Asset bootstrap; update when adding new assets
- **config/** – All game content; safe to modify without breaking logic
- **states/game.lua** – Main game loop; input dispatch and rendering

---

**Philosophy**: Modularity over clever code. Data-driven over hard-coded. Clarity for humans first.
