
--[[
    Sprite Class
    This is essentially just a Wrapper for LÖVEs Image
]]--

Sprite = {}
Sprite.__index = Sprite

function Sprite.new(path)
    local self = setmetatable({}, Sprite)

    self.image = love.graphics.newImage(path)

    return self
end

function Sprite:Draw(x, y)
    love.graphics.draw(self.image, x or 0, y or 0)
end


--[[
    Audio Class
    This is essentially just a Wrapper for LÖVEs Source
]]--

Audio = {}
Audio.__index = Audio

function Audio.new(path, soundType)
    local self = setmetatable({}, Audio)

    self.source = love.audio.newSource(path, soundType or "static")

    return self
end

function Audio:Play()
    self.source:play()
end

function Audio:Stop()
    self.source:stop()
end

function Audio:Pause()
    self.source:pause()
end

function Audio:Resume()
    self.source:play()
end

function Audio:SetLooping(bool)
    self.source:setLooping(bool)
end

function Audio:SetVolume(volume)
    self.source:setVolume(volume)
end