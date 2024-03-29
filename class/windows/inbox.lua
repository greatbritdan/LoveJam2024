WindowInbox = Class("WindowInbox", Window)

WindowInboxData = {
    --emailinput = "user1@inbox.com",
    --passwordinput = "iloveboss22",
}

function WindowInbox:initialize(desktop, x, y, w, h, args)
    Window.initialize(self, desktop, x, y, 300, 200, "inbox.com", 300, 200)
    self.program = "inbox"
    self.icon = "inbox"
    self.args = args
    
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
            love.graphics.setColor(self.desktop:getColor("window","error"))
            love.graphics.printf(self.errorMessage, self.x+3, self.y+self.navbar.h+3, self.w-6, "center")
        end
    elseif self.screen == "inbox" then
        love.graphics.setColor(self.desktop:getColor("window","subfill"))
        love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 20)
        love.graphics.setColor(self.desktop:getColor("window","subtext"))
        love.graphics.printf(self.email, self.x+3, self.y+self.navbar.h+6, (self.w/2)-6, "center")

        -- I'm sorry...
        local hover = self:hover()
        love.graphics.setScissor(self.x*Env.scale, (self.y+self.navbar.h+22)*Env.scale, self.w*Env.scale, (self.h-self.navbar.h-24)*Env.scale)
        local y = self.y+self.navbar.h+22+self.scroll
        for i, email in ipairs(self.emails) do
            if not email.hidden then
                -- Draw email box
                love.graphics.setColor(self.desktop:getColor("window","darkfill"))
                love.graphics.rectangle("fill", self.x+2, y, self.w-4, 32)
                love.graphics.setColor(self.desktop:getColor("window","text"))
                love.graphics.print(email.subject, self.x+6, y+4)
                love.graphics.print(email.from, self.x+self.w-6-Font:getWidth(email.from), y+4)
                
                -- Print out email content
                love.graphics.setColor(self.desktop:getColor("window","subtext"))
                local content = ""
                local splitn = Split(email.content,"\n")
                local split = Split(splitn[1]," ")
                for _,word in ipairs(split) do
                    if love.graphics.getFont():getWidth(content.." "..word) > self.w-16 then
                        content = content.."..."
                        break
                    end
                    content = content.." "..word
                end
                love.graphics.print(content, self.x+6, y+16)

                -- Highlight email
                love.graphics.setColor(self.desktop:getColor("highlight","normal"))
                if self.clickingEmail == i then
                    love.graphics.setColor(self.desktop:getColor("highlight","pressed"))
                elseif hover == i then
                    love.graphics.setColor(self.desktop:getColor("highlight","hover"))
                end
                love.graphics.rectangle("fill", self.x+2, y, self.w-4, 32)

                y = y + 34
            end
        end
        love.graphics.setScissor()
    elseif self.screen == "email" then
        -- Print out email
        local email = self.emails[self.subscreen]
        love.graphics.setColor(self.desktop:getColor("window","subfill"))
        love.graphics.rectangle("fill", self.x, self.y+self.navbar.h, self.w, 20)
        love.graphics.setColor(self.desktop:getColor("window","subtext"))
        love.graphics.print(email.subject, self.x+24, self.y+self.navbar.h+6)

        -- Print out email content
        love.graphics.setColor(self.desktop:getColor("window","text"))
        love.graphics.print("from: "..email.from, self.x+3, self.y+self.navbar.h+24)
        love.graphics.print("to: "..email.to, self.x+3, self.y+self.navbar.h+34)
        love.graphics.printf(email.content, self.x+3, self.y+self.navbar.h+50, self.w-24, "left")
        local height = TextHeight(email.content, self.w-24)

        -- Print out reference to email
        local refemail = email.reference
        if refemail then
            love.graphics.setColor(self.desktop:getColor("window","subtext"))
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
            if self.emails[hover].onOpen then
                self.emails[hover].onOpen(self.desktop, self)
            end
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
    if not AABB(mx, my, 1, 1, self.x+2, y, self.w-4, self.h-self.navbar.h-24) then
        return
    end
    y = y + self.scroll
    for i,email in ipairs(self.emails) do
        if not email.hidden then
            if AABB(mx, my, 1/Env.scale, 1/Env.scale, self.x+2, y, self.w-4, 32) then
                return i
            end
            y = y + 34
        end
    end
    return false
end

function WindowInbox:changeScreen(screen,subscreen)
    local function resizeElement(element, offsetY)
        local sy = ((self.h-self.navbar.h)/2)-50+self.navbar.h
        element.y = self.y+sy+offsetY
        element.w = self.w-16
    end

    self.scrollable = false

    self.elements = {}
    self.screen = screen
    self.subscreen = subscreen or false

    if self.screen == "login" then
        self.scroll = 0
        local emailinput = WindowInboxData.emailinput or ""
        if emailinput == "" and self.args.file.email then
            emailinput = self.args.file.email
        end
        local passwordinput = WindowInboxData.passwordinput or ""
        if passwordinput == "" and self.args.file.password then
            passwordinput = self.args.file.password
        end

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
            if validemail and (not validemail.deleted) then
                self.email = self.elements.email.text
                self.emails = self.desktop:getEmails(self.email)
                WindowInboxData.authenticated = self.email
                self.errorMessage = false
                self:changeScreen("inbox")
            elseif validemail and validemail.deleted then
                self.errorMessage = "account deleted"
            else
                self.errorMessage = "invalid email or password"
            end
        end})
    else
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

function WindowInbox:updateScroll()
    if self.screen ~= "inbox" then
        self.scrollable = false
        return
    end
    local count = 0
    for _,email in pairs(self.emails) do
        if not email.hidden then
            count = count + 1
        end
    end
    local height = (count*34) - 2
    self.scrollMax = -(height-(self.h-self.navbar.h-24))
    if self.scrollMax < 0 then
        self.scrollable = true
    else
        self.scrollMax = 0
    end
end