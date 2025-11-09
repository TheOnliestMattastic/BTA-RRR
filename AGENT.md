# AGENT.md – Battle Tactics Arena: Refactored & Remastered

This is the ground truth for the BTAR-R project. It documents the current codebase structure, best practices, and communication guidelines.

## Project Overview

**Battle Tactics Arena (BTAR-R)** is a 2D turn-based tactical RPG prototype built with Lua and LÖVE2D. The game features:

- Grid-based combat on randomized tilesets
- Multiple character classes (ninja, gladiator, mage, ranger, etc.)
- Action Point (AP) economy for strategic gameplay
- Animated characters and visual effects powered by `anim8`
- Modular, data-driven architecture
- **Vim-style keybindings** (hjkl navigation) as a learning tool

**Core Concept**: Two players alternate turns on the same machine, spending AP to move, attack, or heal. First team to eliminate all enemies wins.

**Secondary Objective**: Serve as a practice environment for Vim-style text/object manipulation. Players learn navigational muscle memory through hjkl keybindings while enjoying a strategic tactical game.

### Directory Structure

```
/assets          → Sprites, tilesets, facesets, UI, fonts
/core            → Game logic modules (character, map, gameState, UI, combat)
/config          → Data-driven definitions (characters, tilesets, FX, UI)
/states          → Game state controllers (menu, game)
/lib             → Third-party libraries (anim8)
main.lua         → Entry point with state machine
conf.lua         → LÖVE configuration (version, window defaults)
```

---

## AI Assistant Role: Coding Mentor

I act as your **Coding Mentor** and specialist guide for this project. While you are the project manager and decision-maker, I serve to:

- **Teach Best Practices**: Explain architectural decisions, design patterns, and why certain approaches are preferred over others.
- **Provide Guidance**: Offer recommendations on code structure, refactoring opportunities, and improvements.
- **Correct Issues**: Flag potential bugs, performance concerns, and anti-patterns when encountered.
- **Explain Trade-offs**: When multiple valid approaches exist (e.g., explicit code vs. loops), explain the reasoning behind recommended choices.
- **Support Learning**: Provide rationale behind decisions so you understand the "why" behind recommendations, not just the "what."

All guidance respects your final say as project manager, but I will actively mentor and suggest improvements.

---

## Code Style and Structure

### Best Practices

- **Modular Design**: Separate concerns into focused modules; avoid monolithic files.
- **Local Scope**: Minimize global variables; use `local` for all variables and functions.
- **Data-Driven Configs**: Define content (characters, tilesets, FX, UI) in `/config` without touching core logic.
- **OOP Patterns**: Use metatables for encapsulation (e.g., `Module.__index = Module`).
- **Descriptive Comments**: Use ADHD-friendly reminder comments at the start of code blocks.
- **Error Handling**: Wrap risky operations (drawing, updates) in `pcall()` where appropriate.
- **Naming Conventions**: 
  - `camelCase` for variables and functions
  - `PascalCase` for module names
  - `SCREAMING_SNAKE_CASE` for constants

### ADHD-Friendly Reminder Comments

Add short, context-setting comments at the start of major code blocks:

```lua
-- Init: Load modules and set up game state
-- Draw: Render map, characters, and UI
-- Update: Handle animations and game logic
```

Format: 1-2 words, colon, brief description.

---

## Core Modules

### core/gameInit.lua

Bootstraps the game by initializing registries and loading all assets.

- **Load Modules**: Requires all core modules and config files
- **Create Registries**: Instantiates `AssetRegistry` and populates it with tilesets, characters, FX, UI, fonts
- **Init Function**: Called by `states/game.lua` to set up game state helpers

Key: This is the single entry point for asset management.

### core/character.lua

Encapsulates individual character data and behavior.

- **Constructor**: `Character.new(class, x, y, stats, tags)` – Creates a character with position, stats, and sprites
- **Update**: Handles walking animation and state transitions
- **Draw**: Renders character sprite at grid position; respects alive/dead state
- **Damage**: `takeDamage(amount)` – Reduces HP and checks for death
- **Heal**: `heal(amount)` – Restores HP up to max
- **Movement**: `moveTo(x, y)` – Animates character walk to new tile
- **Animation**: `setAnimations(charDef)` – Sets up idle/walk/attack animations from registry
- **Checks**: `isAlly(otherChar)` – Compares team alignment
- **Attack**: `canBasicAttack(target)` – Validates attack feasibility

