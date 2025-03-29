-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local rutaAssets = "AndroidResources/res/"
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
cuadrado:toFront()

local vertices = { 0,-110, 27,-35, 105,-35, 43,16, 65,90, 0,45, -65,90, -43,15, -105,-35, -27,-35, }
local polygon = display.newPolygon( 100, 100, vertices)
polygon:setFillColor(0,1,0)
polygon.strokeWidth =3
polygon:setStrokeColor(1,1,0)
polygon.x = 200
polygon.width = 100

icono = display.newImage("Icon.png", 50, 200)

icono2 = display.newImageRect( rutaAssets .. "/mipmap-hdpi/ic_launcher.png", 57, 57)
icono2.x = 114; icono2.y = 200
icono2.width = 20
print(polygon.width, polygon.height)
icono2:toBack()
--cuadrado:toFront()

local options = {
    text = "HOLA MUNDO",
    x=0, y=100, width =220, height=100, font="Arial", align = "right", size=30
}

--local texto = display.newText("HOLA MUNDO!", 0, 100, "Arial Black", 30, "center")
local texto = display.newText(options)
texto.x = 10
texto.text = "TITULO"
