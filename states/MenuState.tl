-- File: states/MenuState.tl

-- IMPORTS
local Class     = require 'lib.classic'
local Gamestate = require 'lib.hump.gamestate' 

-- We will load the PlayState and NarrativeSystem when switching or initializing
-- but for type safety, we define the dependencies here.
require 'states.PlayState'
require 'systems.NarrativeSystem'

-- Define the class structure
global record MenuState
    font: any -- The love.graphics.Font object for the menu text
end

local MenuState = Class.extend(Gamestate, MenuState)

-- Constructor/Initializer
-- In a real scenario, this would be called once in main.tl
function MenuState.new(self: MenuState)
    -- FIX: Changed love.graphics,.newFont to love.graphics.newFont
    self.font = love.graphics.newFont(24) 
end

-- Draw Method: Render the menu screen UI
function MenuState:draw()
    love.graphics.setFont(self.font)
    
    -- Set the text color to a soft white
    love.graphics.setColor(1, 1, 1)

    -- Draw the title
    love.graphics.printf(
        "KNOT ENGINE DEMO", 
        0, love.graphics.getHeight() / 3, love.graphics.getWidth(), 
        "center"
    )
    
    -- Draw the instructions (Re-added for usability)
    love.graphics.printf(
        "Press [SPACE] to Start Game", 
        0, love.graphics.getHeight() / 2, love.graphics.getWidth(), 
        "center"
    )
    
    -- Note: We intentionally avoid drawing the NarrativeSystem here, 
    -- as it is a game system, not a menu UI element.
end

-- Input Method: Handle the state transition
function MenuState:keypressed(key: string)
    if key == ' ' or key == 'return' then
        -- CRITICAL: Switch to the PlayState. We use require here for demonstration
        -- but in the final main.tl, we will pass the PlayState instance/class.
        local PlayState = require 'states.PlayState'
        
        -- The Gamestate.switch call will clean up this state and call PlayState.enter
        Gamestate.switch(PlayState.new())
    end
end

-- Other optional methods like MenuState:update() are typically empty for simple menus

return MenuState