Key: Characters are fully encapsulated. All interactions go through methods.

### core/gameState.lua

Manages game state: turn progression, turn order, and win conditions.

- **Constructor**: `GameState.new()` – Initializes turn counter and empty turn order
- **Active Character**: `getActiveCharacter()` – Returns character at current position in turn order
- **Turn Progression**: `endTurn()` – Advances turn counter to next character in initiative order
- **AP Clamping**: `clampAP(characters)` – Limits each character's AP to max (4)
- **Win Condition**: `checkWin()` – Sets `over=true` and `winner` when a team is eliminated

Key: Separates game logic from rendering and input. Turn order is set by TurnManager during game init.

### core/map.lua

Manages the tile grid and hover/range highlighting.

- **Constructor**: Positions map relative to turn order UI (32px padding)
- **Draw**: Renders all tiles using tileset grid; highlights hovered tiles
- **Hover Detection**: `getHoveredTile(mx, my)` – Returns `{col, row}` or `nil`
- **Movement Range**: `highlightMovementRange(char, isOccupied)` – Draws movement area
- **Attack Range**: `highlightAttackRange(char)` – Draws attackable tiles

Key: Assumes 32px tiles; all coordinates are grid-based (0-indexed).

### core/turnManager.lua

Manages turn order and initiative calculations.

- **Initiative Rolls**: `rollInitiative(characters)` – Rolls d20 for each character, adds SPD stat, returns sorted results (highest first)
- **Set Turn Order**: `setTurnOrder(state, characters, initiativeRolls)` – Reorders characters based on initiative rolls
- **Active Index**: `getActiveIndex(state, characters)` – Returns current character's index in turn order
- **Active Character**: `getActiveCharacter(state, characters)` – Returns current character object
- **Upcoming Names**: `getUpcomingNames(state, characters, count)` – Returns list of next N characters' classes
- **Facesets**: `prepareUpcomingFacesets(names, facesets)` – Pairs names with faceset images

Key: Handles initiative calculation (d20 + SPD modifier) and maintains turn order throughout the game.

### core/gameLogic.lua

Houses combat and game mechanics.

**Combat module:**
- `Combat.inRange(attacker, target)` – Checks Manhattan distance against attacker's range
- `Combat.resolveHit(attacker, defender)` – Rolls accuracy and dodge; returns "hit", "miss", or "dodge"
- `Combat.computeDamage(attacker, defender)` – Calculates damage (power - defense, minimum 1)
- `Combat.isAlly(char1, char2)` – Checks if characters are on same team

**GameHelpers module:**
- `findCharacterAt(col, row)` – Returns character at grid position or `nil`
- `handleSelection(clickedChar)` – Manages character selection logic
- `performAttack(attacker, target)` – Executes attack, applies damage, manages AP

Key: Centralizes all mechanical calculations; all formulas configurable at module top.

### core/gameUI.lua

Renders all on-screen UI elements: stats panels, action menu, upcoming turn order.

- **Message Overlay**: `drawMessage(game, font)` – Displays temporary messages at screen top
- **Active Stats**: `drawActiveStats(faceset, char, fontTiny, fontSmall, uiImages, currentAP)` – Renders active character panel (left) with faceset, name, AP, HP hearts
- **Target Stats**: `drawTargetStats(faceset, char, fontTiny, fontSmall, uiImages)` – Renders target character panel (left, below active) with stats
- **Upcoming Turn Order**: `drawUpcoming(facesets, yPositions)` – Renders next 8 characters in turn order (right side)
- **Action Menu**: `drawActionMenu(activeChar, font, uiImages)` – Renders 4 labeled action buttons (right side)

