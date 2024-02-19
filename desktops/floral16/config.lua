local path = "desktops/floral16"

return {
    path = path,
    name = "floral16",
    theme = "dark",
    background = {
        t = "image", img = love.graphics.newImage(path.."/background.png")
    },
    avalablePrograms = {"remotedesktop"},
    desktop = {
        {
            name = "protection",
            type = "text",
            content = {{"todo:"},{"- encrypt all passwords\n- setup antivirus\n- don't use twitter","left"}}
        },
        {
            pos = {13,1},
            name = "goal",
            type = "text",
            content = "i commissioned this artist and they never delivered, i'm so salty that i think it would be cool to see her pc go up in flames...\n\ndisable her antivirus and install the program below, then get out asap\n\n- ann0nymous112",
        }
    },
    bin = {}
}