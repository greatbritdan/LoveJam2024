WindowImageViewer = Class("WindowImageViewer", Window)

function WindowImageViewer:initialize(desktop, x, y, w, h, args)
    Window.initialize(self, desktop, x, y, 200, 150, "image viewer")
    self.img = args and args.img or false
    self.filename = args and args.filename or "unknown.image"
    self.program = "imageviewer"
    self.icon = "imageviewer"
end

function WindowImageViewer:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    -- Draw title
    love.graphics.setColor(self.desktop:getColor("window","subfill"))
    love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 13)
    love.graphics.setColor(self.desktop:getColor("window","subtext"))
    love.graphics.printf(self.filename, self.x+4, self.y+self.navbar.h+3, self.w-8, "left")

    -- Print out content
    if self.img then
        love.graphics.setColor(1,1,1)
        local smallestScale = math.min(self.w/self.img:getWidth(), (self.h-self.navbar.h-13)/self.img:getHeight())
        local x, y = self.x+(self.w-self.img:getWidth()*smallestScale)/2, self.y+self.navbar.h+13+(self.h-self.navbar.h-13-self.img:getHeight()*smallestScale)/2
        love.graphics.draw(self.img, x, y, 0, smallestScale, smallestScale)
    else
        love.graphics.setColor(self.desktop:getColor("window","error"))
        love.graphics.printf("error: no image provided, please open a valid image file.", self.x+4, self.y+self.navbar.h+17, self.w-8, "center")
    end

    -- Draw UI
    Window.drawUI(self)
end