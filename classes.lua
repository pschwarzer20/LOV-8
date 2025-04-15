
local function newImage(path, alphaColor)
    if (not alphaColor) then
        return love.graphics.newImage(path)
    end

	local imageData = love.image.newImageData(path)

	imageData:mapPixel(function(x, y, r, g, b, a)
        if (r == alphaColor.r and
            g == alphaColor.g and
            b == alphaColor.b and
            a == alphaColor.a) then
            return 0, 0, 0, 0
        end

		return r, g, b, a
	end)

    local image = love.graphics.newImage(imageData)

    return image
end


--[[
    Sprite Class
    This is essentially just a Wrapper for LÖVEs Image
]]--

Sprite = {}
Sprite.__index = Sprite

function Sprite.new(path, alphaColor)
    local self = setmetatable({}, Sprite)

    self.image = newImage(path, alphaColor)

    return self
end

function Sprite:Draw(x, y)
    love.graphics.draw(self.image, x or 0, y or 0)
end


--[[
    Spritesheet Class
    This is essentially just a Wrapper for LÖVEs Image, specifically made for Spritesheets
]]--

Spritesheet = {}
Spritesheet.__index = Spritesheet

function Spritesheet.new(path, width, height, alphaColor)
    local self = setmetatable({}, Spritesheet)

    self.sprites = {}

    if (string.find(path, ".json")) then
        local contents, size = love.filesystem.read(path)
        local metadata = json.decode(contents)

        self.image = newImage("games/" .. metadata.image, alphaColor)

        -- Create the slices according to the sliceData
        local imageWidth, imageHeight = self.image:getWidth(), self.image:getHeight()

        local counter = 0
        for _, data in pairs(metadata.tiles) do
            table.insert(self.sprites, love.graphics.newQuad(
                data.x,
                data.y,
                data.width,
                data.height,
                imageWidth,
                imageHeight
            ))
            counter = counter + 1
        end

        self.Count = counter

        return self
    end

    self.image = newImage(path, alphaColor)

    -- Generate slices
    local imageWidth, imageHeight = self.image:getWidth(), self.image:getHeight()
    local columns = math.floor(imageWidth / width)
    local rows = math.floor(imageHeight / height)

    local counter = 0
    for x = 0, columns - 1 do
        for y = 0, rows - 1 do
            table.insert(self.sprites, love.graphics.newQuad(
                x * width,
                y * height,
                width,
                height,
                imageWidth,
                imageHeight
            ))
            counter = counter + 1
        end
    end

    self.Count = counter

    return self
end

function Spritesheet:Draw(slice, x, y)
    local sprite = self.sprites[slice]
    if sprite then
        love.graphics.draw(self.image, sprite, x or 0, y or 0)
    end
end


--[[
    Sound Class
    This is essentially just a Wrapper for LÖVEs Source
]]--

Sound = {}
Sound.__index = Sound

function Sound.new(path, soundType)
    local self = setmetatable({}, Sound)

    self.source = love.audio.newSource(path, soundType or "static")

    return self
end

function Sound:Play()
    self.source:play()
end

function Sound:Stop()
    self.source:stop()
end

function Sound:Pause()
    self.source:pause()
end

function Sound:Resume()
    self.source:play()
end

function Sound:SetLooping(bool)
    self.source:setLooping(bool)
end

function Sound:SetVolume(volume)
    self.source:setVolume(volume)
end


--[[
    Color Class
    A convenient Color class that works with any love2D function
]]--

function Color(r, g, b, a)
    r = (r or 255) / 255
    g = (g or 255) / 255
    b = (b or 255) / 255
    a = (a or 255) / 255

    local color = {
        r = r, g = g, b = b, a = a,
        [1] = r, [2] = g, [3] = b, [4] = a -- love2D expects a sequential array, so heres the fix for that
    }

    -- Return it as a class, that way we can use it freely anywhere we wish
    return setmetatable(color, {
        __index = function(tbl, key)
            if key == 1 then return tbl.r
            elseif key == 2 then return tbl.g
            elseif key == 3 then return tbl.b
            elseif key == 4 then return tbl.a
            else return rawget(tbl, key)
            end
        end,
        __tostring = function(tbl)
            return tbl
        end
    })
end
