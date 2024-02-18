WindowBank = Class("WindowBank", Window)

WindowBankData = {
    accnameinput = "user1_newaccount",
    passwordinput = "284733",
}

function WindowBank:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "bank", 300, 200)
    self.program = "bank"
    self.icon = "bank"

    self.accname = false
    if not WindowBankData.authenticated then
        self:changeScreen("login")
    else
        self.accname = WindowBankData.authenticated
        self:changeScreen("home")
    end
end

function WindowBank:draw()
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

        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.printf(self.accname, self.x+3, self.y+self.navbar.h+6, (self.w/2)-6, "center")
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowBank:mousepressed(mx, my, b)
    if self.minimized then return end
    if b ~= 1 then return end
    return Window.mousepressed(self, mx, my, b)
end

function WindowBank:mousereleased(mx, my, b)
    if self.minimized then return end
    if b ~= 1 then return end
    return Window.mousereleased(self, mx, my, b)
end

function WindowBank:changeScreen(screen,subscreen)
    self.elements = {}
    self.screen = screen
    self.subscreen = subscreen or false

    if self.screen == "login" then
        local function resizeElement(element, offsetY)
            local sy = ((self.h-self.navbar.h)/2)-60+self.navbar.h
            element.y = self.y+sy+offsetY
            element.w = self.w-16
        end

        local accnameinput = WindowBankData.accnameinput or ""
        local passwordinput = WindowBankData.passwordinput or ""

        self.elements.accnamelabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="account name:", desktop=self.desktop, resize=function (element)
            resizeElement(element, 0)
        end})
        self.elements.accname = UI.input({x=8, y=0, w=self.w-16, h=16, text=accnameinput, mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 20)
        end, func=function (element)
            WindowBankData.accnameinput = element.text
            self.elements.forgot.active = false
            if element.text ~= "" then
                self.elements.forgot.active = true
            end
        end})
        self.elements.passwordlabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="password:", desktop=self.desktop, resize=function (element)
            resizeElement(element, 40)
        end})
        self.elements.password = UI.input({x=8, y=0, w=self.w-16, h=16, text=passwordinput, mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 60)
        end, func=function (element)
            WindowBankData.passwordinput = element.text
        end})
        self.elements.login = UI.button({x=8, y=0, w=self.w-16, h=16, text="login", desktop=self.desktop, resize=function (element)
            resizeElement(element, 80)
        end, func=function (element)
            local validaccount = self.desktop:validateBank(self.elements.accname.text, self.elements.password.text)
            if validaccount then
                local bankn = self.elements.accname.text
                local bank = self.desktop:getBank(bankn)
                if not bank.closed then
                    self.accname = self.elements.accname.text
                    WindowBankData.authenticated = self.accname
                    self.errorMessage = false
                    self:changeScreen("home")
                else
                    self.errorMessage = "this account is now closed"
                end
            else
                self.errorMessage = "invalid account name or password"
            end
        end})
        self.elements.forgot = UI.button({x=8, y=0, w=self.w-16, h=16, text="forgot password", desktop=self.desktop, resize=function (element)
            resizeElement(element, 100)
        end, func=function (element)
            local validaccount = self.desktop:validateBankReset(self.elements.accname.text)
            if validaccount then
                local bankn = self.elements.accname.text
                local bank = self.desktop:getBank(bankn)
                if not bank.closed then
                    self.errorMessage = "email with recovery code sent"
                    self.desktop:sendEmail(bank.email, "bank@inbox.com", "bank password recovery", "your recovery code is: "..bank.password,bank.identifier)
                else
                    self.errorMessage = "this account is now closed"
                end
            else
                self.errorMessage = "invalid account name"
            end
        end})
        self.elements.forgot.active = false
    elseif self.screen == "home" then
        local function resizeElement(element, offsetY)
            local sy = ((self.h-self.navbar.h-20)/2)+self.navbar.h
            element.y = self.y+sy+offsetY
            element.w = self.w-16
        end

        self.elements.logout = UI.button({x=(self.w/2)+2, y=2, w=(self.w/2)-4, h=16, text="logout", desktop=self.desktop, resize=function (element)
            element.x = self.x+(self.w/2)+2
            element.w = (self.w/2)-4
        end, func=function()
            WindowInboxData.authenticated = false
            self:changeScreen("login")
        end})

        self.elements.deposit = UI.button({x=8, y=0, w=self.w-16, h=16, text="deposit", desktop=self.desktop, resize=function (element)
            resizeElement(element, 0)
        end})
        self.elements.deposit.active = false
        self.elements.withdraw = UI.button({x=8, y=0, w=self.w-16, h=16, text="withdraw", desktop=self.desktop, resize=function (element)
            resizeElement(element, 20)
        end, func=function (element)
            self:changeScreen("withdraw")
        end})
    end
    self:sync()
end