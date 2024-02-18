Button = Class("Button")

function Button:initialize(scene, shape, x, y)
    self.scene = scene
    self.shape = shape
    self.angle = 0
    if shape == "circle" then
        self.x, self.y, self.r = x, y, 32
        self.polygon = Polygon:new(self.shape, self.x, self.y, self.r)
    elseif shape == "rectangle" then
        self.x, self.y, self.w, self.h = x, y, 64, 64
        self.polygon = Polygon:new(self.shape, self.x, self.y, 64, 64)
    elseif shape == "thinrectangle" then
        self.x, self.y, self.w, self.h = x, y, 64, 32
        self.polygon = Polygon:new(self.shape, self.x, self.y, 64, 32)
    end

    self.velocity = {0, 0, 0} -- x, y, spin
    self.gravity = 384

    self.combo = 0
    self.scoretext = {}

    self.hovering = false
    self.clicking = false
end

function Button:update(dt)
    -- Move the Button
    self.x = self.x + (self.velocity[1] * dt)
    self.y = self.y + (self.velocity[2] * dt)
    self.velocity[2] = self.velocity[2] + self.gravity * dt
    self:rotate(self.velocity[3], dt)
    self.polygon:move(self.x,self.y)

    -- Check if the button is out of bounds
    if self.polygon:center()[2] > Env.height then
        self.DELETEME = true
    end
    if self.polygon:center()[1] < 0 then
        self.velocity[1] = -self.velocity[1]
    end
    if self.polygon:center()[1] > Env.width then
        self.velocity[1] = -self.velocity[1]
    end

    -- Check if the mouse is hovering the button
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    self.hovering = self.polygon:hover(mx, my)
    if (not self.hovering) and self.clicking then
        self.clicking = false
    end

    -- Update the scoretext
    for i, v in ipairs(self.scoretext) do
        v:update(dt)
        if v.opacity <= 0 then
            table.remove(self.scoretext, i)
        end
    end
end

function Button:getQuad()
    if self.clicking then return 3
    elseif self.hovering then return 2
    end
    return 1
end

function Button:draw()
    -- Draw the Button
    local rot = math.rad(self.angle)
    love.graphics.draw(ButtonImg, ButtonQuad[self.shape][self:getQuad()], self.x, self.y, rot, 2, 2, 16, 16)

    -- Draw the scoretext
    for i, v in ipairs(self.scoretext) do
        v:draw()
    end
end

function Button:click(mx, my, b)
    if b == 1 then
        self.clicking = self.hovering
    end
end

function Button:release(mx, my, b)
    if b == 1 then
        if self.clicking and self.hovering then
            if self.combo < 5 then
                self.combo = self.combo + 1
            end
            self.scene:addScore(self.combo, self)
        end
        self.clicking = false
    end
end

function Button:rotate(angle, dt)
    self.angle = (self.angle + angle * dt) % 360
    self.polygon:rotate(angle * dt)
end