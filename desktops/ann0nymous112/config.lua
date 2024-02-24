local path = "desktops/ann0nymous112"

return {
    path = path,
    name = "ann0nymous112",
    pfp = love.graphics.newImage(path.."/pfp.png"),
    theme = "dark",
    background = {
        t = "image", img = love.graphics.newImage(path.."/background.png")
    },
    avalablePrograms = {"remotedesktop","exit"},
    desktop = {
        {
            name = "victimfiles",
            type = "folder",
            {
                name = "user1",
                type = "text",
                content = {
                    {"victim report:"},
                    {"name: user1","left"},
                    {"action: bank drained","left"},
                    {"comment: the test subject has drained his bank account successfully.","left"}
                }
            },
            {
                name = "floral16",
                type = "text",
                content = {
                    {"victim report:"},
                    {"name: floral16","left"},
                    {"action: pc destroyed","left"},
                    {"comment: the test subject has made their pc disfunctional.","left"}
                }
            },
            {
                name = "cursedgoomba1",
                type = "text",
                content = {
                    {"victim report:"},
                    {"name: cursedgoomba1","left"},
                    {"action: none yet","left"},
                    {"comment: waiting for test subject to finish with floral16.","left"}
                }
            },
            {
                name = "loveuser",
                type = "text",
                content = {
                    {"victim report:"},
                    {"name: loveuser","left"},
                    {"status: in my control","left"}
                },
                onOpen = function (desktop,window,file)
                    desktop:updateFile("b:/desktop/you'rehere", {hidden = false})
                end
            }
        },
        {
            pos = {13,1},
            name = "goal",
            type = "text",
            content = "where did you go? i can't see you on my radar, must have been the virus... just don't touch anything.\n\n- ann0nymous112"
        },
        {
            pos = {13,2},
            name = "you'rehere",
            type = "text",
            content = "oh i see, your on my pc... you think you have some kind of control? well you don't.\n\ni'm going to make sure you never leave nowm you asked for this.\n\n- ann0nymous112",
            hidden = true,
            onOpen = function (desktop,window,file)
                desktop:createFile("b:/desktop/", {pos = {7,4}, name = "exit", type = "shortcut", target = "b:/programs/exit"})
            end
        }
    },
    bin = {}
}