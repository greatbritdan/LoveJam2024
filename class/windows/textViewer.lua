WindowTextViewer = Class("WindowTextViewer", Window)

function WindowTextViewer:initialize(desktop, x, y, w, h, args)
    Window.initialize(self, desktop, x, y, 200, 150, "text viewer")
    self.content = args and args.content
    self.filename = args and args.filename or "unknown.text"

    self.program = "textviewer"
    self.icon = "textviewer"
end

function WindowTextViewer:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)
    love.graphics.setColor(self:getColor("subbackground"))
    love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 13)

    -- Print out content
    love.graphics.setColor({0.5,0.5,0.5})
    love.graphics.printf(self.filename, self.x+4, self.y+self.navbar.h+3, self.w-8, "left")
    if self.content then
        love.graphics.setColor({1,1,1})
        love.graphics.printf(self.content, self.x+4, self.y+self.navbar.h+17, self.w-8, "center")
    else
        love.graphics.setColor({1,0.5,0.5})
        love.graphics.printf("error: no content provided, please open a valid text file.", self.x+4, self.y+self.navbar.h+17, self.w-8, "center")
    end

    -- Draw UI
    Window.drawUI(self)
end