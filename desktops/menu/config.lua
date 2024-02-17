local path = "desktops/menu"

return {
    path = path,
    name = "administator",
    theme = "dark",
    background = {
        t = "image", img = love.graphics.newImage(path.."/background.png")
    },
    desktop = {
        {
            name = "menu",
            type = "program",
            program = "menu",
            icon = "britfile"
        }
    },
    openByDefault = WindowMenu
}