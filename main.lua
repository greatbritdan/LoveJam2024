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

    Font = love.graphics.newImageFont("graphics/font.png", "abcdefghijklmnopqrstuvwxyz 0123456789.,:=+%*-()/\\", 1)
    love.graphics.setFont(Font)

    IconsImg = love.graphics.newImage("graphics/icons.png")
    IconsImgNames = {"test"}
    IconsQuads = {}
    for i = 1, IconsImg:getWidth()/16 do
        IconsQuads[IconsImgNames[i]] = love.graphics.newQuad((i-1)*16, 0, 16, 16, IconsImg:getWidth(), IconsImg:getHeight())
    end

    require("class.desktopButton")
    require("class.window")
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

--

function Round(n, deci)
    deci = 10^(deci or 0)
    return math.floor(n*deci+.5)/deci
end
function AABB(ax, ay, awidth, aheight, bx, by, bwidth, bheight)
	return ax+awidth > bx and ax < bx+bwidth and ay+aheight > by and ay < by+bheight
end

function Split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function Tablecontains(table, name)
    for i = 1, #table do
        if table[i] == name then
            return i
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