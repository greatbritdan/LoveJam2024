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
        WindowFileManager:new(self,nil,nil,400,300)
    }
    self.taskbar.buttons = {
        DesktopButton:new(self, self.windows[1], "filemanager")
    }

    self.filesystem = {
        {
            name = "test",
            type = "txt",
            content = "Hello, World!"
        },
        {
            name = "test 2",
            type = "txt",
            content = "Hello, World! But different!"
        },
        {
            name = "folder",
            type = "folder",
            {
                name = "test 3",
                type = "txt",
                content = "Hello, World! But different-er!"
            }
        }
    }

    self.theme = "dark"
    self.themes = {
        light = {
            taskbar = {
                background = {0.8,0.8,0.8,0.9},
                text = {0,0,0},
            },
            window = {
                background = {0.7,0.7,0.7},
                subbackground = {0.8,0.8,0.8},
                navbar = {
                    background = {0.9,0.9,0.9},
                    text = {0,0,0}
                }
            }
        },
        dark = {
            taskbar = {
                background = {0.2,0.2,0.2,0.9},
                text = {1,1,1},
            },
            window = {
                background = {0.1,0.1,0.1},
                subbackground = {0.2,0.2,0.2},
                navbar = {
                    background = {0.3,0.3,0.3},
                    text = {1,1,1}
                }
            }
        }
    }
end

function Desktop:getColor(name,subname)
    if subname then
        return self.themes[self.theme]["taskbar"][name][subname]
    end
    return self.themes[self.theme]["taskbar"][name]
end

function Desktop:update(dt)
    for _, window in pairs(self.windows) do
        window:update(dt)
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
    love.graphics.setColor(self:getColor("background"))
    love.graphics.rectangle("fill", 0, self.h-self.taskbar.h, self.w, self.taskbar.h)

    -- Draw task bar buttons
    for i, button in pairs(self.taskbar.buttons) do
        button:draw(i)
    end

    -- Draw time
    love.graphics.setColor(self:getColor("text"))
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

function Desktop:textinput(text)
    if self.focus then
        self.focus:textinput(text)
    end
end

function Desktop:keypressed(key, scancode, isrepeat)
    if self.focus then
        self.focus:keypressed(key, scancode, isrepeat)
    end
end

--

function Desktop:getFile(path)
    path = string.gsub(path, "^b:/", "")
    path = Split(path, "/")
    local file = self.filesystem
    for i = 1, #path do
        file = TableContainsWithin(file, path[i], "name")
        if not file then
            return false
        end
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