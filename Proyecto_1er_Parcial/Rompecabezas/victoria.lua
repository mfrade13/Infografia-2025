local composer = require("composer")
local scene = composer.newScene()

local cw = display.contentWidth
local ch = display.contentHeight

function scene:create(event)
    local sceneGroup = self.view
    nivel = composer.getVariable("nivelSeleccionado")

    local imagenArchivo = {
        facil = "dragonBlancoFacil.jpg",
        medio = "hadesMedio.jpg",
        dificil = "kanekiDificil.jpg"
    }

    marcoRompecabezas = display.newImageRect(sceneGroup, "marcoRompecabezas.png", 510, 510)
    marcoRompecabezas.x = cw/2
    marcoRompecabezas.y = ch/2
    marcoRompecabezas.alpha = 1000

    imagenRompecabezas = display.newImageRect(sceneGroup, imagenArchivo[nivel], 360, 360)
    imagenRompecabezas.x = cw/2
    imagenRompecabezas.y = ch/2
    imagenRompecabezas.alpha = 1000

    local tiempoFinal = composer.getVariable("tiempoFinal")
    local movimientosFinal = composer.getVariable("movimientosFinal")

    fondo = display.newImageRect(sceneGroup, "fondoGame.jpg", cw, ch)
    fondo.alpha = 0.5
    fondo.x = cw/2
    fondo.y = ch/2

    local texto = display.newText({
        parent = sceneGroup,
        text = "¡VICTORIA!",
        x = cw/2,
        y = ch/2,
        font = "algerian",
        fontSize = 150
    })
    texto:setFillColor(0)

    local detalles = display.newText({
        parent = sceneGroup,
        text = "Movimientos: " .. movimientosFinal .. "  |  Tiempo: " .. tiempoFinal .. "s",
        x = display.contentCenterX,
        y = 200,
        font = native.systemFontBold,
        fontSize = 32
    })
    --detalles:setFillColor(20/255, 287/255, 0)
    detalles:setFillColor(0)

    local botonInicio = display.newImageRect(sceneGroup, "btn.png", 150, 60)
    botonInicio.x = cw/2
    botonInicio.y = ch - 200
    botonInicio:setFillColor(1,0,0)

    local textoBoton = display.newText({
        parent = sceneGroup,
        text = "MENU",
        x = botonInicio.x,
        y = botonInicio.y,
        font = "algerian",
        fontSize = 18
    })
    textoBoton:setFillColor(0)

    botonInicio:addEventListener("tap", function()
        composer.removeScene("juego")
        composer.gotoScene("inicio", {effect = "fade", time = 400})
    end)

    transition.to(texto, {time = 1000, xScale = 1.2, yScale = 1.2, rotation = 360})
end

scene:addEventListener("create", scene)
return scene
