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
            name = "to delete",
            type = "folder",
            {
                name = "bank details (user1)",
                type = "text",
                content = {
                    {"hi mate, reminder to switch all the bank details to the new account, the old one is compromised.\n\nif they ask for the current details here they are."},
                    {"- 16 digit code: 6329 1124 2646 2211\n- expiration date: March 2027\n- cvc code: 289","left"},
                    {"cheers,\n\n- boss"}
                }
            },
            {
                name = "bank details (savings)",
                type = "text",
                content = "hey, just quickly, what are the details for this account, i can not remember.\n\n- user1"
            },
            {
                name = "new document",
                type = "text",
                content = ""
            },
            {
                name = "new document (1)",
                type = "text",
                content = "recovery code - 344291"
            },
            {
                name = "dwwf",
                type = "folder"
            }
        },
        {
            pos = {1,6},
            name = "balance",
            type = "text",
            content = {
                {"hey mate, as requested here is the balance of all the accounts in our name,\n\nremember that the ann0nymous has an eye on our 2nd account, i've transfered it to a new account:"},
                {"- savings: £22.54\n- user1: £1.23 (comprimised)\n- user1_newaccount: £9,640.50","left"},
                {"cheers,\n\n- boss"}
            },
        },
        {
            pos = {2,3},
            name = "inbox",
            type = "program",
            program = "inbox",
            icon = "inbox",
        },
        {
            pos = {13,1},
            name = "goal",
            type = "text",
            content = "generic name but trust me, this guy is loaded.\n\nget access to his back details and send everything to me:\n\nmy account number: 12345678\nmy sort code: 39-27-11\n\n- ann0nymous112",
        }
    },
    bin = {
        {
            name = "new folder",
            type = "folder"
        },
        {
            name = "email",
            type = "text",
            content = {{"(incase of memory loss)"},{"- email: user1@inbox.com\n- password: iloveboss22","left"}}
        }
    }
}