WindowHowtoplay = Class("WindowHowtoplay", Window)

WindowHowtoplayData = {
    page = 1
}

function WindowHowtoplay:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, 300, 200, "how to play", 300, 200, false, true, {fullscreen=false})
    self.program = "howtoplay"
    self.icon = "howtoplay"

    self.elements.next = UI.button({x=self.x+self.w-20, y=self.y+self.h-20, w=16, h=16, text=">", desktop=desktop, resize=function (element)
        element.x = self.x+self.w-20
        element.y = self.y+self.h-20
    end, func=function() self:setPage(WindowHowtoplayData.page+1) end})
    self.elements.last = UI.button({x=4, y=self.y+self.h-20, w=16, h=16, text="<", desktop=desktop, resize=function (element)
        element.y = self.y+self.h-20
    end, func=function() self:setPage(WindowHowtoplayData.page-1) end})
    self.elements.page = UI.label({x=24, y=self.y+self.h-20, w=(self.w-48)/2, h=16, text="page 1/1", desktop=desktop, resize=function (element)
        element.w = (self.w-48)/2
        element.y = self.y+self.h-20
    end})
    self.elements.inputpage = UI.input({x=24+((self.w-48)/2), y=self.y+self.h-20, w=(self.w-48)/2, h=16, mc=20, text="1", desktop=desktop, resize=function (element)
        element.w = (self.w-48)/2
        element.x = self.x+24+((self.w-48)/2)
        element.y = self.y+self.h-20
    end, func=function(element)
        local page = tonumber(element.text)
        if page then
            self:setPage(page)
        end
    end})
    self:sync()

    self.elements.page.text = "page "..WindowHowtoplayData.page.."/"..#WindowHowtoplayContent

    self:setPage(WindowHowtoplayData.page)
end

function WindowHowtoplay:draw()
    if self.minimized then return end

    -- Draw window
    Window.draw(self)

    -- Draw bar
    love.graphics.setColor(self.desktop:getColor("window","subfill"))
    love.graphics.rectangle("fill", self.x, self.y+self.h-24, self.w, 24)
    self.elements.page.text = "page "..WindowHowtoplayData.page.."/"..#WindowHowtoplayContent

    -- Draw content
    local content = WindowHowtoplayContent[WindowHowtoplayData.page]
    love.graphics.setColor(self.desktop:getColor("window","text"))
    local x, y = self.x+8, self.y+self.navbar.h+8
    for i, line in pairs(content.content) do
        local allign = line[2] or "center"
        love.graphics.printf(line[1], x, y, self.w-16, allign)
        y = y + TextHeight(line[1], self.w-16) + 4
    end

    -- Draw UI
    Window.drawUI(self)
end

function WindowHowtoplay:setPage(page)
    if page < 1 then page = #WindowHowtoplayContent end
    if page > #WindowHowtoplayContent then page = 1 end
    WindowHowtoplayData.page = page
    self.elements.inputpage.text = tostring(page)
end

--

WindowHowtoplayContent = {
    {
        content = {
            {"contents:"},
            {"page 1: contents","left"},
            {"page 2: introduction","left"},
            {"page 3-6: navigating the computer","left"},
            {"programs:"},
            {"page 7: filemanager","left"},
            {"page 8: inbox","left"},
            {"page 9: bank","left"},
            {"page 10: antivirus","left"},
            {"you can access this window again by clicking the start menu icon in the bottom left and going to 'howtoplay':"},
        }
    },
    {
        content = {
            {"introduction:"},
            {"welcome to back-window!","left"},
            {"your job is quite simple, to cause chaos. each round you'll be given a goal, this could be to drain someones bank account or to break their computer, after which a remote desktop app will be added to programs and allow you to progress","left"},
            {"there are several tools you will need to use to progress, each section will go over what you need to know to use them.","left"},
            {"good luck!","left"}
        }
    },
    {
        content = {
            {"navigating the computer:"},
            {"the computer is made up of 3 core parts:","left"},
            {"the desktop","left"},
            {"the filesystem","left"},
            {"and the windows","left"}
        }
    },
    {
        content = {
            {"the desktop:"},
            {"the desktop is where you'll find your goal, programs you'll need to use and some data to help you beat the game. it'll also have at least 1 folder to give you access to the filesystem.","left"},
            {"at the bottom of the desktop is the taskbar, this shows you all your open windows and has a start button, clicking the start button gives you access to game windows like this one!","left"}
        }
    },
    {
        content = {
            {"the filesystem:"},
            {"the filesystem is the home of all the files, in the root directory (b:/) you'll have 3 folders. desktop, bin and programs","left"},
            {"the desktop folder is where all the files seen on the desktop are stored.","left"},
            {"the bin folder is where files that are hidden from the desktop are stored, make sure to check it every round.","left"},
            {"the programs are where all the programs used for the level are stored, and where the remote desktop app used to progress is also stored.","left"}
        }
    },
    {
        content = {
            {"the windows:"},
            {"the windows are where you'll be doing most of your work, they can be moved, resized and minimized. they can also be closed by clicking the x in the top right.","left"},
            {"the windows will also have a navigation bar, this is where you can move the window and close/minimise.","left"}
        }
    },
    {
        content = {
            {"using filemanager:"},
            {"filemanager is a program that allows you to view the filesystem, it can be accessed by running filemanager directly or opening a folder.","left"},
            {"you can navigate the filesystem by clicking on folders, and open files by clicking on them. to go back press the '<' button on the top right.","left"},
            {"you can also go direct to a path by typing it in the top bar and pressing enter. some files will be hidden and must be typed in here to access them","left"}
        }
    },
    {
        content = {
            {"using inbox:"},
        }
    },
    {
        content = {
            {"using bank:"},
        }
    },
    {
        content = {
            {"using antivirus:"},
        }
    }
}