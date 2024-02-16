Window = Class("Window")

function Window:initialize(desktop, x, y, w, h, title, minW, minH)
    self.desktop = desktop
    self.program = false
    self.icon = "test"

    self.x, self.y = x or (Env.width/2)-(w/2), y or ((Env.height-self.desktop.taskbar.h)/2)-(h/2)
    self.w, self.h = w, h
    self.minW, self.minH = minW or 200, minH or 150

    self.minimized = false
    self.fullscreen = false
    self.ox, self.oy, self.ow, self.oh = self.x, self.y, self.w, self.h

    self.navbar = {
        h = 13,
        buttons = {}
    }
    self.navbar.buttons[1] = {
        name = "minimize",
        color = {normal={0,1,0},hover={0.5,1,0},click={0,0.75,0}},
        func = function()
            self.minimized = true
            if self.desktop.focus == self then
                self.desktop.focus = false
            end
        end
    }
    self.navbar.buttons[2] = {
        name = "fullscreen",
        color = {normal={1,1,0},hover={1,1,0.5},click={0.75,0.75,0}},
        func = function()
            if self.fullscreen then
                self.x, self.y, self.w, self.h = self.ox, self.oy, self.ow, self.oh
                self.fullscreen = false
            else
                self.ox, self.oy, self.ow, self.oh = self.x, self.y, self.w, self.h
                self.x, self.y, self.w, self.h = 0, 0, Env.width, Env.height
                self.fullscreen = true
            end
            self:sync()
        end
    }
    self.navbar.buttons[3] = {
        name = "close",
        color = {normal={1,0,0},hover={1,0.5,0},click={0.75,0,0}},
        func = function()
            self.desktop:windowClose(self)
        end
    }

    self.elements = {}

    self.title = title

    self.moving = false
    self.resizing = false
    self.resizePadding = 2
    self.clicking = false

    self.debug = false
end

function Window:getColor(name,subname)
    if subname then
        return self.desktop.themes[self.desktop.theme]["window"][name][subname]
    end
    return self.desktop.themes[self.desktop.theme]["window"][name]
end

function Window:update(dt)
    if self.minimized then return end
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    if self.moving then
        self.x, self.y = mx-self.mx, my-self.my
        self:sync()
    end
    if self.resizing then
        if TableContains(self.resizing, "top") then
            self.y = my
            self.h = self.oh-(my-self.oy)
            if self.h < self.minH then
                self.h = self.minH
                self.y = self.oy+self.oh-self.minH
            end
        end
        if TableContains(self.resizing, "bottom") then
            self.h = my-self.y
            if self.h < self.minH then
                self.h = self.minH
            end
        end
        if TableContains(self.resizing, "left") then
            self.x = mx
            self.w = self.ow-(mx-self.ox)
            if self.w < self.minW then
                self.w = self.minW
                self.x = self.ox+self.ow-self.minW
            end
        end
        if TableContains(self.resizing, "right") then
            self.w = mx-self.x
            if self.w < self.minW then
                self.w = self.minW
            end
        end
        self:sync()
    end
    for _, element in pairs(self.elements) do
        element:update(dt)
    end
end

function Window:draw()
    if self.minimized then return end
    self:drawWindow()
    self:drawUI()
end

function Window:drawWindow()
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    local hover = self:hovering(mx, my)

    -- Draw window
    love.graphics.setColor(self:getColor("background"))
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    love.graphics.setColor(self:getColor("navbar","background"))
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.navbar.h)
    love.graphics.setColor({0.5,0.5,0.5})
    if self.desktop.focus == self then
        love.graphics.setColor(self:getColor("navbar","text"))
    end
    love.graphics.print(self.title, self.x+3, self.y+3)

    -- Draw navbar buttons
    for i, button in pairs(self.navbar.buttons) do
        local x = self.x+self.w-(#self.navbar.buttons*self.navbar.h)+((i-1)*self.navbar.h)
        love.graphics.setColor(button.color.normal)
        if hover and hover[1] == "navbarbutton" and hover[2] == button then
            if love.mouse.isDown(1) then
                love.graphics.setColor(button.color.click)
            else
                love.graphics.setColor(button.color.hover)
            end
        end
        love.graphics.rectangle("fill", x, self.y, self.navbar.h, self.navbar.h)
    end

    if not self.debug then return end
    -- visualise padding
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", self.x+self.w-self.resizePadding, self.y, self.resizePadding, self.h)
    love.graphics.rectangle("fill", self.x, self.y, self.resizePadding, self.h)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.resizePadding)
    love.graphics.rectangle("fill", self.x, self.y+self.h-self.resizePadding, self.w, self.resizePadding)
