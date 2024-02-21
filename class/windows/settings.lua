WindowSettings = Class("WindowSettings", Window)

function WindowSettings:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "settings", 300, 200)
    self.program = "settings"
    self.icon = "settings"
end

function WindowSettings:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    love.graphics.setColor(1,1,1)
    love.graphics.printf("settings will be here at some point!", self.x+4, self.y+self.navbar.h+3, self.w-8, "center")

    -- Draw UI
    Window.drawUI(self)
end