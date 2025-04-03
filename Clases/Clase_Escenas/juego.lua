local composer = require( "composer" )
 
local scene = composer.newScene()
-- local CW = display.contentWidth
-- local CH = display.contentHeight
local f1
local frutas = {}
function goToMenu(self, e) 
    if e.phase == "ended" then
        local options = {effect = "fade", time = 1000}
        composer.gotoScene( "menu", options)
    end
    return true
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local fondo = display.newImageRect( sceneGroup,"bg_3.jpg", CW,CH)
    fondo.x = CW/2
    fondo.y = CH/2
    fondo.name = "bg_3"

    local btn_play  =   display.newImageRect( sceneGroup,"btn_play.png", 200, 100)
    btn_play.x = 150
    btn_play.y = 150
    btn_play.touch = goToMenu
    btn_play:addEventListener("touch", btn_play)

    for k,v in pairs(event.params) do
        print( k, v )   
    end


end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        f1 = display.newImageRect( sceneGroup,"fruta.png", 100, 100)
        f1.x = math.random(200,CW-200)
        f1.y = math.random(200,CH-200)

        frutas[1] = f1
        for k,v in pairs(event.params) do
            print( k, v )   
        end

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local f2 = display.newImageRect( sceneGroup,"fruta.png", 100, 100)
        f2.x = math.random(200,CW-200)
        f2.y = math.random(200,CH-200)
        transition.to(f1,{x=math.random(200,CW-200), y=math.random(200,CH-200), time=1000})

        frutas[2] = f2
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
        for i=#frutas,1,-1 do
            frutas[i]:removeSelf()
            frutas[i] = nil
        end
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