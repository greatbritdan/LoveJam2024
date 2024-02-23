WindowZipcrash = Class("WindowZipcrash", Window)

WindowZipcrashToolate = false

function WindowZipcrash:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "zipcrash", 300, 200)

    self.accessable = false
    local antivirus = self.desktop:getAntivirus(self.desktop.zipcrash.target)
    if antivirus and (not antivirus.enabled) then
        self.accessable = true
        self:updateScreen()
    end
    self.program = "zipcrash"
    self.icon = "zipcrash"
end

function WindowZipcrash:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    love.graphics.setColor(1,0.5,0.5)
    if WindowZipcrashToolate then
        love.graphics.printf("installing zipcrash.torrent\nexiting the program is not allowed.\n\nenjoy...", self.x+4, self.y+self.navbar.h+3, self.w-8, "center")
    elseif self.accessable then
        love.graphics.setColor(1,1,1)
        love.graphics.printf("welcome to zipcrash!", self.x+4, self.y+self.navbar.h+3, self.w-8, "center")
        love.graphics.setColor(0.75,0.75,0.75)
        love.graphics.printf("this is a beta of zipcrash, an exciting new zipping tool for any pc, any spec!\n\nby pressing install you agree to our terms and conditions and no we will not be linking them, not like anyone reads them... to be fair i doubt your reading this, i could say 'pickle fart' and you wouldn't know. cool huh!\n\nanyway yeah press install.", self.x+4, self.y+self.navbar.h+23, self.w-8, "center")
    else
        love.graphics.printf("error: please disalbe antivirus to contine free instalation.", self.x+4, self.y+self.navbar.h+3, self.w-8, "center")
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowZipcrash:updateScreen()
    self.elements = {}
    if WindowZipcrashToolate then
        return
    end
    if self.accessable then
        self.elements.installnow = UI.button({x=8, y=self.h-20, w=self.w-16, h=16, text="install now!", desktop=self.desktop, resize=function (element)
            element.y = self.y+self.h-20
        end, func=function()
            WindowZipcrashToolate = true
            table.remove(self.navbar.buttons, 3)
            -- Idk why I made it this... but it's funny
            self.NOCLOSEYMATE = true
            if self.desktop.zipcrash.onInstall then
                self.desktop.zipcrash.onInstall(self.desktop,self)
            end
            self:updateScreen()
        end})
    end
    self:sync()
end