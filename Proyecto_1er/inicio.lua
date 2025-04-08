local composer = require( "composer" )
 
local scene = composer.newScene()

local CW = display.contentWidth
local CH = display.contentHeight
local btn_iniciar = nil

local function gotoMenu(self, event)
    if event.phase == "ended" then
        local options = {effect ="fade", time=100}
        composer.gotoScene("menu", options)
    end
    return true
end

-- create()
function scene:create( event )

    local sceneGroup = self.view

    local fondo = display.newImageRect(sceneGroup, "/images/fondo.jpg", 1280, 720)
    fondo.x = CW/2; fondo.y = CH/2
    fondo.xScale = 1.42; fondo.yScale = 1.42

    local titulo = display.newImageRect(sceneGroup, "/images/titulo.png", 393, 128)
    titulo.x = CW/2; titulo.y = 180
    titulo.xScale = 1.3; titulo.yScale = 1.3

    local fondo_logo = display.newCircle( sceneGroup, CW/2, CH/2, 727/4 )
    fondo_logo:setFillColor(1)

    local logo = display.newImageRect(sceneGroup, "/images/pokeball.png", 727, 727)
    logo.x = CW/2; logo.y = CH/2
    logo.xScale = 0.5; logo.yScale = 0.5

    btn_iniciar = display.newImageRect(sceneGroup, "/images/marco.png", 361, 117)
    btn_iniciar.x = CW/2; btn_iniciar.y = CH/2 + 300
    btn_iniciar.xScale = 0.7; btn_iniciar.yScale = 0.8

    local texto_iniciar = display.newText(sceneGroup, "Iniciar", CW/2, CH/2 + 300, native.systemFontBold, 40)
    texto_iniciar:setFillColor(0)

    btn_iniciar.touch = gotoMenu

    --print(fondo_btn.x, fondo_btn.y, texto_iniciar.x, texto_iniciar.y)
    --print(CW, CH)
end

-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        btn_iniciar:addEventListener("touch", btn_iniciar)
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        btn_iniciar:removeEventListener("touch", btn_iniciar)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene