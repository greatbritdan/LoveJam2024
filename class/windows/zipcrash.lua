WindowZipcrash = Class("WindowZipcrash", Window)

function WindowZipcrash:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "zipcrash", 300, 200)
    self.program = "zipcrash"
    self.icon = "zipcrash"
end

function WindowZipcrash:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    love.graphics.setColor({1,0.5,0.5})
    love.graphics.printf("error: please disalbe antivirus to contine free instalation.", self.x+4, self.y+self.navbar.h+3, self.w-8, "center")

    -- Draw UI
    Window.drawUI(self)
end