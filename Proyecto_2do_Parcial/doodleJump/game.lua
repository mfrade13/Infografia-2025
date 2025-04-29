local composer = require("composer")
local physics = require("physics")
local scene = composer.newScene()

local cw = display.contentWidth
local ch = display.contentHeight

-- VARIABLES GLOBALES
local personaje
local plataformas = {}
local score = 0
local scoreText
local ultimaPlataformaY
local plataformaGroup
local cameraGroup
local hudGroup  
local fondo
local velocidadMovimiento = 150
local alturaSalto = -450
local scoreStep = 130
local nextScoreY
local gameLoopTimer

if _G.currentScore == nil then
    _G.currentScore = 0
end

-- CREACION DE PLATAFORMAS
local function crearPlataforma(x, y)
    local plataforma = display.newImageRect(plataformaGroup, "plataforma.png", 80, 20)
    plataforma.x = x
    plataforma.y = y
    physics.addBody(plataforma, "static", {bounce = 0, friction = 0})
    plataforma.name = "plataforma"
    table.insert(plataformas, plataforma)
    return plataforma
end

-- ELIMINAR PLATAFORMAS FUERA DE CAMARA
local function eliminarPlataformas()
    if #plataformas == 0 or not personaje then return end
    for i = #plataformas, 1, -1 do
        if plataformas[i] and plataformas[i].y > ch then
            display.remove(plataformas[i])
            plataformas[i] = nil
            table.remove(plataformas, i)
        end
    end
end

-- EFECTO TELETRANSPORTE
local function teletransportePersonaje()
    if not personaje then return end
    if personaje.x < 0 then
        personaje.x = cw
    elseif personaje.x > cw then
        personaje.x = 0
    end
end

function scene:create(event)
    local sceneGroup = self.view
    physics.start()
    physics.setGravity(0, 18)
    score = 0

    plataformaGroup = display.newGroup()
    hudGroup = display.newGroup()  
    cameraGroup = display.newGroup()
    
    sceneGroup:insert(hudGroup)    
    sceneGroup:insert(cameraGroup) 
    cameraGroup:insert(plataformaGroup)

    -- FONDO
    fondo = display.newImageRect(hudGroup, "fondo.jpg", cw, ch)
    fondo.x = cw/2
    fondo.y = ch/2

    -- CREACION PLATAFORMAS INICIALES
    for i = 1, 10 do
        local x = math.random(0, cw)
        local y = ch - (i * 120)
        crearPlataforma(x, y)
        ultimaPlataformaY = y
    end

    -- CREACION PERSONAJE
    local imagenPersonaje = _G.personajeSeleccionado == "yugiInicio" and "yugi.png" or "seiya.png"
    personaje = display.newImageRect(cameraGroup, imagenPersonaje, 80, 100)
    personaje.x = plataformas[1].x
    personaje.y = ch - 130
    physics.addBody(personaje, "dynamic", {bounce = 0, radius = 30, friction = 0})
    personaje:setLinearVelocity(0, alturaSalto)

    -- TEXTO SCORE
    scoreText = display.newText({
        parent = sceneGroup,
        text = "SCORE: " .. score,
        x = cw / 2,
        y = 30,  
        font = "cooper black",
        fontSize = 40
    })
    scoreText:setFillColor(1, 112/255, 0)
    nextScoreY = personaje.y - scoreStep
    
    -- FUNCION MOVIMIENTO PERSONAJE
    function moverPersonaje(event)
        if not personaje then return true end
        if event.phase == "began" then
            local vx, vy = personaje:getLinearVelocity()
            if event.x < cw / 2 then
                personaje.xScale = -1
                personaje:setLinearVelocity(-velocidadMovimiento, vy)
            else
                personaje.xScale = 1
                personaje:setLinearVelocity(velocidadMovimiento, vy)
            end
        end
        return true
    end

    -- FUNCION COLISION
    function onCollision(event)
        if not personaje then return end
        
        if event.phase == "began" and event.other.name == "plataforma" then
            local vx, vy = personaje:getLinearVelocity()
            if vy > 0 and personaje.y < event.other.y  then
                personaje:setLinearVelocity(vx, alturaSalto)
            end
        end
    end

    -- FUNCION GAME LOOP
    function gameLoop()
        if not personaje then 
            if gameLoopTimer then
                timer.cancel(gameLoopTimer)
                gameLoopTimer = nil
            end
            return 
        end
        teletransportePersonaje()
        
        --  MOVIMIENTO CAMARA
        local cameraOffset = ch / 2 - personaje.y 
        if cameraGroup and cameraGroup.y < cameraOffset then
            cameraGroup.y = cameraGroup.y + (cameraOffset - cameraGroup.y) * 0.1
        end

        -- ACTUALIZAR SCORE
        if personaje.y < nextScoreY then
            score = score + 1
            _G.currentScore = score
            if scoreText then
                scoreText.text = "SCORE: " .. score
            end
            nextScoreY = nextScoreY - scoreStep
        end

        --CREACION DE PLATAFORMAS CONSTANTE
        while ultimaPlataformaY > personaje.y - ch do
            local x = math.random(40, cw - 40)
            ultimaPlataformaY = ultimaPlataformaY - 120 --math.random(100, 150)
            crearPlataforma(x, ultimaPlataformaY)
            --scoreText:toFront()
        end
        eliminarPlataformas()

        -- GAMEOVER
        if cameraGroup then
            local bottomEdge = -cameraGroup.y + ch
            if personaje.y > bottomEdge then  
                Runtime:removeEventListener("touch", moverPersonaje)
                personaje:removeEventListener("collision", onCollision)
                --[[
                if gameLoopTimer then
                    timer.cancel(gameLoopTimer)
                    gameLoopTimer = nil
                end
                ]]
                local finalScore = score
                timer.performWithDelay(100, function()
                    composer.gotoScene("gameover", {
                        effect = "fade",
                        time = 500
                    })
                end)
            end
        end
    end
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
    elseif phase == "did" then
        if personaje then
            Runtime:addEventListener("touch", moverPersonaje)
            personaje:addEventListener("collision", onCollision)
            gameLoopTimer = timer.performWithDelay(30, gameLoop, 0)
        else
            print("Personaje no se creó correctamente")
        end
    end
end

function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then

        if gameLoopTimer then
            timer.cancel(gameLoopTimer)
            gameLoopTimer = nil
        end

        if personaje then
            personaje:removeEventListener("collision", onCollision)
        end
        Runtime:removeEventListener("touch", moverPersonaje)
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
    if gameLoopTimer then
        timer.cancel(gameLoopTimer)
        gameLoopTimer = nil
    end

    if personaje then
        personaje:removeEventListener("collision", onCollision)
    end
    Runtime:removeEventListener("touch", moverPersonaje)
    
    for i = #plataformas, 1, -1 do
        if plataformas[i] then
            display.remove(plataformas[i])
            plataformas[i] = nil
        end
    end
    plataformas = {}
    
    if personaje then
        display.remove(personaje)
        personaje = nil
    end
    
    if scoreText then
        display.remove(scoreText)
        scoreText = nil
    end
    
    if fondo then
        display.remove(fondo)
        fondo = nil
    end
    
    if plataformaGroup then
        display.remove(plataformaGroup)
        plataformaGroup = nil
    end
    
    if hudGroup then
        display.remove(hudGroup)
        hudGroup = nil
    end
    
    if cameraGroup then
        display.remove(cameraGroup)
        cameraGroup = nil
    end
    
    physics.stop()
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene