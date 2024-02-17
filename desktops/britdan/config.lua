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
            name = "welcome",
            type = "text",
            content = "welcome to <game name here>!\n\nclick the icon below this file to open the file manager.\n\nhave fun, oh and do not open the bin, nothing is there.\n\n- britdan"
        },
        {
            name = "filemanager",
            type = "shortcut",
            target = "b:/programs/filemanager",
        }
    },
    bin = {
        {
            name = "background",
            type = "image",
            img = love.graphics.newImage(path.."/background.png")
        },
        {
            name = "delete me",
            type = "text",
            icon = "test",
            content = "youre a real snooper arent you, fine ill spill the beans.\n\nif your reading this youve been accepted into our hacker group (weather you like it or not).\n\nwe have a few tasks for you to do, and lets just say you dont want to know what happens if you dont.\n\nopen the remote desktop app in the programs file to begin.\n\n- ann0nymous112",
            onOpen = function(desktop,window,file)
                desktop:updateFile("b:/desktop/welcome", {content = "welcome to <game name here>!\n\nits too late.\n\n- ann0nymous112"})
                desktop:updateFile("b:/programs/remotedesktop", {hidden = false})
            end
        }
    },
    openByDefault = "b:/desktop/welcome"
}