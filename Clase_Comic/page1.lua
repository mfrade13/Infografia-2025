local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local CW = display.contentWidth
local CH = display.contentHeight
local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local fondo
local indice = 1

local posiciones = {
    {xScale = 1, yScale=1, x=0,y=0},
    {xScale = 1.48, yScale=3.1, x=0,y=0},
    {xScale=3, yScale=3.1,x=-2050, y=0}
}

function moverAdelante(e)
    if e.phase == "ended" then 
        print(e.target.valor)
        if indice >= 0 and indice<=#posiciones then
            indice = indice + e.target.valor
            print(posiciones[indice].xScale, posiciones[indice].yScale, 
                            posiciones[indice].x, posiciones[indice].y  )
            transition.to(fondo, {
                time =1000, 
                xScale=posiciones[indice].xScale, 
                yScale=posiciones[indice].yScale,
                x=posiciones[indice].x,
                y=posiciones[indice].y
            }
            )
        end
    end    
end


 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    print("estoy en la pagina 1")
    fondo = display.newImageRect(sceneGroup,"spiderman2.jpg", CW, CH)
    fondo.anchorX = 0; fondo.anchorY = 0

    local izquierda = display.newImageRect(sceneGroup,"Flecha_izquierda.png", 385, 503)
    izquierda.x = CW/2 - 100
    izquierda.y = CH -150
    izquierda.xScale=0.3; izquierda.yScale=0.3
    izquierda.anchorX = 0; izquierda.anchorY = 0
    izquierda.valor = -1

    local derecha = display.newImageRect(sceneGroup,"Flecha_derecha.png", 385, 503)
    derecha.x = CW/2 + 100
    derecha.y = CH -150
    derecha.xScale=0.3; derecha.yScale=0.3
    derecha.anchorX = 0; derecha.anchorY = 0
    derecha.valor = 1
    izquierda:addEventListener("touch", moverAdelante)
    derecha:addEventListener("touch", moverAdelante)
    -- print(fondo.width, fondo.height)
    local panel_derecho = display.newRect(sceneGroup,CW,0,50,CH)
    panel_derecho:setFillColor(0.4)
    panel_derecho.anchorX=1; panel_derecho.anchorY=0
    fondo:scale(3.3,3.1)
    -- print(fondo.contentWidth, fondo.height)
    fondo:translate(0,- 1/3 * fondo.contentHeight)
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