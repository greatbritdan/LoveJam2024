local path = "desktops/ann0nymous112"

return {
    path = path,
    name = "ann0nymous112",
    pfp = love.graphics.newImage(path.."/pfp.png"),
    theme = "dark",
    background = {
        t = "image", img = love.graphics.newImage(path.."/background.png")
    },
    avalablePrograms = {"remotedesktop"},
    desktop = {
        {
            name = "filemanager",
            type = "shortcut",
            target = "b:/programs/filemanager",
        },
        {
            pos = {13,1},
            name = "goal",
            type = "text",
            content = "where did you go? i can't see you on my radar, must have been the virus... just don't touch anything.\n\n- ann0nymous112"
        }
    },
    bin = {}
}