Bird = Class{}

local GRAVITY = 10


function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dy = 0
end


function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -2
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end


function Bird:collides(pipe)
    if self.x + self.width - 4 < pipe.x or self.x + 4 > pipe.x + pipe.width then
        return false
    end

    if pipe.orientation == 'up' then
        if self.y + self.height - 4 < pipe.y then
            return false
        end
    else
        if self.y + 4 > pipe.y then
            return false
        end
    end

    return true
end


function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end