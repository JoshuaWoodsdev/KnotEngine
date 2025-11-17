-- File: states/PlayState.tl

-- IMPORTS
local Class      = require 'lib.classic'
local Gamestate  = require 'lib.hump.gamestate' 
-- Note: STI is no longer required here if we are not loading the map file by default.
-- However, we keep it required if we intend to load maps later.
-- For now, let's assume the user will inject the map later.
require 'entities.GameObject' 
require 'entities.Player'     

--Pulls in everything for game
global record PlayState
    map: any          -- STI map object (will be nil initially)
    entities: {GameObject} -- Array of entities that must be updated/drawn
    player: Player    -- The main player instance
    camera: any       -- The Hump Camera instance
    previous: any     -- State previous to this one
end

local PlayState = Class.extend(Gamestate, PlayState)


-- CONSTANTS
local WORLD_WIDTH: number = 800
local WORLD_HEIGHT: number = 600

-- CONSTRUCTOR/ENTER METHOD
function PlayState.enter(self: PlayState, previous: any)
    self.previous = previous

    -- --- DECOUPLING CHANGE 1: DO NOT LOAD MAP FILE ---
    -- We initialize self.map to nil. The user (developer) must call a 
    -- separate function later (e.g., self:loadMap('path/to/map.lua')) 
    -- to provide the content.
    self.map = nil 

    -- Initialize the entity list (which must be typed as an array of GameObjects)
    self.entities = {}

    -- Player setup (Use default coordinates since we can't read map properties)
    local player = Player.new(100, 100, 32, 32, 'assets/player.png')
    self.entities[#self.entities + 1] = player
    self.player = player

    -- Example static block
    local block = GameObject.new(300, 300, 64, 64, 'assets/wall.png')
    block.passable = false 
    self.entities[#self.entities + 1] = block

    -- INSTANTIATE THE CAMERA
    self.camera = require 'lib.hump.camera'
    
    -- Set the camera to follow the player
    self.camera:setFollow(
        self.player, 
        WORLD_WIDTH / 2,  
        WORLD_HEIGHT / 2
    )
end


-- UPDATE METHOD
function PlayState:update(dt: number)
    -- --- DECOUPLING CHANGE 2: Conditional Map Update ---
    if self.map then
        self.map:update(dt)
    end

    -- Update all entities (delegates physics and logic to each object)
    for i: number = 1, #self.entities do
        local entity: GameObject = self.entities[i]
        entity:update(dt)
    end
    
    -- Update the camera position based on the player's new position
    self.camera:update(dt)
end


-- DRAW METHOD
function PlayState:draw()
    -- Start camera view
    self.camera:attach()
    
    -- --- DECOUPLING CHANGE 3: Conditional Map Draw ---
    if self.map then
        self.map:draw()
    end

    -- Draw all entities
    for i: number = 1, #self.entities do
        self.entities[i]:draw()
    end
    
    -- Stop camera view
    self.camera:detach()
    
    -- Draw HUD elements here (outside camera) if needed
end


-- INPUT DELEGATION (No changes here)
function PlayState:keypressed(key: string)
    self.player:keypressed(key)
end

function PlayState:keyreleased(key: string)
    self.player:keyreleased(key)
end

return PlayState
