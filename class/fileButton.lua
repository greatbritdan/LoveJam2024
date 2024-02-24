FileButton = Class("FileButton")

function FileButton:initialize(desktop, window, i, file)
    self.desktop = desktop
    self.window = window or false

    self.i = i
    if self.window == "desktop" then
        if type(self.i) == "table" then
            self.x, self.y = self.i[1], self.i[2]
        else
            self.x, self.y = math.floor((self.i-1)/7)+1, ((self.i-1)%7)+1
        end
    end

    self.isShortcut = false
    if self.window == "startmenu" then
        self.file = file
    else
        if file.type == "shortcut" then
            self.file = self.desktop:getFileFromShortcut(file)
            self.isShortcut = true
        else
            self.file = file
        end
    end

    self.clicking = false
end

function FileButton:setHightlightColor()
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    if self.clicking then
        love.graphics.setColor(1,1,1,0.5)
    elseif self:hover(mx, my) then
        love.graphics.setColor(1,1,1,0.25)
    else
        love.graphics.setColor(1,1,1,0)
    end
end

function FileButton:draw()
    local name, icon
    if self.window == "startmenu" then
        name, icon = self.file, self.file
    else
        name, icon = self.file.label or self.file.name, self.file.icon or self.file.type
    end
    love.graphics.setColor({1,1,1})
    if self.window == "desktop" then
        local x, y = 8+((self.x-1)*48), 8+((self.y-1)*48)
        love.graphics.printf(name, x-2, y+34, 36, "center")
        self:drawIcon(icon, x, y, 2)
        self:setHightlightColor()
        love.graphics.rectangle("fill", x, y, 32, 32)
    elseif self.window == "startmenu" then
        local y = self.desktop.h-self.desktop.taskbar.h-self.desktop.startMenu.h+4
        love.graphics.print(name, 26, y+((self.i-1)*20)+6)
        self:drawIcon(icon, 6, y+((self.i-1)*20)+2, 1)
        self:setHightlightColor()
        love.graphics.rectangle("fill", 4, y+((self.i-1)*20), self.desktop.startMenu.w-8, 20)
    elseif self.window then
        local y = self.window.y+self.window.navbar.h+24+((self.i-1)*20)+self.window.scroll
        love.graphics.print(name, self.window.x+26, y+6)
        self:drawIcon(icon, self.window.x+6, y+2, 1)
        self:setHightlightColor()
        love.graphics.rectangle("fill", self.window.x+4, y, self.window.w-8, 20)
    end
end
function FileButton:drawIcon(icon,x,y,s)
    love.graphics.draw(IconsImg, IconsQuads[icon], x, y, 0, s, s)
    if self.isShortcut then
        love.graphics.draw(IconsImg, IconsQuads["shortcut"], x, y, 0, s, s)
    end
end

function FileButton:mousepressed(mx,my,b)
    if b ~= 1 then return end
    if self:hover(mx,my) then
        self.clicking = true
        return true
    end
    return false
end

function FileButton:mousereleased(mx,my,b)
    if b ~= 1 then return end
    if self.clicking and self:hover(mx,my) then
        self:click()
        self.clicking = false
        return true
    end
    return false
end

function FileButton:hover(mx,my)
    if self.window == "desktop" then
        local x, y = 8+((self.x-1)*48), 8+((self.y-1)*48)
        if AABB(mx, my, 1/Env.scale, 1/Env.scale, x, y, 32, 32) then
            return true
        end
    elseif self.window == "startmenu" then
        local y = self.desktop.h-self.desktop.taskbar.h-self.desktop.startMenu.h+4+((self.i-1)*20)
        if AABB(mx, my, 1/Env.scale, 1/Env.scale, 4, y, self.desktop.startMenu.w-8, 20) then
            return true
        end
    elseif self.window then
        if not AABB(mx, my, 1/Env.scale, 1/Env.scale, self.window.x+4, self.window.y+self.window.navbar.h+24, self.window.w-8, self.window.h-self.window.navbar.h-28) then
            return
        end
        local y = self.window.y+self.window.navbar.h+24+((self.i-1)*20)+self.window.scroll
        if AABB(mx, my, 1/Env.scale, 1/Env.scale, self.window.x+4, y, self.window.w-8, 20) then
            return true
        end
    end
    return false
end

function FileButton:click()
    if self.window == "desktop" then
        self.desktop:openFile(self.file)
    elseif self.window == "startmenu" then
        if self.file == "levelselect" then
            local file = self.desktop:getFile("b:/programs/levelselect")
            if file then
                self.desktop:openFile(file)
            end
        elseif self.file == "settings" then
            local file = self.desktop:getFile("b:/programs/settings")
            if file then
                self.desktop:openFile(file)
            end
        elseif self.file == "power" then
            love.event.quit()
        end
    elseif self.window then
        self.desktop:openFile(self.file, self.window)
        self.desktop.dontOverwriteFocus = true
    end
end