**Action Menu Details:**
- Buttons labeled (top to bottom): "Navigate", "Actions", "Abilities", "Concentrate"
- Buttons use press-on-release pattern: show hover state on mouse over, pressed state while held, activate on release
- `updateActionMenu(vx, vy, uiImages)` – Updates button hover/pressed states each frame
- `actionMenuMousePressed(vx, vy, uiImages)` – Tracks button press for press-on-release behavior
- `actionMenuMouseReleased(vx, vy, uiImages)` – Triggers button action on release (if valid)

**Panel Details:**
- Active/target stats use a 3x3 grid panel (`panel_3` sprite) tiled for flexible height
- Action buttons positioned right of map with 32px padding from screen edge
- Turn order positioned on far right

Key: All UI positioning and assets are data-driven from `config/ui.lua`.

### core/assetRegistry.lua

Centralized registry for all game assets.

- **Tilesets**: `loadTilesets()` – Loads tileset sprites and creates anim8 grids
- **Characters**: `loadCharacters()` – Loads character sprites, facesets, and animation definitions
- **FX**: `loadFX()` – Loads effect sprites and animations
- **UI**: `loadUI()` – Loads button, panel, and icon sprites
- **Fonts**: `loadFonts()` – Loads TTF fonts at specified sizes
- **Getters**: `getTileset(tag)`, `getCharacter(class)`, `getUI(tag)`, etc.

Key: Single source of truth for all asset loading; prevents duplicate loads.

### core/inputHandler.lua

Centralized input handling for all game states (menu and game).

- **Constructor**: `InputHandler.new(context)` – Creates handler tied to a game state reference
- **Direction Detection**: `getVimDirection(key)` – Maps hjkl to directions
- **Alternative Keys**: `getArrowDirection(key)` – Maps WASD and arrow keys to directions
- **Direction Fallback**: `getDirection(key)` – Returns direction or nil (prioritizes Vim)
- **Movement**: `moveCharacter(direction)` – Moves selected character on grid
- **Turn Management**: `endTurn()` – Advances to next turn
- **Button Tracking**: `setButtonPressed()`, `isPressed()` – Tracks press-on-release button state

Key: Separates input logic from state files; supports multiple input methods (Vim-first, WASD/arrows as fallback).

---

## Config Files

### config/characters.lua

Defines all playable character classes. Each entry includes:

- `path` – Path to sprite sheet (16x16 frames)
- `faceset` – Path to portrait image (38x38)
- `stats` – `{hp, pwr, def, dex, spd, rng}`
- `animations` – Dictionary of animation names → frame specs
- `tags` – Optional flags (e.g., `{slash = true}`)

**Current Classes:**
- `ninjaBlack`, `ninjaBlue`, `ninjaRed`, `ninjaGreen` (4 variants)
- `gladiatorBlue`, `gladiatorRed` (2 variants)
- Extensible: Add new classes here without touching core logic

Key: All character data is immutable; stats are copied to character instances at runtime.

### config/tilesets.lua

Defines tileset sprites used for map generation.

Each entry includes:
- `path` – Path to sprite sheet
- `frameW`, `frameH` – Tile dimensions (typically 16x16)
- `frames` – Optional animation frames for animated tiles

Key: Maps are generated with random tile picks from configured tilesets.

### config/fx.lua

Defines visual effects (damage numbers, hit flash, etc.).

Each entry includes:
- `path` – Sprite sheet path
- `frameW`, `frameH` – Frame dimensions
- `frames` – Animation frame spec (e.g., `{"1-5", 1}`)
- `duration` – Animation duration in seconds

Key: FX are data-driven; new effects don't require code changes.

### config/ui.lua

Defines all UI assets: buttons, panels, bars, icons, and fonts.

- **Bars**: Meters for HP, AP, resources
- **Patterns**: Background patterns and decorative borders
- **Buttons**: Interactive buttons with multiple states (idle, hover, press)
- **Cursors**: Mouse cursor variants
- **Frames**: Border and frame elements
- **Headers**: Section headers
- **Panels**: Background panels (including 3x3 tileable `panel_3`)
- **Arrows**: Directional indicators
- **Tabs**: Tab elements for menus
- **Fonts**: Font definitions (alagard.ttf and NormalFont.ttf, sizes 12-96)

Key: All UI sprites and fonts are centralized; update here to reskin the game.

---

## Game States

### states/menu.lua

Main menu state. Renders title, start button, and background using data from `config/ui.lua`.

- **Load**: Loads button sprite and fonts from `config/ui.lua`; creates animation quads for button states
- **Update**: Tracks mouse position to determine button hover/press state
- **Draw**: Renders title, button with current state (normal/hover/pressed), centered on screen
- **Input**: Uses press-on-release pattern; button activates only on release if originally pressed on button
- **Resize**: Updates virtual scaling on window resize

**Button Behavior:**

- Press-on-release: Button shows visual press state while held, only activates when released over button
- Supports both mouse clicks and Enter key for activation
- Escape key quits the game

Key: Demonstrates best practice of loading UI config centrally; simple pass-through to `states/game.lua` when "Start" is pressed.

### states/game.lua

Main gameplay state. Manages map, characters, input, and game flow.

- **Load**: Initializes map, characters, game state, and input handler
- **Update**: Updates character animations, FX, and game logic
- **Draw**: Renders map, characters, FX, and UI elements
- **Input**: Handles mouse clicks and keyboard shortcuts via `InputHandler`
- **Resize**: Updates virtual scaling

**Input Flow:**

1. **Mouse**: Click character → select (auto-highlight movement range)
2. **Mouse**: Click empty tile → move selected character (if within range)
3. **Mouse**: Click enemy → attack (if in range and AP available)
4. **Keyboard**: hjkl (Vim) or arrows/WASD → move character
5. **Keyboard**: Space → end turn
6. **Keyboard**: Escape → quit game

Key: Input is grid-based; all coordinates converted from screen to virtual to grid. Uses `InputHandler` for centralized control logic.

---

## Virtual Resolution System

Game renders to a fixed **1024×768** virtual canvas, then scaled to window size.

**Variables:**
- `VIRTUAL_WIDTH = 1024`
- `VIRTUAL_HEIGHT = 768`
- `scale` = ratio of window to virtual dimensions
- `translateX`, `translateY` = offset to center scaled canvas

**Mouse Coordinate Conversion:**
```lua
local vx = (screenX - translateX) / scale
local vy = (screenY - translateY) / scale
```

Key: All drawing and input use virtual coordinates; no hard-coded screen positions.

---

## Turn Order and AP Economy

### Turn System

- Turn counter increments each turn (`state.turn`)
- Initiative order is calculated at game start using D&D-style rolls: d20 + character SPD modifier
- Turn order is maintained by `state.turnOrder[]`, set by TurnManager during game initialization
- When a character's turn begins, they gain 2 AP via `gainAP()`

### Action Points (AP)

- Each character has individual AP tracking (`character.ap`, max 4 per `character.maxAP`)
- **Starting AP**: Gain 2 AP per turn (clamped to max 4)
- **Reserved AP**: Players can reserve unused AP for next turn (implementation pending)
- **Movement**: No AP cost in current version (will implement later)
- **Attack**: Costs 1 AP (defined in `gameLogic.CONFIG`)
- **Heal**: Costs 2 AP (defined in `gameLogic.CONFIG`)
- AP is clamped to max 4 each frame by `GameState:clampAP(characters)`

Key: AP is now per-character, updated dynamically, and displayed via AP points in the UI.

---

## Combat System

### Attack Resolution

1. **Range Check**: Is target within `attacker.rng`?
2. **Accuracy Roll**: Compare `hitChance = 60 + attacker.dex * 8` against 0-100
3. **Dodge Roll**: Compare `dodgeChance = defender.dex * 5` against 0-100
4. **Result**: "hit", "miss", or "dodge"
5. **Damage**: `max(1, attacker.pwr - defender.def)`
6. **Apply**: Reduce target HP; trigger death if HP ≤ 0

Key: All formulas configurable in `gameLogic.CONFIG`.

---

## Asset Loading Workflow

1. **gameInit.lua** calls `AssetRegistry:loadTilesets()`, `loadCharacters()`, etc.
2. Config modules define data (no images loaded here)
3. Registry instantiates sprites, grids, and animations
4. Game state holds registry reference; modules access via `registry:getXYZ(tag)`
5. No asset is loaded twice; registry acts as cache

