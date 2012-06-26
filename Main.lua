-- Little Jumping... something
-- Pepe Enguídanos (pepinganos) 2012

function setup()
    displayMode(FULLSCREEN)
    
--Constants:
    hillSegmentWidth = 20    --if less, more beatiful but slower
    textureSize = 200    --hills texture size
    --maxTex MUST be 2/3 because of the repeating texture noise.
    --The pattern MUST repeat itself after 2/3 of the texture. The third
    --part is the same as the first part, and is used to chain the texture
    maxTex = 2/3

--Debug
    watch("position.x")
    watch("hero.ball.y")
    watch("hero.speed")

--Objects creation
    local tex = HillsTexture()
    sky = Sky()
    backgroundHills1 = BackHills(tex.texture, 1)
    backgroundHills2 = BackHills(tex.texture, 1)
    hills = Hills(tex.texture, 1, 400)    --400 keyPoints
    hero = Hero()
end

function draw()
    sky:draw(hero.ball.x)

    backgroundHills1:draw(.4,.08, 200, color(100,100,100,255), hero.ball.x)
    backgroundHills2:draw(.5,.15, 0, color(150,150,150,255), hero.ball.x)

    pScale = (HEIGHT*5/6) / hero.ball.y    --lower scale if hero flies high
    pScale = math.min(pScale, 1.3)    --limit scale
    
    setOffsetX(hero.ball.x)    --set offset

    translate(position.x,0)    --apply transforms and draw main hills and hero
    scale(pScale)   

    hills:draw()

    hero:draw()
end

function setOffsetX (newOffsetX)
    offsetX = newOffsetX
    position = vec2(WIDTH/8 - offsetX*pScale, 0)
end

function touched(touch)   
    if (touch.state == BEGAN or touch.state == MOVING) then
        hero.diving = true
    else
        hero.diving = false
    end
end