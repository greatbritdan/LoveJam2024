WindowFactoryreset = Class("WindowFactoryreset", Window)

function WindowFactoryreset:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "factory reset", 300, 200, false, true, {fullscreen=false})
    self.program = "factoryreset"
    self.icon = "factoryreset"

    self.elements.reset = UI.button({x=4, y=self.h-20, w=self.w-8, h=16, text="factory reset", func=function() self:factoryReset() end, resize=function(element)
        element.y = self.y+self.h-20
        element.w = self.w-8
    end})
    self:sync()
end

function WindowFactoryreset:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)
    
    local antivirus = self.desktop:getAntivirus("ann0n112")
    local bank = self.desktop:getBank("ann0n7")

    -- Draw content
    if (antivirus.enabled) or (not bank.closed) then
        love.graphics.setColor(self.desktop:getColor("window","error"))
        love.graphics.printf("you have missing requirements:", self.x+8, self.y+self.navbar.h+4, self.w-16, "center")

        local i = 0
        if antivirus.enabled then
            i = i + 1
            love.graphics.printf(i..". you must disable your antivirus", self.x+8, self.y+self.navbar.h+24+((i-1)*12), self.w-16, "center")
        end
        if not bank.closed then
            i = i + 1
            love.graphics.printf(i..". you must close your bank account", self.x+8, self.y+self.navbar.h+24+((i-1)*12), self.w-16, "center")
        end
        self.elements.reset.active = false
    else
        love.graphics.setColor(self.desktop:getColor("window","success"))
        love.graphics.printf("no missing requirements:", self.x+8, self.y+self.navbar.h+4, self.w-16, "center")
        self.elements.reset.active = true
    end

    -- Draw UI
    Window.drawUI(self)
end