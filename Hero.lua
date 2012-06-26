Hero = class()

function Hero:init()
    self.prevAngs = {0,0,0,0,0,0,0,0,0,0}  --previous hero's orientations

    local sprites = {"Documents:p1","Documents:p1","Documents:p1"}
    self.sprHero = {}
    for i = 1, 3 do
        self.sprHero[i] = mesh()
        self.sprHero[i].texture = sprites[i]
        self.sprHero[i]:setColors(255,255,255,255)
        self.sprHero[i]:addRect(0,0,60,45)
    end
    self.frameCounter = 0
    self.ball = self:createCircle(0,1000,15)
    self.ball.linearVelocity = vec2(1000,0)
end

function Hero:draw()
    self.frameCounter = self.frameCounter + 1
    --set minimum speed
    self.ball.linearVelocity = vec2(math.max(self.ball.linearVelocity.x, 160),
                               math.max(self.ball.linearVelocity.y, -1200))
    self.speed = (hero.ball.linearVelocity):len()

    if (self.diving) then      --if touched, dive
        self.ball:applyForce(vec2(5,-50), self.ball.position)
    end
    ------
    pushMatrix()
    translate(self.ball.x, self.ball.y)
    local lv = self.ball.linearVelocity
    local ang = -math.deg(lv:angleBetween(vec2(1,0)))
    if(lv.x < 0) then ang = 180 + ang end -- if it goes backwards (just in case)
    ang = self:averageAng(ang)
    rotate(ang)
    if (self.heroFrame == nil) then self.heroFrame = 1 end
    if (self.frame == nil or self.frame < self.frameCounter) then
        self.frame = self.frameCounter + 19
        if (self.heroFrame == 1) then 
            self.heroFrame = 2 
        else
            self.heroFrame = 1    
        end
    end

    if (not self.diving) then
        self.sprHero[self.heroFrame]:setRect(0,0,0,0)
        self.sprHero[self.heroFrame]:draw()
    else
        self.sprHero[3]:setRect(0,0,48,48)
        self.sprHero[3]:draw()
    end
    popMatrix()
end

function Hero:drawBall()    --not used, it draws the true ball "inside" the hero
    pushMatrix()
    rotate(ball.angle)
    strokeWidth(2.0)
    line(0,0,ball.radius-3,0)
    strokeWidth(2.5)
    noFill()
    ellipse(0,0,ball.radius*2)
    popMatrix()
end

function Hero:createCircle(x,y,r)    --creates the physics ball that determines 
                                --the behavior of the hero
    local circle = physics.body(CIRCLE, r)
    circle.interpolate = true
    circle.x = x
    circle.y = y
    circle.restitution = 0
    circle.friction = 0.1
    circle.density = 1
    circle.sleepingAllowed = false
    return circle
end

function Hero:averageAng(ang) --smooths the rotation of the hero
                              --by averaging its n last angles
    local NUM_PREV_VELS = 7
    local avAng = 0
    if (self.nextAng == nil) then self.nextAng = 1 end
    for i = 1, NUM_PREV_VELS do
        avAng = avAng + self.prevAngs[i]
    end
    avAng = avAng/NUM_PREV_VELS
    self.prevAngs[self.nextAng] = ang
    self.nextAng = self.nextAng + 1
    if (self.nextAng > NUM_PREV_VELS) then self.nextAng = 0 end 
    return avAng
end