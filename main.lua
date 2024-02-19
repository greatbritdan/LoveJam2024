-- Game name ideas
--[[
    Bit-Breach
    Smashed Windows
    Backwindow
]]

function love.load()
    local lversion = string.format("%02d.%02d.%02d", love._version_major, love._version_minor, love._version_revision)
	if lversion < "00.11.40" then
		error("You have an outdated version of Love! Get 0.11.4 or higher and retry.")
	end

    Env = require("env")
    Var = require("variables")
    Class = require("libs.middleclass")
    Screen = require("libs.BT_Screen")
    UI = require("libs.BT_UI")

    love.graphics.setDefaultFilter("nearest")
    love.graphics.setLineStyle("rough")

    Font = love.graphics.newImageFont("graphics/font.png", "abcdefghijklmnopqrstuvwxyz 0123456789.,:=+%*-()/\\|<>'_£@", 1)
    love.graphics.setFont(Font)

    IconsImg = love.graphics.newImage("graphics/icons.png")
    IconsImgNames = {"exclamation","filemanager","text","folder","blank","shortcut","textviewer","desktop","bin","programs","start","image","imageviewer","remotedesktop","inbox","bank"}
    IconsQuads = {}
    for i = 1, IconsImg:getWidth()/16 do
        IconsQuads[IconsImgNames[i]] = love.graphics.newQuad((i-1)*16, 0, 16, 16, IconsImg:getWidth(), IconsImg:getHeight())
    end

    WindowIconsImg = love.graphics.newImage("graphics/windowIcons.png")
    WindowIconsImgNames = {"minimize","fullscreen","close"}
    WindowIconsQuads = {}
    for i = 1, WindowIconsImg:getWidth()/13 do
        WindowIconsQuads[WindowIconsImgNames[i]] = love.graphics.newQuad((i-1)*13, 0, 13, 13, WindowIconsImg:getWidth(), WindowIconsImg:getHeight())
    end

    TitleImg = love.graphics.newImage("graphics/title.png")

    FansSound = love.audio.newSource("audio/fans.mp3","static")
    ClickSounds = {
        love.audio.newSource("audio/click1.mp3","static"),
        love.audio.newSource("audio/click2.mp3","static"),
        love.audio.newSource("audio/click3.mp3","static")
    }
    KeySounds = {
        love.audio.newSource("audio/key1.mp3","static"),
        love.audio.newSource("audio/key2.mp3","static"),
        love.audio.newSource("audio/key3.mp3","static"),
        love.audio.newSource("audio/key4.mp3","static"),
        love.audio.newSource("audio/key5.mp3","static")
    }
    NewEmailSound = love.audio.newSource("audio/newemail.mp3","static")

    DesktopName = "loveuser"
    Desktops = {"loveuser","user1"}

    require("class.window")
    require("class.windows.fileManager")
    require("class.windows.textViewer")
    require("class.windows.imageViewer")
    require("class.windows.inbox")
    require("class.windows.bank")

    require("class.fileButton")
    require("class.taskbarButton")
    require("class.desktop")

    Screen:changeState("desktop", {"none", 0, {0,0,0}}, {"fade", 0.25, {0,0,0}})
end

function love.update(dt)
    dt = math.min(0.01666667, dt)
    Screen:update(dt)
end

function love.draw()
    Screen:draw()
    if Env.showfps or Env.showdrawcalls or Env.showcursor then
        love.graphics.setColor(1,1,1)
        local text = ""
        if Env.showfps then
            text = text .. string.format("fps: %s\n", love.timer.getFPS())
        end
        if Env.showcursor then
            local mx, my = math.floor(love.mouse.getX()/Env.scale), math.floor(love.mouse.getY()/Env.scale)
            love.graphics.rectangle("fill", mx*Env.scale, my*Env.scale, Env.scale, Env.scale)
            text = text .. string.format("cursor: %s - %s\n", mx*Env.scale, my*Env.scale)
        end
        if Env.showdrawcalls then
            local stats = love.graphics.getStats()
            text = text .. string.format("drawcalls: %s\n", stats.drawcalls+1)
        end
        love.graphics.print(text,4,4,0,2,2)
    end
end

--

function love.mousepressed(x, y, b)
    Screen:mousepressed(x, y, b)
end
function love.mousereleased(x, y, b)
    Screen:mousereleased(x, y, b)
end
function love.mousemoved(x, y, dx, dy)
    Screen:mousemoved(x, y, dx, dy)
end
function love.wheelmoved(x, y)
    Screen:wheelmoved(x, y)
end
function love.keypressed(key, scancode, isrepeat)
    Screen:keypressed(key, scancode, isrepeat)
end
function love.keyreleased(key, scancode)
    Screen:keyreleased(key, scancode)
end
function love.textinput(text)
    Screen:textinput(text)
end

function love.resize(w, h)
    Env.width, Env.height = w/Env.scale, h/Env.scale
    Screen:resize()
end

--

function Round(n, deci)
    deci = 10^(deci or 0)
    return math.floor(n*deci+.5)/deci
end
function AABB(ax, ay, awidth, aheight, bx, by, bwidth, bheight)
	return ax+awidth > bx and ax < bx+bwidth and ay+aheight > by and ay < by+bheight
end

function Split(str, d)
	local data = {}
	local from, to = 1, string.find(str, d)
	while to do
		table.insert(data, string.sub(str, from, to-1))
		from = to+d:len()
		to = string.find(str, d, from)
	end
	table.insert(data, string.sub(str, from))
	return data
end
function RemoveEmpty(list)
    local newlist = {}
    for i = 1, #list do
        if list[i] ~= "" then
            table.insert(newlist, list[i])
        end
    end
    return newlist
end

function TextHeight(text, w)
    local split = Split(text, "\n")
    local lines = 0
    for _, line in pairs(split) do
        local width = Font:getWidth(line)
        if width > w then
            local split = Split(line, " ")
            local line = ""
            for i, word in pairs(split) do
                if Font:getWidth(line.." "..word) > w then
                    lines = lines + 1
                    line = word
                else
                    line = line.." "..word
                end
            end
            lines = lines + 1
        else
            lines = lines + 1
        end
    end
    return lines*Font:getHeight()
end

function TableContains(table, name)
    for i = 1, #table do
        if table[i] == name then
            return i
        end
    end
    return false
end
function TableContainsWithin(table, name, key)
    for i = 1, #table do
        if table[i][key] == name then
            return table[i]
        end
    end
    return false
end

function Deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Deepcopy(orig_key)] = Deepcopy(orig_value)
        end
        setmetatable(copy, Deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

Printold = print
function print(...)
    local vals = {...}
    local outvals = {}
    for i, t in pairs(vals) do
        if type(t) == "table" then
            outvals[i] = Tabletostring(t)
        elseif type(t) == "function" then
            outvals[i] = "function"
        else
            outvals[i] = tostring(t)
        end
    end
    Printold(unpack(outvals))
end
function Tabletostring(t)
    local array = true
    local ai = 0
    local outtable = {}
    for i, v in pairs(t) do
        if type(v) == "table" then
            outtable[i] = Tabletostring(v)
        elseif type(v) == "function" then
            outtable[i] = "function"
        else
            outtable[i] = tostring(v)
        end

        ai = ai + 1
        if t[ai] == nil then
            array = false
        end
    end
    local out = ""
    if array then
        out = "[" .. table.concat(outtable,",") .. "]"
    else
        for i, v in pairs(outtable) do
            out = string.format("%s%s: %s, ", out, i, v)
        end
        out = "{" .. out .. "}"
    end
    return out
end