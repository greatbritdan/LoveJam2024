Polygon = Class("Polygon")

function Polygon:initialize(shape, x, y, w, h)
    if shape == "circle" then
        self.points = self:createCircle(x, y, w, 16)
    else
        self.points = self:CreateRectangle(x, y, w, h)
    end
end

function Polygon:center()
    local center = {0,0}
    for i=1,#self.points,2 do
        center[1] = center[1] + self.points[i]
        center[2] = center[2] + self.points[i+1]
    end
    center[1] = center[1] / (#self.points/2)
    center[2] = center[2] / (#self.points/2)
    return center
end

function Polygon:move(newx, newy)
    local center = self:center()
    local dx, dy = newx-center[1], newy-center[2]
    for i=1,#self.points,2 do
        self.points[i] = self.points[i] + dx
        self.points[i+1] = self.points[i+1] + dy
    end
end

function Polygon:rotate(angle)
    local center = self:center()
    for i=1,#self.points,2 do
        local x, y = self.points[i], self.points[i+1]
        local dx, dy = x-center[1], y-center[2]
        local r = math.sqrt(dx*dx + dy*dy)
        local a = math.atan2(dy, dx) + math.rad(angle)
        self.points[i] = center[1] + r * math.cos(a)
        self.points[i+1] = center[2] + r * math.sin(a)
    end
end

function Polygon:hover(mx, my)
    local inside = false
    for i=1,#self.points,2 do
        local x1, y1 = self.points[i], self.points[i+1]
        local x2, y2 = self.points[i+2] or self.points[1], self.points[i+3] or self.points[2]
        if ((y1 > my) ~= (y2 > my)) and (mx < (x2 - x1) * (my - y1) / (y2 - y1) + x1) then
            inside = not inside
        end
    end
    return inside
end

function Polygon:CreateRectangle(x, y, w, h)
    return {x-w/2, y-h/2, x-w/2, y+h/2, x+w/2, y+h/2, x+w/2, y-h/2}
end

function Polygon:createCircle(x, y, r, segments)
    local polygon = {}
    for i=1,segments do
        local a = math.rad((i-1)/segments*360)
        table.insert(polygon, x + r * math.cos(a))
        table.insert(polygon, y + r * math.sin(a))
    end
    return polygon
end