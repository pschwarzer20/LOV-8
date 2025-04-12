
local function CalculateMemoryUsage()
end

local function LoadSprite(name)
    name = "games/" .. name

    local info = love.filesystem.getInfo(name)
    if (not info) then
        error("Failed to load Sprite! ("..name..")")
        return
    end

    virtual.currentMemory = virtual.currentMemory + info.size

    local newSprite = love.graphics.newImage(name)
end

-- Establish Sandbox
-- Everything in the table is what the Sandbox has access to
local consoleEnv = {
    NAME = "NULL",
    AUTHOR = "NULL",
    VERSION = 0,

    Load,
    Update,
    Draw,
    KeyPressed,

    Sprite = LoadSprite,

    print = love.graphics.print,
}
consoleEnv._G = consoleEnv
setmetatable(consoleEnv, {
    __index = function(_, key)
        return function(...) end -- Return an empty function to avoid erroring, not perfect, but works most of the time
    end
})

function loadGame(gameName)
    local fn, err = loadfile("games/" .. gameName .. ".lua", "t", consoleEnv)
    if not fn then
        error("Failed to load sandbox file (1): " .. err)
    end

    local ok, execErr = pcall(fn)
    if not ok then
        error("Error running sandbox file (2): " .. execErr)
    end

    love.window.setTitle(consoleEnv.NAME or "NULL")
end



local maxScaling = 4
function love.load()
    love.window.setTitle("Waiting for Game")

    -- Console Variables
    curTime = 0
    scaling = 4
    keysPressed = {}

    -- Setup Window
    love.graphics.setDefaultFilter("nearest", "nearest")
    font = love.graphics.newImageFont("font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.:;<=>?-+*/)('&%$#ß!@[ß]^_{|}~", -1)
    love.window.updateWindow()

    -- Create Virtual Console
    virtual = {
        maxMemory = 16000,
        currentMemory = 0,

        loadedSprites = {},
        loadedSounds = {},
        loadedFonts = {},
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

    keysPressed[key] = true

    if (consoleEnv.KeyPressed) then
        consoleEnv.KeyPressed(key)
    end
end

function love.keyboard.wasPressed(key)
    return keysPressed[key]
end

function love.window.updateWindow()
    love.window.setMode(scaling*240, scaling*160, {resizable=false, vsync=0})
end

function love.update(dt)
    curTime = curTime + dt

    if (love.keyboard.wasPressed("f1")) then
        scaling = scaling + 1

        if (scaling == maxScaling+1) then
            scaling = 1
        end

        love.window.updateWindow()
    end

    keysPressed = {}

    if (consoleEnv.Update) then
        consoleEnv.Update(dt, curTime)
    end
end

function love.draw()
    love.graphics.scale(scaling, scaling)

    love.graphics.setFont(font)

    love.graphics.print(virtual.currentMemory/1000 .. "/" .. virtual.maxMemory/1000 .. " KB", 2, 2)
    
    if (consoleEnv.Draw) then
        consoleEnv.Draw()
    end
end
