local game = {}

require("class.button")

local button
function game.load(last)
    button = Button:new("thinrectangle", Env.width/2, Env.height/2)
end
function game.update(dt)
    button:update(dt)
    button:rotate(90, dt)
end
function game.draw()
    love.graphics.setColor(1,1,1)

    -- Draw the Button
    button:draw()

    -- Draw the Pointer
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    love.graphics.draw(PointerImg, mx, my, 0, 1, 1, 16, 16)
end
function game.mousepressed(mx, my, b)
    button:click(mx, my, b)
end
function game.mousereleased(mx, my, b)
    button:release(mx, my, b)
end

return game