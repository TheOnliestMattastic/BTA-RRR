# Changelog

All notable changes to BTAR-R are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-18

### ✨ Added

- **Complete refactor from original prototype** — Rebuilt from monolithic `inGame.lua` into modular architecture
- **Modular design** — Separated concerns into `/core`, `/config`, `/states` directories
- **Encapsulated entities** — `Character`, `GameState`, `Combat`, `Map`, `TurnManager` classes
- **Data-driven configuration** — Add new characters, tilesets, FX, and UI without touching core logic
- **Registries for asset management** — Centralized caching: `AnimationRegistry`, `TilesetRegistry`, `UIRegistry`
- **Turn-based combat system** — Initiative rolls (d20 + SPD), action points, movement, attacks, and healing
- **Grid-based map system** — 32×32 tile navigation with range highlighting and hover detection
- **Character animation system** — Sprite sheets with `anim8` library for smooth character and FX animations
- **Combat mechanics** — Hit/miss/dodge rolls with damage calculation and knockback effects
- **Vim-style keybindings** — hjkl navigation with arrow/WASD fallbacks
- **Comprehensive documentation** — AGENT.md, inline code comments, and DEVLOG tracking refactor progress
- **State machine architecture** — Menu and game states for clean state management

### 🛠️ Infrastructure

- **LÖVE2D framework** — Built with Lua on LÖVE2D 11.3+
- **Virtual resolution system** — Fixed 1024×768 scaling for consistent rendering across window sizes
- **Error handling** — `pcall()` wrappers for safe drawing and game logic updates

### 📚 Documentation

- **AGENT.md** — Comprehensive guide to project structure, code practices, and development workflow
- **DEVLOG.md** — Detailed documentation of refactoring journey and development decisions
- **Inline comments** — ADHD-friendly code reminders (`-- Init:`, `-- Draw:`, `-- Update:`)
- **README** — Quick start guide and feature overview

### 🎮 Gameplay Features

- **Two-character matchups** — Configurable character classes with unique stats and animations
- **Action Point economy** — +2 AP per turn (max 4), costs: attack (1 AP), heal (2 AP)
- **Combat resolution** — Accuracy, dodge, and damage formulas with visual feedback
- **Win conditions** — Victory when all opposing units are eliminated

### 🎨 Visual Features

- **Animated sprites** — Character and effect animations powered by `anim8`
- **Tileset rendering** — Configurable tile-based maps
- **UI panels** — Stats display, action menu, turn order, combat messages
- **FX system** — Visual effects with animation sequences

### 🔄 Code Quality

- **Modular structure** — One responsibility per module
- **Local scope discipline** — All variables properly scoped
- **KISSME principles** — Keep It Stupidly Simple, Modularize Everything
- **Naming conventions** — `camelCase` functions, `PascalCase` modules, `SCREAMING_SNAKE_CASE` constants

## [0.1.0] - Original Prototype

### ✨ Features (Original)

- **Basic turn-based combat** — Two characters on a grid
- **Simple attack and heal mechanics** — Hard-coded logic in single file
- **Basic UI** — Health bars and action prompts
- **Class project deliverable** — Proof of concept for tactical RPG gameplay

---

## Future Roadmap

- [ ] **Special abilities** — Unique character skills with unique mechanics
- [ ] **AI opponents** — Computer-controlled players
- [ ] **Level/map selection** — Multiple battle scenarios
- [ ] **Audio system** — Sound effects and music
- [ ] **Save/load system** — Persist game state
- [ ] **Multiplayer over network** — Online play support
- [ ] **Mobile port** — Touch controls for mobile devices
