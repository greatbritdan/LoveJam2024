local path = "desktops/floral16"

return {
    path = path,
    name = "floral16",
    pfp = love.graphics.newImage(path.."/pfp.png"),
    theme = "dark",
    background = {
        t = "image", img = love.graphics.newImage(path.."/background.png")
    },
    avalablePrograms = {"remotedesktop","inbox","zipcrash","antivirus","crypter"},
    desktop = {
        {
            pos = {1,4},
            name = "filemanager",
            type = "shortcut",
            target = "b:/programs/filemanager",
        },
        {
            pos = {1,5},
            name = "antivirus",
            type = "shortcut",
            target = "b:/programs/antivirus",
        },
        {
            pos = {2,5},
            name = "protection",
            type = "text",
            content = {{"todo:"},{"- encrypt all passwords\n- setup antivirus\n- don't use twitter","left"}}
        },
        {
            pos = {1,6},
            name = "inbox",
            type = "shortcut",
            target = "b:/programs/inbox",
        },
        {
            pos = {1,7},
            name = "utils",
            type = "folder",
            {
                name = "crypter",
                type = "shortcut",
                target = "b:/programs/crypter",
            },
            {
                name = "test",
                type = "text",
                content = "hello there",
            },
            {
                name = "test encrypted",
                type = "text",
                content = "ifmmp!uifsf",
            }
        },
        {
            pos = {13,1},
            name = "goal",
            type = "text",
            content = "i commissioned this artist and they never delivered, i'm so salty that i think it would be cool to see her pc go up in flames...\n\ndisable her antivirus and install the program below, then get out asap\n\n- ann0nymous112",
        },
        {
            pos = {13,2},
            name = "zipcrash (shortcut)",
            type = "shortcut",
            target = "b:/programs/zipcrash"
        }
    },
    bin = {},
    antivirus = {
        {
            username = "16floralflowers",
            password = "daisy987",
            enabled = true,
        }
    },
    emails = {},
}