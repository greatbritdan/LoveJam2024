local menu = {}
local menuclass

function menu.load(last)
    menuclass = MenuScreen:new()
end
function menu.update(dt)
    menuclass:update(dt)
end
function menu.draw()
    menuclass:draw()
end
function menu.mousepressed(mx, my, b)
    menuclass:mousepressed(mx, my, b)
end
function menu.mousereleased(mx, my, b)
    menuclass:mousereleased(mx, my, b)
end
function menu.keypressed(key)
    menuclass:keypressed(key)
end

return menu