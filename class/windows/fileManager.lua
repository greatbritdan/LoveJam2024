WindowFileManager = Class("fileManager", Window)

function WindowFileManager:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, w, h, "file manager")
    self.elements.path = UI.input({x=24, y=4, w=self.w-28, h=16, text="b:/", mc=50, resize=function (element)
        element.w = self.w-28
    end})
    self:sync()
end

function WindowFileManager:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)
    love.graphics.setColor(self:getColor("subbackground"))
    love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, 20, self.h-self.navbar.h)
    love.graphics.rectangle("fill", self.x+20, self.y+self.navbar.h, self.w-20, 24)

    -- Print out all files in path
    local files = self.desktop:getFile(self.elements.path.text)
    if files then
        love.graphics.setColor({1,1,1})
        local y = self.y+self.navbar.h+28
        for _, file in ipairs(files) do
            if file.type ~= "folder" then
                love.graphics.print(file.name.."."..file.type, self.x+24, y)
            else
                love.graphics.print(file.name, self.x+24, y)
            end
            y = y + 12
        end
    end

    -- Draw UI
    Window.drawUI(self)
end