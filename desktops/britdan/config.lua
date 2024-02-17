local path = "desktops/britdan"

return {
    path = path,
    name = "britdan",
    theme = "dark",
    background = {
        t = "image", img = love.graphics.newImage(path.."/background.png")
    },
    desktop = {
        {
            name = "hello",
            type = "text",
            content = "hello, world"
        },
        {
            name = "pfp",
            type = "image",
            img = love.graphics.newImage(path.."/pfp.png")
        },
        {
            name = "folder",
            type = "folder",
            {
                name = "file",
                type = "text",
                content = "this is a file"
            }
        },
        {
            pos = {4,4},
            name = "bin (shortcut)",
            type = "shortcut",
            target = "b:/bin/"
        },
        {
            name = "bin (shortcut)",
            type = "shortcut",
            target = "b:/bin/"
        }
    },
    bin = {
        {
            name = "trash",
            type = "text",
            content = "this is the trash"
        },
    }
}