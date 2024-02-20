WindowAntivirus = Class("WindowAntivirus", Window)

function WindowAntivirus:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "antivirus", 300, 200)
    self.program = "antivirus"
    self.icon = "antivirus"
end

function WindowAntivirus:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    love.graphics.setColor({1,1,1})
    love.graphics.printf("content.", self.x+4, self.y+self.navbar.h+3, self.w-8, "center")

    -- Draw UI
    Window.drawUI(self)
end