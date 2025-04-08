local composer = require( "composer" )
local widget = require("widget")
 
local scene = composer.newScene()

--Funcion para el boton play
local function onPlayButtonRelease()
    
    composer.gotoScene("scene_juego", { effect = "fade", time = 500 })
    print("Botón 'Play' presionado")
    
end

--Funcion para el boton exit
local function onExitButtonRelease()
    print("Botón 'Exit' presionado")
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    ----------Fondo----------
    local fondo0 = display.newImageRect( sceneGroup, "fondo5.jpg", CW, CH )
    fondo0.anchorX = 0; fondo0.anchorY = 0;
    fondo0:setFillColor(0.7,0.7,0.8)

    ----------Titulo menu----------
    local options_titulo_menu = 
    {
        parent = sceneGroup,
        text = "FUTLE\n\nJUEGO DE ADIVINANZA",
        x = CW/2,
        y = CH/4,
        font = "Bahnschrift SemiBold",
        fontSize = 28,
        align = "center"
    }
    local titulo_menu = display.newText( options_titulo_menu )
    titulo_menu:setFillColor(1,1,1)

    ----------Boton play----------
    local boton_play = widget.newButton(
        {
            shape = "roundedRect",
            width = CW * 0.5,
            height = CH * 0.08,
            cornerRadius = 12,
            fillColor = { default={ 0.2, 0.4, 0.3, 1 }, over={ 0.1, 0.8, 0.4, 1 } },
            strokeColor = { default={ 0.1, 0.27, 0.15 }, over={ 0.2, 0.5, 0.2 } },
            strokeWidth = 4,
            label = "JUGAR",
            labelColor = { default={ 1, 1, 1 }, over={ 0.9, 0.9, 0.9 } },
            font = "Franklin Gothic Medium",
            fontSize = 22,
            onRelease = onPlayButtonRelease  
        }
    )
    boton_play.x = CW/2
    boton_play.y = CH*2/3
    sceneGroup:insert(boton_play)

    ----------Boton exit----------
    local boton_exit = widget.newButton(
        {
            shape = "roundedRect",
            width = CW * 0.5,
            height = CH * 0.08,
            cornerRadius = 12,
            fillColor = { default={ 0.6, 0.1, 0.1, 1 }, over={ 0.9, 0.2, 0.2, 1 } },
            strokeColor = { default={ 0.4, 0.05, 0.05 }, over={ 0.6, 0.1, 0.1 } },
            strokeWidth = 4,
            label = "SALIR",
            labelColor = { default={ 1, 1, 1 }, over={ 0.9, 0.9, 0.9 } },
            font = "Franklin Gothic Medium",
            fontSize = 22,
            onRelease = onExitButtonRelease
        }
    )
    boton_exit.x = CW/2
    boton_exit.y = CH*5/6
    sceneGroup:insert(boton_exit)

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