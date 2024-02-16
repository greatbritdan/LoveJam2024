Desktop = Class("Desktop")

function Desktop:initialize()
    self.w, self.h = Env.width, Env.height
    self.background = {t="color", color={0.4,0.7,1}}

    self.taskbar = {
        h = 20
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

    self.windows = {
        Window:new(self,50,50,200,100,"window 1"),
        Window:new(self,150,100,200,100,"window 2")
    }
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
    love.graphics.setColor(0,0,0,0.75)
    love.graphics.rectangle("fill", 0, self.h-self.taskbar.h, self.w, self.taskbar.h)

    -- Draw window icons
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    for i, window in pairs(self.windows) do
        if AABB(mx, my, 1, 1, (i-1)*self.taskbar.h, self.h-self.taskbar.h, self.taskbar.h, self.taskbar.h) then
            love.graphics.setColor(0.75,0.75,0.75)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.rectangle("fill", (i-1)*self.taskbar.h, self.h-self.taskbar.h, self.taskbar.h, self.taskbar.h)
    end
end

function Desktop:mousepressed(mx, my, b)
    for i, window in pairs(self.windows) do
        --[[if b == 1 and AABB(mx, my, 1, 1, (i-1)*self.taskbar.h, self.h-self.taskbar.h, self.taskbar.h, self.taskbar.h) then
            if window.minimized then
                window.minimized = false
            end
            self:windowBringToFront(window)
            return
        end]]
    end
    for i, window in pairs(self.windows) do
        if window:mousepressed(mx, my, b) then
            self:windowBringToFront(window)
            return
        end
    end
end
function Desktop:mousereleased(mx, my, b)
    for _, window in pairs(self.windows) do
        window:mousereleased(mx, my, b)
    end
end

function Desktop:keypressed(key, scancode, isrepeat)
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    if key == "n" then
        table.insert(self.windows, Window:new(self,mx,my,200,100,"window "..(#self.windows+1)))
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

function Desktop:windowClose(targetWindow)
    for i, window in pairs(self.windows) do
        if window == targetWindow then
            table.remove(self.windows, i)
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