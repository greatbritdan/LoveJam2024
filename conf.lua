function love.conf(t)
    t.identity = "_base"
	t.version = "11.4"
    t.console = true

    local env = require("env")
	t.window.width = env.width*env.scale
	t.window.height = env.height*env.scale
    t.window.resizable = false
    t.window.minwidth = env.width
    t.window.minheight = env.height
end