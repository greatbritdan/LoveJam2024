GameScreen = Class("GameScreen")

function GameScreen:initialize()
    love.graphics.setBackgroundColor(0.4,0.5,0.9)

    self.options = {
        br = {"button", "rectangle"}, bc = {"button", "circle"}, btr = {"button", "thinrectangle"}, bmr = {"button", "minirectangle"},
        sr = {"switch", "rectangle"}, sc = {"switch", "circle"}, str = {"switch", "thinrectangle"}, smr = {"switch", "minirectangle"}
    }

    self.foregroundHeight = 100

    self.round = 1
    self.rounds = {
        {count=99, wait=5, options={"br,","bc","btr","bmr","sr","sc","str","smr"}},
    }
    self.roundcount, self.roundtimer = 0, -2

    self.roundtext = "round "..self.round
    self.roundtextopacity = 2

    self.elements = {}

    self.score = 0
    self.scoretext = {}

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

    -- Update the round
    self.roundtimer = self.roundtimer + dt
    if self.roundtimer >= self.rounds[self.round].wait then
        if self.rounds[self.round].count > self.roundcount then
            local options = self.rounds[self.round].options
            local option = self.options[options[math.random(1,#options)]]
            if option[1] == "button" then
                self:addButton(option[2])
            end
            if option[1] == "switch" then
                self:addSwitch(option[2])
            end
            self.roundcount = self.roundcount + 1
            self.roundtimer = 0
        else
            self.round = self.round + 1
            self.roundcount, self.roundtimer = 0, -2
            self.roundtext = "round "..self.round
            self.roundtextopacity = 2
        end
    end

    if self.roundtextopacity > 0 then
        self.roundtextopacity = self.roundtextopacity - dt
        if self.roundtextopacity <= 0 then
            self.roundtext = false
        end
    end
end
function GameScreen:draw()
    -- Draw the elements
    for i, v in ipairs(self.elements) do
        v:draw()
    end
    -- Draw the ScoreText
    for i, v in ipairs(self.scoretext) do
        v:draw()
    end

    -- Draw the Foreground
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", 0, Env.height-self.foregroundHeight, Env.width, self.foregroundHeight)

    -- Draw the Pointer
    love.graphics.setColor(1,1,1,0.5)
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    love.graphics.draw(PointerImg, mx, my, 0, 1, 1, 16, 16)

    -- Draw the Score
    love.graphics.setColor(1,1,1)
    love.graphics.printf("score: "..self.score, 0, 4, Env.width/2, "center", 0, 2, 2)
    if self.roundtext then
        love.graphics.setColor(1,1,1,self.roundtextopacity)
        love.graphics.printf(self.roundtext, 0, (Env.height/2)-16, Env.width/4, "center", 0, 4, 4)
    end
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