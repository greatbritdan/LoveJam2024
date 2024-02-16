Desktop = Class("Desktop")

function Desktop:initialize()
    self.filesystem = {
        test = {
            type = "txt",
            content = "Hello, World!"
        },
        test2 = {
            type = "txt",
            content = "Hello, World! But different!"
        }
    }
    self.background = {0.4,0.7,1}
    self.w, self.h = Env.width, Env.height
end

function Desktop:draw()
    love.graphics.setColor(self.background)
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)

    love.graphics.setColor(0,0,0,0.75)
    love.graphics.rectangle("fill", 0, self.h-16, self.w, 16)
end