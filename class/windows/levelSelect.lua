WindowLevelSelect = Class("WindowLevelSelect", Window)

function WindowLevelSelect:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "level select", 300, 200)
    self.program = "levelselect"
    self.icon = "levelselect"
end

function WindowLevelSelect:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    -- Draw UI
    Window.drawUI(self)
end