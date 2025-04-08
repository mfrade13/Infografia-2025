local composer = require( "composer" )
 
local scene = composer.newScene()
local boton_jugar

 
function goToGame(self, event)
    if event.phase == "ended" then
        composer.removeScene("juego") 
        local options = { effect = "fade", time = 500}
        composer.gotoScene( "juego", options )
    end
    return true 
end

function goToInfo(self, event)
    if event.phase == "ended" then
        composer.removeScene("info") 
        local options = { effect = "fade", time = 500}
        composer.gotoScene( "info", options )
    end
    return true 
end


-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    
    local fondo_menu = display.newImageRect( sceneGroup, "menu.png", CW, CH )
    fondo_menu.x = CW/2
    fondo_menu.y = CH/2
 
    boton_jugar = display.newImageRect( sceneGroup, "btn_jugar.png", 1920/13, 778/13)
    boton_jugar.x = CW/2
    boton_jugar.y = CH/1.8
    boton_jugar.touch = goToGame

    btn_info = display.newImageRect( sceneGroup, "btn_info.png", 50, 50)
    btn_info.x = CW/2
    btn_info.y = CH/1.8 + 100
    btn_info.touch = goToInfo
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local texto = display.newText( sceneGroup, "Duck Hunt", CW/2, CH/3, native.systemFont, 40)
        boton_jugar:addEventListener("touch", boton_jugar)
        btn_info:addEventListener("touch", btn_info)
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        boton_jugar:removeEventListener( "touch", boton_jugar )
 
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    composer.removeScene("start")
 
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