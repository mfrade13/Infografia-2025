local composer = require("composer")
local scene = composer.newScene()

local cw = display.contentWidth
local ch = display.contentHeight

local fondo
local imagenRompecabezas
local botonIniciar
local nivel
local colorBtn

function scene:create(event)
    local sceneGroup = self.view

    nivel = composer.getVariable("nivelSeleccionado")
    --print(nivel)

    fondo = display.newImageRect(sceneGroup, "fondoGame.jpg", cw, ch)
    fondo.x = display.contentCenterX
    fondo.y = display.contentCenterY

    -- Imagen del rompecabezas ordenada según el nivel
    local imagenArchivo = {
        facil = "dragonBlancoFacil.jpg",
        medio = "hadesMedio.jpg",
        dificil = "kanekiDificil.jpg"
    }

    if nivel == "facil" then
        colorBtn = {27/255, 1, 0}
    elseif nivel == "medio" then
        colorBtn = {0, 54/255, 1}
    else 
        colorBtn = {1,0,0}
    end

    --print(colorBtn)

    marcoRompecabezas = display.newImageRect(sceneGroup, "marcoRompecabezas.png", 510, 510)
    marcoRompecabezas.x = cw/2
    marcoRompecabezas.y = ch/2

    imagenRompecabezas = display.newImageRect(sceneGroup, imagenArchivo[nivel], 360, 360)
    imagenRompecabezas.x = cw/2
    imagenRompecabezas.y = ch/2

    botonIniciar = display.newImageRect(sceneGroup, "btn.png", 150, 60)
    botonIniciar.x = cw/2
    botonIniciar.y = ch - 50
    botonIniciar:setFillColor(unpack(colorBtn))

    local textoBoton = display.newText({
        parent = sceneGroup,
        text = "INICIAR",
        x = botonIniciar.x,
        y = botonIniciar.y,
        font = "algerian",
        fontSize = 18
    })
    textoBoton:setFillColor(0)
    
    --TEXTO TIEMPO
    textoTiempo = display.newText({
        parent = sceneGroup,
        text = "Tiempo: 0s",
        x = cw - 180,
        y = 50,
        font = "algerian",
        fontSize = 40
    })
    textoTiempo:setFillColor(0)

    --TEXTO MOVIMIENTOS
    textoMovimientos = display.newText({
        parent = sceneGroup,
        text = "Movimientos: 0",
        x = 210,
        y = 50,
        font = "algerian",
        fontSize = 40
    })
    textoMovimientos:setFillColor(0)

    botonIniciar:addEventListener("tap", function()
        composer.gotoScene("juego", {effect = "fade", time = 500})
    end)
    --]]
end

scene:addEventListener("create", scene)
return scene
