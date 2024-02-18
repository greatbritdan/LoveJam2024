MenuScreen = Class("MenuScreen")

function MenuScreen:initialize()
    self.spriteBatchWidth = 0
    self.backgroundSpriteBatch = love.graphics.newSpriteBatch(BackgroundImg, 100)
    for i = 0, Env.width/128 do
        for j = 0, Env.height/128 do
            self.backgroundSpriteBatch:add(i*128, j*128, 0, 2, 2)
        end
        self.spriteBatchWidth = self.spriteBatchWidth + 128
    end
end
function MenuScreen:update(dt)
end
function MenuScreen:draw()
    -- Draw the Background
    love.graphics.setColor(1,1,1)
    local x = (Env.width/2)-(self.spriteBatchWidth/2)
    love.graphics.draw(self.backgroundSpriteBatch, x)
end
function MenuScreen:mousepressed(mx, my, b)
end
function MenuScreen:mousereleased(mx, my, b)
end
function MenuScreen:keypressed(key)
end