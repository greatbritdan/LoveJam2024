local desktop = {}
local desktopClass
local desktopLoaded, desktopTimer = false, 0

function desktop.load(last)
    desktopClass = Desktop:new(DesktopName)
end
function desktop.update(dt)
    if desktopLoaded then
        desktopClass:update(dt)
        return
    end
    desktopTimer = desktopTimer + dt
    if desktopTimer > 2.5 then
        desktopLoaded = true
    end
end
function desktop.draw()
    if desktopLoaded then
        desktopClass:draw()
        return
    end

    -- Draw desktop loading text
    love.graphics.setColor(1,1,1)
    if desktopTimer < 1.5 then
        love.graphics.printf("please wait...", 0, (Env.height/2)-(Font:getHeight()/2)-16, Env.width/2, "center", 0, 2, 2)
        love.graphics.printf("do not power off the computer...", 0, (Env.height/2)-(Font:getHeight()/2)+16, Env.width/2, "center", 0, 2, 2)
    else
        love.graphics.printf("welcome back "..DesktopName, 0, (Env.height/2)-(Font:getHeight()/2), Env.width/2, "center", 0, 2, 2)
    end
end
function desktop.mousepressed(mx, my, b)
    if not desktopLoaded then return end
    desktopClass:mousepressed(mx, my, b)
end
function desktop.mousereleased(mx, my, b)
    if not desktopLoaded then return end
    desktopClass:mousereleased(mx, my, b)
end
function desktop.keypressed(key, scancode, isrepeat)
    if not desktopLoaded then return end
    desktopClass:keypressed(key, scancode, isrepeat)
end
function desktop.textinput(text)
    if not desktopLoaded then return end
    desktopClass:textinput(text)
end

return desktop