WindowExit = Class("WindowExit", Window)

function WindowExit:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "exit", 300, 200)
    self.program = "exit"
    self.icon = "exit"
end

function WindowExit:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    -- Draw UI
    Window.drawUI(self)
end