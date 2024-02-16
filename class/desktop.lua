Desktop = Class("Desktop")

function Desktop:initialize()
    self.w, self.h = Env.width, Env.height
    self.background = {t="color", color={0.4,0.7,1}}

    self.taskbar = {
        h = 20,
        buttons = {}
    }

    self.focus = false
    self.windows = {
        Window:new(self,50,50,200,100,"window 1"),
        Window:new(self,150,100,200,100,"window 2")
    }
    self.taskbar.buttons = {
        DesktopButton:new(self, self.windows[1]),
        DesktopButton:new(self, self.windows[2])
    }

    self.filesystem = {
        test = {
            type = "txt",
            content = "Hello, World!"
        },
        test2 = {
            type = "txt",
            content = "Hello, World! But different!"
        },
        folder = {
            type = "folder",
            test3 = {
                type = "txt",
                content = "Hello, World! But different-er!"
            }
        }
    }
end

function Desktop:update(dt)
    for _, window in pairs(self.windows) do
        window:update(dt)
        --window.text = "z "..self:getZPos(window).." t "..self:getTaskbarPos(window)
        window.text = ""
        if self.focus == window then
            window.text = "focused"
        end
    end
end

function Desktop:draw()
    -- Draw background
    if self.background.t == "color" then
        love.graphics.setColor(self.background.color)
    end
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)

    -- Draw windows below task bar and icons
    for i = #self.windows, 1, -1 do
        local window = self.windows[i]
        window:draw()
    end

    -- Draw task bar
    love.graphics.setColor(0,0,0,0.75)
    love.graphics.rectangle("fill", 0, self.h-self.taskbar.h, self.w, self.taskbar.h)

    -- Draw task bar buttons
    for i, button in pairs(self.taskbar.buttons) do
        button:draw(i)
    end

    -- Draw time
    love.graphics.setColor(1,1,1)
    love.graphics.printf(os.date("%H:%M"), self.w-50, self.h-self.taskbar.h+2, 50, "center")
    love.graphics.printf(os.date("%x"), self.w-50, self.h-self.taskbar.h+11, 50, "center")
end

function Desktop:mousepressed(mx, my, b)
    if my < self.h-self.taskbar.h then
        self.focus = false
        for i, window in pairs(self.windows) do
            if window:mousepressed(mx, my, b) then
                self:windowBringToFront(window)
                self.focus = window
                return
            end
        end
    else
        for i, button in pairs(self.taskbar.buttons) do
            button:mousepressed(mx, my, i, b)
        end
    end
end
function Desktop:mousereleased(mx, my, b)
    for i, button in pairs(self.taskbar.buttons) do
        button:mousereleased(mx, my, i, b)
    end
    for _, window in pairs(self.windows) do
        window:mousereleased(mx, my, b)
    end
end

function Desktop:keypressed(key, scancode, isrepeat)
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    if key == "n" then
        table.insert(self.windows, Window:new(self,mx,my,200,100,"window "..(#self.windows+1)))
        table.insert(self.taskbar.buttons, DesktopButton:new(self, self.windows[#self.windows]))
        self:windowBringToFront(self.windows[#self.windows])
    end
end

--

function Desktop:getFile(path)
    path = Split(path, "/")
    local file = self.filesystem
    for i = 1, #path do
        file = file[path[i]]
    end
    return file
end

function Desktop:getZPos(targetWindow)
    for i, window in pairs(self.windows) do
        if window == targetWindow then
            return i
        end
    end
    return 0
end
function Desktop:getTaskbarPos(targetWindow)
    for i, button in pairs(self.taskbar.buttons) do
        if button.window == targetWindow then
            return i
        end
    end
    return 0
end

function Desktop:windowClose(targetWindow)
    for i, window in pairs(self.windows) do
        if window == targetWindow then
            table.remove(self.windows, i)

            for i, button in pairs(self.taskbar.buttons) do
                if button.window == targetWindow then
                    table.remove(self.taskbar.buttons, i)
                    return
                end
            end

            return
        end
    end
end
function Desktop:windowBringToFront(targetWindow)
    local newWindows = {}
    table.insert(newWindows, targetWindow)
    for i, window in pairs(self.windows) do
        if window ~= targetWindow then
            table.insert(newWindows, window)
        end
    end
    self.windows = newWindows
end