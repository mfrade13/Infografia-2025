local composer = require("composer")
local scene = composer.newScene()

local cw = display.contentWidth
local ch = display.contentHeight
--[[
if not _G.personajeSeleccionado then
    _G.personajeSeleccionado = "yugiInicio" 
end
]]

function scene:create(event)
    local sceneGroup = self.view

    -- FONDO
    local fondo = display.newImageRect(sceneGroup, "fondoMenu.jpg", cw, ch)
    fondo.x = cw/2
    fondo.y = ch/2

    -- TEXTO
    local titulo = display.newText({
        parent = sceneGroup,
        text = "¡LISTO PARA SALTAR!",
        x = cw/2,
        y = 70,
        font = "cooper black",
        fontSize = 30
    })
    titulo:setFillColor(1)

    -- PERSONAJE SELECCIONADO
    local personaje
    if _G.personajeSeleccionado == "yugiInicio" then
        personaje = display.newImageRect(sceneGroup, "yugiInicio.png", 216, 289)
    else
        personaje = display.newImageRect(sceneGroup, "seiyaInicio.png", 159, 289)
    end
    personaje.x = cw/2
    personaje.y = ch/2 -20

    -- BOTÓN INICIAR
    local btnIniciar = display.newImageRect(sceneGroup, "btn.png", 150, 60)
    btnIniciar.x = cw/2
    btnIniciar.y = ch/2 + 180
    btnIniciar:setFillColor(1)
    
    local textoIniciar = display.newText({
        parent = sceneGroup,
        text = "INICIAR",
        x = btnIniciar.x,
        y = btnIniciar.y,
        font = "algerian",
        fontSize = 18
    })
    textoIniciar:setFillColor(0)

    -- BOTÓN VOLVER AL MENÚ
    local btnMenu = display.newImageRect(sceneGroup, "btn.png", 150, 60)
    btnMenu.x = cw/2
    btnMenu.y = ch/2 + 255
    btnMenu:setFillColor(1)
    
    local textoMenu = display.newText({
        parent = sceneGroup,
        text = "MENU",
        x = btnMenu.x,
        y = btnMenu.y,
        font = "algerian",
        fontSize = 18
    })
    textoMenu:setFillColor(0)

    -- ACCIÓN DEL BOTÓN INICIAR
    local function startGame()
        composer.gotoScene("game", { effect = "fade", time = 500 })
    end

    -- ACCIÓN DEL BOTÓN MENÚ
    local function goToMenu()
        composer.gotoScene("menu", { effect = "fade", time = 500 })
    end

    btnIniciar:addEventListener("tap", startGame)
    textoIniciar:addEventListener("tap", startGame)
    btnMenu:addEventListener("tap", goToMenu)
    textoMenu:addEventListener("tap", goToMenu)
end

function scene:show(event)
    if event.phase == "will" then
        composer.removeScene("game")
        composer.removeScene( "gameover")
        if event.params and event.params.fromMenu then
            _G.currentScore = 0
        end
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene