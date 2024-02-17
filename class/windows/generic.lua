WindowGeneric = Class("WindowGeneric", Window)

function WindowGeneric:initialize(desktop, x, y, w, h, args)
    Window.initialize(self, desktop, x, y, 200, 150, "text viewer")
    self.args = args or {}
end

function WindowGeneric:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    -- Draw UI
    Window.drawUI(self)
end