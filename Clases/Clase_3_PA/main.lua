-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local ancho = 22
local alto = 19

local CW = display.contentWidth
local CH = display.contentHeight

local ancho_pxl = CW/ancho
local alto_pxl = CH/alto
local fondo = display.newRect(0,0, CW,CH)
fondo.x =CW/2; fondo.y = CH/2
local rojo = {1,0,0}

--lineas horizontales
for i=1, alto,1 do
    linea = display.newLine(0, i*(CH/alto), CW, i*(CH/alto))
    linea:setStrokeColor(0)
end
--lineas verticales
for i=1,ancho,1 do
    linea = display.newLine(i*(CW/ancho),0, i*(CW/ancho), CH)
    linea:setStrokeColor(0)
    linea.strokeWidth=1
end

-- linea:setStrokeColor(1,1,0)

local punta_borde_cola = display.newRect( 18*ancho_pxl, 1*alto_pxl, ancho_pxl, alto_pxl )
punta_borde_cola:setFillColor(0)
punta_borde_cola.anchorX=0; punta_borde_cola.anchorY =0

local fuego_rojo = display.newRect(17*ancho_pxl, 2*alto_pxl, 4*ancho_pxl, 5*alto_pxl)
fuego_rojo:setFillColor(unpack(rojo))
fuego_rojo.anchorX=0; fuego_rojo.anchorY=0



-- 19 - 2
local punta_borde_cola2 = display.newRect( 19*ancho_pxl, 2*alto_pxl, ancho_pxl, alto_pxl )
punta_borde_cola2:setFillColor(0)
punta_borde_cola2.anchorX=0; punta_borde_cola2.anchorY =0



local nariz_borde = display.newRect(0, 7*alto_pxl, ancho_pxl, 2*alto_pxl)
nariz_borde:setFillColor(0)
nariz_borde.anchorX=0; nariz_borde.anchorY=0

local menton = display.newRect(ancho_pxl,9*alto_pxl, ancho_pxl, alto_pxl)
menton:setFillColor(0); menton.anchorX=0; menton.anchorY = 0
local cola_h1_b = display.newRect(17*ancho_pxl, 2*alto_pxl, ancho_pxl, 3*alto_pxl) 
cola_h1_b:setFillColor(0)
cola_h1_b.anchorX=0; cola_h1_b.anchorY=0

local cola_h2_b = display.newRect(16*ancho_pxl, 5*alto_pxl, ancho_pxl, 2*alto_pxl) 
cola_h2_b:setFillColor(0)
cola_h2_b.anchorX=0; cola_h2_b.anchorY=0

local cola_h3_b = display.newRect(18*ancho_pxl, 5*alto_pxl, 2*ancho_pxl, 3*alto_pxl) 
cola_h3_b:setFillColor(1,1,0)
cola_h3_b.anchorX=0; cola_h3_b.anchorY=0

local fuego_rojo = display.newRect(18*ancho_pxl, 5*alto_pxl, 1*ancho_pxl, 1*alto_pxl)
fuego_rojo:setFillColor(1,0,0)
fuego_rojo.anchorX=0; fuego_rojo.anchorY=0

