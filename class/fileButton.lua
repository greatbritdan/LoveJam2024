FileButton = Class("FileButton")

function FileButton:initialize(desktop, window, i, file)
    self.desktop = desktop
    self.window = window or false

    self.i = i
    if not self.window then
        if type(self.i) == "table" then
            self.x, self.y = self.i[1], self.i[2]
        else
            self.x, self.y = math.floor((self.i-1)/7)+1, ((self.i-1)%7)+1
        end
    end

    self.isShortcut = false
    if file.type == "shortcut" then
        self.file = self.desktop:getFileFromShortcut(file)
        self.isShortcut = true
    else
        self.file = file
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
    love.graphics.setColor({1,1,1})
    if self.window and self.file.hidden ~= true then
        local y = self.window.y+self.window.navbar.h+24+((self.i-1)*20)+self.window.scroll
        love.graphics.print(self.file.name, self.window.x+24, y+6)
        if self.file.icon then
            love.graphics.draw(IconsImg, IconsQuads[self.file.icon], self.window.x+4, y+2)
        else
            love.graphics.draw(IconsImg, IconsQuads[self.file.type], self.window.x+4, y+2)
        end
        if self.isShortcut then
            love.graphics.draw(IconsImg, IconsQuads["shortcut"], self.window.x+4, y+2)
        end
        self:setHightlightColor()
        love.graphics.rectangle("fill", self.window.x+4, y, self.window.w-8, 20)
    else
        local x, y = 8+((self.x-1)*48), 8+((self.y-1)*48)
        love.graphics.printf(self.file.name, x-2, y+34, 36, "center")
        if self.file.icon then
            love.graphics.draw(IconsImg, IconsQuads[self.file.icon], x, y, 0, 2, 2)
        else
            love.graphics.draw(IconsImg, IconsQuads[self.file.type], x, y, 0, 2, 2)
        end
        if self.isShortcut then
            love.graphics.draw(IconsImg, IconsQuads["shortcut"], x, y, 0, 2, 2)
        end
        self:setHightlightColor()
        love.graphics.rectangle("fill", x, y, 32, 32)
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
    if self.window then
        if not AABB(mx, my, 1, 1, self.window.x+4, self.window.y+self.window.navbar.h+24, self.window.w-8, self.window.h-self.window.navbar.h-28) then
            return
        end
        local y = self.window.y+self.window.navbar.h+24+((self.i-1)*20)+self.window.scroll
        if AABB(mx, my, 1/Env.scale, 1/Env.scale, self.window.x+4, y, self.window.w-8, 20) then
            return true
        end
    else
        local x, y = 8+((self.x-1)*48), 8+((self.y-1)*48)
        if AABB(mx, my, 1/Env.scale, 1/Env.scale, x, y, 32, 32) then
            return true
        end
    end
    return false
end

function FileButton:click()
    if self.window then
        self.desktop:openFile(self.file, self.window)
        self.desktop.dontOverwriteFocus = true
    else
        self.desktop:openFile(self.file)
    end
end