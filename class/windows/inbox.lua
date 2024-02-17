WindowInbox = Class("WindowInbox", Window)

WindowInboxData = {
    emailinput = "user1@inbox.com",
    passwordinput = "iloveboss22"
}

function WindowInbox:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 200, 150, "inbox")
    self.program = "inbox"
    self.icon = "inbox"
    
    self.email = false
    self.emails = {}
    if not WindowInboxData.first then
        WindowInboxData.first = true
        self.errorMessage = "session expired, please re-login."
    end

    if not WindowInboxData.authenticated then
        self:changeScreen("login")
    else
        self.email = WindowInboxData.authenticated
        self.emails = self.desktop:getEmails(self.email)
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
        love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 20)

        love.graphics.setColor({0.5,0.5,0.5})
        love.graphics.printf(self.email, self.x+3, self.y+self.navbar.h+6, (self.w/2)-6, "center")
        love.graphics.printf(#self.emails, self.x+3, self.y+self.navbar.h+26, (self.w/2)-6, "center")
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowInbox:changeScreen(screen)
    local function resizeElement(element, offsetY)
        local sy = ((self.h-self.navbar.h)/2)-50+self.navbar.h
        element.y = self.y+sy+offsetY
        element.w = self.w-16
    end

    self.elements = {}
    self.screen = screen

    if self.screen == "login" then
        local emailinput = WindowInboxData.emailinput or ""
        local passwordinput = WindowInboxData.passwordinput or ""

        self.elements.emaillabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="email:", desktop=self.desktop, resize=function (element)
            resizeElement(element, 0)
        end})
        self.elements.email = UI.input({x=8, y=0, w=self.w-16, h=16, text=emailinput, mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 20)
        end, func=function() WindowInboxData.emailinput = self.elements.email.text end})
        self.elements.passwordlabel = UI.label({x=8, y=0, w=self.w-16, h=16, text="password:", desktop=self.desktop, resize=function (element)
            resizeElement(element, 40)
        end})
        self.elements.password = UI.input({x=8, y=0, w=self.w-16, h=16, text=passwordinput, mc=50, desktop=self.desktop, resize=function (element)
            resizeElement(element, 60)
        end, func=function() WindowInboxData.passwordinput = self.elements.password.text end})
        self.elements.login = UI.button({x=8, y=0, w=self.w-16, h=16, text="login", desktop=self.desktop, resize=function (element)
            resizeElement(element, 80)
        end, func=function()
            local validemail = self.desktop:validateEmail(self.elements.email.text, self.elements.password.text)
            if validemail then
                self.email = self.elements.email.text
                self.emails = self.desktop:getEmails(self.email)
                WindowInboxData.authenticated = self.email
                self.errorMessage = false
                self:changeScreen("inbox")
            else
                self.errorMessage = "invalid email or password"
            end
        end})
    elseif self.screen == "inbox" then
        self.elements.logout = UI.button({x=(self.w/2)+2, y=2, w=(self.w/2)-4, h=16, text="logout", desktop=self.desktop, resize=function (element)
            element.x = self.x+(self.w/2)+2
            element.w = (self.w/2)-4
        end, func=function()
            WindowInboxData.authenticated = false
            self:changeScreen("login")
        end})

        self.elements.slider = UI.slider({x=self.w-16, y=20, w=16, h=self.h-self.navbar.h-20, dir="ver", fl=0.25, desktop=self.desktop, resize=function (element)
            element.x = self.x+self.w-16
            element.sx = self.x+self.w-16
        end})
    end
    self:sync()
end
