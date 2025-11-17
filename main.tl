-- File: main.tl

-- Define global variables with types
global World: any          -- Placeholder type for the Bump world instance
global Width: number  = 800  -- Standard LÖVE convention is to set width first, then height
global Height: number = 600

-- IMPORTS (Keep these local)
local Class      = require 'lib.classic'
local Gamestate  = require 'lib.hump.gamestate'
local Camera     = require 'lib.hump.camera'
local Bump       = require 'lib.bump'
local STI        = require 'lib.sti'

-- Load game states (using dot notation)
require 'states.MenuState'
require 'states.PlayState'

-- PROGRAM LIFECYCLE FUNCTIONS

function love.load()
    love.window.setTitle("Knot Game Engine")
    -- Use the correct global variable order for setMode
    love.window.setMode(Width, Height)

    -- Initialize the Bump World
    World = Bump.newWorld(64)

    -- Set Start State (use dot notation for the constructor)
    Gamestate.switch(MenuState.new())

end -- CRITICAL FIX 1: This function was missing its closing 'end'


function love.update(dt: number) 
    Gamestate.update(dt)
end    


function love.draw()
   Gamestate.draw()
   -- The tostring() is needed because love.timer.getFPS() returns a number
   love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 580) 
end


function love.keypressed(key: string)
   Gamestate.keypressed(key)
end