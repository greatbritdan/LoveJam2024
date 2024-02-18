local game = {}

require("class.polygon")
require("class.button")

local button
function game.load(last)
    button = Button:new("thinrectangle", Env.width/2, Env.height/2)
end
function game.update(dt)
    button:update(dt)
end
function game.draw()
    -- Draw the Button
    love.graphics.setColor(1,1,1)
    button:draw()

    -- Draw the Pointer
    love.graphics.setColor(1,1,1,0.5)
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