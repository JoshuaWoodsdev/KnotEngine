-- Player inherits from GameObject, so we require it.
require 'entities.GameObject'
local Class = require 'lib.classic'

-- Define a constant for the player's normal movement speed
global PLAYER_SPEED: number = 200
-- Define constants that control the Dash ability's mechanics
global DASH_DURATION: number = 0.15 -- How long the dash lasts (in seconds)
global DASH_MULTIPLIER: number = 4.0 -- Multiplier for velocity during the dash

-- Define the Player structure. It inherits all properties from GameObject.
global record Player 
    is_dashing: boolean   -- Is the player actively dashing right now?
    dash_timer: number    -- Counts down the duration of the dash
    original_velX: number -- Stores normal horizontal speed before dash
    original_velY: number -- Stores normal vertical speed before dash
end

-- Extend GameObject (This links the Player to the parent class)
local Player = Class.extend(GameObject, Player)

--Need to create a constructor to init the class above
function Player.new(self: Player, x: number, y: number, w: number, h: number, imagePath: string)
    -- CRITICAL: Call the parent's constructor first! This sets up physics and visuals.
    Player.super.new(self, x, y, w, h, imagePath) 
    
    -- Initialize Player-specific state
    self.passable = false        -- Player is solid (for collision filter)
    self.is_dashing = false      -- Dash state off
    self.dash_timer = 0          -- Dash ready
    self.original_velX = 0       -- Zeroed out until first movement
    self.original_velY = 0
end

-- SECTION 3: ABILITY LOGIC AND UPDATE OVERRIDE

-- Helper method to start the dash
function Player:startDash()
    if not self.is_dashing and self.dash_timer <= 0 then
        -- 1. Store and Apply Boost
        self.original_velX = self.velX -- Save current velocity
        self.original_velY = self.velY
        self.velX = self.velX * DASH_MULTIPLIER -- Boost velocity
        self.velY = self.velY * DASH_MULTIPLIER 

        -- 2. Start Timer
        self.is_dashing = true
        self.dash_timer = DASH_DURATION
    end
end

-- OVERRIDE the update method to handle dash duration logic
function Player:update(dt: number)
    -- 1. Player-specific logic: Handle the dash timer countdown
    if self.is_dashing then
        self.dash_timer = self.dash_timer - dt
        
        -- Check if the dash duration has ended
        if self.dash_timer <= 0 then
            self.is_dashing = false
            -- Reset velocity to the original speed (stopping the dash)
            self.velX = self.original_velX
            self.velY = self.original_velY
        end
    end
    
    -- 2. Execute Physics: Call the parent's update to run World:move()
    Player.super.update(self, dt)
end

-- SECTION 4: INPUT MANAGEMENT

function Player:keypressed(key: string)
    -- Prevent normal movement changes while dashing
    if not self.is_dashing then
        if key == 'a' then
            self.velX = -PLAYER_SPEED
        elseif key == 'd' then
            self.velX = PLAYER_SPEED
        elseif key == 'w' then
            self.velY = -PLAYER_SPEED
        elseif key == 's' then
            self.velY = PLAYER_SPEED
        end
    end
    
    -- Trigger the dash ability
    if key == 'space' then
        self:startDash()
    end
end

function Player:keyreleased(key: string)
    -- Only allow stopping movement if not dashing
    if not self.is_dashing then
        if key == 'a' or key == 'd' then
            self.velX = 0
        elseif key == 'w' or key == 's' then
            self.velY = 0
        end
    end
end

return Player