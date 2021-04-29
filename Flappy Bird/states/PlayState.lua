--PlayState handles the gameplay, applies collision detection and score recording.
--When player hits pipe or ground, change state to ScoreState.

PlayState = Class{__includes = BaseState}

--minimum vertical gap allowed between a top pipe and a bottom pipe
MINIMUM_GAP = 30


function PlayState:init()
    self.bird = Bird()
    self.pipes = {}

    --timer of pipe spawning
    self.timer = 0

    --player score
    self.score = 0
end


function PlayState:update(dt)
    --update bird
    self.bird:update(dt)

    --if hits the ground
    if self.bird.y + self.bird.height >= VIRTUAL_HEIGHT - 14 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end 

    --update timer
    self.timer = self.timer + dt
    if self.timer >= 2 then
        local orientation = math.random(2) == 1 and 'up' or 'down'
        local y

        if #self.pipes > 0 and orientation ~= self.pipes[#self.pipes].orientation then
            if orientation == 'up' then
                y = math.random(self.pipes[#self.pipes].y + MINIMUM_GAP, VIRTUAL_HEIGHT - 20)
            else
                y = math.random(10, self.pipes[#self.pipes].y - MINIMUM_GAP)
            end
        else
            if orientation == 'up' then
                y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 20)
            else
                y = math.random(10, VIRTUAL_HEIGHT / 2)
            end
        end
        
        table.insert(self.pipes, Pipe(orientation, y))
        self.timer = 0
    end

    for k, pipe in pairs(self.pipes) do
        pipe:update(dt)
        
        if self.bird:collides(pipe) then
            sounds['explosion']:play()
            sounds['hurt']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end

        if not pipe.scored then
            if pipe.x + pipe.width < self.bird.x then
                self.score = self.score + 1
                pipe.scored = true
                sounds['score']:play()
            end
        end

        if pipe.x < -pipe.width then
            table.remove(self.pipes, k)
        end
    end
end


function PlayState:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: '..tostring(self.score), 8, 8)

    self.bird:render()
end