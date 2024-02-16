-- MADE BY BRITDAN

local btscreen = {dir="screens"}
local screen = {}

function screen:initialize()
    self.screens = {}
    for i, v in pairs(love.filesystem.getDirectoryItems(btscreen.dir)) do
        local name = v:sub(1,-5)
        self.screens[name] = require(btscreen.dir .. "/" .. name)
    end
    self.state = false
    self.laststate, self.nextstate = false, false

    -- functions that wont be triggered while transitioning.
    self.transitionlock = {"mousepressed", "mousereleased", "keypressed", "keyreleased", "wheelmoved"}
end

function screen:update(dt)
    self:runFunction("update", {dt})
    if self.transition then
        self:updateTransition(dt)
    end
end

function screen:draw()
    love.graphics.push()
    love.graphics.scale(Env.scale, Env.scale)
    local r,g,b,a = love.graphics.getColor()
    self:runFunction("draw")
    if self.transition then
        self:drawTransition()
    end
    love.graphics.setColor(r,g,b,a)
    love.graphics.pop()
end

function screen:mousepressed(x, y, button)
    x, y = math.floor(x/Env.scale), math.floor(y/Env.scale)
    self:runFunction("mousepressed", {x, y, button})
end
function screen:mousereleased(x, y, button)
    x, y = math.floor(x/Env.scale), math.floor(y/Env.scale)
    self:runFunction("mousereleased", {x, y, button})
end
function screen:keypressed(key, scancode, isrepeat)
    self:runFunction("keypressed", {key, scancode, isrepeat})
end
function screen:keyreleased(key, scancode)
    self:runFunction("keyreleased", {key, scancode})
end
function screen:wheelmoved(x, y)
    self:runFunction("wheelmoved", {x, y})
end
function screen:mousemoved(x, y, dx, dy)
    x, y = math.floor(x/Env.scale), math.floor(y/Env.scale)
    self:runFunction("mousemoved", {x, y, dx, dy})
end
function screen:resize()
    self:runFunction("resize")
end
function screen:textinput(text)
    self:runFunction("textinput", {text})
end

--

function screen:setState(state)
    if self.laststate then
        self:runFunction("unload", {state})
    end
    self.laststate = self.state
    self.state = state
    if not self.laststate then
        self.laststate = self.state
    end
    if self.state then
        self:runFunction("load", {self.laststate})
    end
end

function screen:changeState(state, transout, transin)
    self.nextstate = state
    self.transition = "out"
    self.transitiontimer = 0
    self.transitionout = transout or {"none", 0, {0,0,0}}
    self.transitionin = transin or {"none", 0, {0,0,0}}
    self:updateTransition(0)
end

function screen:runFunction(name, args)
    -- if no function for screen or transiton locks the function
    if (not self.screens[self.state][name]) or (self.transition and TableContains(self.transitionlock, name)) then
        return
    end
    if args then
        self.screens[self.state][name](unpack(args))
    else
        self.screens[self.state][name]()
    end
end

--

function screen:updateTransition(dt)
    if not self.transition then
        return
    end

    self.transitiontimer = self.transitiontimer + dt
    local trans = self.transitionout
    if self.transition == "in" then
        trans = self.transitionin
    end

    if trans[1] == "none" or self.transitiontimer >= trans[2] then
        if self.transition == "out" then
            self.transition = "in"
            self.transitiontimer = self.transitiontimer - trans[2]
            self:setState(self.nextstate)
        else
            self.transition = false
        end
        self:updateTransition(0)
    end
end

function screen:drawTransition(dt)
    local trans, transt = self.transitionout, "out"
    if self.transition == "in" then
        trans, transt = self.transitionin, "in"
    end
    local percent = self.transitiontimer/trans[2]
    local r,g,b
    if trans[3] then
        r,g,b = trans[3][1] or 0, trans[3][2] or 0, trans[3][3] or 0
    else
        r,g,b = 0, 0, 0
    end
    if trans[1] == "fade" then
        if transt == "out" then
            love.graphics.setColor(r,g,b,percent)
        else
            love.graphics.setColor(r,g,b,1-(percent))
        end
        love.graphics.rectangle("fill",0,0,Env.width,Env.height)
    end
end

screen:initialize()
return screen