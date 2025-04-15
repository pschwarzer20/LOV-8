
NAME = "Test"
AUTHOR = "Tarion"
VERSION = 0

local backgroundColor = Color(48, 104, 80, 255)
local colo3r = Color(48, 104, 80, 255)
function Load()
    SetBackgroundColor(backgroundColor)
    color = Color(48, 104, 80, 255)
end

function Update(dt, curTime)
end

local sprite = Spritesheet("testSprites.png", 16, 16, Color(48, 104, 80, 255))
local tileset = Spritesheet("tileset.json", 16, 16, Color(48, 104, 80, 255))
local testSound = Sound("testSound.mp3", "static")

local test = 1
local test2 = 1
function KeyPressed(key)
    if (key == "f3") then
        test = test - 1
        test2 = test2 - 1

        if (test == 0) then
            test = sprite.Count
        end
        if (test2 == 0) then
            test2 = tileset.Count
        end
    elseif (key == "f4") then
        test = test + 1
        test2 = test2 + 1

        if (test == sprite.Count + 1) then
            test = 1
        end
        if (test2 == tileset.Count + 1) then
            test2 = 1
        end
    elseif (key == "f2") then
        testSound:Play()
        testSound = nil
        collectgarbage()
    end
end

function Draw()
    DrawText(test .. "/" .. sprite.Count, 50, 25)

    sprite:Draw(test, 5, 25)
    tileset:Draw(test2, 30, 0)
end


-- TODO:
-- 1. Implement memory limits for code, track how many variables are loaded, based on the size, like int64 and stuff
