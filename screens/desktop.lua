local desktop = {}
local desktopclass

function desktop.load(last)
    desktopclass = Desktop:new()
end
function desktop.update(dt)
    desktopclass:update(dt)
end
function desktop.draw()
    desktopclass:draw()
end
function desktop.mousepressed(mx, my, b)
    desktopclass:mousepressed(mx, my, b)
end
function desktop.mousereleased(mx, my, b)
    desktopclass:mousereleased(mx, my, b)
end
function desktop.keypressed(key, scancode, isrepeat)
    desktopclass:keypressed(key, scancode, isrepeat)
end

return desktop