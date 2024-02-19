local desktop = {}
local desktopClass, desktopConfig, desktopLoaded, desktopTimer

function desktop.load(last)
    desktopConfig = love.filesystem.load("desktops/"..DesktopName.."/config.lua")()
    desktopClass = Desktop:new(desktopConfig)
    desktopLoaded, desktopTimer = false, 2
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

    -- Draw darkened desktop background
    if desktopConfig.background.t == "color" then
        love.graphics.setColor(desktopConfig.background.color)
        love.graphics.rectangle("fill", 0, 0, Env.width, Env.height)
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.rectangle("fill", 0, 0, Env.width, Env.height)
    elseif desktopConfig.background.t == "image" then
        love.graphics.setColor(0.5,0.5,0.5)
        local scaleX = Env.width/desktopConfig.background.img:getWidth()
        local scaleY = Env.height/desktopConfig.background.img:getHeight()
        love.graphics.draw(desktopConfig.background.img, 0, 0, 0, scaleX, scaleY)
    end

    -- Draw desktop loading text
    love.graphics.setColor(1,1,1)
    if desktopTimer < 1.5 then
        love.graphics.printf("please wait...", 0, (Env.height/2)-(Font:getHeight()/2)-16, Env.width/2, "center", 0, 2, 2)
        love.graphics.printf("do not power off the computer...", 0, (Env.height/2)-(Font:getHeight()/2)+16, Env.width/2, "center", 0, 2, 2)
    else
        love.graphics.printf("welcome back "..desktopConfig.name, 0, (Env.height/2)-(Font:getHeight()/2), Env.width/2, "center", 0, 2, 2)
    end
end
function desktop.mousepressed(mx, my, b)
    if not desktopLoaded then return end
    desktopClass:mousepressed(mx, my, b)
    if b == 1 then
        ClickSounds[math.random(1, #ClickSounds)]:stop()
        ClickSounds[math.random(1, #ClickSounds)]:play()
    end
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
function desktop.wheelmoved(x,y)
    if not desktopLoaded then return end
    desktopClass:wheelmoved(x,y)
end

return desktop