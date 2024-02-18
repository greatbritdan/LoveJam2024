local game = {}
local gameclass

function game.load(last)
    gameclass = GameScreen:new()
end
function game.update(dt)
    gameclass:update(dt)
end
function game.draw()
    gameclass:draw()
end
function game.mousepressed(mx, my, b)
    gameclass:mousepressed(mx, my, b)
end
function game.mousereleased(mx, my, b)
    gameclass:mousereleased(mx, my, b)
end
function game.keypressed(key)
    gameclass:keypressed(key)
end

return game