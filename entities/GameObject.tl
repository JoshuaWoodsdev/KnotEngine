-- File: entities/GameObject.tl

-- We need to require the Classic library locally
local Class = require 'lib.classic'

-- 1. DEFINE THE STATIC CLASS STRUCTURE (The Blueprint)
global record GameObject
    x: number
    y: number
    velX: number
    velY: number
    width: number
    height: number
    sprite: any  -- Represents the love.Image object
end

-- 2. EXTEND THE CLASS (The Runtime Logic Setup)
-- Link the defined structure to the Classic library for inheritance
local GameObject = Class.extend(nil, GameObject)


-- 3. CONSTRUCTOR METHOD
function GameObject.new(self: GameObject, x: number, y: number, w: number, h: number, imagePath: string)
    self.x = x
    self.y = y
    self.velX = 0
    self.velY = 0
    self.width = w
    self.height = h
    self.sprite = love.graphics.newImage(imagePath)

    -- Register with the global Bump World 
    World:add(self, self.x, self.y, self.width, self.height)
end


-- 4. UPDATE METHOD (Physics and Movement)
function GameObject:update(dt: number)
    local newX: number = self.x + self.velX * dt
    local newY: number = self.y + self.velY * dt

    local actualX: number, actualY: number, cols: any = World:move(
        self, 
        newX, 
        newY, 
        function(col: any)
            return col.other.passable 
        end
    )
    
    self.x = actualX
    self.y = actualY
end

-- 5. DRAW METHOD
function GameObject:draw()
    love.graphics.draw(self.sprite, self.x, self.y)
end


return GameObject