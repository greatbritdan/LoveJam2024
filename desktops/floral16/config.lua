local path = "desktops/floral16"

return {
    path = path,
    name = "floral16",
    pfp = love.graphics.newImage(path.."/pfp.png"),
    theme = "dark",
    background = {
        t = "image", img = love.graphics.newImage(path.."/background.png")
    },
    avalablePrograms = {"remotedesktop","inbox","zipcrash","antivirus"},
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
            name = "todo",
            type = "text",
            content = {{"todo:"},{"- setup antivirus\n- don't use twitter","left"}}
        },
        {
            pos = {1,5},
            name = "inbox",
            type = "shortcut",
            target = "b:/programs/inbox",
        },
        {
            pos = {9,7},
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
                    {"function level.load()\n    local path = 'b:/bin/hidden'\n    local file = sys.getfile(path)\n    if file then\n        return file\n    end\nend","left"}
                }
            },
            {
                name = "movetest bug",
                type = "text",
                content = "i can't seem to get the rectangle to move, i've tried everything and it just won't budge, i'm so confused."
            },
            {
                name = "to lexi",
                type = "text",
                content = {{"function love.load()\n    print('i love you mom!')\nend","left"}}
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
            name = "diary",
            type = "folder",
            {
                name = "17th feb",
                type = "text",
                content = "i'm so excited to start using this new computer, i've been saving up for so long and i finally have enough to buy one.\n\ni'm going to use it to start my own business, i'm so excited!\n\n- floral16"
            },
            {
                name = "18th feb",
                type = "text",
                content = "i've been using the computer for a day now and i'm already in love with it, i'm doing art commissions and i wanna make games too, i'm so excited!!\n\n- floral16"
            },
            {
                name = "25th feb",
                type = "text",
                content = "i just made a new wallpaper and i love it, it's teal too (my favourite color), i'm so happy with it.\n\n- floral16"
            },
            {
                name = "3rd mar",
                type = "text",
                content = "who is ann0nymous112? they keep sending me weird emails, i don't know who they are but they seem to know me, i'm so confused.\n\n- floral16"
            }
        },
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
                name = "password temp",
                type = "text",
                content = {{"switching accounts,"},{"old username: floral16\nold password: love111","left"},{"new username: 16floralflowers\nnew password: daisy987","left"}}
            }
        }
    },
    antivirus = {
        {
            username = "16floralflowers",
            password = "daisy987",
            enabled = true,
            security = {
                {
                    question = "what is your mother's first name?",
                    answer = "lexi"
                },
                {
                    question = "what is your favourite color?",
                    answer = "teal"
                }
            }
        }
    },
    zipcrash = {
        enabled = false,
        target = "16floralflowers",
        onInstall = function (desktop,window)
            desktop:forAllFiles(function (file,filepath)
                if file.name == "remotedesktop" then
                    return
                end
                desktop:updateFile(filepath,{label="error",icon="exclamation",content=false})
            end)
            desktop.background = {t="color",color={0,0,0}}
            desktop:createFile("b:/desktop", {pos = {13,3}, name = "get out", type = "text", content = "good job on that, now get out before the computer breaks, i've added remotedesktop to programs... oh right it's all error, the last error on the root file.\n\n- ann0nymous112"})
            desktop:updateFile("b:/programs/remotedesktop", {hidden = false})
        end
    }
}