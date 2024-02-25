Desktop = Class("Desktop")

function Desktop:initialize(config)
    self.programWindows = {
        filemanager = WindowFileManager,
        textviewer = WindowTextViewer,
        imageviewer = WindowImageViewer,
        inbox = WindowInbox,
        bank = WindowBank,
        zipcrash = WindowZipcrash,
        antivirus = WindowAntivirus,
        crypter = WindowCrypter,
        levelselect = WindowLevelSelect,
        settings = WindowSettings,
        howtoplay = WindowHowtoplay,
        factoryreset = WindowFactoryreset
    }

    self.w, self.h = Env.width, Env.height
    self.background = config.background or {t = "color", color = {0.75,0.75,0.75}}

    self.name = config.name
    self.pfp = config.pfp

    self.focus = false
    self.startMenu = {
        w = 182, h = 124,
        open = false,
        buttons = {
            FileButton:new(self, "startmenu", 1, "levelselect"),
            FileButton:new(self, "startmenu", 2, "settings"),
            FileButton:new(self, "startmenu", 3, "howtoplay"),
            FileButton:new(self, "startmenu", 4, "power")
        }
    }
    self.taskbar = {
        h = 20,
        buttons = { TaskbarButton:new(self, false) }
    }
    self.windows = {}
    self.emails = config.emails or {}
    self.banks = config.banks or {}
    self.antivirus = config.antivirus or {}
    self.zipcrash = config.zipcrash or {}

    self.avalablePrograms = {
        filemanager = true,
        textviewer = true,
        imageviewer = true,
        levelselect = true,
        settings = true,
        howtoplay = true
    }
    for _,program in pairs(config.avalablePrograms) do
        self.avalablePrograms[program] = true
    end

    self:populateFilesystem(config.desktop, config.bin)

    self:createDesktopIcons()

    self.theme = SETTINGS.theme or "dark"
    self.themes = Var.themes

    if config.openByDefault then
        local file = self:getFile(config.openByDefault)
        self:openFile(file)
    end
end

function Desktop:getColor(name,subname)
    if subname then
        return self.themes[self.theme][name][subname]
    end
    return self.themes[self.theme][name]
end

function Desktop:update(dt)
    for _, window in pairs(self.windows) do
        window:update(dt)
    end
end

function Desktop:draw()
    -- Draw background
    if self.background.t == "color" then
        love.graphics.setColor(self.background.color)
        love.graphics.rectangle("fill", 0, 0, self.w, self.h)
    elseif self.background.t == "image" then
        love.graphics.setColor(1,1,1)
        local scaleX = self.w/self.background.img:getWidth()
        local scaleY = self.h/self.background.img:getHeight()
        love.graphics.draw(self.background.img, 0, 0, 0, scaleX, scaleY)
    end

    -- Draw desktop icons
    for _, icon in pairs(self.desktopIcons) do
        icon:draw()
    end

    -- Draw windows below task bar and icons
    for i = #self.windows, 1, -1 do
        local window = self.windows[i]
        if not window.minimized then
            love.graphics.setColor(self:getColor("window","shadow"))
            love.graphics.rectangle("fill", window.x+2, window.y+2, window.w, window.h)
        end
        window:draw()
    end

    -- Draw start menu
    if self.startMenu.open then
        love.graphics.setColor(self:getColor("taskbar","fill"))
        love.graphics.rectangle("fill", 0, self.h-self.taskbar.h-self.startMenu.h, self.startMenu.w, self.startMenu.h)
        for _,button in pairs(self.startMenu.buttons) do
            button:draw()
        end
        love.graphics.setColor(1,1,1)
        love.graphics.draw(self.pfp, 4, self.h-self.taskbar.h-36)
        love.graphics.setColor(self:getColor("taskbar","text"))
        love.graphics.print(self.name, 44, self.h-self.taskbar.h-24)
    end

    -- Draw task bar
    love.graphics.setColor(self:getColor("taskbar","fill"))
    love.graphics.rectangle("fill", 0, self.h-self.taskbar.h, self.w, self.taskbar.h)

    -- Draw task bar buttons
    for i, button in pairs(self.taskbar.buttons) do
        button:draw(i)
    end

    -- Draw time
    love.graphics.setColor(self:getColor("taskbar","text"))
    love.graphics.printf(os.date("%H:%M"), self.w-50, self.h-self.taskbar.h+2, 50, "center")
    love.graphics.printf(os.date("%x"), self.w-50, self.h-self.taskbar.h+11, 50, "center")
