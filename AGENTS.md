# BTA-RRR Agent Configuration

## Project Overview

**BTA-RRR** is a turn-based tactical grid combat game built in LÖVE2D (Lua framework) with heavy focus on professional code architecture and clean design patterns. Originally a monolithic CS final project, this codebase is being actively refactored into a modular, interview-quality example of production-level Lua development practices.

**Target Audience:** Job recruiters and technical interviewers evaluating professional-grade game architecture and OOP design.

## Design Philosophy: KISSME

All development follows the **KISSME** principle:

- **Keep It Stupidly Simple** — No over-engineering. Clear intent over cleverness.
- **Modularize Everything** — Each module has one responsibility; dependencies flow downward.
- **Data-Driven** — Game configuration lives in `config/` (characters, tilesets, effects); logic lives in `core/`.
- **Object-Oriented** — All major entities (Character, Map, GameState, etc.) use Lua metatables with `__index` and `.new()` constructors.

### Architectural Layers

```
main.lua
├── states/        (state machine: menu, game)
├── core/          (game logic: turn manager, input, UI, characters)
├── config/        (data: characters, tilesets, effects)
├── lib/           (third-party libraries: anim8)
└── assets/        (sprites, fonts, tilesets)
```

- **States** (`states/`) — Independent state objects with `load()`, `update(dt)`, `draw()`, `keypressed()`, etc.
- **Core** (`core/`) — Business logic, entity models, and system managers.
- **Config** (`config/`) — Declarative data tables (not procedural).
- **Lib** — Vendored dependencies only (anim8 for sprite animations).

## Code Comment Standards (WHAT/WHY/HOW)

**Every codeblock must have a structured comment header** following this pattern:

```lua
-- =============================================================================
-- MODULE_NAME
-- -----------------------------------------------------------------------------
-- WHAT: One sentence describing what this does
-- WHY:  One sentence explaining why it's needed
-- HOW:  One sentence explaining the implementation approach
-- NOTE: [Optional] Gotchas, alternatives, or reminders
-- =============================================================================
```

### Guidelines

1. **Use section headers with dashes** for visual organization
2. **Pick 1–3 keywords** (WHAT/WHY/HOW/NOTE) — skip what's obvious
3. **Be concise** — 1–2 lines per section
4. **Avoid redundancy** — Don't restate what the code obviously does

### Examples

```lua
-- =============================================================================
-- InputHandler
-- =============================================================================
-- WHAT: Centralizes input from keyboard (vim-style hjkl + arrows) and mouse
-- WHY:  Allows easy switching between keyboard and mouse focus; supports game
--       as educational tool for vim navigation practice
-- HOW:  Maintains state for current UI focus ("map" or "menu"), direction
--       mappings, and map cursor position
-- =============================================================================

-- =============================================================================
-- gainAP()
-- =============================================================================
-- WHAT: Increments character's action points at turn start (capped at maxAP)
-- NOTE: Healers gain AP at same rate as other classes (may change in balance)
-- =============================================================================
```

## Vim-Style Navigation

The game doubles as **Vim navigation practice** for recruiter/interviewer engagement:

- **hjkl**: Move cursor on map (h=left, j=down, k=up, l=right)
- **Arrow Keys / WASD**: Alternative directional input (accessibility)
- **Tab**: Toggle focus between map and action menu
- **j/k**: Navigate menu up/down (when menu has focus)
- **Space**: End turn
- **Return**: Confirm action (move, attack, etc.)

This is intentional: showcases how game mechanics can serve dual purposes (entertainment + education).

## Project Structure

### Core Modules (`core/`)

| Module | Responsibility | Key Classes/Functions |
|--------|-----------------|----------------------|
| `character.lua` | Character entity with stats, animations, movement | `Character.new()`, `:takeDamage()`, `:moveTo()` |
| `gameState.lua` | Turn order, win conditions, AP management | `GameState.new()`, `:endTurn()`, `:checkWin()` |
| `turnManager.lua` | Initiative rolls, turn progression | `rollInitiative()`, `getActiveCharacter()` |
| `inputHandler.lua` | Keyboard/mouse/vim input routing | `InputHandler.new()`, `:getVimDirection()`, `:toggleFocus()` |
| `gameUI.lua` | HUD rendering (stats, action menu, turn order) | `drawActionMenu()`, `drawActiveStats()` |
| `map.lua` | Tile grid, rendering, collision | `Map.new()`, `:draw()`, `:getTile()` |
| `gameLogic.lua` | Combat calculations (damage, hits, ranges) | `GameHelpers.performAttack()`, `findCharacterAt()` |
| `assetRegistry.lua` | Centralized asset loading (sprites, fonts, tilesets) | `registry:getCharacter()`, `:getFonts()` |
| `gameInit.lua` | Setup and dependency injection for game state | `init()` |

### Config Modules (`config/`)

| Module | Purpose |
|--------|---------|
| `characters.lua` | Character class definitions (stats, animations, sprite paths) |
| `tilesets.lua` | Tileset definitions (texture atlases, frame sizes) |
| `ui.lua` | UI layout constants (button positions, sizes) |
| `fx.lua` | Visual effects (damage numbers, hit flashes, animations) |

### States (`states/`)

