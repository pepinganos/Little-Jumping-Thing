Sky = class()
----------------------------------
--Generates random beautiful skies
----------------------------------
rnd = math.random

function Sky:init()
    self.bgMesh = mesh()
    self.bgMesh.texture = self:generatePlasma()    --sky's texture
    self.bgMesh:addRect(WIDTH/2, HEIGHT*3/4,WIDTH,HEIGHT/2)
    self.bgMesh:setColors(255,255,255,255)
end

function Sky:draw(pos)
    smooth()    --avoid sky pixelation
     --Sky texture resized 4 times the width of the screen
    self.bgMesh:setRect(1,WIDTH*2-pos/100, HEIGHT*3/4,WIDTH*4,HEIGHT/2)
    self.bgMesh:draw()    --Draw the sky
end
------------------------------------
-- Plasma Generator Code -----------
------------------------------------
function Sky:generatePalette()
    self.palette = {}
    local r, g, b
    local c = 0
    local inc = 1 / 400
    
    for e = 0, 400 do
        if (c < 0.5) then r = c * 2
        else r = (1 - c) * 2 end
            
        if (c >= 0.3 and c < 0.8) then g = (c - 0.3) * 2
        elseif (c < 0.3) then g = (0.3 - c) * 2
        else g = (1.3 - c) * 2 end
            
        if (c >= 0.5) then b = (c - 0.5) * 2
        else b = (0.5 - c) * 2 end
    
        self.palette[e] = color(r * 255, g * 255, b * 255)
        c = c + inc
    end
end
 
function Sky:generatePlasma()
    self:generatePalette()
    self.size = 128  --Only powers of 2, otherwise we get gaps
    local buffer = image(self.size, self.size)
    
    --Start calculating with 4 random corners
    self:divideGrid (buffer, 0, 0, self.size, rnd(), rnd(), rnd(), rnd())
    return buffer
end

function Sky:divideGrid(dest, x, y, lenght, c1, c2, c3, c4)
    local newLenght = lenght / 2
    if (lenght < 2) then --Keep calculating until size is less than 2
        dest:set(x + 1, y + 1, 
                 self.palette[math.floor((c1 + c2 + c3 + c4) * 100)]) --Plot the point
    return end
    
    --Calculate the average of the 4 corners and add a random displacement 
    local middle = (c1 + c2 + c3 + c4) / 4 + (rnd() - 0.5) * newLenght * 3 / self.size

    --Calculate new edges
    local edge1 = (c1 + c2) / 2
    local edge2 = (c2 + c3) / 2
    local edge3 = (c3 + c4) / 2
    local edge4 = (c4 + c1) / 2
            
    --Clamp middle between 0 and 1
    if (middle < 0) then middle = 0
    elseif (middle > 1) then middle = 1 end
        
    --Recursevely call this function for each one of the 4 new rectangles
    self:divideGrid(dest, x, y, newLenght, c1, edge1, middle, edge4)
    self:divideGrid(dest, x + newLenght, y, newLenght, edge1, c2, edge2, middle)
    self:divideGrid(dest, x + newLenght, y + newLenght, newLenght, middle, edge2, c3, edge3)
    self:divideGrid(dest, x, y + newLenght, newLenght, edge4, middle, edge3, c4)
end
