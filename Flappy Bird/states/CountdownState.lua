CountdownState = Class{__includes = BaseState}

COUNTDOWN_INTERVAL = 0.75


function CountdownState:init()
    self.count = 3
    self.timer = 0
end


function CountdownState:update(dt)
    if self.timer == 0 then
        sounds['beep']:play()
    end

    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_INTERVAL then
        self.timer = self.timer % COUNTDOWN_INTERVAL
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        else
            sounds['beep']:play()
        end

    end
end


function CountdownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end