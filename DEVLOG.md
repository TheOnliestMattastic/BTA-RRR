# Devlog – Rebuilding Battle Tactics Arena

## October 20, 2025

### What I Started With

This project began as my final class project a few years ago: a tactical RPG prototype built in LÖVE (Lua). The original code worked, but it was very **monolithic**:

- A single `inGame.lua` file handled map rendering, character logic, UI, and input all at once.
- Game state was tracked in a global `game` table with cryptic indices (`game[1]`, `game[2]`, etc.).
- Characters were stored in a giant `char` table with mixed data and flags.
- Adding new classes, attacks, or maps required editing multiple places in the same file.

It was a great learning experience, but not something I’d want to showcase.

---

### What I’ve Done So Far

I’ve started **rebuilding the game from the ground up** with best practices in mind:

1. **Modular Design**
   - Created a `Character` module (`character.lua`) that encapsulates stats, position, sprite, and methods like `update`, `draw`, `takeDamage`, and `heal`.
   - This replaces the old global `char` table with clean, object‑like entities.
   - `game.lua` now imports `Character`, `GameState`, and `Map` instead of defining everything inline.

2. **GameState Manager**
   - Built a `GameState` module (`gameState.lua`) to handle turns, action points, and win conditions.
   - This centralizes logic that was previously scattered across `inGame.lua`.

3. **Clearer Project Structure**
   - Planning a `/core` folder for reusable modules (`character.lua`, `map.lua`, `gameState.lua`, `ui.lua`).
   - States (`menu.lua`, `game.lua`) will live in `/States`.
   - Assets (sprites, fonts) are separated into `/assets`.

---

### Why This Matters

- **Readability**: Others can immediately see clean, modular code instead of one giant file.
- **Scalability**: Adding new classes, maps, or abilities will be data‑driven, not hard‑coded.
- **Professionalism**: The repo will include a polished `README.md` and this `devlog.md` to show my growth and thought process.

## October 31, 2025

### Window and UI Improvements

- **Dynamic Window Resizing**: Enabled resizable windows and updated the default resolution to 1280x720 for better modern display compatibility. Added resize callbacks to dynamically update global window dimensions.
- **Window Constraints**: Set minimum window sizes and disabled auto-sizing to prevent UI elements from becoming too small or misaligned.
- **UI Module Refactoring**: Removed the separate `ui.lua` module and integrated Slab UI initialization directly into the menu state for cleaner separation of concerns.
- **Menu State Overhaul**: Refactored `states/menu.lua` to use Slab UI components, including proper window setup, background colors, and button sizing relative to window dimensions.
- **Slab Integration**: Began integrating the Slab immediate-mode GUI library into the menu state, replacing basic LÖVE drawing with more flexible UI elements.

## November 1, 2025

### Advanced Menu UI Features

- **Button Image and Hover Effects**: Added sprite-based buttons with hover state changes using SubX offsets in the button image for visual feedback.
- **Menu Button Rendering**: Improved button image loading and rendering logic, ensuring buttons are centered and scale properly with window size.
- **Slab UI Elements**: Fully transitioned the menu state to use Slab UI elements, including proper layout management and font handling.
- **UI Initialization and Rendering**: Refactored menu state UI initialization to load fonts and styles dynamically, and optimized rendering for better performance and maintainability.

---

## November 2, 2025

### UI Refactoring and Slab Removal

- **Removed Slab Dependency**: Completely removed the Slab UI library from the project to reduce external dependencies and gain full control over rendering. Deleted `lib/Slab/` and all Slab-related code.
- **Custom UI Implementation**: Refactored `states/menu.lua` and `states/game.lua` to use LÖVE's built-in drawing functions (`love.graphics.printf`, `love.graphics.rectangle`, etc.) combined with custom UI sprites from `assets/sprites/ui/` (e.g., `button.png` for interactive elements).
- **Menu State Overhaul**: Replaced Slab-based UI in the menu with direct sprite rendering for buttons (using quads for hover/press states) and text. Implemented custom mouse interaction for button clicks and state transitions.
- **Game UI Simplification**: Removed Slab window and layout code from the game state. Updated character selection to use simple yellow outlines and range highlights with LÖVE primitives. Added basic text rendering for UI elements like stats.
- **Bug Fixes**: Resolved a visual bug where selection boxes were drawing around every character instead of just the selected one by correcting the conditional logic in `game.lua`.
- **Virtual Resolution Handling**: Ensured UI elements scale correctly with the virtual resolution system, including mouse coordinate transformations for accurate input.
- **Documentation Updates**: Thoroughly reviewed and updated `AGENT.md` and `spec.md` to reflect the new UI architecture, remove outdated references, and accurately describe the current codebase structure and modules.
