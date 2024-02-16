WindowFileManager = Class("fileManager", Window)

function WindowFileManager:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, w, h, "file manager")
    self.elements.path = UI.input({x=24, y=4, w=self.w-48, h=16, text="b:/", mc=50, resize=function (element)
        element.w = self.w-48
    end})
    self.elements.back = UI.button({x=self.w-20, y=4, w=16, h=16, text="<", func=function (element)
        local path = self.elements.path.text
        if path == "b:/" then
            return
        end
        path = string.gsub(path, "^b:/", "")
        path = Split(path, "/")
        table.remove(path, #path)
        if #path > 0 then
            path = table.concat(path, "/").."/"
            self.elements.path.text = "b:/"..path
        else
            self.elements.path.text = "b:/"
        end
    end, resize=function (element)
        element.x = self.x+self.w-20
    end})
    self:sync()

    self.program = "filemanager"
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
        local y = self.y+self.navbar.h+28
        for i, file in ipairs(files) do
            love.graphics.setColor({0.5,0.5,0.5})
            if self:hoveringFile() == i then
                love.graphics.setColor({1,1,1})
            end
            local file = file
            if file.type == "shortcut" then
                file = self.desktop:getFileFromShortcut(file)
            end
            if file.type ~= "folder" then
                love.graphics.print(file.name.."."..file.type, self.x+44, y+4)
            else
                love.graphics.print(file.name, self.x+44, y+4)
            end
            if file.icon then
                love.graphics.draw(IconsImg, IconsQuads[file.icon], self.x+24, y)
            else
                love.graphics.draw(IconsImg, IconsQuads[file.type], self.x+24, y)
            end
            y = y + 20
        end
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowFileManager:mousepressed(mx, my, b)
    local hover = self:hoveringFile()
    if hover then
        local file = self.desktop:getFile(self.elements.path.text)[hover]
        if file.type == "shortcut" then
            file = self.desktop:getFileFromShortcut(file)
        end
        self.desktop:openFile(file,self)
        return true
    end
    if Window.mousepressed(self, mx, my, b) then
        return true
    end
    return false
end

function WindowFileManager:hoveringFile()
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    local files = self.desktop:getFile(self.elements.path.text)
    if files then
        local y = self.y+self.navbar.h+28
        for i, file in ipairs(files) do
            if AABB(mx, my, 1, 1, self.x+24, y, self.w-28, 20) then
                return i
            end
            y = y + 20
        end
    end
    return false
end