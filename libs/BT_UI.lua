local ui = Class("BT_UI")

function ui:initialize(t,data)
    self.t = t
    self.x, self.y, self.w, self.h = data.x, data.y, data.w, data.h
    self.shown, self.active, self.pressed = true, true, false
    self.func = data.f or data.func or function () end

    self.text = data.t or data.text or false
    self.textallign = data.ta or data.textallign or "center"

    if self.t == "label" then
        self.link = data.l or data.link
        if not(type(self.link) == "table" and self.link.getValue and self.link:getValue()) then
            self.link = false
        end
    end

    self.repeattimer = 0
    if self.t == "button" or self.t == "toggle" then
        local repeating = data.r or data["repeat"]
        if repeating then
            if type(self.repeating) == "table" then
                self.repeating = {repeating[1],repeating[2]}
            else
                self.repeating = {0.5,repeating}
            end
        end
    end

    if self.t == "toggle" then
        self.items = data.is or data.items or false
        self.item = data.i or data.item or 1
        if type(self.item) == "number" then
            self.item = math.max(1,math.min(self.item,#self.items))
        elseif type(self.item) == "string" then
            self.item = Tablecontains(self.items,self.item) or 1
        end
    end

    if self.t == "slider" then
        self.fill = data.fl or data.fill or 0.5
        if self.fill > 1 then
            self.fill = 1/(self.w/self.fill)
        end
        self.limit = data.l or data.limit or {0,10,0,1}
        self.value = data.v or data.value or self.limit[1]

        self.sx, self.sy, self.sw, self.sh = self.x, self.y, self.w*self.fill, self.h
        if self.value ~= self.limit[1] then
            self.sx = self:posFromValue()
        end
    end

    if self.t == "input" then
        self.inputting = false
        self.maxcharacters = data.mc or data.maxcharacters or 10
        if not self.text then
            self.text = ""
        end
    end

    self.resize = data.resize or nil

    self.style = {
        padding = 8,
        shape = { curve=0, point=100, outline=1 },
        text = { scale=1 },
        color = {
            void = {normal={0,0,0,.5}, hover={0,0,0,.5}, pressed={0,0,0,.5}, inactive={0,0,0,.5}},
            back = {normal={0,0,0},    hover={.2,.2,.2}, pressed={.4,.4,.4}, inactive={0,0,0}},
            line = {normal={.6,.6,.6}, hover={.8,.8,.8}, pressed={1,1,1},    inactive={.2,.2,.2}},
            text = {normal={.6,.6,.6}, hover={.8,.8,.8}, pressed={1,1,1},    inactive={.2,.2,.2}},
            white = {1,1,1},
        }
    }
end

function ui:update(dt)
    if self.pressed then
        if self.repeating then
            self.repeattimer = self.repeattimer + dt
            if self.repeattimer > self.repeating[1] then
                self.repeattimer = self.repeattimer - self.repeating[2]
                if self.t == "toggle" then
                    self.item = ((self.item)%#self.items)+1
                end
                self:func()
            end
        end
        if self.t == "slider" then
            local mx, my = love.mouse.getPosition()
            self.sx = math.max(self.x,math.min(mx-(self.sw/2), self.x+self.w-self.sw))
            local oldval = self.value
            self.value = self:valueFromPos()
            if self.value ~= oldval then
                self:func()
            end
        end
    end
end

function ui:draw()
    if self.shown then
        if self.scissor then
            love.graphics.push()
            love.graphics.setScissor(self.scissor.x,self.scissor.y,self.scissor.w,self.scissor.h)
        end

        if self.t ~= "label" then
            if self.t == "slider" then
                self:drawFill(self.x,self.y,self.w,self.h,"void")
                self:drawFill(self.sx,self.sy,self.sw,self.sh,"back")
                self:drawLine(self.sx,self.sy,self.sw,self.sh,"line")
            else
                self:drawFill(self.x,self.y,self.w,self.h,"back")
                self:drawLine(self.x,self.y,self.w,self.h,"line")
                if self.t == "input" and self.inputting then
                    -- draw cursor at end of text
                    local font = love.graphics.getFont()
                    y = self:allignY(self.y,self.h,font)-2
                    x = self:allignX(self.x,self.w,self.text,self.textallign,font)+(font:getWidth(self.text)*self.style.text.scale)+self.style.text.scale
                    self:setColor("text")
                    love.graphics.print("|", x, y, 0, self.style.text.scale, self.style.text.scale)
                end
            end
        end
        if self.link then
            self.text = self.link:getValue()
        end

        local txt = self:getText()
        if txt then
            self:drawText(self.x,self.y,self.w,self.h,"text",txt,self.textallign)
        end

        if self.scissor then
            love.graphics.setScissor()
            love.graphics.pop()
        end
    end
end

function ui:press(x,y,b)
    if b ~= 1 then return false end
    if self.active and self:highlight(x,y) then
        if self.t == "input" then
            self.oldtext = self.text
            self.inputting = true
        else
            self.pressed = true
        end
    end
end
function ui:unpress(x,y,b)
    if b ~= 1 then return false end
    if self.pressed and self:highlight(x,y) then
        if self.t == "toggle" then
            self.item = ((self.item)%#self.items)+1
        end
        self:func()
    end
    if self.repeating then
        self.repeattimer = 0
    end
    if self.t ~= "input" then
        self.pressed = false
    end
end

function ui:scroll(x,y)
    if self.t == "slider" then
        local mx, my = love.mouse.getPosition()
        if self.global or self:highlight(mx,my,true) then
            local oldval = self.value
            self.value = math.max(self.limit[1], math.min(Round(self.value+((-y)*self.limit[4]),self.limit[3]), self.limit[2]))
            self.sx = self:posFromValue()
            if self.value ~= oldval then
                self:func()
            end
            return true
        end
    end
    return false
end

function ui:textinput(t)
    if self.t == "input" and self.inputting then
        if #self.text < self.maxcharacters then
            self.text = self.text .. t
        end
    end
end
function ui:keypress(k)
    if self.t == "input" and self.inputting then
        if k == "backspace" then
            self.text = self.text:sub(1, -2)
        end
        if k == "escape" or k == "return" then
            if k == "escape" then
                self.text = self.oldtext
            end
            self.inputting = false
            self:func()
        end
    end
end

--

function ui:highlight(mx,my,s)
    if self.t == "label" then
        return false
    end
    mx, my = mx or love.mouse.getX(), my or love.mouse.getY()
    if self.scissor and (not AABB(self.scissor.x,self.scissor.y,self.scissor.w,self.scissor.h,mx,my,1,1)) then
        return false
    end
    if self.active then
        if self.t == "slider" and (not s) then
            return AABB(self.sx,self.sy,self.sw,self.sh,mx,my,1,1)
        else
            return AABB(self.x,self.y,self.w,self.h,mx,my,1,1)
        end
    end
end

function ui:getValue()
    if self.t == "toggle" then
        return self.items[self.item]
    end
    if self.t == "slider" then
        return self.value
    end
    if self.t == "input" then
        return self.text
    end
    return false
end
function ui:getText()
    if self.t == "toggle" then
        return self:getValue()
    end
    if self.text then
        return self.text
    end
    return false
end

function ui:valueFromPos()
    local fw = self.w-self.sw
    local diff = math.abs(self.limit[1]-self.limit[2])
    return Round(((self.sx-self.x)/fw)*diff,self.limit[3])
end
function ui:posFromValue()
    local fw = self.w-self.sw
    local diff = math.abs(self.limit[1]-self.limit[2])
    return self.x+(fw*(self.value/diff))
end

--

function ui:getColor(sect)
    if self.t == "label" then return self.style.color.white end
    if self.active == false then return self.style.color[sect].inactive end
    if self.pressed then return self.style.color[sect].pressed end
    if self:highlight() then return self.style.color[sect].hover end
    return self.style.color[sect].normal
end
function ui:setColor(sect)
    love.graphics.setColor(self:getColor(sect))
end

function ui:debugDraw()
    local lwidth = love.graphics.getLineWidth()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
    if self.scissor then
        love.graphics.setColor(.2,1,1)
        love.graphics.rectangle("line",self.scissor.x,self.scissor.y,self.scissor.w,self.scissor.h)
    end
    love.graphics.setLineWidth(lwidth)
end

function ui:drawRect(t,x,y,w,h)
    local curve, points = self.style.shape.curve, self.style.shape.points
    love.graphics.rectangle(t,x,y,w,h,curve,curve,points)
end
function ui:drawFill(x,y,w,h,col)
    self:setColor(col)
    self:drawRect("fill",x,y,w,h)
end
function ui:drawLine(x,y,w,h,col)
    if not self.style.shape.outline then
        return
    end
    local lwidth = love.graphics.getLineWidth()
    love.graphics.setLineWidth(self.style.shape.outline)
    self:setColor(col)
    self:drawRect("line",x,y,w,h)
    love.graphics.setLineWidth(lwidth)
end
function ui:drawText(x,y,w,h,col,text,texta)
    local font = love.graphics.getFont()
    y = self:allignY(y,h,font)
    x = self:allignX(x,w,text,texta,font)
    self:setColor(col)
    love.graphics.print(text, x, y, 0, self.style.text.scale, self.style.text.scale)
end
function ui:allignX(x,w,text,texta,font)
    if texta == "left" then
        return x+self.style.padding
    elseif texta == "right" then
        return x+w-self.style.padding-(font:getWidth(text)*self.style.text.scale)
    elseif texta == "center" then
        return x+(w/2)-(((font:getWidth(text))*self.style.text.scale)/2)
    end
end
function ui:allignY(y,h,font)
    return y+(h/2)-(((font:getHeight()-1)*self.style.text.scale)/2)
end

--

function ui.label(data)  return ui:new("label",data)  end
function ui.button(data) return ui:new("button",data) end
function ui.toggle(data) return ui:new("toggle",data) end
function ui.slider(data) return ui:new("slider",data) end
function ui.input(data)  return ui:new("input",data)  end

return ui