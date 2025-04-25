local composer = require("composer")
local scene = composer.newScene()

local cw = display.contentWidth
local ch = display.contentHeight

function scene:create(event)
    local sceneGroup = self.view

    -- FONDO
    local imagenFondo = _G.personajeSeleccionado == "yugiInicio" and "yugiGameover.png" or "seiyaGameover.png"
    fondo = display.newImageRect(sceneGroup, imagenFondo, cw, ch)
    fondo.x = cw/2
    fondo.y = ch/2

    -- BOTON REINICIAR
    local btnReiniciar = display.newImageRect(sceneGroup, "btn.png", 150, 60)
    btnReiniciar.x = cw / 2 - 80
    btnReiniciar.y = ch / 2 + 230
    btnReiniciar:setFillColor(1, 0, 0)
    
    local textoReiniciar = display.newText({
        parent = sceneGroup,
        text = "REINICIAR",
        x = btnReiniciar.x,
        y = btnReiniciar.y,
        font = "algerian",
        fontSize = 18
    })
    textoReiniciar:setFillColor(0)

    -- BOTON VOLVER AL MENU
    local btnMenu = display.newImageRect(sceneGroup, "btn.png", 150, 60)
    btnMenu.x = cw / 2 + 80
    btnMenu.y = ch / 2 + 230
    btnMenu:setFillColor(1, 0, 0)
    
    local textoMenu = display.newText({
        parent = sceneGroup,
        text = "MENÚ",
        x = btnMenu.x,
        y = btnMenu.y,
        font = "algerian",
        fontSize = 18
    })
    textoMenu:setFillColor(0)

    -- TEXTO GAMEOVER
    local gameOverText = display.newText({
        parent = sceneGroup,
        text = "¡GAME OVER!",
        x = cw / 2,
        y = ch * 0.15,
        font = "cooper black",
        fontSize = 55
    })
    --gameOverText:setFillColor(129/255, 0, 0)
    gameOverText:setFillColor(0)

    -- PUNTAJE FINAL
    local finalScore = _G.currentScore
    local scoreText = display.newText({
        parent = sceneGroup,
        text = "PUNTAJE: " .. finalScore,
        x = cw / 2,
        y = ch * 0.25,
        font = "cooper black",
        fontSize = 45
    })
    --scoreText:setFillColor(129/255, 0, 0)
    scoreText:setFillColor(0)

    btnReiniciar:addEventListener("tap", function()
        composer.gotoScene("preview", {effect = "fade", time = 500})
    end)
    
    btnMenu:addEventListener("tap", function()
        _G.currentScore = 0
        composer.gotoScene("menu", {effect = "fade", time = 500})
    end)
end

function scene:show(event)
    if event.phase == "will" then
        composer.removeScene("game")
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene