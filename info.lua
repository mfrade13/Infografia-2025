local composer = require( "composer" )
 
local scene = composer.newScene()

local instrucciones = "Instrucciones \n\n" ..
    "1. Debes disparar al pato no a las aves.\n" ..
    "2. Si le das 10 veces al pato, ganas.\n" ..
    "3. Si das tres veces a los pájaros, pierdes.\n" ..
    "4. ¡Buena suerte!"
 

function goToStart(self, event)
    if event.phase == "ended" then
        composer.removeScene("info") 
        local options = { effect = "fade", time = 500}
        composer.gotoScene( "start", options )
    end
    return true 
end
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    
    local fondo_info = display.newImageRect( sceneGroup, "info.jpg", CW, CH )
    fondo_info.x = CW/2
    fondo_info.y = CH/2

    btn_volver = display.newImageRect( sceneGroup, "btn_volver.png", 1920/13, 778/13)
    btn_volver.x = CW/2
    btn_volver.y = CH/2
    btn_volver.touch = goToStart
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
 
    elseif ( phase == "did" ) then
        
        local texto = display.newText( sceneGroup, instrucciones, CW/2, CH/4, native.systemFont, 15)
        btn_volver:addEventListener( "touch", btn_volver )
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
        btn_volver:removeEventListener( "touch", btn_volver )
 
    elseif ( phase == "did" ) then
       
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene