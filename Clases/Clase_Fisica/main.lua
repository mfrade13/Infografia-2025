-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local physics = require( "physics" )
-- Your code here

local CW = display.contentWidth
local CH = display.contentHeight

local fondo = display.newImageRect( "bg_1.jpg", CW, CH )
fondo.x = CW/2
fondo.y = CH/2

local options_sprite_1 = {
    width = 300,
    height = 300,
    numFrames = 8
}

local sprite_sheet_1 = graphics.newImageSheet("avanza_derecha.png", options_sprite_1)
local sequence =     {
    name = "avanza_derecha",
    start = 1,
    count = 8,
    time= 8/12 *1000,
    sheet = sprite_sheet_1
}
local cazador = display.newSprite(sprite_sheet_1, sequence)
cazador.x = CW/2
cazador.y = CH/8
cazador:play()
cazador.nombre = "Cazador"
cazador.botas = 0.1
-- cazador.gravityScale = 0
-- physics.addBody(cazador, "static", { radius = 100 })

local box_options = {
    halfWidth = CW/2,
    halfHeight = 100/2,
    x=0,y=0,angle=0
}

local box_cazador = {
    halfWidth = 20,
    halfHeight = 100,
    x=0,y=0,angle=0
}

local piso = display.newImageRect("piso.png", 580, 252)
piso.x = CW/2
piso.y = CH - 100
piso.nombre = "Piso"

local f1 = display.newImageRect("fruta.png", 100, 100)
f1.x = CW/2 -25
f1.y = CH -250
f1.anchorX = 0.5; f1.anchorY = 0.5;
f1.nombre = "Fruta"


physics.start()
print(physics.getGravity())

physics.setDrawMode("debug")
physics.addBody(cazador, "dynamic", {box =box_cazador,density=1, density = 3, bounce = 0.2, friction = cazador.botas })
cazador.isFixedRotation = true
physics.setGravity(0, 9.8)
cazador.gravityScale = 0
physics.addBody(piso, "static", {box = box_options, bounce = 0.2, friction = 0.1})
print(piso.bodyType.bounce)
physics.addBody(f1, "kinematic", {radius=50, bounce = 0.2, density = 2 })

function preCollisionEvent(self, event)
   -- print("La colision se dio entre " .. self.nombre .. " precolisiono con "  .. event.other.nombre)
end

function postCollisionEvent(self, event)
    print("Post collision)")
    local otro = event.other
    if otro.nombre == "Fruta"  then
        print("Colisione con la fruta")
        timer.performWithDelay(100, function()
            otro.bodyType = "dynamic"
            otro:applyLinearImpulse(-5, -5, f1.x-50, f1.y)
        end
         )
        else 
            print(otro.nombre )
            event.target:applyForce(0, -400, event.target.x, event.target.y)   
    end
    otro:setFillColor(255, 0, 0)
end

cazador.preCollision = preCollisionEvent
cazador.postCollision = postCollisionEvent
cazador:addEventListener("preCollision", cazador)
cazador:addEventListener("postCollision", cazador)
