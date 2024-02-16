WindowFileManager = Class("fileManager", Window)

function WindowFileManager:initialize(desktop, x, y, w, h)
    Window.initialize(self, desktop, x, y, w, h, "file manager")
end