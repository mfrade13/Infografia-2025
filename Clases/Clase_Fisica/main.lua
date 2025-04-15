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
cazador.y = CH/2
cazador:play()

physics.start()
print(physics.getGravity())
physics.setDrawMode("debug")
physics.addBody(cazador, "dynamic", {radius =100})
physics.setGravity(0, 0)