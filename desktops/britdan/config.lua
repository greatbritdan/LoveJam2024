local path = "desktops/britdan"

return {
    path = path,
    name = "britdan",
    theme = "dark",
    background = {
        t = "image",
        img = love.graphics.newImage(path.."/background.png")
    },
    filesystem = {
        {
            name = "desktop",
            type = "folder",
            {
                name = "hello",
                type = "text",
                content = "hello, world"
            },
            {
                name = "pfp",
                type = "image",
                img = love.graphics.newImage(path.."/pfp.png")
            }
        }
    },
}