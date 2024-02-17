WindowMenu = Class("WindowMenu", Window)

function WindowMenu:initialize(desktop, x, y, w, h, args)
    Window.initialize(self, desktop, x, y, 400, 300, "menu", 400, 300, false, true, {minimize=true, fullscreen=false, close=false})

    local centerX = (self.w/2)-(TitleImg:getWidth()/2)
    local startY = self.navbar.h+8+TitleImg:getHeight()+8
    self.elements.start = UI.button({x=centerX, y=startY, w=TitleImg:getWidth(), h=20, text="britdan", desktop=desktop, func=function ()
        DesktopName = "britdan"
        Screen:changeState("desktop", {"fade", 0.25, {0,0,0}}, {"fade", 0.25, {0,0,0}})
    end})
    self:sync()

    self.program = "menu"
    self.icon = "britfile"
end

function WindowMenu:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(TitleImg, self.x+(self.w/2)-(TitleImg:getWidth()/2), self.y+self.navbar.h+16)

    -- Draw UI
    Window.drawUI(self)
end