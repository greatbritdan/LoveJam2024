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
            content = "welcome to <game name here>!\n\nclick the icon below this file to open the file manager.\n\nhave fun, oh and don't open the bin, nothing is there.\n\n- britdan"
        },
        {
            name = "filemanager",
            type = "shortcut",
            target = "b:/programs/filemanager",
        },
        {
            pos = {13,1},
            name = "goal",
            type = "text",
            content = "for all future jobs, i'll be leaving your goals in a text document on the desktop like this, you must complete them all.\n\n- ann0nymous112",
            hidden = true
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
            icon = "blank",
            content = "you're a real snooper aren't you, fine i'll spill the beans.\n\nif you're reading this you've been accepted into our hacker group (if you like it or not).\n\nwe have a few tasks for you to do, and lets just say you don't want to know what happens if you don't.\n\nopen the remote desktop app in the programs file to begin.\n\n- ann0nymous112",
            onOpen = function(desktop,window,file)
                desktop:updateFile("b:/desktop/welcome", {content = "welcome to <game name here>!\n\nits too late.\n\n- ann0nymous112"})
                desktop:updateFile("b:/desktop/goal", {hidden = false})
                desktop:createFile("b:/programs", {name = "readme", type = "text",
                    content = "when your goal is complete i'll allow you access to the remote desktop.\n\nbut until you do there is no way to leave, enter when you're ready.\n\n- ann0nymous112",
                    onOpen = function(desktop,window,file)
                        desktop:updateFile("b:/programs/remotedesktop", {hidden = false})
                    end
                })
            end
        }
    },
    openByDefault = "b:/desktop/welcome"
}