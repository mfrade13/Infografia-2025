-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
print(display.contentWidth, display.contentHeight)
local CW = display.contentWidth
local CH = display.contentHeight
display.setStatusBar( display.LightTransparentStatusBar )


local cuadrado = display.newRect( CW/2, CH/2, 100, 100 )
cuadrado:setFillColor( 1, 0, 0 )

local circulo = display.newCircle(CW/2, CH/2, 30)
circulo.strokeWidth = 3
circulo:setStrokeColor( 0,0,1 )
circulo:setFillColor(1,1,0)

local linea = display.newLine(0,0, CW/2, CH/2, CW/2, CH,0,0)
linea:setStrokeColor(178/255,95/255,77/255)
linea.strokeWidth = 5
linea:append(CW,0)
