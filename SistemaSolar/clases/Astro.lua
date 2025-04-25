local Astro = {}
Astro.__index = Astro

function Astro:new(params)
    local self = setmetatable({}, Astro)
    self.image = display.newImageRect(params.img, params.width, params.height)
    self.image.x, self.image.y = params.x, params.y
    self.orbitCenter = params.orbitCenter
    self.orbitRadius = params.orbitRadius or 0
    self.speed = params.speed or 0
    self.angle = 0
    self.rotationSpeed = params.rotationSpeed or 2
    return self
end

function Astro:update(dt)
    if self.orbitCenter then
        self.angle = self.angle + self.speed * dt
        self.image.x = self.orbitCenter.x + math.cos(self.angle) * self.orbitRadius
        self.image.y = self.orbitCenter.y + math.sin(self.angle) * self.orbitRadius
        self:rotateSelf(self.rotationSpeed)
    end
end

function Astro:rotateSelf(speed)
    self.image.rotation = self.image.rotation + speed
end

function Astro:guardarPosicionFinal()
    self.finalX = self.image.x
    self.finalY = self.image.y
end

function Astro:show()
    self.image.isVisible = true
end

function Astro:hide()
    self.image.isVisible = false
end

return Astro
