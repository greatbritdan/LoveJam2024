WindowSettings = Class("WindowSettings", Window)

function WindowSettings:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 150, 104, "settings", 150, 104, false, true, {fullscreen=false})
    self.program = "settings"
    self.icon = "settings"

    local function resizeElement(element, offsetY)
        local sy = ((self.h-self.navbar.h)/2)-40+self.navbar.h
        element.y = self.y+sy+offsetY+2
        element.w = self.w-16
        if element.sy then
            element.sy = self.y+sy+offsetY+2
            element.sw = element.w*element.fill
            element.sx = element:posFromValue(element.value)
        end
    end

    local volume = SETTINGS.volume or 10

    self.elements.volumelabel = UI.label({x=8, y=8, w=self.w-16, h=16, text="volume: "..volume, desktop=self.desktop, resize=function (element)
        resizeElement(element,0)
    end})
    self.elements.volume = UI.slider({x=8, y=8, w=self.w-16, h=16, value=volume, fl=0.25, desktop=self.desktop, resize=function (element)
        resizeElement(element,20)
    end, func=function (element, released)
        SETTINGS.volume = element:getValue()
        if released then
            element.sx = element:posFromValue(element.value)
            UpdateVolume()
        end
        element.startSX = element.sx-self.x
    end})

    local theme = SETTINGS.theme or "dark"
    self.elements.themelabel = UI.label({x=8, y=8, w=self.w-16, h=16, text="theme: "..theme, desktop=self.desktop, resize=function (element)
        resizeElement(element,40)
    end})
    self.elements.theme = UI.toggle({x=8, y=8, w=self.w-16, h=16, is={"dark","light"}, i=theme, desktop=self.desktop, resize=function (element)
        resizeElement(element,60)
    end, func=function (element)
        SETTINGS.theme = element:getValue()
        UpdateTheme(self.desktop)
    end})

    self:sync()
end

function WindowSettings:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    -- Update labels (too lazy to make an update function for this...)
    self.elements.volumelabel.text = "volume: "..self.elements.volume:getValue()
    self.elements.themelabel.text = "theme: "..self.elements.theme:getValue()

    -- Draw UI
    Window.drawUI(self)
end