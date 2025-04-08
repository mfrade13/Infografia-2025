local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 

 -- Define grid dimensions



function goDidfficultySelector( self, event )

    if ( "ended" == event.phase ) then
        local options = {
            effect = "fade",
            time = 200,
            params = {
                language = self.value
            }
        }
        composer.gotoScene( "difficulty", options )
    end
    return true
end


-- create()
function scene:create( event )
    
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    display.setDefault( "background",green[1], green[2], green[3] );
    local tittle_options = {
        parent = sceneGroup,
        text = "Wordle",
        x = CW/2,
        y =gridSize*2,
        font = "Gill Sans Ultra Bold",
        fontSize = 90,
        align = "center"
    }
    local title = display.newText( tittle_options );
    title:setFillColor( 1 );


    -- Buttons
    local text_options = {
        parent = sceneGroup,
        x = CW/2,
        font = "Gill Sans Ultra Bold",
        fontSize = 50,
        align = "center"
    }
    
    local sp_y = gridSize*8;
    spanish_button = display.newRoundedRect( sceneGroup, CW/2, sp_y, gridSize*7, gridSize*2, 20 );
    spanish_button.value = "es";
    text_options.text = "Español";
    text_options.y = sp_y;
    local spanishButtonText = display.newText(  text_options );   
    spanishButtonText:setFillColor( green[1], green[2], green[3] );

    local en_y = gridSize*10.5;
    english_button = display.newRoundedRect( sceneGroup, CW/2, en_y, gridSize*7, gridSize*2, 20 );
    english_button.value = "en";
    text_options.text = "Inglés";
    text_options.y = en_y;
    local english_button_text = display.newText(  text_options );   
    english_button_text:setFillColor( green[1], green[2], green[3] );

    local bo_y = gridSize*13;
    bol_button = display.newRoundedRect( sceneGroup, CW/2, bo_y, gridSize*7, gridSize*2, 20 );
    bol_button.value = "bo";
    text_options.text = "Bolivia";
    text_options.y = bo_y;
    local english_button_text = display.newText(  text_options );   
    english_button_text:setFillColor( green[1], green[2], green[3] );
  
    
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    display.setDefault( "background",green[1], green[2], green[3] );
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        bol_button.touch = goDidfficultySelector;
        bol_button:addEventListener( "touch", bol_button );
        spanish_button.touch = goDidfficultySelector;
        spanish_button:addEventListener( "touch", spanish_button );
        english_button.touch = goDidfficultySelector;
        english_button:addEventListener( "touch", english_button );
        
 
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
        bol_button.touch = nil;
        bol_button:removeEventListener( "touch", bol_button );
        spanish_button.touch = nil;
        spanish_button:removeEventListener( "touch", spanish_button );
        english_button.touch = nil;
        english_button:removeEventListener( "touch", english_button );
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