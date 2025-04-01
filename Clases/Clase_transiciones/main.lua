-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here
local CW = display.contentWidth
local CH = display.contentHeight

local fondo = display.newImageRect("bg_3.jpg", CW, CH)
--fondo.anchorX = 0; fondo.anchorY = 0
fondo.x = CW/2
fondo.y = CH/2

local fruta = display.newImageRect("fruta.png", 100, 100)
fruta.x = 100
fruta.y = 100
--fruta.anchorX = 0; fruta.anchorY = 0
print(fruta.alpha)
--fruta.alpha= 0
--fruta:setFillColor(0, 1)
fruta.rotation = 720

local titulo = display.newText("Game", CW/2, CH/6, native.systemFont, 55)
print(titulo.size)
titulo.size = 30; titulo.alpha= 0.2

function moverFruta()
    print("Esta funcion esta en el onComplete de mi transicion")
    transition.to(fruta, {time =300, alpha=0.5, x = -100})
end

function repetir()
    print("estamos repitiendo iteraciones durante la transicion")
end
transition.to(fruta, {time=3000, x=600, y = 500, rotation=1200, onComplete=moverFruta})

transition.to(fruta,{x = 300, delay=4000})
transition.to(titulo, {time=1000, size = 90, alpha = 1, iterations = 5, tag="titulo", onRepeat=repetir})