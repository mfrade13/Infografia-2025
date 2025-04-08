local composer = require("composer")
local scene = composer.newScene()

local themeName = "dark"  -- Variable global a la escena

function scene:create(event)
    local sceneGroup = self.view

    display.setDefault("background", 0.1, 0.1, 0.1)

    local title = display.newText({
        text = "Menú Principal",
        x = display.contentCenterX,
        y = 100,
        fontSize = 28
    })
    sceneGroup:insert(title)

    local btnCalc = display.newRect(display.contentCenterX, 200, 200, 50)
    btnCalc.strokeWidth = 2
    btnCalc:setStrokeColor(0, 0, 0)
    btnCalc:setFillColor(0.2, 0.6, 1)
    sceneGroup:insert(btnCalc)

    local txtCalc = display.newText("Calculadora", btnCalc.x, btnCalc.y, native.systemFontBold, 20)
    sceneGroup:insert(txtCalc)

    btnCalc:addEventListener("tap", function()
        composer.gotoScene("scenes.calculator", {params={theme=themeName}, effect="slideLeft"})
    end)

    local btnSettings = display.newRect(display.contentCenterX, 280, 200, 50)
    btnSettings.strokeWidth = 2
    btnSettings:setStrokeColor(0, 0, 0)
    btnSettings:setFillColor(0.2, 0.8, 0.5)
    sceneGroup:insert(btnSettings)

    local txtSettings = display.newText("Ajustes", btnSettings.x, btnSettings.y, native.systemFontBold, 20)
    sceneGroup:insert(txtSettings)

    btnSettings:addEventListener("tap", function()
        composer.gotoScene("scenes.settings", {effect="slideLeft"})
    end)
end

function scene:show(event)
    if event.phase == "did" then
        themeName = (event.params and event.params.theme) or "dark"
    end
end

scene:addEventListener("show", scene)
scene:addEventListener("create", scene)
return scene
