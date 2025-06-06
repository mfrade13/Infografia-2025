-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here
local CW = display.contentWidth
local CH = display.contentHeight

local transicion_titulo
local frutas = {}
local grupo_fondo = display.newGroup()
local grupo_intermedio = display.newGroup()
local fondo = display.newImageRect( "bg_3.jpg", CW, CH)
grupo_fondo:insert(1, fondo)
print(grupo_fondo.x, grupo_fondo.y)
--fondo.anchorX = 0; fondo.anchorY = 0
fondo.x = CW/2
fondo.y = CH/2
fondo.name = "Fondo"

local fruta = display.newImageRect("fruta.png", 100, 100)
fruta.x = 100
fruta.y = 100
--fruta.anchorX = 0; fruta.anchorY = 0
print(fruta.alpha)
--fruta.alpha= 0
--fruta:setFillColor(0, 1)
fruta.rotation = 720
fruta.name = "manzana"

local titulo = display.newText("Game", CW/2, CH/6, native.systemFont, 55)
print(titulo.size)
titulo.size = 30; titulo.alpha= 0.2
titulo.name = "titulo"

local btn = display.newImageRect("btn_play.png", 100, 100)
btn.x = CW/2
btn.y = 650

function moverFruta()
    print("Esta funcion esta en el onComplete de mi transicion")
    print(transicion_titulo)
    transition.to(fruta, {time =300, delay=100, alpha=0.5, x = -100})
    transition.pause()
end

function repetir()
    print("estamos repitiendo iteraciones durante la transicion")
    print(fruta.x)
end
transicion_titulo = transition.to(titulo, {time=1000, size = 90, alpha = 1, iterations = 5, tag="crecer", onRepeat=repetir})
transition.to(fruta, {time=3000, x=600, y = 500, rotation=1200, transition=easing.inBack, onComplete=moverFruta})
transition.to(fruta,{x = 300, delay=4000})

function resumir(event)
    if event.phase == "began" then
        print("Fase bega")
    elseif event.phase == "moved" then
        print("Fase moved")
    elseif event.phase == "ended" then
        print("Fase ended")
        transition.resume("crecer")
    end
end

function btn:touch( event)
    if event.phase == "began" then
        print("Fase began, posicion X" .. self.x )
        print("Poscion del click " .. event.x)
    elseif event.phase == "moved" then
        print("Fase moved")

    elseif event.phase == "ended" then
        print("Fase ended boton")
        self.x = event.x
        self.y = event.y
        transition.resume("crecer")
        self.isVisible = false
        fondo.alpha = 1
        -- for i=1, #frutas do
        --     frutas[i].alpha = 0.3
        -- end
        grupo_intermedio.alpha = 0.3
        grupo_intermedio.x = 500
        grupo_fondo.y = 400
    end
    return 1
end

function removerFruta(self, event)
    if event.phase == "began" then
        print("Fase bega")
    elseif event.phase == "moved" then
        print("Fase moved")
    elseif event.phase == "ended" then
        print("Fruta removida: " .. self.name)
        if self.name == "Fondo" then
            self.alpha = 0.5
        else
            self:removeSelf()
            self = nil
        end
    end
    return 1
end

function frutasRemovidas( self, event )
    if event.phase == "ended" then
        print("Fruta removida: ")
        if self.alpha == 1 then
            print("Tocando nuestra fruta .." .. self.name)
--            display.remove(self)
            self:rotate(90)
            end
    end
   return 1
end


for i = 1,10 do
    local fruta = display.newImageRect(grupo_intermedio, "fruta.png", 100, 100)
    fruta.x = math.random(100, CW-100)
    fruta.y = math.random(100, CH-100)
    fruta.name = "fruta" .. i
    print(fruta.x, fruta.y)

    fruta.touch = frutasRemovidas
    fruta:addEventListener("touch", fruta)
    frutas[i] = fruta
end

print(btn.x, btn.y)
btn:translate(100, 50)
print(btn.x, btn.y)


local puntos = {0, 0 , 90, 0, 90, 90, 0, 90}
local polygon = display.newPolygon(grupo_intermedio, CW/2, CH/2, puntos )
--polygon:rotate(45)
polygon.rotation =45
newx = math.cos(math.rad(45)) * 0 - math.sin(math.rad(45)) * 0
newy = math.sin(math.rad(45)) * 0 + math.cos(math.rad(45)) * 0

newx2 = math.cos(math.rad(45)) * 0 - math.sin(math.rad(45)) * 90
newy2 = math.sin(math.rad(45)) * 0 + math.cos(math.rad(45)) * 90




local newPoints = {0,0 ,63, 63, 7,127, -63, 63}
print(newx2, newy2)
print(math.cos(math.rad(45)), math.sin(45))

local polygon2 = display.newPolygon(grupo_intermedio, CW/2, CH/2, newPoints )
polygon2:setFillColor(1,0,0,0.4)
-- polygon2:scale(3,2)
polygon2.xScale = 3
polygon2.yScale = 2

fruta.touch = removerFruta
fondo.touch = removerFruta
titulo.touch = removerFruta
titulo:addEventListener("touch", titulo)
fruta:addEventListener("touch", fruta)
fondo:addEventListener("touch", fondo)
btn:addEventListener("touch", btn)
--btn:addEventListener("touch", resumir)

-- grupo_intermedio:translate(CW/2, 0)
-- grupo_intermedio.rotation = 90
-- grupo_intermedio:scale(0.5,0.5)
-- grupo_intermedio.isVisible = false