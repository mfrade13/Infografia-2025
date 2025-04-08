local composer = require( "composer" )
 
local scene = composer.newScene()

local CW = display.contentWidth
local CH = display.contentHeight
local btns_region = {}
local btn_volver = nil

local function gotoPokedex(self, event)
    if event.phase == "ended" then
        local options = {effect ="fade", time=100, params = {
            region = self.region,
            id_region = self.id_region
        }}
        composer.gotoScene("pokedex", options)
    end
    return true
end

local function gotoInicio(self, event)
    if event.phase == "ended" then
        local options = {effect ="fade", time=100}
        composer.gotoScene("inicio", options)
    end
    return true
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    local fondo = display.newImageRect(sceneGroup, "/images/fondo.jpg", 1280, 720)
    fondo.x = CW/2; fondo.y = CH/2
    fondo.xScale = 1.42; fondo.yScale = 1.42

    local regiones = {"Kanto", "Johto", "Hoenn", "Sinnoh", "Unova", "Kalos", "Alola", "Galar", "Paldea", "Nacional"}

    local startX = CW/2 - 200
    local startY = CH/2 - 350

    for i = 1, 9 do
        local x = startX + ((i - 1) % 3) * 200
        local y = startY + math.floor((i - 1) / 3) * 200
        btns_region[i] = display.newImageRect(sceneGroup, "/images/marco.png", 361, 117)
        btns_region[i].x = x; btns_region[i].y = y
        btns_region[i].xScale = 0.5; btns_region[i].yScale = 0.8
        btns_region[i].region = regiones[i]
        btns_region[i].id_region = i
        btns_region[i].touch = gotoPokedex
        local texto = display.newText(sceneGroup, regiones[i], x, y, native.systemFontBold, 35)
        texto:setFillColor(0)
    end

    btns_region[10] = display.newImageRect(sceneGroup, "/images/marco.png", 361, 117)
    btns_region[10].x = CW/2; btns_region[10].y = CH/2 + 250
    btns_region[10].xScale = 0.95; btns_region[10].yScale = 0.8
    btns_region[10].region = regiones[10]
    btns_region[10].id_region = 10
    btns_region[10].touch = gotoPokedex
    local texto_10 = display.newText(sceneGroup, "Pokédex Nacional", CW/2, CH/2 + 2*200 - 150, native.systemFontBold, 35)
    texto_10:setFillColor(0)

    btn_volver = display.newText(sceneGroup, "Volver", CW/2, CH/2 + 2*200, native.systemFontBold, 30)
    btn_volver:setFillColor(0)
    btn_volver.touch = gotoInicio
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        for i = 1, 10 do
            btns_region[i]:addEventListener("touch", btns_region[i])
        end
        btn_volver:addEventListener("touch", btn_volver)
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        for i = 1, 10 do
            btns_region[i]:removeEventListener("touch", btns_region[i])
        end
        btn_volver:removeEventListener("touch", btn_volver)
 
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