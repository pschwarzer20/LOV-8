
local test = 1
local delay = 0

function Update(dt, curTime)
    if (curTime > delay) then
        delay = curTime + 1
        test = test + 1
    end 
end

function Draw()
    print("Counter: " .. test, 10, 10)
end
