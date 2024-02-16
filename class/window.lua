Window = Class("Window")

function Window:initialize(desktop, w, h)
    self.desktop = desktop
    self.taskbar = desktop.taskbar
    self.x, self.y, self.w, self.h = (Env.width/2)-(w/2), ((Env.height-self.taskbar.h)/2)-(h/2), w, h
    self.navbar = {
        h = 12
    }
    self.text = "test omg its a widow"

    self.moving = false
    self.resizing = false
    self.resizePadding = 4
end

function Window:update(dt)
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    if self.moving then
        self.x, self.y = mx-self.mx, my-self.my
    end
    if self.resizing then
        if Tablecontains(self.resizing, "top") then
            self.y = my
            self.h = self.oh-(my-self.oy)
        end
        if Tablecontains(self.resizing, "bottom") then
            self.h = my-self.y
        end
        if Tablecontains(self.resizing, "left") then
            self.x = mx
            self.w = self.ow-(mx-self.ox)
        end
        if Tablecontains(self.resizing, "right") then
            self.w = mx-self.x
        end
    end
end

function Window:draw()
    love.graphics.setColor(1,1,1,0.75)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(0,0,0,0.75)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.navbar.h)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(self.text, self.x, self.y+self.navbar.h+4, self.w, "center")
    -- visualise padding
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", self.x+self.w-self.resizePadding, self.y, self.resizePadding, self.h)
    love.graphics.rectangle("fill", self.x, self.y, self.resizePadding, self.h)
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.resizePadding)
    love.graphics.rectangle("fill", self.x, self.y+self.h-self.resizePadding, self.w, self.resizePadding)
end

function Window:mousepressed(mx,my, b)
    if b ~= 1 then return end
    local hover = self:hovering(mx, my)
    if not hover then return end
    if hover[1] == "navbar" then
        self.moving = true
        self.mx, self.my = mx-self.x, my-self.y
    end
    if hover[1] == "resize" then
        self.resizing = hover
        self.ox, self.oy, self.ow, self.oh = self.x, self.y, self.w, self.h
    end
end

function Window:mousereleased(mx, my, b)
    if b ~= 1 then return end
    if self.moving then
        self.moving = false
    end
    if self.resizing then
        self.resizing = false
    end
end

function Window:hovering(mx, my)
    -- Check if hovering over edges (resizeing)
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
    -- Check if hovering over navbar
    if AABB(mx, my, 1, 1, self.x, self.y, self.w, self.navbar.h) then
        return {"navbar"}
    end
    if AABB(mx, my, 1, 1, self.x, self.y, self.w, self.h) then
        return {"window"}
    end
    return false
end