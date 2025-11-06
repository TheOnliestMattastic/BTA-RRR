# AGENT.md - Battle Tactics Arena: Refactored & Remastered

This is the AGENT.md file for the BTAR-R project. It serves as the ground truth for commands, style, structure, and best practices. Use this to maintain consistency across the codebase.

## Project Overview

Battle Tactics Arena (BTAR-R) is a 2D turn-based tactical RPG prototype built with Lua and LÖVE2D. The game features grid-based combat, character classes, AP economy, and modular architecture.

Key folders:

- `/core`: Game logic modules (character, map, gameState, ui, etc.)
- `/config`: Data-driven definitions (characters, fx, tilesets)
- `/states`: Game states (menu, game)
- `/assets`: Sprites, tilesets, UI elements, fonts
- `/lib`: Third-party libraries (anim8)

## Code Style and Structure

### Best Practices

- Use modular design: separate concerns into different files/modules.
- Avoid global variables; use local tables and require statements.
- Data-driven configs: add new content via config files without touching core logic.
- Encapsulate entities: use metatables for OOP-like structures.
- Comment blocks: add short, descriptive comments for each major block.
- Error handling: use pcall for risky operations (e.g., drawing, updating).
- Consistent naming: camelCase for variables/functions, PascalCase for modules.

### ADHD-Friendly Reminder Comments

Add short reminder comments at the start of each code block to jumpstart memory. Examples:

- `-- Init: Load modules and set up game state`
- `-- Draw: Render map, characters, and UI`
- `-- Update: Handle animations and game logic`

These comments should be 1-2 words followed by a colon and brief description.

## Core Modules

### core/gameInit.lua

- **Init Block**: `-- Load: Require all core modules and configs`
- **Setup Block**: `-- Create: Instantiate registries and load assets`
- **Init Function**: `-- Bootstrap: Initialize game state and helpers`

### core/character.lua

- **Constructor**: `-- Create: New character with stats and sprites`
- **Update**: `-- Animate: Update walking and animation states`
- **Draw**: `-- Render: Draw character sprite if alive`
- **Combat**: `-- Damage: Reduce HP and check death`
- **Heal**: `-- Restore: Increase HP up to max`
- **Movement**: `-- Move: Animate movement to target position`
- **Animation**: `-- Set: Configure animations from registry`
- **Checks**: `-- Ally: Check team alignment`
- **Attack**: `-- Can Attack: Validate basic attack possibility`

### core/gameState.lua

- **Constructor**: `-- New State: Initialize turns and AP`
- **Turn Logic**: `-- Current Team: Determine active player`
- **AP Management**: `-- Spend: Deduct action points`
- **Turn End**: `-- Next: Advance turn and reset AP`
- **Clamp**: `-- Cap: Limit AP to max values`
- **Win Check**: `-- Victory: Check for game over conditions`

### core/map.lua

- **Constructor**: `-- Build: Create map with layout and tileset`
- **Draw**: `-- Render: Draw tiles and highlight hover`
- **Hover**: `-- Detect: Check mouse over tile`
- **Highlight**: `-- Range: Show movement area for selected character`

### core/turnManager.lua

- **Active Index**: `-- Get: Current turn's active character index`
- **Active Character**: `-- Retrieve: Active character based on turn`
- **Upcoming Names**: `-- List: Names of upcoming characters in turn order`

### core/gameUI.lua

- **Draw Message**: `-- Overlay: Display game messages`
- **Draw Character Stats**: `-- UI: Render faceset and stats for characters`
- **Draw Active/Target/Upcoming**: `-- Display: Turn-based UI elements`

### states/menu.lua

- **Load**: `-- Init: Load UI assets and canvas`
- **Update**: `-- Logic: Handle button hover/press`
- **Draw**: `-- UI: Render title, button, and background`
- **Resize**: `-- Scale: Update virtual scaling`

### states/game.lua

- **Load**: `-- Setup: Initialize map, characters, and state`
- **Update**: `-- Tick: Update characters, FX, and UI`
- **Draw**: `-- Display: Render map, characters, and overlays`
- **Input**: `-- Click: Handle mouse presses for selection/movement/attacks`

## Config Files

Use config files to define data without code changes.

### config/characters.lua

- Define classes with paths, stats, and animations.
- Stats: hp, pwr, def, dex, spd, rng.

### Other Configs

- `fx.lua`: Effect definitions
- `tilesets.lua`: Tile assets

## Commands and Scripts

- **Run Game**: `./love.appimage .` (from project root)
- **Debug**: Set LOCAL_LUA_DEBUGGER_VSCODE=1 and run with "debug" arg
- **Build**: No build step; LÖVE runs directly from source
- **UI**: Custom drawing with LÖVE functions; no external UI libs

## Next Steps

1. **Add More Character Classes**: Define in `config/characters.lua` and implement special abilities in `core/character.lua`.
2. **Implement Special Attacks**: Extend `Combat.lua` with skills beyond basic attacks.
3. **Add AI Opponent**: Create AI logic for enemy turns.
4. **Polish UI**: Enhance `states/menu.lua` and add in-game UI elements.
5. **Save/Load System**: Implement game state persistence.
6. **Multiplayer**: Add network support for online play.
7. **Sound Effects**: Integrate audio using LÖVE's sound module.
8. **Testing**: Add unit tests for core modules using a Lua testing framework.
9. **Documentation**: Expand README and add API docs for modules.

## Maintenance Notes

- Keep code modular; avoid monolithic files.
- Update this AGENT.md when adding new features or changing structure.
- Regularly refactor: move repeated code to helpers.
- Profile performance: Use LÖVE's debug tools for FPS and memory.
