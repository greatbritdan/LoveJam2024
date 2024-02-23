WindowAntivirus = Class("WindowAntivirus", Window)

WindowAntivirusData = {
    userinput = "16floralflowers",
    passwordinput = "daisy987",
    q1input = "lexi",
    q2input = "teal",
}

function WindowAntivirus:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "antivirus", 300, 200)
    self.program = "antivirus"
    self.icon = "antivirus"

    self.username = false
    self.antivirus = {}
    if not WindowAntivirusData.authenticated then
        self:changeScreen("login")
    else
        self.username = WindowAntivirusData.authenticated
        self.antivirus = self.desktop:getAntivirus(self.username)
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
    else
        love.graphics.setColor(self:getColor("subbackground"))
        love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 20)
        if self.antivirus.enabled then
            love.graphics.setColor(0.5,1,0.5)
            love.graphics.printf("protection: on", self.x+3, self.y+self.navbar.h+6, (self.w/2)-6, "center")
        else
            love.graphics.setColor(1,0.5,0.5)
            love.graphics.printf("protection: off", self.x+3, self.y+self.navbar.h+6, (self.w/2)-6, "center")
        end

        if self.screen == "security" then
            love.graphics.setColor(1,0.5,0.5)
            love.graphics.printf("unusual activity detected, answer these security questions to access account:", self.x+3, self.y+self.navbar.h+23, self.w-6, "center")
        end
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowAntivirus:changeScreen(screen)
    self.elements = {}
    self.screen = screen

    if self.screen == "login" then
        local function resizeElement(element, offsetY)
            local sy = ((self.h-self.navbar.h)/2)-50+self.navbar.h
            element.y = self.y+sy+offsetY
            element.w = self.w-16
        end

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

        if self.screen == "main" then
            local function resizeElement(element, offsetY)
                local sy = ((self.h-self.navbar.h)/2)-20+self.navbar.h
                element.y = self.y+sy+offsetY
                element.w = self.w-16
            end

            local text = self.antivirus.enabled and "enabled" or "disabled"
            self.elements.enablelabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="antivirus:", desktop=self.desktop, resize=function (element)
                resizeElement(element, 0)
            end})
            self.elements.enable = UI.button({x=8, y=0, w=self.w-16, h=16, text=text, desktop=self.desktop, resize=function (element)
                resizeElement(element, 20)
            end, func=function()
                if WindowAntivirusData.securityAuthenticated then
                    self.antivirus.enabled = not self.antivirus.enabled
                    self.elements.enable.text = self.antivirus.enabled and "enabled" or "disabled"
                    local window = self.desktop:windowExists("zipcrash")
                    if window then
                        window.accessable = not self.antivirus.enabled
                        window:updateScreen()
                    end
                else
                    self:changeScreen("security")
                end
            end})
        elseif self.screen == "security" then
            local function resizeElement(element, offsetY)
                local sy = ((self.h-self.navbar.h)/2)-50+self.navbar.h
                element.y = self.y+sy+offsetY
                element.w = self.w-16
            end

            local q1input = WindowAntivirusData.q1input or ""
            local q2input = WindowAntivirusData.q2input or ""

            self.elements.q1label = UI.label({x=8, y=0, w=self.w-16, h=16, text=self.antivirus.security[1].question, desktop=self.desktop, resize=function (element)
                resizeElement(element, 0)
            end})
            self.elements.q1 = UI.input({x=8, y=0, w=self.w-16, h=16, text=q1input, mc=50, desktop=self.desktop, resize=function (element)
                resizeElement(element, 20)
            end, func=function() WindowAntivirusData.q1input = self.elements.q1.text end})
            self.elements.q2label = UI.label({x=8, y=0, w=self.w-16, h=16, text=self.antivirus.security[2].question, desktop=self.desktop, resize=function (element)
                resizeElement(element, 40)
            end})
            self.elements.q2 = UI.input({x=8, y=0, w=self.w-16, h=16, text=q2input, mc=50, desktop=self.desktop, resize=function (element)
                resizeElement(element, 60)
            end, func=function() WindowAntivirusData.q2input = self.elements.q2.text end})
            self.elements.submit = UI.button({x=8, y=0, w=self.w-16, h=16, text="submit", desktop=self.desktop, resize=function (element)
                resizeElement(element, 80)
            end, func=function()
                if self.elements.q1.text == self.antivirus.security[1].answer and self.elements.q2.text == self.antivirus.security[2].answer then
                    self.errorMessage = false
                    WindowAntivirusData.securityAuthenticated = true
                    self:changeScreen("main")
                else
                    self.errorMessage = "incorrect"
                end
            end})
        end
    end
    self:sync()
end
