-- clases/Luna.lua
local Astro = require("clases.Astro")
local Luna = {}
Luna.__index = Luna
setmetatable(Luna, { __index = Astro })

function Luna:new(params)
    local self = setmetatable(Astro:new(params), Luna)

    self.speed = params.speed or 2        -- Más rápida que los planetas
    self.orbitRadius = params.orbitRadius or 30
    self.angle = 0

    return self
end

-- Update, Hide y Show ya están definido en Astro y no se necesita modificar nada en Luna

return Luna
