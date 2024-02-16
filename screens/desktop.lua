local desktop = {}
local desktopclass

function desktop.load(last)
    desktopclass = Desktop:new()
end
function desktop.update(dt)
end
function desktop.draw()
    desktopclass:draw()
end

return desktop