end

function Desktop:mousepressed(mx, my, b)
    if self.startMenu.open then
        for _, button in pairs(self.startMenu.buttons) do
            button:mousepressed(mx, my, b)
        end
        return
    end
    if my < self.h-self.taskbar.h then
        self.dontOverwriteFocus = false
        self.focus = false
        for i, window in pairs(self.windows) do
            if window:mousepressed(mx, my, b) then
                if not self.dontOverwriteFocus then
                    self:windowBringToFront(window)
                    self.focus = window
                end
                return
            end
        end
        for _, icon in pairs(self.desktopIcons) do
            if icon:mousepressed(mx, my, b) then
                return
            end
        end
    else
        for i, button in pairs(self.taskbar.buttons) do
            if button:mousepressed(mx, my, i, b) then
                return
            end
        end
    end
end
function Desktop:mousereleased(mx, my, b)
    if self.startMenu.open then
        for _, button in pairs(self.startMenu.buttons) do
            button:mousereleased(mx, my, b)
        end
        self.startMenu.open = false
        return
    end
    if my < self.h-self.taskbar.h then
        for _, window in pairs(self.windows) do
            window:mousereleased(mx, my, b)
        end
        for _, icon in pairs(self.desktopIcons) do
            icon:mousereleased(mx, my, b)
        end
    else
        for i, button in pairs(self.taskbar.buttons) do
            button:mousereleased(mx, my, i, b)
        end
    end
end

function Desktop:textinput(text)
    if self.focus then
        self.focus:textinput(text)
    end
end

