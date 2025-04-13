
NAME = "Test"
AUTHOR = "Tarion"
VERSION = 0

local test = 0
local delay = 0

local last = ""

function Load()
end

function Update(dt, curTime)
end

local sprite = Sprite("testSprites.png")
function KeyPressed(key)
    if (key == "f5") then
        test = test + 1
        sprite = Sprite("testSprites.png")
    end
end

function Draw()
    print("Loaded Sprites: " .. test, 10, 10)
    sprite:Draw(100, 0)
end
