WindowFileManager = Class("fileManager", Window)

function WindowFileManager:initialize(desktop, x, y, w, h, args)
    Window.initialize(self, desktop, x, y, 300, 200, "file manager", 300, 200)
    local path = args and args.path or "b:/"

    self.scrollable = true

    self.elements.path = UI.input({x=2, y=2, w=self.w-22, h=16, text=path, mc=50, desktop=desktop, func=function() self:search() end, resize=function (element)
        element.w = self.w-22
    end})
    self.elements.back = UI.button({x=self.w-18, y=2, w=16, h=16, text="<", desktop=desktop, func=function() self:goBack() end, resize=function (element)
        element.x = self.x+self.w-18
    end})
    self:createIcons()
    self:sync()

    self.program = "filemanager"
    self.icon = "filemanager"
end

function WindowFileManager:createIcons()
    self.icons = {}
    local files = self.desktop:getFile(self.elements.path.text)
    if files then
        local i = 1
        for _, file in ipairs(files) do
            if file.hidden ~= true then
                table.insert(self.icons, FileButton:new(self.desktop, self, i, file))
                i = i + 1
            end
        end
    end
    self:updateScroll()
end

function WindowFileManager:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)
    love.graphics.setColor(self:getColor("subbackground"))
    love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 20)

    -- Draw icons
    love.graphics.setScissor(self.x*Env.scale, (self.y+self.navbar.h+24)*Env.scale, self.w*Env.scale, (self.h-self.navbar.h-28)*Env.scale)
    for _, icon in ipairs(self.icons) do
        icon:draw()
    end
    love.graphics.setScissor()

    -- Draw UI
    Window.drawUI(self)
end

function WindowFileManager:mousepressed(mx, my, b)
    if self.minimized then return end
    if b ~= 1 then return end
    for _, icon in ipairs(self.icons) do
        if icon:mousepressed(mx, my, b) then
            return true
        end
    end
    return Window.mousepressed(self, mx, my, b)
end

function WindowFileManager:mousereleased(mx, my, b)
    if self.minimized then return end
    if b ~= 1 then return end
    for _, icon in ipairs(self.icons) do
        if icon:mousereleased(mx, my, b) then
            self:createIcons()
            return true
        end
    end
    return Window.mousereleased(self, mx, my, b)
end

function WindowFileManager:goBack()
    local path = self.elements.path.text
    if path == "b:/" then
        return
    end
    path = string.gsub(path, "^b:/", "")
    path = RemoveEmpty(Split(path, "/"))
    table.remove(path, #path)
    if #path > 0 then
        path = table.concat(path, "/").."/"
        self.elements.path.text = "b:/"..path
    else
        self.elements.path.text = "b:/"
    end
    self:createIcons()
end

function WindowFileManager:search()
    self:createIcons()
end

function WindowFileManager:updateScroll()
    local height = (#self.icons*20)+4
    self.scrollMax = -(height-(self.h-self.navbar.h-24))
    if self.scrollMax < 0 then
        self.scrollable = true
    else
        self.scrollMax = 0
    end
end