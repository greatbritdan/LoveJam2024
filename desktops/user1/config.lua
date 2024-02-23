local path = "desktops/user1"

return {
    path = path,
    name = "user1",
    pfp = love.graphics.newImage(path.."/pfp.png"),
    theme = "dark",
    background = {
        t = "image", img = love.graphics.newImage(path.."/background.png")
    },
    avalablePrograms = {"remotedesktop","inbox","bank"},
    desktop = {
        {
            name = "to delete",
            type = "folder",
            {
                name = "bank details (user1)",
                type = "text",
                content = "hi mate, reminder to switch all the bank details to the new account, the old one is compromised.\n\ncheers,\n\n- boss"
            },
            {
                name = "bank details (savings)",
                type = "text",
                content = "hey, just quickly, what are the details for this account, i can not remember.\n\n- user1"
            },
            {
                name = "new folder",
                type = "folder",
                {
                    name = "bug report",
                    type = "image",
                    img = love.graphics.newImage(path.."/bug.png")
                }
            },
            {
                name = "dwwf",
                type = "folder"
            }
        },
        {
            name = "new document",
            type = "text",
            content = ""
        },
        {
            pos = {1,7},
            name = "balance",
            type = "text",
            content = {
                {"hey mate, as requested here is the balance of all the accounts in our name,\n\nremember that the ann0nymous has an eye on our 2nd account, i've transfered it to a new account:"},
                {"- savings: £23\n- user1: £0 (comprimised)\n- user1_newaccount: £9,640","left"},
                {"cheers,\n\n- boss"}
            },
        },
        {
            pos = {4,1},
            name = "inbox",
            type = "program",
            program = "inbox",
            icon = "inbox",
        },
        {
            pos = {5,1},
            name = "bank",
            type = "program",
            program = "bank",
            icon = "bank",
        },
        {
            pos = {13,1},
            name = "goal",
            type = "text",
            content = "generic name but trust me, this guy is loaded.\n\nget access to his bank details and send everything to me:\n\naccount: ann0n7\n\n- ann0nymous112",
        }
    },
    bin = {
        {
            name = "new folder",
            type = "folder",
            {
                name = "back",
                type = "image",
                img = love.graphics.newImage(path.."/background.png")
            }
        },
        {
            name = "email",
            type = "text",
            content = {{"(incase of memory loss)"},{"the password is iloveboss22","left"}}
        }
    },
    emails = {
        {
            email = "user1@inbox.com",
            password = "iloveboss22",
            emails = {
                {
                    from = "boss23@inbox.com",
                    to = "user1@inbox.com",
                    subject = "re: bank details - savings",
                    content = "the password was 123456, but the account is no longer in use and the funds have been moved to the new account.\n\n- boss",
                    reference = {
                        from = "user1@inbox.com",
                        to = "boss23@inbox.com",
                        subject = "bank details - savings",
                        content = "hey, just quickly, what are the details for this account, i can not remember.\n\n- user1",
                    }
                },
                {
                    from = "noreply@inbox.com",
                    to = "user1@inbox.com",
                    subject = "welcome to inbox.com",
                    content = "welcome to inbox.com, the best email service in the world, we hope you enjoy your stay.\n\n- the inbox.com team",
                }
            },
            _emails = {
                {
                    from = "unknown",
                    to = "unknown",
                    subject = "unknown",
                    content = "unknown",
                }
            }
        }
    },
    banks = {
        {
            closed = true,
            name = "savings",
            password = "123456",
            email = "boss23@inbox.com"
        },
        {
            closed = true,
            name = "user1",
            password = "d839j39vjn30jk40k330", -- no one can guess this
            email = "boss23@inbox.com"
        },
        {
            identifier = "user1_newaccount_1",
            closed = false,
            name = "user1_newaccount",
            password = "284733",
            email = "user1@inbox.com",
            balance = 9640,
            onSend = function (desktop,from,to,account)
                if to.name == "ann0n7" and to.balance == 9640 then
                    desktop:createFile("b:/desktop", {pos = {13,2}, name = "funds recieved", type = "text", content = "the funds have been recieved, lets move on.\n\n- ann0nymous112"})
                    desktop:updateFile("b:/programs/remotedesktop", {hidden = false})
                end
            end
        },
        {
            closed = false,
            name = "ann0n7",
            balance = 0
        }
    }
}