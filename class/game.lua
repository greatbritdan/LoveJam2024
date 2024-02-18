GameScreen = Class("GameScreen")

function GameScreen:initialize()
    love.graphics.setBackgroundColor(0.4,0.5,0.9)

    self.score = 0
    self.foregroundHeight = 100

    self.elements = {}
    self.scoretext = {}

    math.randomseed(os.time())
end
function GameScreen:update(dt)
    for i = #self.elements, 1, -1 do
        self.elements[i]:update(dt)
        if self.elements[i].DELETEME then
            table.remove(self.elements, i)
        end
    end

    for i = #self.scoretext, 1, -1 do
        self.scoretext[i]:update(dt)
        if self.scoretext[i].DELETEME then
            table.remove(self.scoretext, i)
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
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.rectangle("fill", 0, Env.height-self.foregroundHeight, Env.width, self.foregroundHeight)

    -- Draw the Pointer
    love.graphics.setColor(1,1,1,0.5)
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    love.graphics.draw(PointerImg, mx, my, 0, 1, 1, 16, 16)

    -- Draw the Score
    love.graphics.setColor(1,1,1)
    love.graphics.print("score: "..self.score, 4, 4, 0, 2, 2)
end
function GameScreen:mousepressed(mx, my, b)
    if b == 2 then
        self:addButton()
    end
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

function GameScreen:addButton()
    local x, y = math.random(32, Env.width-32), Env.height-50
    local shapes = {"circle", "rectangle", "thinrectangle"}
    local shape = shapes[math.random(1,#shapes)]

    local button = Button:new(self, shape, x, y)
    button.velocity[1] = math.random(-128,128)
    button.velocity[2] = math.random(-384,-512)
    button.velocity[3] = math.random(-45,45)

    table.insert(self.elements, button)
end
function GameScreen:removeButton(button)
    for i, v in ipairs(self.elements) do
        if v == button then
            table.remove(self.elements, i)
            break
        end
    end
end

function GameScreen:addScore(score, button)
    self.score = self.score + score
    local text = "+"..score
    local scoretext = ScoreText:new(button, text)
    table.insert(self.scoretext, scoretext)
end