GameScreen = Class("GameScreen")

function GameScreen:initialize()
    love.graphics.setBackgroundColor(0.4,0.5,0.9)

    self.optionsKey = {
        br = {"button", "rectangle"}, bc = {"button", "circle"}, btr = {"button", "thinrectangle"}, bmr = {"button", "minirectangle"},
        sr = {"switch", "rectangle"}, sc = {"switch", "circle"}, str = {"switch", "thinrectangle"}, smr = {"switch", "minirectangle"}
    }

    self.foregroundHeight = 100

    self.paused = false
    self.time, self.timer = 1, 0
    self.count, self.counter = 20, 0
    self.options = {"br","bc","btr","bmr","sr","str","smr"}

    self.elements = {}

    self.score = 0
    self.scoretext = {}

    self.spriteBatchWidth = 0
    self.backgroundSpriteBatch = love.graphics.newSpriteBatch(BackgroundImg, 100)
    for i = 0, Env.width/128 do
        for j = 0, Env.height/128 do
            self.backgroundSpriteBatch:add(i*128, j*128, 0, 2, 2)
        end
        self.spriteBatchWidth = self.spriteBatchWidth + 128
    end
    self.foregroundSpriteBatch = love.graphics.newSpriteBatch(ForegroundImg, 100)
    for i = 0, Env.width/128 do
        self.foregroundSpriteBatch:add(i*128, 0, 0, 2, 2)
    end
    math.randomseed(os.time())
end
function GameScreen:update(dt)
    -- Update the elements
    for i = #self.elements, 1, -1 do
        self.elements[i]:update(dt)
        if self.elements[i].DELETEME then
            table.remove(self.elements, i)
        end
    end

    -- Update the scoretext
    for i = #self.scoretext, 1, -1 do
        self.scoretext[i]:update(dt)
        if self.scoretext[i].DELETEME then
            table.remove(self.scoretext, i)
        end
    end

    if self.paused then return end

    -- Add a new element
    self.timer = self.timer + dt
    if self.timer >= self.time then
        self.timer = self.timer - self.time
        local option = self.options[math.random(1, #self.options)]
        local shape = self.optionsKey[option][2]
        if self.optionsKey[option][1] == "button" then
            self:addButton(shape)
        else
            self:addSwitch(shape)
        end
        self.counter = self.counter + 1
        if self.counter >= self.count then
            self.paused = true
        end
    end
end
function GameScreen:draw()
    -- Draw the Background
    love.graphics.setColor(1,1,1)
    local x = (Env.width/2)-(self.spriteBatchWidth/2)
    love.graphics.draw(self.backgroundSpriteBatch, x)

    -- Draw the Background Screen (Hud)
    x = (Env.width/2)-(BackgroundScreenImg:getWidth())
    love.graphics.draw(BackgroundScreenImg, x, 64, 0, 2, 2)
    love.graphics.setColor(0,0.75,0)
    love.graphics.printf("score: "..self.score.." / "..self.count*10, 0, 76, Env.width/2, "center", 0, 2, 2)
    love.graphics.rectangle("fill", x+8, 96, (BackgroundScreenImg:getWidth()*2)-16, 2)
    love.graphics.printf(self.count-self.counter.." remaining", 0, 104, Env.width/2, "center", 0, 2, 2)

    love.graphics.setColor(0.21,0.21,0.21)
    love.graphics.print("fail line", 2, Env.height-self.foregroundHeight-48, 0, 2, 2)
    love.graphics.rectangle("fill", 0, Env.height-self.foregroundHeight-32, Env.width, 2)

    -- Draw the elements
    love.graphics.push()
    love.graphics.translate(4,4)
    love.graphics.setColor(0,0,0,0.5)
    for i, v in ipairs(self.elements) do
        v:draw(true)
    end
    love.graphics.pop()
    for i, v in ipairs(self.elements) do
        v:draw()
    end

    -- Draw the Foreground
    love.graphics.setColor(1,1,1)
    love.graphics.draw(self.foregroundSpriteBatch, 0, Env.height-self.foregroundHeight, 0, 2, 2)
    love.graphics.setColor(0.21,0.21,0.21)
    love.graphics.rectangle("fill", 0, Env.height-self.foregroundHeight+40, Env.width, self.foregroundHeight-40)

    -- Draw the ScoreText
    for i, v in ipairs(self.scoretext) do
        v:draw()
    end

    -- Draw the Pointer
    love.graphics.setColor(1,1,1,0.5)
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    love.graphics.draw(PointerImg, mx, my, 0, 1, 1, 16, 16)
end
function GameScreen:mousepressed(mx, my, b)
    if my >= Env.height-self.foregroundHeight then
        return
    end
    for i, v in ipairs(self.elements) do
        v:click(mx, my, b)
    end
end
function GameScreen:mousereleased(mx, my, b)
    if my >= Env.height-self.foregroundHeight then
        return
    end
    for i, v in ipairs(self.elements) do
        v:release(mx, my, b)
    end
end
function GameScreen:keypressed(key)
    if key == "1" then
        self.paused = false
        self.time, self.timer = 0.66, 0
        self.count, self.counter = 100, 0
        self.elements = {}
        self.score = 0
        self.scoretext = {}
    end
end

function GameScreen:addButton(shape)
    local x, y = math.random(32, Env.width-32), Env.height-50
    local button = Button:new(self, shape, x, y)
    button.velocity[1] = math.random(-128,128)
    button.velocity[2] = math.random(-384,-512)
    button.velocity[3] = math.random(-45,45)
    table.insert(self.elements, button)
end
function GameScreen:addSwitch(shape)
    local x, y = math.random(32, Env.width-32), Env.height-50
    local switch = Switch:new(self, shape, x, y)
    switch.velocity[1] = math.random(-128,128)
    switch.velocity[2] = math.random(-384,-512)
    switch.velocity[3] = math.random(-45,45)
    table.insert(self.elements, switch)
end
function GameScreen:addScore(score, button)
    self.score = self.score + score
    local text = "+"..score
    local scoretext = ScoreText:new(button, text)
    table.insert(self.scoretext, scoretext)
end

function HueToRGB(hue)
    local r, g, b
    if hue < 0 or hue > 1 then
        return 0, 0, 0
    end
    local h = hue * 6
    local i = math.floor(h)
    local f = h - i
    local p = 0
    local q = 1 - f
    local t = f
    if i % 6 == 0 then
        r, g, b = 1, t, p
    elseif i % 6 == 1 then
        r, g, b = q, 1, p
    elseif i % 6 == 2 then
        r, g, b = p, 1, t
    elseif i % 6 == 3 then
        r, g, b = p, q, 1
    elseif i % 6 == 4 then
        r, g, b = t, p, 1
    elseif i % 6 == 5 then
        r, g, b = 1, p, q
    end
    return r, g, b
end