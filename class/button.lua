Button = Class("Button")

function Button:initialize(shape, x, y)
    self.shape = shape
    self.angle = 0
    if shape == "circle" then
        self.x, self.y, self.r = x, y, 32
        self.polygon = CreateCircle(x, y, 32, 16)
    elseif shape == "rectangle" then
        self.x, self.y, self.w, self.h = x, y, 64, 64
        self.polygon = CreateRectangle(x, y, 64, 64)
    elseif shape == "thinrectangle" then
        self.x, self.y, self.w, self.h = x, y, 64, 32
        self.polygon = CreateRectangle(x, y, 64, 32)
    end

    self.hovering = false
    self.clicking = false
end

function Button:update(dt)
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    self.hovering = HoveringPolygon(self.polygon, mx, my)
    if (not self.hovering) and self.clicking then
        self.clicking = false
    end
end

function Button:getQuad()
    if self.clicking then return 3
    elseif self.hovering then return 2
    end
    return 1
end

function Button:draw()
    love.graphics.polygon("fill", unpack(self.polygon))
    local rot = math.rad(self.angle)
    love.graphics.draw(ButtonImg, ButtonQuad[self.shape][self:getQuad()], self.x, self.y, rot, 2, 2, 16, 16)
end

function Button:click(mx, my, b)
    if b == 1 then
        self.clicking = self.hovering
    end
end

function Button:release(mx, my, b)
    if b == 1 then
        if self.clicking and self.hovering then
            print("clicked!")
        end
        self.clicking = false
    end
end

function Button:rotate(angle, dt)
    self.angle = (self.angle + angle * dt) % 360
    RotatePolygon(self.polygon, angle * dt)
end