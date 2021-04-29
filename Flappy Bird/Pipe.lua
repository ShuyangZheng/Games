Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60


function Pipe:init(orientation, y)
    self.orientation = orientation
    self.width = PIPE_IMAGE:getWidth()
    self.x = VIRTUAL_WIDTH
    self.y = y

    --for the purpose of counting score
    self.scored = false
end


function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end


function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y, 0, 1, 
    self.orientation == 'up' and 1 or -1)

end

    