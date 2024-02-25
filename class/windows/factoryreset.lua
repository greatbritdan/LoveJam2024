WindowFactoryreset = Class("WindowFactoryreset", Window)

WindowFactoryresetEnding = nil

function WindowFactoryreset:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 200, 150, "factory reset", 200, 150, false, true, {fullscreen=false})
    self.program = "factoryreset"
    self.icon = "factoryreset"

    self.areYouSure = false
    self.choice = false
    self:updateScreen()
end

function WindowFactoryreset:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    if self.choice then
        love.graphics.setColor(self.desktop:getColor("window","text"))
        if self.choice == "yes" then
            love.graphics.printf("factory reset initialized...", self.x+8, self.y+self.navbar.h+4, self.w-16, "center")
        else
            love.graphics.printf("factory reset aborted...", self.x+8, self.y+self.navbar.h+4, self.w-16, "center")
        end
    elseif self.areYouSure then
        love.graphics.setColor(self.desktop:getColor("window","text"))
        love.graphics.printf("are you sure you want to factory reset?", self.x+8, self.y+self.navbar.h+4, self.w-16, "center")
    else
        -- Get requirements
        local antivirus = self.desktop:getAntivirus("ann0n112")
        local bank = self.desktop:getBank("ann0n7")

        -- Draw requirements
        if (antivirus.enabled) or (not bank.closed) then
            love.graphics.setColor(self.desktop:getColor("window","error"))
            love.graphics.printf("you have missing requirements:", self.x+8, self.y+self.navbar.h+4, self.w-16, "center")

            local i = 0
            if antivirus.enabled then
                i = i + 1
                love.graphics.printf(i..". you must disable your antivirus", self.x+8, self.y+self.navbar.h+24+((i-1)*24), self.w-16, "center")
            end
            if not bank.closed then
                i = i + 1
                love.graphics.printf(i..". you must close your bank account", self.x+8, self.y+self.navbar.h+24+((i-1)*24), self.w-16, "center")
            end
            self.elements.reset.active = false
        else
            love.graphics.setColor(self.desktop:getColor("window","success"))
            love.graphics.printf("no missing requirements:", self.x+8, self.y+self.navbar.h+4, self.w-16, "center")
            self.elements.reset.active = true
        end
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowFactoryreset:updateScreen()
    self.elements = {}

    if self.choice then
        WindowFactoryresetEnding = self.choice
        self.desktop:complete(true)
    elseif self.areYouSure then
        self.elements.yes = UI.button({x=4, y=self.h-20, w=self.w/2-6, h=16, text="yes", func=function()
            self.choice = "yes"
            self:updateScreen()
        end, resize=function(element)
            element.y = self.y+self.h-20
            element.w = self.w/2-6
        end})
        self.elements.no = UI.button({x=self.w/2+2, y=self.h-20, w=self.w/2-6, h=16, text="no", func=function()
            self.choice = "no"
            self:updateScreen()
        end, resize=function(element)
            element.y = self.y+self.h-20
            element.w = self.w/2-6
        end})

        local file = self.desktop:getFile("b:/desktop/last pleed")
        self.desktop:openFile(file)
    else
        self.elements.reset = UI.button({x=4, y=self.h-20, w=self.w-8, h=16, text="factory reset", func=function()self.areYouSure = true; self:updateScreen() end, resize=function(element)
            element.y = self.y+self.h-20
            element.w = self.w-8
        end})
    end
    self:sync()
end