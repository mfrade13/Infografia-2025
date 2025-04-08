local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    local title = display.newText("Ajustes de Tema", display.contentCenterX, 100, native.systemFontBold, 24)
    sceneGroup:insert(title)

    local btnLight = display.newRect(display.contentCenterX, 200, 180, 40)
    btnLight:setFillColor(1, 1, 1)
    sceneGroup:insert(btnLight)

    local txtLight = display.newText("Claro", btnLight.x, btnLight.y, native.systemFontBold, 18)
    txtLight:setFillColor(0)
    sceneGroup:insert(txtLight)

    btnLight:addEventListener("tap", function()
        composer.gotoScene("scenes.calculator", {params={theme="light"}, effect="slideRight"})
    end)

    local btnDark = display.newRect(display.contentCenterX, 260, 180, 40)
    btnDark:setFillColor(0.2, 0.2, 0.2)
    sceneGroup:insert(btnDark)

    local txtDark = display.newText("Oscuro", btnDark.x, btnDark.y, native.systemFontBold, 18)
    txtDark:setFillColor(1)
    sceneGroup:insert(txtDark)

    btnDark:addEventListener("tap", function()
        composer.gotoScene("scenes.calculator", {params={theme="dark"}, effect="slideRight"})
    end)
end

scene:addEventListener("create", scene)
return scene
