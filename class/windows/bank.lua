WindowBank = Class("WindowBank", Window)

WindowBankData = {}

function WindowBank:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "bank", 300, 200)
    self.program = "bank"
    self.icon = "bank"

    if not WindowBankData.authenticated then
        self:changeScreen("login")
    else
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
    local function resizeElement(element, offsetY)
        local sy = ((self.h-self.navbar.h)/2)-60+self.navbar.h
        element.y = self.y+sy+offsetY
        element.w = self.w-16
    end

    self.elements = {}
    self.screen = screen
    self.subscreen = subscreen or false

    if self.screen == "login" then
        self.elements.accnamelabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="account name:", desktop=self.desktop, resize=function (element)
            resizeElement(element, 0)
        end})
        self.elements.accname = UI.input({x=8, y=0, w=self.w-16, h=16, text="", mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 20)
        end, func=function (element)
            self.elements.forgot.active = false
            if element.text ~= "" then
                self.elements.forgot.active = true
            end
        end})
        self.elements.passwordlabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="password:", desktop=self.desktop, resize=function (element)
            resizeElement(element, 40)
        end})
        self.elements.password = UI.input({x=8, y=0, w=self.w-16, h=16, text="", mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 60)
        end})
        self.elements.login = UI.button({x=8, y=0, w=self.w-16, h=16, text="login", desktop=self.desktop, resize=function (element)
            resizeElement(element, 80)
        end, func=function (element)
            local validaccount = self.desktop:validateBank(self.elements.accname.text, self.elements.password.text)
            if validaccount then
                local bankn = self.elements.accname.text
                local bank = self.desktop:getBank(bankn)
                if not bank.closed then
                    print("authenticated")
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
                    self.errorMessage = "email with recovery code sent to "..bank.email
                    self.desktop:sendEmail(bank.email, "bank@inbox.com", "bank password recovery", "your recovery code is: "..bank.password)
                else
                    self.errorMessage = "this account is now closed"
                end
            else
                self.errorMessage = "invalid account name"
            end
        end})
        self.elements.forgot.active = false
    else
    end
    self:sync()
end