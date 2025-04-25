local composer = require("composer")
local scene = composer.newScene()

local cw = display.contentWidth
local ch = display.contentHeight
_G.personajeSeleccionado = nil

function scene:create(event)
    local sceneGroup = self.view

    -- FONDO
    local fondo = display.newImageRect(sceneGroup, "fondoMenu.jpg", cw, ch)
    fondo.x = cw/2
    fondo.y = ch/2

    -- TITULO
    local titulo = display.newText({
        parent = sceneGroup,
        text = "ANIME JUMP",
        x = cw/2,
        y = 70,
        font = "cooper black",
        fontSize = 55
    })
    titulo:setFillColor(1)

    -- SELECCIONAR PERSONAJE TEXT
    local seleccionarText = display.newText({
        parent = sceneGroup,
        text = "Selecciona tu Personaje:",
        x = cw/2,
        y = 150,
        font = "cooper black",
        fontSize = 20
    })
    seleccionarText:setFillColor(1)

    -- BOTTOM TEXT
    local bottonText = display.newText({
        parent = sceneGroup,
        text = "By: Nicolas Moscoso Linares",
        x = cw/2,
        y = ch/2 + 250,
        font = "cooper black",
        fontSize = 15
    })
    bottonText:setFillColor(1)

    -- YUGI
    local yugiInicio = display.newImageRect(sceneGroup, "yugiInicio.png", 216, 289)
    yugiInicio.x = cw/2 - 100
    yugiInicio.y = ch/2 + 50

    -- SEIYA
    local seiyaInicio = display.newImageRect(sceneGroup, "seiyaInicio.png", 159, 289)
    seiyaInicio.x = cw/2 + 100
    seiyaInicio.y = ch/2 + 50

    -- SELECCIONAR PERSONAJE
    local function seleccionarPesonaje(personaje)
        _G.personajeSeleccionado = personaje
        _G.currentScore = 0
        composer.gotoScene("preview", { 
            effect = "fade", 
            time = 500,
            params = { fromMenu = true }
        })
    end

    yugiInicio:addEventListener("tap", function() seleccionarPesonaje("yugiInicio") end)
    seiyaInicio:addEventListener("tap", function() seleccionarPesonaje("seiyaInicio") end)
end

function scene:show(event)
    if event.phase == "will" then
        composer.removeScene("game")
        composer.removeScene("preview")
        composer.removeScene("gameover")
        
        _G.currentScore = 0
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene