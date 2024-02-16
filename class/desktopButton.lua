DesktopButton = Class("DesktopButton")

function DesktopButton:initialize(desktop, window)
    self.desktop = desktop
    self.window = window
    self.clicking = false
end

function DesktopButton:draw(i)
    -- Draw task bar button highlight
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    if self.clicking then
        love.graphics.setColor(1,1,1,0.5)
    elseif self:hover(mx,my,i) then
        love.graphics.setColor(1,1,1,0.25)
    else
        love.graphics.setColor(1,1,1,0)
    end
    love.graphics.rectangle("fill", ((i-1)*self.desktop.taskbar.h), self.desktop.h-self.desktop.taskbar.h, self.desktop.taskbar.h, self.desktop.taskbar.h)
    
    -- Draw task bar button icon
    love.graphics.setColor(1,1,1)
    love.graphics.draw(IconsImg, IconsQuads[self.window.icon], ((i-1)*self.desktop.taskbar.h)+2, self.desktop.h-self.desktop.taskbar.h+2, 0)
    
    -- Draw task bar button indicator
    love.graphics.setColor(0.5,0.5,1)
    if self.desktop.focus == self.window then
        love.graphics.rectangle("fill", (i-1)*self.desktop.taskbar.h+4, self.desktop.h-1, self.desktop.taskbar.h-8, 1)
    else
        love.graphics.rectangle("fill", (i-1)*self.desktop.taskbar.h+6, self.desktop.h-1, self.desktop.taskbar.h-12, 1)
    end
end

function DesktopButton:hover(mx,my,i)
    if AABB(mx, my, 1, 1, (i-1)*self.desktop.taskbar.h, self.desktop.h-self.desktop.taskbar.h, self.desktop.taskbar.h, self.desktop.taskbar.h) then
        return true
    end
end

function DesktopButton:mousepressed(mx,my,i,b)
    if b ~= 1 then return end
    if self:hover(mx,my,i) then
        self.clicking = true
    end
end
function DesktopButton:mousereleased(mx,my,i,b)
    if b ~= 1 then return end
    if self.clicking and self:hover(mx,my,i) then
        self:click()
    end
    self.clicking = false
end

function DesktopButton:click()
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