local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    background:setFillColor(0.1, 0.1, 0.2)

    local title = display.newText({
        parent = sceneGroup,
        text = "Bomberman Lua",
        x = display.contentCenterX,
        y = 80,
        font = native.systemFontBold,
        fontSize = 48
    })
    title:setFillColor(1, 0.8, 0.2)

    -- Selector de dificultad
    local difficulties = { "Fácil", "Media", "Difícil" }
    local selectedDifficultyIndex = 2

    local difficultyText = display.newText({
        parent = sceneGroup,
        text = "Dificultad: " .. difficulties[selectedDifficultyIndex],
        x = display.contentCenterX,
        y = 180,
        font = native.systemFont,
        fontSize = 24
    })
    difficultyText:setFillColor(1, 1, 1)

    difficultyText:addEventListener("tap", function()
        selectedDifficultyIndex = selectedDifficultyIndex % #difficulties + 1
        difficultyText.text = "Dificultad: " .. difficulties[selectedDifficultyIndex]
    end)

    -- Botón estilizado
    local playButton = display.newRoundedRect(sceneGroup, display.contentCenterX, 260, 200, 50, 12)
    playButton:setFillColor(0.9, 0.7, 0.1)
    playButton.strokeWidth = 3
    playButton:setStrokeColor(1, 1, 0)

    local playText = display.newText({
        parent = sceneGroup,
        text = "Iniciar Juego",
        x = display.contentCenterX,
        y = 260,
        font = native.systemFontBold,
        fontSize = 24
    })
    playText:setFillColor(0, 0, 0)

    -- Ir a la escena del juego con parámetros
    local function goToGame()
        local selectedDifficulty = difficulties[selectedDifficultyIndex]
        composer.gotoScene("scenes.game", {
            effect = "fade",
            time = 500,
            params = {
                dificultad = selectedDifficulty
            }
        })
    end

    playButton:addEventListener("tap", goToGame)
    playText:addEventListener("tap", goToGame)
end

scene:addEventListener("create", scene)
return scene
