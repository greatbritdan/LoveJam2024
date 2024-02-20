WindowAntivirus = Class("WindowAntivirus", Window)

WindowAntivirusData = {
    --userinput = "",
    --passwordinput = "",
}

function WindowAntivirus:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "antivirus", 300, 200)
    self.program = "antivirus"
    self.icon = "antivirus"

    self.username = false
    if not WindowAntivirusData.authenticated then
        self:changeScreen("login")
    else
        self.username = WindowAntivirusData.authenticated
        self:changeScreen("main")
    end
end

function WindowAntivirus:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    if self.screen == "login" then
        -- Print out error message
        if self.errorMessage then
            love.graphics.setColor(1,0.5,0.5)
            love.graphics.printf(self.errorMessage, self.x+3, self.y+self.navbar.h+3, self.w-6, "center")
        end
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowAntivirus:changeScreen(screen)
    local function resizeElement(element, offsetY)
        local sy = ((self.h-self.navbar.h)/2)-50+self.navbar.h
        element.y = self.y+sy+offsetY
        element.w = self.w-16
    end

    self.elements = {}
    self.screen = screen

    if self.screen == "login" then
        local userinput = WindowAntivirusData.userinput or ""
        local passwordinput = WindowAntivirusData.passwordinput or ""

        self.elements.userlabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="username:", desktop=self.desktop, resize=function (element)
            resizeElement(element, 0)
        end})
        self.elements.user = UI.input({x=8, y=0, w=self.w-16, h=16, text=userinput, mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 20)
        end, func=function() WindowAntivirusData.userinput = self.elements.user.text end})
        self.elements.passwordlabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="password:", desktop=self.desktop, resize=function (element)
            resizeElement(element, 40)
        end})
        self.elements.password = UI.input({x=8, y=0, w=self.w-16, h=16, text=passwordinput, mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 60)
        end, func=function() WindowAntivirusData.passwordinput = self.elements.password.text end})
        self.elements.login = UI.button({x=8, y=0, w=self.w-16, h=16, text="login", desktop=self.desktop, resize=function (element)
            resizeElement(element, 80)
        end, func=function()
            local validantiv = self.desktop:validateAntivirus(self.elements.user.text, self.elements.password.text)
            if validantiv then
                self.username = self.elements.user.text
                self.antivirus = self.desktop:getAntivirus(self.username)
                WindowAntivirusData.authenticated = self.username
                self.errorMessage = false
                self:changeScreen("main")
            else
                self.errorMessage = "invalid username or password"
            end
        end})
    else
        self.elements.logout = UI.button({x=(self.w/2)+2, y=2, w=(self.w/2)-4, h=16, text="logout", desktop=self.desktop, resize=function (element)
            element.x = self.x+(self.w/2)+2
            element.w = (self.w/2)-4
        end, func=function()
            WindowInboxData.authenticated = false
            self:changeScreen("login")
        end})
    end
    self:sync()
end
