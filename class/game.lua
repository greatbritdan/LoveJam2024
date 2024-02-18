GameScreen = Class("GameScreen")

function GameScreen:initialize()
    love.graphics.setBackgroundColor(0.4,0.5,0.9)
    self.elements = {}

    math.randomseed(os.time())
    self:spawnButton()
end
function GameScreen:update(dt)
    for i, v in ipairs(self.elements) do
        v:update(dt)
    end
end
function GameScreen:draw()
    -- Draw the elements
    for i, v in ipairs(self.elements) do
        v:draw()
    end

    -- Draw the Foreground
    love.graphics.setColor(1,1,1,0.5)
    love.graphics.rectangle("fill", 0, Env.height-100, Env.width, 100)

    -- Draw the Pointer
    love.graphics.setColor(1,1,1,0.5)
    local mx, my = love.mouse.getX()/Env.scale, love.mouse.getY()/Env.scale
    love.graphics.draw(PointerImg, mx, my, 0, 1, 1, 16, 16)
end
function GameScreen:mousepressed(mx, my, b)
    for i, v in ipairs(self.elements) do
        v:click(mx, my, b)
    end
end
function GameScreen:mousereleased(mx, my, b)
    for i, v in ipairs(self.elements) do
        v:release(mx, my, b)
    end
end

function GameScreen:spawnButton()
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