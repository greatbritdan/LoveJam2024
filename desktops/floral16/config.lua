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
            pos = {1,2},
            name = "antivirus",
            type = "shortcut",
            target = "b:/programs/antivirus",
        },
        {
            pos = {1,3},
            name = "inbox",
            type = "shortcut",
            target = "b:/programs/inbox",
        },
        {
            pos = {1,7},
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
            pos = {2,2},
            name = "todo",
            type = "text",
            content = {{"todo:"},{"- don't use twitter (done)","left"},{"- setup an antivirus (done)","left"},{"- stop using the same password for everything (not done)","left"}}
        },
        {
            pos = {12,7},
            name = "game",
            type = "folder",
            {
                name = "example",
                type = "text",
                content = {
                    {"function love.load()\n    -- load code here\nend","left"},
                    {"function love.update(dt)\n    -- update code here\nend","left"},
                    {"function love.draw()\n    -- draw code here\nend","left"}
                }
            }
        },
        {
            pos = {13,7},
            name = "game (1)",
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
            name = "open me",
            type = "text",
            icon = "blank",
            content = "hello there daisy,\n\nif you're reading this you've been accepted into our hacker group (if you like it or not).\n\nwe have some tasks for you to do, and lets just say you don't want to know what happens if you don't.\n\nopen the remote desktop app in the programs file to begin.\n\n- ann0nymous112",
        },
        {
            name = "hidden",
            type = "folder",
            hidden = true,
            {
                name = "brokencode",
                type = "image",
                img = love.graphics.newImage(path.."/brokencode.png")
            },
            {
                name = "error",
                type = "text",
                content = "main.text:6: attempt to perform arithmetic on global 'x' (a nil value)"
            },
            {
                name = "draft email",
                type = "text",
                content = "how do i make this work?\n\n- floral16"
            }
        }
    },
    emails = {
        {
            email = "daisy_f@inbox.com",
            password = "daisy987",
            emails = {
                {
                    from = "ann0n7@inbox.com",
                    to = "daisy_f@inbox.com",
                    subject = "stop ignoring me",
                    content = "i know who you are, i know what you're doing, you must listen to me, go to your bin and read the note.\n\n- ann0nymous112"
                },
                {
                    from = "ann0n7@inbox.com",
                    to = "daisy_f@inbox.com",
                    subject = "hello",
                    content = "hello floral16, i hope you're enjoying your new computer, i'm sure you'll love it, i have a surprise for you, check your bin.\n\n- ann0nymous112"
                },
                {
                    from = "lexi_f@inbox.com",
                    to = "daisy_f@inbox.com",
                    subject = "re: i have a pc now!",
                    content = "i'm so happy for you daisy and proud of you for saving up for one, i love you so much!\n\n--\nbest regards, lexi",
                    reference = {
                        from = "daisy_f@inbox.com",
                        to = "lexi_f@inbox.com",
                        subject = "i have a pc now!",
                        content = "hi mom!\n\ni finally have a pc now, i'm so excited to start using it, i'm going to start my own business and make games, i'm so excited!",
                    }
                },
                {
                    from = "support.antivirus@inbox.com",
                    to = "daisy_f@inbox.com",
                    subject = "welcome to antivirus!",
                    content = "hello 16floralflowers!\n\nwe know you can't put a price on security, but we did anyway, and you paid it, so thank you for choosing our antivirus, we hope you enjoy your stay.\n\n- the antivirus support team",
                },
                {
                    from = "noreply@inbox.com",
                    to = "daisy_f@inbox.com",
                    subject = "welcome to inbox.com",
                    content = "welcome to inbox.com, the best email service in the world, we hope you enjoy your stay.\n\n- the inbox.com team",
                }
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