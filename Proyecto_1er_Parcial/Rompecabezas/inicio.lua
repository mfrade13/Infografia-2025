local composer = require("composer")
local scene = composer.newScene()

local cw = display.contentWidth
local ch = display.contentHeight

print(cw, ch)

local fondo
local titulo
local btnFacil
local btnMedio
local btnDificil

local function seleccionarNivel(nivel)
    composer.setVariable("nivelSeleccionado", nivel)
    composer.removeScene("juego")
    composer.removeScene("previewRompecabezas")
    composer.gotoScene("previewRompecabezas", {effect = "fade", time = 500})
end

function scene:create(event)
    local sceneGroup = self.view
    --FONDO
    fondo = display.newImageRect(sceneGroup, "fondoGame.jpg", cw, ch)
    fondo.x = cw/2
    fondo.y = ch/2

    --TITULO
    titulo = display.newImageRect(sceneGroup, "titulo.png", 700, 200)
    titulo.x = cw/2
    titulo.y = 100

    --BOTON FACIL
    btnFacil = display.newImageRect(sceneGroup, "btn.png", 150, 60)
    btnFacil:setFillColor(27/255, 1, 0)
    btnFacil.x = cw/3 - 160
    btnFacil.y = 250

    btnFacil:addEventListener("tap", function() seleccionarNivel("facil") end)

    local textoFacil = display.newText({
        parent = sceneGroup,
        text = "FÁCIL",
        x = btnFacil.x,
        y = btnFacil.y,
        font = "algerian",
        fontSize = 18
    })
    textoFacil:setFillColor(0)

    --IMAGEN FACIL
    imagenFacil = display.newImageRect(sceneGroup, "dragonBlancoFacil.jpg", 290, 290)
    imagenFacil.x = cw/3 -160
    imagenFacil.y = 470

    --BOTON MEDIO
    btnMedio = display.newImageRect(sceneGroup, "btn.png", 150, 60)
    btnMedio:setFillColor(0, 54/255, 1)
    btnMedio.x = cw/3 + 160
    btnMedio.y = 250

    btnMedio:addEventListener("tap", function () seleccionarNivel("medio") end)

    local textoMedio = display.newText({
        parent = sceneGroup,
        text = "MEDIO",
        x = btnMedio.x,
        y = btnMedio.y,
        font = "algerian",
        fontSize = 18
    })
    textoMedio:setFillColor(0)

    --IMAGEN MEDIO 
    imagenMedio = display.newImageRect(sceneGroup, "hadesMedio.jpg", 290, 290)
    imagenMedio.x = cw/3 + 160
    imagenMedio.y = 470

    --BOTON DIFICIL
    btnDificil = display.newImageRect(sceneGroup, "btn.png", 150, 60)
    btnDificil:setFillColor(1,0,0)
    btnDificil.x = cw/3 + 480
    btnDificil.y = 250

    btnDificil:addEventListener("tap", function () seleccionarNivel("dificil") end)

    local textoDificil = display.newText({
        parent = sceneGroup,
        text = "DIFÍCIL",
        x = btnDificil.x,
        y = btnDificil.y,
        font = "algerian",
        fontSize = 18
    })
    textoDificil:setFillColor(0)

    --IMAGEN DIFICIL
    imagenDificil = display.newImageRect(sceneGroup, "kanekiDificil.jpg", 290, 290)
    imagenDificil.x = cw/3 + 480
    imagenDificil.y = 470

end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
    end
end
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene

