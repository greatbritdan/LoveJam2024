TaskbarButton = Class("TaskbarButton")

function TaskbarButton:initialize(desktop, window)
    self.desktop = desktop
    self.window = window or false
    self.clicking = false
end

function TaskbarButton:draw(i)
    -- Draw task bar button highlight
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    if self.clicking then
        love.graphics.setColor(self.desktop:getColor("highlight","pressed"))
    elseif self:hover(mx,my,i) then
        love.graphics.setColor(self.desktop:getColor("highlight","hover"))
    else
        love.graphics.setColor(self.desktop:getColor("highlight","normal"))
    end
    love.graphics.rectangle("fill", ((i-1)*self.desktop.taskbar.h), self.desktop.h-self.desktop.taskbar.h, self.desktop.taskbar.h, self.desktop.taskbar.h)

    -- Draw task bar button icon
    love.graphics.setColor(1,1,1)
    if not self.window then
        love.graphics.draw(IconsImg, IconsQuads["start"], ((i-1)*self.desktop.taskbar.h)+2, self.desktop.h-self.desktop.taskbar.h+2, 0)
        return
    end
    love.graphics.draw(IconsImg, IconsQuads[self.window.icon], ((i-1)*self.desktop.taskbar.h)+2, self.desktop.h-self.desktop.taskbar.h+2, 0)

    -- Draw task bar button indicator
    love.graphics.setColor(0.5,0.5,1)
    if self.desktop.focus == self.window then
        love.graphics.rectangle("fill", ((i-1)*self.desktop.taskbar.h)+4, self.desktop.h-1, self.desktop.taskbar.h-8, 1)
    else
        love.graphics.rectangle("fill", ((i-1)*self.desktop.taskbar.h)+6, self.desktop.h-1, self.desktop.taskbar.h-12, 1)
    end
end

function TaskbarButton:mousepressed(mx,my,i,b)
    if self:hover(mx,my,i) then
        self.clicking = b
    end
end

function TaskbarButton:mousereleased(mx,my,i,b)
    if self.clicking == b and self.window then
        if self:hover(mx,my,i) then
            if b == 1 then
                self:click()
            elseif b == 2 and (not self.window.NOCLOSEYMATE) then
                self.desktop:windowClose(self.window)
            end
        end
        self.clicking = false
    elseif self.clicking == b and (not self.window) then
        if self:hover(mx,my,i) then
            self.desktop.startMenu.open = not self.desktop.startMenu.open
        end
        self.clicking = false
    end
end

function TaskbarButton:hover(mx,my,i)
    if AABB(mx, my, 1/Env.scale, 1/Env.scale, ((i-1)*self.desktop.taskbar.h), self.desktop.h-self.desktop.taskbar.h, self.desktop.taskbar.h, self.desktop.taskbar.h) then
        return true
    end
end

function TaskbarButton:click()
    if self.desktop.focus ~= self.window then
        self.desktop.focus = self.window
        self.window.minimized = false
        self.desktop:windowBringToFront(self.window)
        return
    end
    self.window.minimized = not self.window.minimized
    if self.window.minimized then
        self.desktop.focus = false
    else
        self.desktop:windowBringToFront(self.window)
    end
end