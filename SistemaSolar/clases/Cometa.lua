-- clases/Cometa.lua
local Astro = require("clases.Astro")
local Cometa = {}
Cometa.__index = Cometa
setmetatable(Cometa, { __index = Astro })

function Cometa:new(params)
    local self = setmetatable(Astro:new(params), Cometa)

    -- Centro de la elipse (por donde orbita)
    self.cx = params.cx or display.contentCenterX
    self.cy = params.cy or display.contentCenterY

    -- Parámetros de la órbita elíptica
    self.a = params.a or 300  -- Semieje mayor (horizontal)
    self.b = params.b or 100  -- Semieje menor (vertical)
    self.speed = params.speed or 0.5  -- Velocidad de la órbita
    self.angle = 0  -- Ángulo inicial de la órbita

    return self
end

function Cometa:update(dt)
    -- Actualizar ángulo de la órbita
    self.angle = self.angle + self.speed * dt

    -- Calcular posición según elipse
    local x = self.cx + self.a * math.cos(self.angle)
    local y = self.cy + self.b * math.sin(self.angle)

    self.image.x = x
    self.image.y = y

    -- Rotación sobre su propio eje
    self:rotateSelf(self.rotationSpeed)
end

return Cometa
