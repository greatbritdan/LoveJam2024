ScoreText = Class("ScoreText")

function ScoreText:initialize(source, text)
    self.x, self.y = source.x, source.y
    self.text = text
    self.opacity = 1
end

function ScoreText:update(dt)
    self.y = self.y - 64 * dt
    self.opacity = self.opacity - dt
end

function ScoreText:draw()
    love.graphics.setColor(1,1,1,self.opacity)
    love.graphics.printf(self.text, self.x-32, self.y, 64, "center", 0, 2, 2)
end