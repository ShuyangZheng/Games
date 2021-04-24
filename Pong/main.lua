VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

PADDLE_WIDTH = 8
PADDLE_HEIGHT = 32
PADDLE_SPEED = 140

BALL_SIZE = 4

SCORE_TO_WIN = 2

LARGE_FONT = love.graphics.newFont(32)
SMALL_FONT = love.graphics.newFont(16)

push = require "push"
Class = require 'class'
require 'Paddle'
require 'Ball'


function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle('Pong')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)

    player1 = Paddle(10, 10, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH-PADDLE_WIDTH-10, VIRTUAL_HEIGHT-PADDLE_HEIGHT-10, PADDLE_WIDTH, PADDLE_HEIGHT)
    resetBalls()

    servingPlayer = 1
    maxNumberOfBalls = 2
    gameState = 'title'
end

--[[
    I'm a block comment!
]]
function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt) -- delta time: the amount time in seconds since the last frame/update.
    if love.keyboard.isDown("w") then
        -- if not (player1.y <= 0) then
        --     player1.y = player1.y - PADDLE_SPEED * dt
        -- end
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("s") then
        -- if not (player1.y >= VIRTUAL_HEIGHT - PADDLE_HEIGHT) then
        --    player1.y = player1.y + PADDLE_SPEED * dt 
        -- end
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown("up") then
        -- if not (player2.y <= 0) then
        --     player2.y = player2.y - PADDLE_SPEED * dt
        -- end
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("down") then
        -- if not (player2.y >= VIRTUAL_HEIGHT - PADDLE_HEIGHT) then
        --     player2.y = player2.y + PADDLE_SPEED * dt
        -- end
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    player1:update(dt)
    player2:update(dt)

    if gameState == 'serve' then
        for i, ball in pairs(balls) do
            ball:serve(servingPlayer)
        end
    end

    if gameState == 'play' then
        -- increase the number of balls according to time
        if numberOfBalls < maxNumberOfBalls then
            local lastTimeStamp = roundStartTime
            local currentTime = love.timer.getTime()
            if currentTime - lastTimeStamp >= 15 then
                numberOfBalls = numberOfBalls + 1
                local newBall = Ball(VIRTUAL_WIDTH / 2 - BALL_SIZE / 2, VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2, BALL_SIZE, BALL_SIZE)
                newBall:serve(servingPlayer)
                balls[numberOfBalls] = newBall
                lastTimeStamp = currentTime
            end
        end

        for i, ball in pairs(balls) do
            if ball:collides(player1) then
                ball.x = player1.x + player1.width
                ball.dx = -ball.dx * 1.01
            elseif ball:collides(player2) then
                ball.x = player2.x - ball.width
                ball.dx = -ball.dx * 1.01
            end

            if ball.y <= 0 or ball.y >= VIRTUAL_HEIGHT - BALL_SIZE then
                ball.dy = -ball.dy
            end

            if ball.x <= 0 then
                servingPlayer = 1
                player2.score = player2.score + 1
                resetBalls()
                gameState = 'serve'
            elseif ball.x >= VIRTUAL_WIDTH - BALL_SIZE then
                servingPlayer = 2
                resetBalls()
                gameState = 'serve'
                player1.score = player1.score + 1
            end

            ball:update(dt)
        end

        if player1.score >= SCORE_TO_WIN or player2.score >= SCORE_TO_WIN then
            gameState = 'win' 
        end
    end


end


function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        if gameState == 'title' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            roundStartTime = love.timer.getTime()
            gameState = 'play'
        elseif gameState == 'win' then
            player1.score = 0
            player2.score = 0
            gameState = 'title'
        end
    end
end


function love.draw()
    push:start()
    love.graphics.clear(121/255, 135/255, 119/255, 255/255)
    love.graphics.setColor(248/255, 237/255, 227/255, 1)

    if gameState == 'title' then
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf('Pong', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT - 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press Enter to Serve', 0, 10, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'win' then
        love.graphics.setFont(LARGE_FONT)
        local winner = player1.score >= SCORE_TO_WIN and '1' or '2'
        love.graphics.printf('Player '..winner..' wins!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press Enter to Restart', 0, VIRTUAL_HEIGHT - 32, VIRTUAL_WIDTH, 'center')
    end

    -- display score
    love.graphics.setFont(LARGE_FONT)
    love.graphics.print(player1.score, VIRTUAL_WIDTH / 2 - 36, VIRTUAL_HEIGHT / 2 - 18)
    love.graphics.print(player2.score, VIRTUAL_WIDTH / 2 + 16, VIRTUAL_HEIGHT / 2 - 18)
    love.graphics.setFont(SMALL_FONT)

    player1:render()
    player2:render()
    for i, ball in pairs(balls) do
        ball:render()
    end
    -- love.graphics.rectangle("fill", player1.x, player1.y, PADDLE_WIDTH, PADDLE_HEIGHT)
    -- love.graphics.rectangle("fill", player2.x, player2.y, PADDLE_WIDTH, PADDLE_HEIGHT)
    -- love.graphics.rectangle("fill", ball.x, ball.y, BALL_SIZE, BALL_SIZE)
    push:finish()
end


-- function collides(b, p)
--     return not (b.y > p.y + PADDLE_HEIGHT or b.x > p.x + PADDLE_WIDTH or p.y > b.y + BALL_SIZE or p.x > b.x + BALL_SIZE)
-- end


function resetBalls()
    balls = {}
    local ball = Ball(VIRTUAL_WIDTH / 2 - BALL_SIZE / 2, VIRTUAL_HEIGHT / 2 - BALL_SIZE / 2, BALL_SIZE, BALL_SIZE)
    table.insert(balls, ball)
    numberOfBalls = 1
end

