WindowFileManager = Class("fileManager", Window)

function WindowFileManager:initialize(desktop, x, y, w, h, args)
    Window.initialize(self, desktop, x, y, 300, 200, "file manager")
    local path = args.path or "b:/"

    self.elements.path = UI.input({x=2, y=2, w=self.w-22, h=16, text=path, mc=50, desktop=desktop, resize=function (element)
        element.w = self.w-22
    end})
    
    self.elements.back = UI.button({x=self.w-18, y=2, w=16, h=16, text="<", desktop=desktop, func=function (_)
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
        element.x = self.x+self.w-18
    end})
    self:sync()

    self.program = "filemanager"
    self.icon = "filemanager"
end

function WindowFileManager:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)
    love.graphics.setColor(self:getColor("subbackground"))
    love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 20)

    -- Print out all files in path
    local files = self.desktop:getFile(self.elements.path.text)
    if files then
        local y = self.y+self.navbar.h+24
        for i, file in ipairs(files) do
            love.graphics.setColor({1,1,1})
            local file = file
            local isShortcut = false
            if file.type == "shortcut" then
                file = self.desktop:getFileFromShortcut(file)
                isShortcut = true
            end
            if file and file.hidden ~= true then
                love.graphics.print(file.name, self.x+24, y+6)
                if file.icon then
                    love.graphics.draw(IconsImg, IconsQuads[file.icon], self.x+4, y+2)
                else
                    love.graphics.draw(IconsImg, IconsQuads[file.type], self.x+4, y+2)
                end
                if isShortcut then
                    love.graphics.draw(IconsImg, IconsQuads["shortcut"], self.x+4, y+2)
                end
                love.graphics.setColor({1,1,1,0})
                if self:hoveringFile() == i then
                    love.graphics.setColor({1,1,1,0.25})
                end
                love.graphics.rectangle("fill", self.x+4, y, self.w-8, 20)
                y = y + 20
            end
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
        self.desktop.dontOverwriteFocus = true
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
            if AABB(mx, my, 1, 1, self.x+4, y, self.w-8, 20) then
                return i
            end
            y = y + 20
        end
    end
    return false
end