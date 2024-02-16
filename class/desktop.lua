Desktop = Class("Desktop")

function Desktop:initialize()
    self.w, self.h = Env.width, Env.height

    self.background = {t="color", color={0.4,0.7,1}}

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

    self.taskbar = {
        height = 20,
        icons = {"test","test2","folder","folder/test3"}
    }

    self.windows = {
        test = Window:new(200,100)
    }
end

function Desktop:draw()
    -- Draw background
    if self.background.t == "color" then
        love.graphics.setColor(self.background.color)
    end
    love.graphics.rectangle("fill", 0, 0, self.w, self.h)

    -- Draw task bar
    love.graphics.setColor(0,0,0,0.75)
    love.graphics.rectangle("fill", 0, self.h-self.taskbar.height, self.w, self.taskbar.height)

    -- Draw icons
    for i, icon in ipairs(self.taskbar.icons) do
        local file = self:getFile(icon)
        if file.type == "folder" then
            love.graphics.setColor(237/255, 226/255, 121/255)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.rectangle("fill", 2+((i-1)*18), self.h-self.taskbar.height+2, 16, 16)
    end
end

function Desktop:getFile(path)
    path = Split(path, "/")
    local file = self.filesystem
    for i = 1, #path do
        file = file[path[i]]
    end
    return file
end