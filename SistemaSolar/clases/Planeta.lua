-- clases/Planeta.lua
local Astro = require("clases.Astro")
local Planeta = {}
Planeta.__index = Planeta
setmetatable(Planeta, { __index = Astro })

function Planeta:new(params)
    local self = setmetatable(Astro:new(params), Planeta)

    self.lunas = {}               -- Lista de lunas asociadas
    
    return self
end

-- Añadir una luna al planeta
function Planeta:addLuna(luna)
    table.insert(self.lunas, luna)
end

-- Actualización de órbita, rotación y lunas
function Planeta:update(dt)
    -- Mover planeta en su órbita
    if self.orbitCenter then
        self.angle = self.angle + self.speed * dt
        self.image.x = self.orbitCenter.x + math.cos(self.angle) * self.orbitRadius
        self.image.y = self.orbitCenter.y + math.sin(self.angle) * self.orbitRadius
    end

    -- Rotar sobre su eje
    self:rotateSelf(self.rotationSpeed)

    -- Actualizar lunas
    for _, luna in ipairs(self.lunas) do
        luna:update(dt)
    end
end

-- Mostrar/ocultar planeta y lunas
function Planeta:show()
    self.image.isVisible = true
    for _, luna in ipairs(self.lunas) do
        luna:show()
    end
end

function Planeta:hide()
    self.image.isVisible = false
    for _, luna in ipairs(self.lunas) do
        luna:hide()
    end
end

return Planeta
