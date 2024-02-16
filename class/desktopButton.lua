DesktopButton = Class("DesktopButton")

function DesktopButton:initialize(desktop, window)
    self.desktop = desktop
    self.window = window
    self.clicking = false
end

function DesktopButton:draw(i)
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    if self.clicking then
        love.graphics.setColor(0.5,0.5,0.5,0.75)
    elseif self:hover(mx,my,i) then
        love.graphics.setColor(0.75,0.75,0.75,0.75)
    else
        love.graphics.setColor(0.25,0.25,0.25,0.75)
    end
    love.graphics.rectangle("fill", (i-1)*self.desktop.taskbar.h, self.desktop.h-self.desktop.taskbar.h, self.desktop.taskbar.h, self.desktop.taskbar.h)
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
    self.window.minimized = not self.window.minimized
    if not self.window.minimized then
        self.desktop:windowBringToFront(self.window)
    end
end