HillsTexture = class()
function HillsTexture:init()
    self.texture = image(textureSize, textureSize)
    setContext(self.texture)
    strokeWidth(1)
    noSmooth()

    local color1 = color(164, 26, 110, 255)
    local color2 = color(148, 231, 52, 255)

    for i = 0, self.texture.height do
        color1 = colorLight(color1, -1)
        color2 = colorLight(color2, 1)

        for j = -3, 1 do
            stroke(color1)
            line(j * self.texture.width / 3 + i, i, 
                 (j + .5) * self.texture.width / 3 + i, i)
            stroke(color2)
            line((j + .5) * self.texture.width / 3 + i, i, 
                 (j + 1) * self.texture.width / 3 + i, i)
        end
    end
    smooth()
    lineCapMode(2)
    
    stroke(0, 0, 0, 85)
    strokeWidth(15)
    line(-1, 15, self.texture.width+1, 15)    --shadow
    
    stroke(216, 36, 11, 255)
    strokeWidth(15)
    line(-1, 5, self.texture.width+1, 5)    --floor
    
    noSmooth()
    stroke(126, 47, 36, 255)
    strokeWidth(2)
    line(-1, 11, self.texture.width+1, 11)    --floor's base line

    setContext()

    --Add some noise for the same price
    local scaleNoise = .05
    local offsetX, offsetY = 0, 0
    

    for x = 1, self.texture.width * maxTex / 2 do
        offsetX = offsetX + scaleNoise
        offsetY = 0
        for y = 1, self.texture.height do
            offsetY = offsetY + scaleNoise
            local c = (noise(offsetX, offsetY) +1) * 30
            
            --first third normal noise
            local r,g,b = self.texture:get(x,y)
            nr,ng,nb=math.min(r/1.2+c,255),math.min(g/1.2+c,255),math.min(b/1.2+c,255)
            self.texture:set(x, y, nr, ng, nb)
            
            --second third backwards noise
            local r,g,b = self.texture:get(self.texture.width * maxTex - x,y)
            nr,ng,nb=math.min(r/1.2+c,255),math.min(g/1.2+c,255),math.min(b/1.2+c,255)
            self.texture:set(self.texture.width * maxTex - x, y, nr, ng, nb)
            
            --third third normal noise
            local r,g,b = self.texture:get(self.texture.width * maxTex + x-1,y)
            nr,ng,nb=math.min(r/1.2+c,255),math.min(g/1.2+c,255),math.min(b/1.2+c,255)
            self.texture:set(self.texture.width * maxTex + x-1, y, nr, ng, nb)

        end
    end
end

function colorLight(c, l)
    c.r = clamp(c.r + l, 0, 255)
    c.g = clamp(c.g + l, 0, 255)
    c.b = clamp(c.b + l, 0, 255)
    return c
end

