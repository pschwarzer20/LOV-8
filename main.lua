
local curTime = 0
function CurTime()
    return curTime
end



local consoleEnv = {
    Load = function() end,
    Update = function(dt) end,
    Draw = function() end,
    KeyPressed = love.keypressed,
    KeyDown = love.keyboard.wasPressed,
    print = love.graphics.print,
}
consoleEnv._G = consoleEnv
setmetatable(consoleEnv, {
    __index = function(_, key)
        return function(...) end
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
end



local maxScaling = 4
function love.load()
    love.window.setTitle("Fantasy Console")
    love.graphics.setDefaultFilter("nearest", "nearest")

    font = love.graphics.newImageFont("font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.:;<=>?-+*/)('&%$#ß!@[ß]^_{|}~", -1)
	--font = love.graphics.newFont("monogram.ttf", 16)
    --font:setFilter("nearest", "nearest")

    scaling = 4
    love.window.updateWindow()

    love.keyboard.keysPressed = {}


    loadGame("test")


    -- Track memory usage using this
    info = love.filesystem.getInfo( "font.png" )

    print(info.size)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true

    if (consoleEnv.WasKeyPressed) then
        consoleEnv.WasKeyPressed(key)
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
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

    love.keyboard.keysPressed = {}

    if (consoleEnv.Update) then
        consoleEnv.Update(dt, curTime)
    end
end

function love.draw()
    love.graphics.scale(scaling, scaling)

    love.graphics.setFont(font)

    love.graphics.print("0/32 KB used", 3, 0)
    
    if (consoleEnv.Draw) then
        consoleEnv.Draw()
    end
end
