
NAME = "Test"
AUTHOR = "Tarion"
VERSION = 0

local test = 0
local delay = 0

function Load()
end

function Update(dt, curTime)
end

function KeyPressed(key)
    if (key == "f5") then
        test = test + 1
        Sprite("testSprites.png")
    end
end

function Draw()
    print("Loaded Sprites: " .. test, 10, 10)
end
