local composer = require( "composer" )
 
local scene = composer.newScene()
local CW = display.contentWidth
local CH = display.contentHeight

local btn_play

function goToGame(self, event)
    if event.phase == "ended" then
        local options = { effect = "fade", time = 1000, params = {
            cantidad = 10,
            velocidad = 1000
        } }
        composer.gotoScene( "juego", options )
    end
    return true 
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local fondo = display.newImageRect( sceneGroup,"bg_1.jpg", CW,CH)
    fondo.x = CW/2
    fondo.y = CH/2
--    fondo.name = "bg_!"

    btn_play = display.newImageRect( sceneGroup,"btn_play.png", 200,200)
    btn_play.x = CW/2
    btn_play.y = CH/2
    btn_play.touch = goToGame



    print("Menu creado")
    

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        print("Menu mostrando")
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        print("Menu mostrado para la fase did")
        btn_play:addEventListener("touch", btn_play)
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        btn_play:removeEventListener( "touch", btn_play )
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