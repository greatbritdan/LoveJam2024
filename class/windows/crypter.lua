WindowCrypter = Class("WindowCrypter", Window)

function WindowCrypter:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "crypter", 300, 200)
    self.program = "crypter"
    self.icon = "crypter"

    self.elements.mode = UI.toggle({x=2, y=2, w=self.w-4, h=16, is={"encrypt","decrypt"}, i=1, desktop=desktop, func=function() self:search() end, resize=function (element)
        element.w = self.w-4
    end})
    self.elements.path = UI.input({x=2, y=22, w=self.w-4, h=16, text="b:/desktop/", mc=50, desktop=desktop, func=function() self:search() end, resize=function (element)
        element.w = self.w-4
    end})
    self.elements.outputlabel = UI.label({x=2, y=42, w=self.w-4, h=16, text="output:", desktop=desktop, resize=function (element)
        element.w = self.w-4
    end})
    self:sync()

    self.errorOutput = "file not found"
end

function WindowCrypter:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", self.x+2, self.y+self.navbar.h+60, self.w-4, self.h-self.navbar.h-62)
    if self.errorOutput then
        love.graphics.setColor(1,0.5,0.5)
        love.graphics.printf(self.errorOutput, self.x+4, self.y+self.navbar.h+62, self.w-8, "center")
    else
        love.graphics.setColor(1,1,1)
        love.graphics.printf(self.output, self.x+4, self.y+self.navbar.h+62, self.w-8, "center")
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowCrypter:search()
    self.errorOutput = false
    local path = self.elements.path.text
    local file = self.desktop:getFile(path)
    if file and file.type == "text" then
        self.output = Deepcopy(file.content)
        -- content = {{"todo:"},{"- encrypt all passwords\n- setup antivirus\n- don't use twitter","left"}}
        if type(self.output) == "table" then
            local output = ""
            for i, v in ipairs(self.output) do
                if type(v) == "table" then
                    output = output .. v[1] .. "\n\n"
                else
                    output = output .. v .. "\n\n"
                end
            end
            self.output = output
        end
        if self.elements.mode:getValue() == "encrypt" then
            self.output = self:encrypt(self.output)
        else
            self.output = self:decrypt(self.output)
        end
    elseif file and file.type ~= "text" then
        self.errorOutput = "only text files are supported"
    else
        self.errorOutput = "file not found"
    end
end

function WindowCrypter:encrypt(content)
    for i = 1, #content do
        local byte = content:byte(i)
        byte = byte + 1
        content = content:sub(1, i-1) .. string.char(byte) .. content:sub(i+1)
    end
    return content
end
function WindowCrypter:decrypt(content)
    for i = 1, #content do
        local byte = content:byte(i)
        byte = byte - 1
        content = content:sub(1, i-1) .. string.char(byte) .. content:sub(i+1)
    end
    return content
end