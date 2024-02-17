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
            name = "bin (shortcut)",
            type = "shortcut",
            target = "b:/bin/"
        },
        {
            name = "bloat1",
            type = "text",
            content = "this is bloatware"
        },
        {
            name = "bloat2",
            type = "text",
            content = "this is bloatware"
        },
        {
            name = "bloat3",
            type = "text",
            content = "this is bloatware"
        },
        {
            name = "bloat4",
            type = "text",
            content = "this is bloatware"
        },
        {
            name = "bloat5",
            type = "text",
            content = "this is bloatware"
        },
        {
            name = "bloat6",
            type = "text",
            content = "this is bloatware"
        },
        {
            name = "bloat7",
            type = "text",
            content = "this is bloatware"
        },
        {
            name = "bloat8",
            type = "text",
            content = "this is bloatware"
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