WindowInbox = Class("WindowInbox", Window)

WindowInboxData = {
    emailinput = "user1@inbox.com",
    passwordinput = "iloveboss22",
}

function WindowInbox:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "inbox", 300, 200)
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

    self.clickingEmail = false
end

function WindowInbox:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    if self.screen == "login" then
        -- Print out error message
        if self.errorMessage then
            love.graphics.setColor(1,0.5,0.5)
            love.graphics.printf(self.errorMessage, self.x+3, self.y+self.navbar.h+3, self.w-6, "center")
        end
    elseif self.screen == "inbox" then
        love.graphics.setColor(self:getColor("subbackground"))
        love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 20)

        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.printf(self.email, self.x+3, self.y+self.navbar.h+6, (self.w/2)-6, "center")

        -- I'm sorry...
        local hover = self:hover()
        local y = self.y+self.navbar.h+22
        for i, email in ipairs(self.emails) do
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill", self.x+2, y, self.w-20, 32)
            love.graphics.setColor(1,1,1)
            love.graphics.print(email.subject, self.x+6, y+4)
            love.graphics.print(email.from, self.x+self.w-22-Font:getWidth(email.from), y+4)
            love.graphics.setColor(0.5,0.5,0.5)
            local content = ""
            local splitn = Split(email.content,"\n")
            local split = Split(splitn[1]," ")
            for _,word in ipairs(split) do
                if love.graphics.getFont():getWidth(content.." "..word) > self.w-32 then
                    content = content.."..."
                    break
                end
                content = content.." "..word
            end
            love.graphics.print(content, self.x+6, y+16)
            if hover == i or self.clickingEmail == i then
                love.graphics.setColor(0.5,0.5,0.5,0.5)
                if self.clickingEmail == i then
                    love.graphics.setColor(0.5,0.5,0.5,0.25)
                end
                love.graphics.rectangle("fill", self.x+2, y, self.w-20, 32)
            end
            y = y + 34
        end
    elseif self.screen == "email" then
        -- Print out email
        local email = self.emails[self.subscreen]
        love.graphics.setColor(self:getColor("subbackground"))
        love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 20)
        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.print(email.subject, self.x+24, self.y+self.navbar.h+6)

        -- Print out email content
        love.graphics.setColor(1,1,1)
        love.graphics.print("from: "..email.from, self.x+3, self.y+self.navbar.h+24)
        love.graphics.print("to: "..email.to, self.x+3, self.y+self.navbar.h+34)
        love.graphics.printf(email.content, self.x+3, self.y+self.navbar.h+50, self.w-24, "left")
        local height = TextHeight(email.content, self.w-24)

        -- Print out reference to email
        local refemail = email.reference
        if refemail then
            love.graphics.setColor(self:getColor("subbackground"))
            love.graphics.rectangle("fill", self.x+2, self.y+self.navbar.h+height+58, self.w-20, 2)
            love.graphics.setColor(0.5,0.5,0.5)
            love.graphics.print(refemail.subject, self.x+3, self.y+self.navbar.h+height+62)
            love.graphics.print("from: "..refemail.from, self.x+3, self.y+self.navbar.h+height+78)
            love.graphics.printf("to: "..refemail.to, self.x+3, self.y+self.navbar.h+height+88, self.w-24, "left")
            love.graphics.printf(refemail.content, self.x+3, self.y+self.navbar.h+height+104, self.w-24, "left")
        end
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowInbox:mousepressed(mx, my, b)
    if self.minimized then return end
    if b ~= 1 then return end
    if self.screen == "inbox" then
        local hover = self:hover()
        if hover then
            self.clickingEmail = hover
            return true
        end
    end
    return Window.mousepressed(self, mx, my, b)
end

function WindowInbox:mousereleased(mx, my, b)
    if self.minimized then return end
    if b ~= 1 then return end
    if self.screen == "inbox" then
        local hover = self:hover()
        if hover and hover == self.clickingEmail then
            self:changeScreen("email", hover)
            self.clickingEmail = false
            return true
        end
    end
    return Window.mousereleased(self, mx, my, b)
end

function WindowInbox:hover()
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    local y = self.y+self.navbar.h+22
    for i,_ in ipairs(self.emails) do
        if AABB(mx, my, 1/Env.scale, 1/Env.scale, self.x+2, y, self.w-20, 32) then
            return i
        end
        y = y + 34
    end
    return false
end

function WindowInbox:changeScreen(screen,subscreen)
    local function resizeElement(element, offsetY)
        local sy = ((self.h-self.navbar.h)/2)-50+self.navbar.h
        element.y = self.y+sy+offsetY
        element.w = self.w-16
    end

    self.elements = {}
    self.screen = screen
    self.subscreen = subscreen or false

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
    else
        self.elements.slider = UI.slider({x=self.w-16, y=20, w=16, h=self.h-self.navbar.h-20, dir="ver", fl=0.25, l={0,1,2}, desktop=self.desktop, resize=function (element)
            element.x = self.x+self.w-16
            element.sx = element.x
            element.h = self.h-self.navbar.h-20
            element.sh = element.h*element.fill
            element.sy = element:posFromValue(element.value)
        end})

        if self.screen == "inbox" then
            self.elements.logout = UI.button({x=(self.w/2)+2, y=2, w=(self.w/2)-4, h=16, text="logout", desktop=self.desktop, resize=function (element)
                element.x = self.x+(self.w/2)+2
                element.w = (self.w/2)-4
            end, func=function()
                WindowInboxData.authenticated = false
                self:changeScreen("login")
            end})
        elseif self.screen == "email" then
            self.elements.back = UI.button({x=2, y=2, w=16, h=16, text="<", desktop=self.desktop, resize=function (element)
                element.x = self.x+2
            end, func=function()
                self:changeScreen("inbox")
            end})
        end
    end
    self:sync()
end
