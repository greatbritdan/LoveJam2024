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
            name = "filemanager",
            type = "shortcut",
            target = "b:/programs/filemanager",
        },
        {
            pos = {1,4},
            name = "antivirus",
            type = "shortcut",
            target = "b:/programs/antivirus",
        },
        {
            pos = {2,4},
            name = "protection",
            type = "text",
            content = {{"todo:"},{"- encrypt all passwords\n- setup antivirus\n- don't use twitter","left"}}
        },
        {
            pos = {1,5},
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
            pos = {2,7},
            name = "game (6)",
            type = "folder",
            {
                name = "movetest",
                type = "text",
                content = {
                    {"local lgr = love.graphics","left"},
                    {"function love.load()\n    local x = 0\nend","left"},
                    {"function love.update(dt)\n    x = x + dt*4\nend","left"},
                    {"function love.draw()\n    lgr.rectangle('fill',x,4,4,4)\nend","left"}
                }
            },
            {
                name = "level",
                type = "text",
                content = {
                    {"function level.load()\n    local path = 'b:/bin/hidden/img'\n    local file = sys.getfile(path)\n    if file then\n        return file\n    end\nend","left"}
                }
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
    bin = {
        {
            name = "hidden",
            type = "folder",
            hidden = true,
            {
                name = "img",
                type = "image"
            },
            {
                name = "unused",
                type = "folder",
            },
            {
                name = "to loveuser",
                type = "text",
                content = "its happened to you too? user1 told me about what happened. he will never let you go you know, you'll always be his plaything. ann0nymous112 is a monster and you know it...\n\nyou can stop this, do what he says, burn my pc just do me 1 favour, when you run the virus do not open the remote desktop program, trust me\n\nmy antivirus username is 16floralflowers and my password is daisy987\n\n- floral16"
            }
        }
    },
    antivirus = {
        {
            username = "16floralflowers",
            password = "daisy987",
            enabled = true,
        }
    },
    emails = {},
}