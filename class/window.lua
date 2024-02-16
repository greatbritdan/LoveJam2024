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
end

function Window:update(dt)
    if self.moving then
        local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
        self.x, self.y = mx-self.mx, my-self.my
    end
end

function Window:draw()
    love.graphics.setColor(1,1,1,0.75)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(0,0,0,0.75)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.navbar.h)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(self.text, self.x, self.y+self.navbar.h+4, self.w, "center")
end

function Window:mousepressed(mx,my, b)
    if b ~= 1 then return end
    local hover = self:hovering(mx, my)
    if hover == "navbar" then
        self.moving = true
        self.mx, self.my = mx-self.x, my-self.y
    end
end

function Window:mousereleased(mx, my, b)
    if b ~= 1 then return end
    if self.moving then
        self.moving = false
    end
end

function Window:hovering(mx, my)
    if AABB(mx, my, 1, 1, self.x, self.y, self.w, self.navbar.h) then
        return "navbar"
    end
    if AABB(mx, my, 1, 1, self.x, self.y, self.w, self.h) then
        return "window"
    end
end