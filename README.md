# ⚔️ Battle Tactics Arena: Refactored & Remastered

```txt
M""""""""M dP                MMP"""""YMM          dP oo                     dP   
Mmmm  mmmM 88                M' .mmm. `M          88                        88   
MMMM  MMMM 88d888b. .d8888b. M  MMMMM  M 88d888b. 88 dP .d8888b. .d8888b. d8888P 
MMMM  MMMM 88'  `88 88ooood8 M  MMMMM  M 88'  `88 88 88 88ooood8 Y8ooooo.   88   
MMMM  MMMM 88    88 88.  ... M. `MMM' .M 88    88 88 88 88.  ...       88   88   
MMMM  MMMM dP    dP `88888P' MMb     dMM dP    dP dP dP `88888P' `88888P'   dP   
MMMMMMMMMM                   MMMMMMMMMMM                                         
                                                                                  
M"""""`'"""`YM            dP     dP                       dP   oo                
M  mm.  mm.  M            88     88                       88                     
M  MMM  MMM  M .d8888b. d8888P d8888P .d8888b. .d8888b. d8888P dP .d8888b.       
M  MMM  MMM  M 88'  `88   88     88   88'  `88 Y8ooooo.   88   88 88'  `""       
M  MMM  MMM  M 88.  .88   88     88   88.  .88       88   88   88 88.  ...       
M  MMM  MMM  M `88888P8   dP     dP   `88888P8 `88888P'   dP   dP `88888P'       
MMMMMMMMMMMMMM                                                                   
```

[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC%20BY--SA%204.0-bd93f9?style=for-the-badge&logoColor=white&labelColor=6272a4)](https://creativecommons.org/licenses/by-sa/4.0/)
[![Language: Lua](https://img.shields.io/badge/Language-Lua-bd93f9?style=for-the-badge&logo=lua&logoColor=white&labelColor=6272a4)](https://www.lua.org/)
[![Framework: LÖVE2D](https://img.shields.io/badge/Framework-LÖVE2D-bd93f9?style=for-the-badge&logoColor=white&labelColor=6272a4)](https://love2d.org/)
[![Status: In Development](https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge&logoColor=white&labelColor=6272a4)]()

## 🔭 Overview

**Battle Tactics Arena (BTA)** is a **2D turn-based tactical RPG** built with **Lua** and the **LÖVE2D framework**. 

Originally created as a class project, the game has been **rebuilt from the ground up** to showcase clean, modular design and professional coding practices. This is both a **playable prototype** and a **portfolio piece** demonstrating architectural growth as a developer.

### Design Philosophy

BTAR-R follows **KISSME principles**:
- **Keep It Stupidly Simple** — Code is explicit and easy to understand
- **Modularize Everything** — Each concern lives in its own file
- **Data-driven design** — Add new content without touching core logic
- **Accessibility first** — Vim-style keybindings (hjkl) for keyboard accessibility

## ✨ Core Features

- **Grid-based tactical combat** — 32×32 tile maps with turn-based movement
- **Character system** — Configurable classes with unique stats, sprites, and animations
- **Action Point economy** — +2 AP per turn (max 4); costs: attack (1 AP), heal (2 AP)
- **Combat resolution** — Accuracy, dodge, and damage calculations with visual feedback
- **Animation system** — Sprite-based animations powered by [`anim8`](https://github.com/kikito/anim8)
- **Modular architecture** — Clean separation of concerns for easy extension

## 🛠️ Refactor Journey

The original prototype lived in a single `inGame.lua` file with global tables and hard‑coded logic.  
The **remastered version** introduces:

- **Modular design**: `/core`, `/states`, `/config` folders
- **Encapsulated entities**: `Character`, `GameState`, `Combat`, `Map`
- **Data‑driven configs**: Add new classes, FX, or tilesets without touching core logic
- **Registries**: Centralized asset management (`AnimationRegistry`, `TilesetRegistry`, `UIRegistry`)
- **Documentation**: Includes a [Devlog](devlog.md) chronicling the rebuild process

This repo is both a **playable prototype** and a **portfolio piece** demonstrating my growth as a developer.

## 🎮 Gameplay

- **Pass & Play**: Two players alternate turns on the same machine
- **Action Points**: Spend AP to move, attack, or heal
- **Victory Condition**: Eliminate all opposing units
- **Combat Resolution**: Hit, miss, dodge, and KO mechanics

## 🚀 Getting Started

### Prerequisites

- [LÖVE2D](https://love2d.org/) (11.3+ recommended)

### Run the Game

```bash
love .
```

## 🗺️ Repo Structure

```
/assets        → Sprites, tilesets, UI
/core          → Game logic (character, combat, map, gameState, registries)
/config        → Data‑driven definitions (characters, fx, tilesets, ui)
/states        → Game states (menu, game)
/lib           → Third‑party libraries (anim8, timer)
devlog.md      → Development log of the refactor
```

## ☄️ Skills Demonstrated

- **Lua programming** — Clean, modular code with proper scoping and error handling
- **Game architecture** — State machines, registries, and modular entity systems
- **LÖVE2D framework** — Window management, graphics, input handling, virtual resolution
- **Animation systems** — Sprite sheet management with `anim8` library
- **Data-driven design** — Configs separate from logic for easy content creation
- **Portfolio storytelling** — Clear documentation of architectural decisions and refactoring journey
- **Version control** — Professional Git practices with meaningful commit history

## 📖 Documentation

- **AGENT.md** — Comprehensive project guide with architecture overview, code practices, and development workflow
- **DEVLOG.md** — Development log documenting the refactor process and design decisions
- **Inline comments** — ADHD-friendly code reminders for clarity and learning
- **README** — Quick start guide and feature overview

## 🛸 License

This project is licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

## 👽 Contact

Curious about my projects? Want to collaborate or hire?

[![Portfolio](https://img.shields.io/badge/Portfolio-bd93f9?style=for-the-badge&logo=githubpages&logoColor=white&labelColor=6272a4)](https://theonliestmattastic.github.io/)  
[![GitHub](https://img.shields.io/badge/GitHub-Profile-bd93f9?style=for-the-badge&logo=github&logoColor=white&labelColor=6272a4)](https://github.com/theonliestmattastic)  
[![Email](https://img.shields.io/badge/Email-matthew.poole485%40gmail.com-bd93f9?style=for-the-badge&logo=gmail&logoColor=white&labelColor=6272a4)](mailto:matthew.poole485@gmail.com)

> “Sometimes the questions are complicated and the answers are simple.” — Dr. Seuss
