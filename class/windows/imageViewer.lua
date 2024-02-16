WindowImageViewer = Class("WindowImageViewer", Window)

function WindowImageViewer:initialize(desktop, x, y, w, h, image, filename)
    Window.initialize(self, desktop, x, y, w, h, "image viewer")
    self.image = image or false
    self.filename = filename or "unknown.image"

    self.program = "imageviewer"
    self.icon = "imageviewer"
end

function WindowImageViewer:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)
    love.graphics.setColor(self:getColor("subbackground"))
    love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 13)

    -- Print out content
    love.graphics.setColor({0.5,0.5,0.5})
    love.graphics.printf(self.filename, self.x+4, self.y+self.navbar.h+3, self.w-8, "left")
    if self.image then
        love.graphics.setColor({1,1,1})
        local smallestScale = math.min(self.w/self.image:getWidth(), (self.h-self.navbar.h-13)/self.image:getHeight())
        local x, y = self.x+(self.w-self.image:getWidth()*smallestScale)/2, self.y+self.navbar.h+13+(self.h-self.navbar.h-13-self.image:getHeight()*smallestScale)/2
        love.graphics.draw(self.image, x, y, 0, smallestScale, smallestScale)
    else
        love.graphics.setColor({1,0.5,0.5})
        love.graphics.printf("error: no image provided, please open a valid image file.", self.x+4, self.y+self.navbar.h+17, self.w-8, "left")
    end

    -- Draw UI
    Window.drawUI(self)
end