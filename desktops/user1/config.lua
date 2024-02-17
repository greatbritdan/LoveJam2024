local path = "desktops/user1"

return {
    path = path,
    name = "user1",
    theme = "dark",
    background = {
        t = "color", color = {0.25,0.35,0.65}
    },
    desktop = {
        {
            name = "filemanager",
            type = "shortcut",
            target = "b:/programs/filemanager",
        },
        {
            pos = {1,7},
            name = "balance",
            type = "text",
            content = {
                {"hey mate, as requested here is the balance of all the accounts in our name,\n\nremember that the ann0nymous has an eye on our 2nd account, i've transfered it to a new account:"},
                {"- savings: £22.54\n- user1: £1.23 (comprimised)\n- user1_newaccount: £9,640.50","left"},
                {"cheers,\n\n- user1"}
            },
        },
        {
            pos = {13,1},
            name = "goal",
            type = "text",
            content = "generic name but trust me, this guy is loaded.\n\nget access to his back details and send everything to me:\n\nmy account number: 12345678\nmy sort code: 39-27-11\n\n- ann0nymous112",
        }
    },
    bin = {}
}