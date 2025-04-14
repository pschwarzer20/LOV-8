
NAME = "Test"
AUTHOR = "Tarion"
VERSION = 0

local backgroundColor = Color(48, 104, 20, 255)
function Load()
    SetBackgroundColor(backgroundColor)
end

function Update(dt, curTime)
end

local sprite = Spritesheet("testSprites.json", 16, 16, Color(48, 104, 80, 255))
local testSound = Sound("testSound.mp3", "static")
local test = 1
function KeyPressed(key)
    if (key == "f3") then
        test = test - 1

        if (test == 0) then
            test = sprite.Count
        end
    elseif (key == "f4") then
        test = test + 1

        if (test == sprite.Count + 1) then
            test = 1
        end
    elseif (key == "f2") then
        testSound:Play()
    end
end

function Draw()
    DrawText(test .. "/" .. sprite.Count, 25, 25)
    sprite:Draw(test, 50, 0)
end