function Desktop:keypressed(key, scancode, isrepeat)
    if self.focus then
        self.focus:keypressed(key, scancode, isrepeat)
    end
    KeySounds[math.random(1, #KeySounds)]:stop()
    KeySounds[math.random(1, #KeySounds)]:play()
end

function Desktop:wheelmoved(x,y)
    if self.focus then
        self.focus:wheelmoved(x,y)
    end
end

--

function Desktop:getFile(path)
    path = string.gsub(path, "^b:/", "")
    path = RemoveEmpty(Split(path, "/"))
    local file = self.filesystem
    for i = 1, #path do
        file = TableContainsWithin(file, path[i], "name")
        if not file then
            return false
        end
    end
    return file
end

function Desktop:getFileFromShortcut(file)
    local target = self:getFile(file.target)
    if target then
        -- this is ugly, but it's a jam game
        target.target = file.target
        target.pos = file.pos
        target.email = file.email
        target.password = file.password
        return target
    end
    return false
end

function Desktop:openFile(file,window)
    if file.onOpen then
        file.onOpen(self,window,file)
        file.onOpen = nil
    end

    -- Open program
    if file.type == "program" then
        if file.name == "remotedesktop" then
            self:complete()
            return
        end
        local windowP = self:windowExists(file.program)
        if windowP then
            self:windowBringToFront(windowP)
            self.focus = windowP
            windowP.minimized = false
            return
        end
        table.insert(self.windows, self.programWindows[file.program]:new(self,nil,nil,nil,nil,{file=file}))
        table.insert(self.taskbar.buttons, TaskbarButton:new(self, self.windows[#self.windows]))
        self.focus = self.windows[#self.windows]
        self:windowBringToFront(self.windows[#self.windows])
        return
    end

    local path
    if file.type == "folder" then
        path = "b:/desktop/"..file.name.."/"
        if file.target then
            path = file.target
        elseif window and window.program == "filemanager" then
            path = window.elements.path.text..file.name.."/"
        end
    end

    local lookups = {
        folder = {program="filemanager", window=WindowFileManager, args={path=path}},
        text = {program="textviewer", window=WindowTextViewer, args={file=file,content=file.content,filename=file.name..".text"}},
        image = {program="imageviewer", window=WindowImageViewer, args={file=file,img=file.img,filename=file.name..".image"}},
        inbox = {program="inbox", window=WindowInbox, args={file=file}},
        bank = {program="bank", window=WindowBank, args={file=file}},
        zipcrash = {program="zipcrash", window=WindowZipcrash, args={file=file}},
        antivirus = {program="antivirus", window=WindowAntivirus, args={file=file}},
        crypter = {program="crypter", window=WindowCrypter, args={file=file}},
        howtoplay = {program="howtoplay", window=WindowHowtoplay, args={file=file}},
        factoryreset = {program="factoryreset", window=WindowFactoryreset, args={file=file}}
    }
    local lookup = lookups[file.type]
    if lookup then
        if file.type == "folder" and window and window.program == "filemanager" then
            window.elements.path.text = path
            window:createIcons()
            return
        end
        local windowP = self:windowExists(lookup.program)
        if windowP then
            if file.type == "folder" then
                windowP.elements.path.text = path
                windowP:createIcons()
            else
                for key, val in pairs(lookup.args) do
                    windowP[key] = val
                end
            end
            self.focus = windowP
            self:windowBringToFront(windowP)
            windowP.minimized = false
            return
        end
        table.insert(self.windows, lookup.window:new(self,nil,nil,nil,nil,lookup.args))
        table.insert(self.taskbar.buttons, TaskbarButton:new(self, self.windows[#self.windows]))
        self.focus = self.windows[#self.windows]
        self:windowBringToFront(self.windows[#self.windows])
        return
    end
end

function Desktop:forAllFiles(func,source,path)
    local source = source or self.filesystem
    local path = path or "b:/"
    for _, file in ipairs(source) do
        if file.type == "folder" then
            -- recursive code, yuck
            self:forAllFiles(func,file,path..file.name.."/")
            func(file,path..file.name.."/")
        else
            func(file,path..file.name)
        end
    end
end

--

function Desktop:windowExists(program)
    for _, window in pairs(self.windows) do
        if window.program == program then
            return window
        end
    end
    return false
end

function Desktop:windowClose(targetWindow)
    for i, window in pairs(self.windows) do
        if window == targetWindow then
            table.remove(self.windows, i)
            for j, button in pairs(self.taskbar.buttons) do
                if button.window == targetWindow then
                    table.remove(self.taskbar.buttons, j)
                    return
                end
            end
            return
        end
    end
end

function Desktop:windowBringToFront(targetWindow)
    local newWindows = {}
    table.insert(newWindows, targetWindow)
    for _, window in pairs(self.windows) do
        if window ~= targetWindow then
            table.insert(newWindows, window)
        end
    end
    self.windows = newWindows
end

function Desktop:populateFilesystem(desktop,bin)
    self.filesystem = {}

    -- Add desktop to filesystem
    self.filesystem[1] = {
        name = "desktop",
        type = "folder",
        icon = "desktop",
    }
    if desktop then
        for _, file in pairs(desktop) do
            table.insert(self.filesystem[1], file)
        end
    end

    -- Add bin to filesystem
    self.filesystem[2] = {
        name = "bin",
        type = "folder",
        icon = "bin",
    }
    if bin then
        for _, file in pairs(bin) do
            table.insert(self.filesystem[2], file)
        end
    end

    -- Add programs to filesystem
    local programs = {
        {name="remotedesktop",program="remotedesktop",window=WindowTextViewer,hidden=true},
        {name="levelselect",program="levelselect",window=WindowLevelSelect,hidden=true},
        {name="settings",program="settings",window=WindowSettings,hidden=true},
        {name="howtoplay",program="howtoplay",window=WindowHowtoplay,hidden=true},

        {name="filemanager",program="filemanager",window=WindowFileManager},
        {name="textviewer",program="textviewer",window=WindowTextViewer},
        {name="imageviewer",program="imageviewer",window=WindowImageViewer},
        
        {name="inbox",program="inbox",window=WindowInbox},
        {name="bank",program="bank",window=WindowBank},
        {name="zipcrash",program="zipcrash",window=WindowZipcrash},
        {name="antivirus",program="antivirus",window=WindowAntivirus},
        {name="crypter",program="crypter",window=WindowCrypter},
        {name="factoryreset",program="factoryreset",window=WindowFactoryreset}
    }
    self.filesystem[3] = {
        name = "programs",
        type = "folder",
        icon = "programs",
    }
    for _, program in pairs(programs) do
        if self.avalablePrograms[program.name] then
            table.insert(self.filesystem[3], {
                name = program.name,
                type = "program",
                program = program.program,
                icon = program.name,
                hidden = program.hidden
            })
        end
    end

    -- Add debug folder to filesystem
    self.filesystem[4] = {
        name = "debug",
        type = "folder",
        hidden = true,
    }
    for program,_ in pairs(self.programWindows) do
        table.insert(self.filesystem[4], {
            name = program,
            type = "program",
            program = program,
            icon = string.lower(program)
        })
    end
    table.insert(self.filesystem[4], {
        name = "remotedesktop",
        type = "program",
        program = "remotedesktop",
        icon = "remotedesktop"
    }) 
end

function Desktop:createDesktopIcons()
    self.desktopIcons = {}
    local files = self:getFile("b:/desktop")
    if files then
        local i = 1
        for _, file in ipairs(files) do
            if file.hidden ~= true then
                if file.pos then
                    table.insert(self.desktopIcons, FileButton:new(self, "desktop", file.pos, file))
                else
                    table.insert(self.desktopIcons, FileButton:new(self, "desktop", i, file))
                    i = i + 1
                end
            end
        end
    end
end

function Desktop:createFile(path, args)
    local file = self:getFile(path)
    if file then
        table.insert(file, args)
        self:createDesktopIcons()
    end
end
function Desktop:updateFile(path, args)
    local file = self:getFile(path)
    if file then
        for key, val in pairs(args) do
            file[key] = val
            if key == "hidden" then
                self:createDesktopIcons()
            end
        end
        for _,window in pairs(self.windows) do
            if window.file == file then
                for key, val in pairs(args) do
                    if window[key] then
                        window[key] = val
                    end
                end
            end
        end
    end
end
function Desktop:deleteFile(path)
    local file = self:getFile(path)
    if file then
        file.hidden = true
        self:createDesktopIcons()
    end
end

function Desktop:validateEmail(vemail,vpass)
    for _,email in pairs(self.emails) do
        if email.email == vemail and email.password == vpass then
            return email
        end
    end
    return false
end
function Desktop:getEmails(vemail)
    for _,email in pairs(self.emails) do
        if email.email == vemail then
            return email.emails
        end
    end
    return {}
end
function Desktop:sendEmail(to, from, subject, content, identifyer)
    for _,emails in pairs(self.emails) do
        if emails.email == to then
            for _,email in pairs(emails.emails) do
                if email.identifyer == identifyer then
                    return
                end
            end
            table.insert(emails.emails, 1, {to=to,from=from,subject=subject,content=content,identifyer=identifyer})
            NewEmailSound:stop()
            NewEmailSound:play()
            for _,window in pairs(self.windows) do
                if window.program == "inbox" then
                    window:sync()
                end
            end
            break
        end
    end
end

function Desktop:validateBankReset(vname)
    for _,bank in pairs(self.banks) do
        if bank.name == vname then
            return true
        end
    end
    return false
end
function Desktop:validateBank(vname,vpass)
    for _,bank in pairs(self.banks) do
        if bank.name == vname and bank.password == vpass then
            return true
        end
    end
    return false
end
function Desktop:getBank(vname)
    for _,bank in pairs(self.banks) do
        if bank.name == vname then
            return bank
        end
    end
    return false
end

function Desktop:validateAntivirus(avuser,avpass)
    for _,antiv in pairs(self.antivirus) do
        if antiv.username == avuser and antiv.password == avpass then
            return true
        end
    end
    return false
end
function Desktop:getAntivirus(avname)
    for _,antiv in pairs(self.antivirus) do
        if antiv.username == avname then
            return antiv
        end
    end
    return false
end

function Desktop:complete(slow)
    WindowInboxData = {}
    WindowBankData = {}
    WindowAntivirusData = {}
    WindowZipcrashToolate = false

    local speed = 0.25
    if slow then
        speed = 2.5
    end

    local idx = TableContains(Desktops, DesktopName)
    DesktopName = Desktops[idx+1]
    Screen:changeState("desktop", {"fade", speed, {0,0,0}}, {"fade", 0.25, {0,0,0}})
end