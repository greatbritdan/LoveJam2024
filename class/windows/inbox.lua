WindowInbox = Class("WindowInbox", Window)

WindowInboxData = {
    emailinput = "user1@inbox.com",
    passwordinput = "iloveboss22"
}

function WindowInbox:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 200, 150, "inbox")
    self.program = "inbox"
    self.icon = "inbox"
    
    if not WindowInboxData.first then
        WindowInboxData.first = true
        self.errorMessage = "session expired, please re-login."
    end
    self.email = false
    if not WindowInboxData.authenticated then
        self:changeScreen("login")
    else
        self.email = WindowInboxData.authenticated
        self:changeScreen("inbox")
    end
end

function WindowInbox:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    if self.screen == "login" then
        -- Print out error message
        if self.errorMessage then
            love.graphics.setColor({1,0.5,0.5})
            love.graphics.printf(self.errorMessage, self.x+3, self.y+self.navbar.h+3, self.w-6, "center")
        end
    elseif self.screen == "inbox" then
        love.graphics.setColor(self:getColor("subbackground"))
        love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 13)

        love.graphics.setColor({0.5,0.5,0.5})
        love.graphics.print("inbox - "..self.email, self.x+3, self.y+self.navbar.h+3)
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowInbox:changeScreen(screen)
    self.elements = {}
    self.screen = screen
    if self.screen == "login" then
        local function resizeElement(element, offsetY)
            local sy = ((self.h-self.navbar.h)/2)-50+self.navbar.h
            element.y = self.y+sy+offsetY
            element.w = self.w-16
        end
        local emailinput = WindowInboxData.emailinput or ""
        local passwordinput = WindowInboxData.passwordinput or ""

        self.elements.emaillabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="email:", mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 0)
        end})
        self.elements.email = UI.input({x=8, y=0, w=self.w-16, h=16, text=emailinput, mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 20)
        end, func=function() WindowInboxData.emailinput = self.elements.email.text end})
        self.elements.passwordlabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="password:", mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 40)
        end})
        self.elements.password = UI.input({x=8, y=0, w=self.w-16, h=16, text=passwordinput, mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 60)
        end, func=function() WindowInboxData.passwordinput = self.elements.password.text end})
        self.elements.login = UI.button({x=8, y=0, w=self.w-16, h=16, text="login", mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 80)
        end, func=function()
            if self.elements.email.text == "user1@inbox.com" and self.elements.password.text == "iloveboss22" then
                self.email = self.elements.email.text
                WindowInboxData.authenticated = self.email
                self.errorMessage = false
                self:changeScreen("inbox")
            else
                self.errorMessage = "invalid email or password"
            end
        end})
    end
    self:sync()
end