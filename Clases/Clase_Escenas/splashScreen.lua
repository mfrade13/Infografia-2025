local composer = require( "composer" )
 
local scene = composer.newScene()
-- local CW = display.contentWidth
-- local CH = display.contentHeight
logo_cabra = nil
function goToMenu() 
    local options = {effect = "fade", time = 500}
    composer.gotoScene( "menu", options)
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local fondo = display.newImageRect( sceneGroup,"bg_2.jpg", CW,CH)
    fondo.x = CW/2
    fondo.y = CH/2
    fondo.name = "bg_2"

    logo_cabra = display.newImageRect(sceneGroup, "cabra.png", 592,820)
    logo_cabra.x = CW/2
    logo_cabra.y = CH/2
    logo_cabra.name = "logo_cabra"


    print(fondo.name)
    
   -- transition.to(fondo, {time=1000, delay=5000, onComplete = goToMenu})
--    sceneGroup:insert(fondo)
    timer.performWithDelay(1000, goToMenu)

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
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