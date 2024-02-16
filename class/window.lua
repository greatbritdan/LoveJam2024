Window = Class("Window")

function Window:initialize(w, h)
    self.x, self.y, self.w, self.h = (Env.width)-(w/2), (Env.height)-(h/2), w, h
end

function Window:draw()
    love.graphics.setColor(0,0,0,0.75)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end