| Module | Purpose |
|--------|---------|
| `menu.lua` | Main menu (Play, Settings, Quit buttons) |
| `game.lua` | Main gameplay loop; orchestrates all systems |

## Development Workflow

### When Adding a Feature

1. **Identify the module** — Does it belong in `core/` (logic), `config/` (data), or `states/` (UI)?
2. **Check dependencies** — Only depend on modules "below" you in the hierarchy.
3. **Use the comment standard** — Every function gets a WHAT/WHY/HOW header.
4. **Keep it stupid simple** — If it's complex, break it into smaller functions.
5. **Test locally** — Run the game with `love .` and verify behavior.

### When Refactoring

1. **Start with a git log** — Run `git log --oneline -10` to see recent changes.
2. **Use conventional commits** — `feat(inputHandler): add vim-style navigation`
3. **Document rationale** — Explain *why* in the commit message, not just *what*.
4. **Update comments** — Keep WHAT/WHY/HOW headers fresh if logic changes.

### When Reviewing Code

Look for:
- Every function has a WHAT/WHY/HOW comment
- No circular dependencies (e.g., `core/` should never require `states/`)
- Clear intent (variable names, function names are self-documenting)
- Data stays in `config/`, logic in `core/`

## Game Design Notes

### Turn System

- **Initiative**: D&D-style `d20 + SPD` stat
- **AP (Action Points)**: Gained at turn start (usually +2, capped at 4)
- **Movement**: Costs based on distance; validates range before execution
- **Attacks**: Range check + damage calculation with defense mitigation

### Character Classes

30+ character classes with distinct stat profiles (hp, pwr, def, dex, spd, rng). See `config/characters.lua` for full list. Each class has:

- Sprite sheet (16x16 frames, 4 directions, 3–5 animation states)
- Faceset (UI portrait for stats display)
- Stat array (hp, power, defense, dexterity, speed, range)
- Animation definitions (idle, walk, attack frames + timings)
- Optional tags (slash, fire, projectile, etc. for future ability system)

### Grid Map

- 16x16 tile grid, 32px per tile
- Randomized tileset selection per tile (procedural map)
- Supports character placement, collision, range highlighting

## Common Tasks

### Add a New Character Class

1. Add entry to `config/characters.lua` with stats and animation definitions
2. Add sprite sheet to `assets/sprites/chars/<className>/SpriteSheet.png`
3. Add faceset to same directory as `Faceset.png`
4. In `states/game.lua`, create instance with `Character.new(className, x, y, stats)`
5. Register animations with `:setAnimations(registry:getCharacter(className))`

### Add a New Ability

1. Define in `core/gameLogic.lua` with damage/range/AP cost
2. Add button to action menu in `core/gameUI.lua`
3. Handle keyboard input in `states/game.lua` keypressed handler
4. Add visual effect (if needed) to `config/fx.lua`

### Adjust Game Balance

Edit stats in `config/characters.lua` (hp, pwr, def, dex, spd, rng) or AP gain in `core/character.lua`:

```lua
function Character:gainAP(amount)
    self.ap = math.min(self.ap + (amount or 2), self.maxAP)  -- Change "2" to adjust
end
```

### Debug Input Flow

- Check `inputHandler:getFocus()` to see if keyboard or mouse has focus
- Check `inputHandler.uiFocus` to see if player is controlling map or menu
- Print input in `states/game.lua` keypressed/mousepressed handlers

## File Naming Conventions

- **Modules**: lowercase with underscores (`turn_manager.lua` — currently not followed; was `turnManager.lua`)
- **Classes/Metatables**: PascalCase (`Character`, `GameState`, `InputHandler`)
- **Functions**: camelCase (`:getTile()`, `:gainAP()`)
- **Constants**: UPPER_SNAKE_CASE (in files, e.g., `local TILE_SIZE = 32`)

*Note: Current codebase uses camelCase for files (e.g., `turnManager.lua`). This is acceptable but consider standardizing to snake_case in future refactors for Lua conventions.*

## Known Limitations & Future Improvements

### Current Gaps

- No persistent game saves
- Action menu buttons are visual placeholders (not all actions implemented)
- No multiplayer or AI opponents
- No ability system (tags exist but are unused)
- Animations hardcoded to directions (no diagonal movement)

### Refactoring Roadmap

Priority areas for recruiter appeal:

1. **Ability System** — Implement ability registry with cost/range/effects
2. **Event System** — Replace direct function calls with event bus (loose coupling)
3. **Data Serialization** — Save/load game state with proper schema
4. **Test Suite** — Unit tests for game logic (damage calc, range checks)
5. **Performance Profiling** — Document optimization decisions

## Useful Commands

```bash
# Run game
love .

# Check code style issues
lua -c core/character.lua  # Check syntax

# View recent changes
git log --oneline -10

# Search for TODOs
grep -r "TODO" core/
```

## References

- **LÖVE2D Docs**: https://love2d.org/wiki/Main_Page
- **Lua Best Practices**: https://www.lua.org/pil/
- **Game Architecture Patterns**: https://gameprogrammingpatterns.com/

---

**Last Updated:** 2025-12-24  
**Scope:** Professional portfolio refactor focusing on clean architecture for recruiting narrative
