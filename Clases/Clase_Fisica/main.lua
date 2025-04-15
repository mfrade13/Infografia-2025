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
cazador.y = CH/4
cazador:play()

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

local f1 = display.newImageRect("fruta.png", 100, 100)
f1.x = CW/2 -25
f1.y = CH -200


physics.start()
print(physics.getGravity())
physics.setDrawMode("hybrid")
physics.addBody(cazador, "dynamic", {box =box_cazador,density=2, bounce = 0.2})
cazador.isFixedRotation = false
--physics.setGravity(0, 0)
physics.addBody(piso, "static", {box = box_options, bounce = 0.2})
print(piso.bodyType.bounce)
physics.addBody(f1, "kinematic", {radius=50, bounce = 0.2 })