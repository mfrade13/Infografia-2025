local composer = require( "composer" )
 
local scene = composer.newScene()
params = nil
buttons = {}
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

function goToGame( event )
    if ( "ended" == event.phase ) then
        local options = {
            effect = "fade",
            time = 200,
            params = {
                difficulty = event.target.value,
                language = params.language
            }
        }
        composer.gotoScene( "game", options )
    end
    return true
end
 
 function goMenu(event)
    if ( "ended" == event.phase ) then
        local options = {
            effect = "fade",
            time = 200,
        }
        composer.gotoScene( "menu", options )
    end
    return true
 end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
    
    local sceneGroup = self.view
    
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
    title:setFillColor( green[1], green[2], green[3] );

     -- Buttons
     local text_options = {
        text = "aa",
        parent = sceneGroup,
        x = CW/2,
        font = "Gill Sans Ultra Bold",
        fontSize = 50,
        align = "center"
    }

    local difficulties = {
        {text = "Fácil", value = "1"},
        {text = "Medio", value = "2"},
        {text = "Difícil", value = "3"}
    }
   

    for i=1, 3 do
        local y_pos = gridSize*4 + (i*2.5)*gridSize;
        buttons[i] = display.newRoundedRect( sceneGroup, CW/2,  y_pos, 7*gridSize, gridSize*2, 20);
        buttons[i].value = difficulties[i].value;
        buttons[i]:setFillColor( green[1], green[2], green[3]);
        --buttons[i].touch = goToGame;
        
        local text = display.newText( text_options );
        text.y = y_pos;
        text.text = difficulties[i].text;
        text:setFillColor( 1 );
    end


    -- Back button
    local backButton = display.newRoundedRect( sceneGroup, gridSize*2,  gridSize*14.5, 3*gridSize, gridSize*2, 20);
    backButton:setFillColor(0.2);
    backButton.touch = goMenu;
    backButton:addEventListener( "touch", goMenu );
    local backText = display.newText( {
        text = "Volver",
        parent = sceneGroup,
        x =  gridSize*2,
        y = gridSize*14.5,
        font = "Gill Sans Ultra Bold",
        fontSize = 30,
        align = "center"
    });
    
    
    
end
 
 
-- show()
function scene:show( event )
    display.setDefault( "background", 1 );
    params = event.params;
   
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        print(params.language);
        for i=1, 3 do
            buttons[i].touch = goToGame;
            buttons[i]:addEventListener( "touch", goToGame);
        end
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        for i=1, 3 do
            buttons[i].touch = goToGame;
            buttons[i]:removeEventListener( "touch", goToGame);
        end
 
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