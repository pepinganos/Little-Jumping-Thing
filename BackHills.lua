BackHills = class()

function BackHills:init(tex, textureScale)
    self.mesh = mesh()
    self.maxKeyPoints = 15  --n points that repeat forever...
    self.textureScale = textureScale    --the greater, the smaller
    self:generateKeyPoints()
    self:generate()
    self.mesh.texture = tex
    self.offset = 0    
end

function BackHills:draw(size, speed, elevation, colorFilter, pos)
    pushMatrix()

    self.mesh:setColors(colorFilter)

    translate(-pos*speed + self.width * (self.offset + 0) * size,elevation)
    scale(size)
    self.mesh:draw()    --draw first section
    translate(self.width,0)
    self.mesh:draw()    --draw second section

    if (hero.ball.x*speed >= self.width * (self.offset + 1) * size)then 
        self.offset = self.offset + 1 
    end
    
    popMatrix()
end

function BackHills:generateKeyPoints()
    self.keyPoints = {}
    local minDX = 160
    local minDY = 60
    local rangeDX = 80
    local rangeDY = 40
 
    local x = 0
    local y = HEIGHT / 2 - minDY
 
    local dy, ny 
    local sign = 1 -- +1 - going up, -1 - going  down
    local paddingTop = 20
    local paddingBottom = 20
 
    for i = 0, self.maxKeyPoints do
        self.keyPoints[i] = vec2(x, y + 500)

        if (i == 0) then
            x = 0
            y = HEIGHT / 2
        else
            x = x + math.random(rangeDX) + minDX
            while(true) do
                dy = math.random(rangeDY) + minDY
                ny = y + dy * sign
                if(ny < HEIGHT - paddingTop and ny > paddingBottom) then
                    break
                end
            end
            y = ny
        end
        sign = -sign
    end
    self.keyPoints[#self.keyPoints].y = self.keyPoints[1].y    --loop
    self.width = self.keyPoints[#self.keyPoints].x
end

function BackHills:generate()
--
    -- key points interval for drawing
    local fromKeyPointI = 1
    local toKeyPointI = self.maxKeyPoints

    local hillVertices = {}
    local hillTexCoords = {}
    
    local nHillVertices = 1
    local p0, p1
    local pt1 = vec2()
    p0 = self.keyPoints[fromKeyPointI]

    local pxTex = (self.keyPoints[fromKeyPointI].x / 
                   WIDTH * self.textureScale) % maxTex
    for i = fromKeyPointI+1, toKeyPointI+0 do       
        p1 = self.keyPoints[i]
 
        -- triangle strip between p0 and p1
        local hSegments = math.floor((p1.x-p0.x)/hillSegmentWidth)
        local dx = (p1.x - p0.x) / hSegments
        local da = math.pi / hSegments
        local ymid = (p0.y + p1.y) / 2
        local ampl = (p0.y - p1.y) / 2
        pt0 = p0:copy()
        local incTex = dx/WIDTH*self.textureScale*4  -- * 4 = thinner lines
        
        for j = 1, hSegments do
            pt1.x = p0.x + j*dx
            pt1.y = ymid + ampl * math.cos(da*j)

            pxTex = pxTex + incTex
            pxTex = pxTex % maxTex
            local pxTex1 = (pxTex + incTex)
            
            --first triangle
            hillVertices[nHillVertices] = vec2(pt0.x, 0)
            hillTexCoords[nHillVertices] = vec2(pxTex, 1)
            nHillVertices = nHillVertices + 1

            hillVertices[nHillVertices] = vec2(pt1.x, 0)
            hillTexCoords[nHillVertices] = vec2(pxTex1, 1)
            nHillVertices = nHillVertices + 1
            
            hillVertices[nHillVertices] = vec2(pt0.x, pt0.y)
            hillTexCoords[nHillVertices] = vec2(pxTex, 0)
            nHillVertices = nHillVertices + 1

            --second triangle
            hillVertices[nHillVertices] = vec2(pt0.x, pt0.y)
            hillTexCoords[nHillVertices] = vec2(pxTex, 0)
            nHillVertices = nHillVertices + 1
            
            hillVertices[nHillVertices] = vec2(pt1.x, 0)
            hillTexCoords[nHillVertices] = vec2(pxTex1, 1)
            nHillVertices = nHillVertices + 1
            
            hillVertices[nHillVertices] = vec2(pt1.x, pt1.y)
            hillTexCoords[nHillVertices] = vec2(pxTex1, 0)
            nHillVertices = nHillVertices + 1
 
            pt0 = pt1:copy()
        end
 
        p0 = p1:copy()
    end
    self.mesh.vertices = hillVertices
    self.mesh.texCoords = hillTexCoords
end
