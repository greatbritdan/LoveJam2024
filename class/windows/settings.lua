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

    -- Draw UI
    Window.drawUI(self)
end