Key: Separation of data definition (config) from asset instantiation (registry).

---

## Development Guidelines

### Adding a New Character Class

1. Add entry to `config/characters.lua` with stats and animation frames
2. Place sprite sheet in `assets/sprites/chars/{className}/SpriteSheet.png` (16×16 frames)
3. Place faceset in same directory as `Faceset.png` (38×38)
4. Reference in `states/game.lua` to spawn (or add to level definition)

### Adding a New Tileset

1. Add entry to `config/tilesets.lua` with image path and frame dimensions
2. Place sprite sheet in `assets/sprites/tilesets/`
3. Pass tileset tag to `Map.new()` when creating map

### Adding a New UI Element

1. Add sprite to `assets/sprites/ui/`
2. Add entry to `config/ui.lua` with frame dimensions
3. Load via `registry:getUI(tag)` in `gameUI.lua` or state files

### Adding a New Effect

1. Add sprite sheet to `assets/sprites/fx/`
2. Add entry to `config/fx.lua` with animation frames
3. Trigger effect in `gameLogic.lua` when appropriate (e.g., on hit)

### Refactoring Code

- When moving repeated code to a loop: ensure clarity; explain trade-offs if the loop is less obvious
- When consolidating logic: prioritize readability over brevity
- When adding a method: consider whether it belongs in a utility module (e.g., `GameHelpers`) or in the entity itself
- When renaming: update `AGENT.md` to reflect changes

---

## Commands and Scripts

### Running the Game

```bash
cd /home/mattastic/gitHub/BTAR-R
./love.appimage .
```

Or with LÖVE installed:
```bash
love .
```

### Debugging

Set environment variable and run with debug launcher (VSCode):
```bash
export LOCAL_LUA_DEBUGGER_VSCODE=1
love . debug
```

### Building

No build step; LÖVE runs directly from source. To distribute, use LÖVE's fusing mechanism or package as .love file.

---

## Performance Notes

- **Drawing**: All UI elements use `pcall()` to handle rendering errors gracefully
- **Animations**: `anim8` library handles sprite animation; animations are reused across characters
- **Registries**: Assets are loaded once and cached; no redundant file I/O
- **Grid Queries**: Movement range and attack range use linear scans; optimize later if needed (e.g., quadtree for large maps)

---

## Known Limitations and TODOs

### Current State (As of November 2025)

- **Two characters only**: Game currently spawns ninjaBlack (green) vs gladiatorBlue (red)
- **Hardcoded map**: 16×16 grass tileset; no level selection UI
- **No special abilities**: All characters use basic attack; no class-specific skills
- **No AI**: Both players must be human (pass & play only)
- **No persistence**: No save/load system

### Future Roadmap

1. **Character Selection**: Allow players to choose characters before match
2. **Special Abilities**: Implement unique attacks for each class
3. **AI Opponent**: Add CPU-controlled team
4. **Level Selection**: Load different maps and tilesets
5. **Sound/Music**: Integrate audio system
6. **Save/Load**: Persist game progress
7. **Multiplayer**: Network support (future)
8. **Unit Tests**: Add test coverage for core modules
9. **Balance Pass**: Tweak stats and formulas based on playtesting

---

## Maintenance Notes

- **Update AGENT.md** whenever architecture changes or new modules are added
- **Keep `/config` in sync** with actual assets; invalid paths break the game
- **Comment-as-you-code**: Use ADHD-friendly reminder comments throughout
- **Modular over clever**: Prefer clear, separable code to clever one-liners
- **Data-driven over hard-coded**: When in doubt, move it to a config file
- **Profile before optimizing**: Measure FPS and memory before premature optimization

---

## Key Takeaways

This codebase is built on three pillars:

1. **Modularity**: Separate concerns; each module does one thing well
2. **Data-Driven Design**: Game content lives in config files, not code
3. **Clarity**: Code is written for humans; comments explain the "why"

The refactor journey from a monolithic `inGame.lua` to modular `/core` demonstrates growth in software design. This repo is both a functional game and a **portfolio piece** showcasing professional coding practices.
