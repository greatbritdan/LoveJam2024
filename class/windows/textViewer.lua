WindowTextViewer = Class("WindowTextViewer", Window)

function WindowTextViewer:initialize(desktop, x, y, w, h, args)
    Window.initialize(self, desktop, x, y, 200, 150, "text viewer")
    self.content = args and args.content
    if self.content and type(self.content) ~= "table" then
        self.content = {self.content}
    end
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
        local y = self.y+self.navbar.h+17
        for _,section in pairs(self.content) do
            local text, allign = Deepcopy(section), "center"
            if type(section) == "table" then
                text = section[1]
                allign = section[2] or "center"
            end
            local split = Split(text,"\n")
            for j,line in pairs(split) do
                love.graphics.printf(line, self.x+4, y, self.w-8, allign)
                y = y + TextHeight(line, self.w-8)
            end
            y = y + 4
        end
    else
        love.graphics.setColor({1,0.5,0.5})
        love.graphics.printf("error: no content provided, please open a valid text file.", self.x+4, self.y+self.navbar.h+17, self.w-8, "center")
    end

    -- Draw UI
    Window.drawUI(self)
end