👾 KNOT Game Engine (LÖVE2D + Teal + Hump + Bump)

KNOT is a clean, type-safe, and modular 2D engine foundation built in Teal (a typed dialect of Lua) for the LÖVE2D framework. It provides a solid architectural base using modern OOP principles.

🚀 Key Technologies

LÖVE2D: The primary game framework.

Teal: Static typing layer for robust code.

Hump: State management (Gamestate) and Camera.

Bump: Collision resolution system.

STI: Simple Tiled Map loader.

📁 Engine Architecture

The core of the engine uses a highly modular structure, based on the principle of Inheritance and Specialization:

Folder/File

Description

main.tl

The main LÖVE2D entry point. Handles engine initialization, state setup, and the central physics world.

states/

Contains all game states (MenuState, PlayState, etc.). Manages which parts of the game are active.

entities/

Contains the base object (GameObject) for physics, and all specialized objects (Player, Enemy, etc.).

lib/

Contains external Lua libraries (Hump, Bump, Classic, STI).

maps/

Holds map data files (level1.lua) used by STI for level structure.

assets/

Directory for all image and sound files.

⚙️ Setup and Installation

Prerequisites

LÖVE2D: Must be installed to run the game (available at love2d.org).

Teal Compiler: Required to compile the .tl files into runnable .lua files.

# Install Teal via LuaRocks (assuming Lua is installed)
luarocks install teal


Running the Engine

Compile the Teal Code: Use the included tlconfig.lua to convert all Teal files into Lua.

tl build


Run with LÖVE2D: Execute the project directory with LÖVE2D.

love .


📝 Current Status

The engine core is structurally complete and supports:

Type-safe inheritance (GameObject -> Player).

Frame-based physics and robust collision using Bump.

Basic Player movement (WASD) and a Dash ability (SPACE).

State management (MenuState -> PlayState).

Camera following (Hump.Camera).