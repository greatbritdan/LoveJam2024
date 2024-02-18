ScoreText = Class("ScoreText")

function ScoreText:initialize(source, text)
    local center = source.polygon:center()
    self.x, self.y = center[1], center[2]
    self.text = text
    self.lines = #Split(self.text, "\n")
    self.opacity = 1
end

function ScoreText:update(dt)
    self.y = self.y - 64 * dt
    self.opacity = self.opacity - dt
    if self.opacity <= 0 then
        self.DELETEME = true
    end
end

function ScoreText:draw()
    love.graphics.setColor(1,1,1,self.opacity)
    --love.graphics.rectangle("fill", self.x-1, self.y-1, 2, 2)
    love.graphics.printf(self.text, self.x-64, self.y-(self.lines*10), 64, "center", 0, 2, 2)
end