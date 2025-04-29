-- clases/Sol.lua
local Astro = require("clases.Astro")
local Sol = {}
Sol.__index = Sol
setmetatable(Sol, { __index = Astro })

function Sol:new(params)
    local self = setmetatable(Astro:new(params), Sol)

   

    return self
end

-- Este método se llamará en cada frame
function Sol:update(dt)
    self:rotateSelf(self.rotationSpeed)
end

return Sol
