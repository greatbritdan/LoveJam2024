local path = "desktops/loveuser2"

local data = {
    path = path,
    name = "loveuser",
    subname = "(ending)",
    pfp = love.graphics.newImage(path.."/pfp.png"),
    theme = "dark",
    background = {
        t = "image", img = love.graphics.newImage(path.."/background.png")
    },
    avalablePrograms = {"inbox"},
    desktop = {
        {
            name = "goodbye",
            type = "text",
            content = "thank you for playing back-window!\n\ni hope you enjoyed the game, and if you did, please consider leaving a review on the itch.io page.\n\n- britdan"
        },
        {
            name = "filemanager",
            type = "shortcut",
            target = "b:/programs/filemanager",
        },
        {
            name = "inbox",
            type = "shortcut",
            target = "b:/programs/inbox",
            email = "loveuser@inbox.com",
            password = "lovewhale11"
        },
        {
            pos = {1,7},
            name = "background",
            type = "image",
            img = love.graphics.newImage(path.."/background.png")
        }
    },
    bin = {
        {
            name = "delete me",
            type = "text",
            icon = "blank",
            content = "you're a real snooper aren't you, fine i'll spill the beans.\n\nif you're reading this you've been accepted into our hacker group (if you like it or not).\n\nwe have a few tasks for you to do, and lets just say you don't want to know what happens if you don't.\n\nopen the remote desktop app in the programs file to begin.\n\n- ann0nymous112",
        }
    },
    openByDefault = "b:/desktop/goodbye"
}

if WindowFactoryresetEnding == "no" then
    data.emails = {
        {
            email = "loveuser@inbox.com",
            password = "lovewhale11",
            emails = {
                {
                    from = "user1@inbox.com",
                    to = "loveuser@inbox.com",
                    subject = "thanks for the help!",
                    content = "hey loveuser, ann0nymous112 just returned all the money he stole from me, i don't know what you did but thank you so much!\n\n- user1",
                },
                {
                    from = "daisy_f@inbox.com",
                    to = "loveuser@inbox.com",
                    subject = "thank you thank you!",
                    content = "hi loveuser, i don't know what you did but ann0nymous112 just restored my computer to normal, thank you so much, thank you!!!\n\n- daisy (floral16)",
                },
                {
                    from = "ann0n7@inbox.com",
                    to = "loveuser@inbox.com",
                    subject = "i owe you an apology",
                    content = "loveuser, i'm sorry for the way i treated you and the others, i've returned the favor by undoing all the horrible things i did, i hope this is a good enough apology.\n\n- ann0nymous112",
                },
            }
        }
    }
elseif WindowFactoryresetEnding == "yes" then
    data.emails = {
        {
            email = "loveuser@inbox.com",
            password = "lovewhale11",
            emails = {
                {
                    from = "user1@inbox.com",
                    to = "loveuser@inbox.com",
                    subject = "thanks for the donation!",
                    content = "hey loveuser, i know it's a shame that ann0nymous112 lost all my money, but i'm glad you were able to help me out even a little bit, thank you so much!\n\n- user1",
                },
                {
                    from = "daisy_f@inbox.com",
                    to = "loveuser@inbox.com",
                    subject = "thanks for the commission",
                    content = "hi loveuser, it's a shame that ann0nymous112 lost all my files, but the money from the commission will help out a lot, thank you so much!\n\n- daisy (floral16)",
                }
            }
        }
    }
else
    data.emails = {
        {
            email = "loveuser@inbox.com",
            password = "lovewhale11",
            emails = {
                {
                    from = "britdan@inbox.com",
                    to = "loveuser@inbox.com",
                    subject = "you skiped the ending",
                    content = "hey loveuser, i noticed you skipped the ending, you should go back and see what happens, it's worth it.\n\n- britdan",
                }
            }
        }
    }
end

return data