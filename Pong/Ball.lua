Ball = Class{}

function Ball:init (x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = 0
    self.dy = 0
end


function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - BALL_SIZE / 2
    self.y = VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2
    self.dx = 0
    self.dy = 0
end


function Ball:serve(servingPlayer)
    self.dx = 50 + math.random(50)
    if servingPlayer == 2 then
        self.dx = -self.dx
    end

    self.dy = math.random(2) == 1 and -100 or 100
end


function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end


function Ball:collides(paddle)
    -- using Axis-Aligned Bounding Box (AABB) collision detection
    if self.x > paddle.x + paddle.width or self.x + self.width < paddle.x then
        return false
    elseif self.y > paddle.y + paddle.height or self.y + self.height < paddle.y then
        return false
    else
        return true
    end
end


function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