end

function Window:drawUI()
    -- Draw elements
    for _, element in pairs(self.elements) do
        element:draw()
    end
end

function Window:mousepressed(mx,my, b)
    if self.minimized then return end
    if b ~= 1 then return end
    local hover = self:hovering(mx, my)
    if not hover then return false end
    if hover[1] == "navbar" then
        self.moving = true
        self.mx, self.my = mx-self.x, my-self.y
        if self.fullscreen then
            self.w, self.h = self.ow, self.oh
            self.mx = self.mx/(Env.width/self.w)
            self.fullscreen = false
        end
        self:sync()
    end
    if hover[1] == "resize" then
        self.resizing = hover
        self.ox, self.oy, self.ow, self.oh = self.x, self.y, self.w, self.h
        self:sync()
    end
    if hover[1] == "navbarbutton" then
        self.clicking = hover[2]
    end
    if hover[1] == "window" then
        for _, element in pairs(self.elements) do
            element:press(mx, my, b)
        end
    end
    return true
end

function Window:mousereleased(mx, my, b)
    if self.minimized then return end
    if b ~= 1 then return end
    if self.moving then
        self.moving = false
    end
    if self.resizing then
        self.resizing = false
    end
    if self.clicking then
        local hover = self:hovering(mx, my)
        if hover and hover[1] == "navbarbutton" and hover[2] == self.clicking then
            self.clicking.func()
        end
        self.clicking = false
    end
    for _, element in pairs(self.elements) do
        element:unpress(mx, my, b)
    end
end

function Window:textinput(text)
    if self.minimized then return end
    for _, element in pairs(self.elements) do
        element:textinput(text)
    end
end

function Window:keypressed(key, scancode, isrepeat)
    if self.minimized then return end
    for _, element in pairs(self.elements) do
        element:keypress(key, scancode, isrepeat)
    end
end

function Window:hovering(mx, my)
    -- Check if hovering over navbar buttons (closing, minimizing, etc)
    for i, button in pairs(self.navbar.buttons) do
        local x = self.x+self.w-(#self.navbar.buttons*self.navbar.h)+((i-1)*self.navbar.h)
        if AABB(mx, my, 1, 1, x, self.y, self.navbar.h, self.navbar.h) then
            return {"navbarbutton", button}
        end
    end
    -- Check if hovering over edges (resizing window)
    local top = AABB(mx, my, 1, 1, self.x, self.y, self.w, self.resizePadding)
    local right = AABB(mx, my, 1, 1, self.x+self.w-self.resizePadding, self.y, self.resizePadding, self.h)
    local bottom = AABB(mx, my, 1, 1, self.x, self.y+self.h-self.resizePadding, self.w, self.resizePadding)
    local left = AABB(mx, my, 1, 1, self.x, self.y, self.resizePadding, self.h)
    if top or right or bottom or left then
        local result = {"resize"}
        if top then
            table.insert(result, "top")
        end
        if bottom then
            table.insert(result, "bottom")
        end
        if left then
            table.insert(result, "left")
        end
        if right then
            table.insert(result, "right")
        end
        return result
    end
    -- Check if hovering over navbar (moving window)
    if AABB(mx, my, 1, 1, self.x, self.y, self.w, self.navbar.h) then
        return {"navbar"}
    end
    if AABB(mx, my, 1, 1, self.x, self.y, self.w, self.h) then
        return {"window"}
    end
    return false
end

function Window:sync()
    for _, element in pairs(self.elements) do
        if not element.startX then
            element.startX, element.startY = element.x, element.y
        end
        element.x, element.y = self.x+element.startX, self.y+self.navbar.h+element.startY
        if element.resize then
            element:resize()
        end
    end
end