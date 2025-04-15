
if arg[2] == "debug" then
    require("lldebugger").start()
end


json = require("libraries/json")

require("classes")

local LoadObject = {
    ["sprite"] = function(name, alphaColor)
        name = "games/" .. name
    
        local info = love.filesystem.getInfo(name)
        if (not info) then
            error("Failed to load Object (FILE NOT FOUND) ("..name..")")
            return
        end
        if ((info.size + virtual.currentMemory) > virtual.maxMemory) then
            error("Failed to load Object (MAX MEMORY) ("..name..")")
            return
        end

        local newObject = Sprite.new(name, alphaColor)

        virtual.loadedObjects[newObject] = {
            object = newObject,
            size = info.size,
        }
        virtual.currentMemory = virtual.currentMemory + info.size
        virtual.loadedCount = virtual.loadedCount + 1

        return newObject
    end,
    ["spritesheet"] = function(name, width, height, alphaColor)
        name = "games/" .. name
        height = height or width

        local info = love.filesystem.getInfo(name)
        if (not info) then
            error("Failed to load Object (FILE NOT FOUND) ("..name..")")
            return
        end
        if ((info.size + virtual.currentMemory) > virtual.maxMemory) then
            error("Failed to load Object (MAX MEMORY) ("..name..")")
            return
        end

        local newObject = Spritesheet.new(name, width, height, alphaColor)

        virtual.loadedObjects[newObject] = {
            object = newObject,
            size = info.size,
        }
        virtual.currentMemory = virtual.currentMemory + info.size
        virtual.loadedCount = virtual.loadedCount + 1

        return newObject
    end,
    ["sound"] = function(name, soundType)
        name = "games/" .. name
        soundType = soundType or "static"

        local info = love.filesystem.getInfo(name)
        if (not info) then
            error("Failed to load Object (FILE NOT FOUND) ("..name..")")
            return
        end
        if ((info.size + virtual.currentMemory) > virtual.maxMemory) then
            error("Failed to load Object (MAX MEMORY) ("..name..")")
            return
        end

        local newObject = Sound.new(name, soundType)

        virtual.loadedObjects[newObject] = {
            object = newObject,
            size = info.size,
        }
        virtual.currentMemory = virtual.currentMemory + info.size
        virtual.loadedCount = virtual.loadedCount + 1

        return newObject
    end,
}

local function SetBackgroundColor(color)
    love.graphics.setBackgroundColor(color)
end

-- Establish Sandbox
-- Everything in the table is what the Sandbox has access to
local consoleEnv = {
    NAME = "NULL",
    AUTHOR = "NULL",
    VERSION = 0,
    path = "",

    Load,
    Update,
    Draw,
    KeyPressed,

    Sprite = LoadObject["sprite"],
    Spritesheet = LoadObject["spritesheet"],
    Sound = LoadObject["sound"],

    Color = Color,

    SetBackgroundColor = SetBackgroundColor,
    DrawText = love.graphics.print,

    print = print,
    collectgarbage = collectgarbage,
    require = function(name)
        require(virtual.path .. name)
    end,
}
consoleEnv._G = consoleEnv

function loadGame(gameName)
    local fn, err = loadfile("games/" .. gameName .. "/main.lua", "t", consoleEnv)
    virtual.path = "games/" .. gameName .. "/"

    if not fn then
        error("Failed to load sandbox file (1): " .. err)
    end

    local ok, execErr = xpcall(fn, debug.traceback)
    if not ok then
        error("Error running sandbox file (2):\n" .. execErr)
    end

    love.window.setTitle(consoleEnv.NAME or "NULL")
end



local maxScaling = 4
function love.load()
    love.window.setTitle("Waiting for Game")

    -- Console Variables
    curTime = 0
    scaling = 4

    -- Setup Window
    love.graphics.setDefaultFilter("nearest", "nearest")
    font = love.graphics.newImageFont("font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.:;<=>?-+*/)('&%$#ß!@[ß]^_{|}~", -1)
    love.window.updateWindow()

    -- Create Virtual Console
    virtual = {
        path = "",

        maxMemory = 16000,
        currentMemory = 0,

        loadedObjects = {},
        loadedCount = 0,
    }

    loadGame("test")

    if (consoleEnv.Load) then
        consoleEnv.Load()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if (key == "f1") then
        scaling = scaling + 1

        if (scaling == maxScaling+1) then
            scaling = 1
        end

        love.window.updateWindow()
    end

    if (consoleEnv.KeyPressed) then
        consoleEnv.KeyPressed(key)
    end
end

function love.window.updateWindow()
    love.window.setMode(scaling*240, scaling*160, {resizable=false, vsync=0})
end

function love.update(dt)
    curTime = curTime + dt

    if (consoleEnv.Update) then
        consoleEnv.Update(dt, curTime)
    end
end

function love.draw()
    local count = 0
    for k, v in pairs(consoleEnv) do
        if (type(v) ~= "function" and v ~= nil) then
            count = count + 1
        end
    end

    love.graphics.scale(scaling*0.5, scaling*0.5)
    love.graphics.print(virtual.currentMemory/1000 .. "/" .. virtual.maxMemory/1000 .. " KB", 2, 2)
    love.graphics.print("Loaded Objects: " .. virtual.loadedCount, 2, 10)
    love.graphics.print("Loaded Variables: " .. count, 2, 18)
    love.graphics.scale(scaling, scaling)

    love.graphics.setFont(font)
    
    if (consoleEnv.Draw) then
        consoleEnv.Draw()
    end
end



local love_errorhandler = love.errhand

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end