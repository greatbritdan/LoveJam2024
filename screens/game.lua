local game = {}

require("class.button")

local button
function game.load(last)
    button = Button:new("thinrectangle", Env.width/2, Env.height/2)
end
function game.update(dt)
    button:update(dt)
    button:rotate(90, dt)
end
function game.draw()
    love.graphics.setColor(1,1,1)
    button:draw()
end
function game.mousepressed(mx, my, b)
    button:click(mx, my, b)
end
function game.mousereleased(mx, my, b)
    button:release(mx, my, b)
end

-- POLYGON --

function CreateRectangle(x, y, w, h)
    return {x-w/2, y-h/2, x-w/2, y+h/2, x+w/2, y+h/2, x+w/2, y-h/2}
end

function CreateCircle(x, y, r, segments)
    local polygon = {}
    for i=1,segments do
        local a = math.rad((i-1)/segments*360)
        local x = x + r * math.cos(a)
        local y = y + r * math.sin(a)
        table.insert(polygon, x)
        table.insert(polygon, y)
    end
    return polygon
end

function RotatePolygon(polygon, angle)
    local center = {0,0}
    for i=1,#polygon,2 do
        center[1] = center[1] + polygon[i]
        center[2] = center[2] + polygon[i+1]
    end
    center[1] = center[1] / (#polygon/2)
    center[2] = center[2] / (#polygon/2)
    for i=1,#polygon,2 do
        local x, y = polygon[i], polygon[i+1]
        local dx, dy = x-center[1], y-center[2]
        local r = math.sqrt(dx*dx + dy*dy)
        local a = math.atan2(dy, dx) + math.rad(angle)
        polygon[i] = center[1] + r * math.cos(a)
        polygon[i+1] = center[2] + r * math.sin(a)
    end
end

function HoveringPolygon(polygon, mx, my)
    local inside = false
    for i=1,#polygon,2 do
        local x1, y1 = polygon[i], polygon[i+1]
        local x2, y2 = polygon[i+2] or polygon[1], polygon[i+3] or polygon[2]
        if ((y1 > my) ~= (y2 > my)) and (mx < (x2 - x1) * (my - y1) / (y2 - y1) + x1) then
            inside = not inside
        end
    end
    return inside
end

return game