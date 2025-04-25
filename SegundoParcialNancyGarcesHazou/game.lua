local composer = require("composer")
local scene = composer.newScene()

-- cargamos modulos necesarios para fisica, configuracion y el personaje
local physics = require("physics")  -- modulo de fisica de corona
local config = require("settings")  -- configuraciones del juego (ancho/alto de pantalla, etc.)
local Character = require("character")  -- modulo personalizado para el personaje

-- iniciamos el motor de fisica y configuramos la gravedad (0 en x, 25 en y)
physics.start()
physics.setGravity(0, 25)

-- variables globales para la escena
local cameraGroup  -- grupo que contendra todos los elementos que se mueven con la camara
local player  -- objeto del jugador
local coinCount = 0  -- contador de monedas recolectadas
local coinText  -- objeto de texto para mostrar el contador de monedas
local currentCameraMode = "follow"  -- modo actual de la camara (follow/center/panoramic)
local fixedCameraX = 0  -- posicion x fija para el modo "center" de la camara
local enterFrameListener  -- referencia al listener de enterframe para poder eliminarlo despues

-- configuracion de la hoja de sprites para las monedas (animacion)
local coinSheetOptions = {
    width = 58,  -- ancho de cada frame
    height = 70,  -- alto de cada frame
    numFrames = 6  -- numero total de frames en la animacion
}
-- cargamos la hoja de sprites de la moneda desde el archivo png
local coinSheet = graphics.newImageSheet("assets/coin.png", coinSheetOptions)

-- tablas para almacenar los objetos del juego
local groundPieces = {}  -- piezas del suelo
local platformPieces = {}  -- plataformas
local coinSprites = {}  -- monedas
local bgImages = {}  -- imagenes de fondo

-- calculamos la posicion y del suelo basado en la altura de la pantalla
local groundY = config.HEIGHT - 330 + config.HEIGHT * 0.300

-- funcion para crear un fondo en la posicion x especificada
local function createBackground(x)
    -- creamos un nuevo imagerect (imagen rectangular) para el fondo
    local bg = display.newImageRect(cameraGroup, "assets/background.png", 2000, config.HEIGHT)
    bg.x = x  -- posicion x
    bg.y = config.HEIGHT / 2 + config.HEIGHT * 0  -- posicion y (centro vertical)
    bg:toBack()  -- lo enviamos al fondo para que no tape otros elementos
    table.insert(bgImages, bg)  -- lo añadimos a la tabla de imagenes de fondo
end

-- funcion para crear un segmento de suelo en la posicion x especificada
local function createGround(x)
    -- creamos un rectangulo para representar el suelo
    local ground = display.newRect(cameraGroup, x, groundY, 2000, 5)
    ground:setFillColor(0.6, 0.3, 0)  -- color marron
    -- añadimos cuerpo fisico estatico (no se mueve) sin rebote
    physics.addBody(ground, "static", { bounce=0 })
    table.insert(groundPieces, ground)  -- añadimos a la tabla de piezas de suelo
end

-- funcion para crear plataformas con un desplazamiento inicial en x
local function createPlatforms(xOffset)
    for i = 1, 5 do  -- creamos 5 plataformas
        -- creamos una plataforma como imagerect
        local p = display.newImageRect(cameraGroup, "assets/platform.png", 150, 50)
        -- posicion x: desplazamiento inicial + 300 + incremento basado en indice
        p.x = xOffset + 300 + (i * 300)
        -- posicion y: base 300 - alternancia basada en paridad + ajuste de altura
        p.y = 300 - (i % 2 * 100) + config.HEIGHT * 0.300
        
        physics.addBody(p, "static", { 
            bounce = 0.1,
            -- Definimos un shape (forma) personalizado para la plataforma
            -- Esto hace que la deteccion ocurra solo en la parte superior
            shape = { 
                -40, -1,  -- esquina superior izquierda (x, y)
                40, -1,   -- esquina superior derecha
                40, 1,   -- esquina inferior derecha
                -40, 1   -- esquina inferior izquierda
            }
        })
        
        table.insert(platformPieces, p)  -- añadimos a la tabla de plataformas
    end
end

-- funcion para crear monedas con un desplazamiento inicial en x
local function createCoins(xOffset)
    for i = 1, 5 do  -- creamos 5 monedas
        -- creamos un sprite de moneda usando la hoja de sprites
        local coin = display.newSprite(cameraGroup, coinSheet, { 
            name = "coin",  -- nombre de la secuencia
            start = 1,  -- frame inicial
            count = 6,  -- numero de frames
            time = 800,  -- duracion de la animacion en ms
            loopCount = 0  -- 0 = loop infinito
        })
        -- posicion aleatoria dentro de un rango
        coin.x = xOffset + math.random(100, 1000)
        coin.y = math.random(100, 400) + config.HEIGHT * 0.300
        coin:setSequence("coin")  -- establecemos la secuencia de animacion
        coin:play()  -- iniciamos la animacion
        -- añadimos cuerpo fisico estatico como sensor (no genera colisiones fisicas)
        physics.addBody(coin, "static", { radius=20, isSensor=true })
        coin.isCoin = true  -- marcamos como moneda para identificarla
        table.insert(coinSprites, coin)  -- añadimos a la tabla de monedas
        
        -- añadimos listener de colision para la moneda
        coin:addEventListener("collision", function(event)
            -- solo nos interesan colisiones que comienzan con el jugador
            if event.phase == "began" and event.other == player then
                coinCount = coinCount + 5  -- incrementamos contador
                coinText.text = "$: " .. coinCount  -- actualizamos texto
                coin:removeSelf()  -- eliminamos la moneda
            end
        end)
    end
end

-- funcion para crear/mostrar el contador de monedas
local function createCoinCounter()
    -- si ya existe un texto de monedas, lo eliminamos
    if coinText then
        coinText:removeSelf()
    end
    
    -- creamos un nuevo objeto de texto para mostrar el contador
    coinText = display.newText({
        parent = scene.view,  -- lo añadimos directamente a la escena (no a cameragroup)
        text = "$: " .. coinCount,  -- texto inicial
        x = display.contentWidth - 90,  -- posicion x (cerca del borde derecho)
        y = 90,  -- posicion y (cerca del borde superior)
        fontSize = 20,  -- tamaño de fuente
        font = "Minecraftia-Regular.ttf"
    })
    coinText:setFillColor(1, 1, 1)  -- color blanco
    coinText.anchorX = 1  -- anclaje a la derecha para alineacion
    coinText:toFront()  -- lo traemos al frente para que sea visible
end

-- funcion para crear un limite izquierdo invisible
local function createLeftBoundary()
    -- creamos un rectangulo rojo transparente en el borde izquierdo
    local leftBoundary = display.newRect(cameraGroup, 0, groundY, 10, config.HEIGHT)
    leftBoundary:setFillColor(1, 0, 0, 0)  -- rojo totalmente transparente
    physics.addBody(leftBoundary, "static", { bounce=0 })  -- cuerpo fisico estatico
end

-- funcion para crear un limite superior invisible
local function createTopBoundary()
    -- creamos un rectangulo rojo transparente en el borde superior
    local topBoundary = display.newRect(cameraGroup, config.WIDTH / 2, 0, config.WIDTH, 10)
    topBoundary:setFillColor(1, 0, 0, 0)  -- rojo totalmente transparente
    physics.addBody(topBoundary, "static", { bounce=0 })  -- cuerpo fisico estatico
end

-- funcion para verificar si necesitamos generar mas terreno
local function checkAndGenerate()
    -- calculamos hasta donde podemos ver (posicion del jugador + ancho de pantalla)
    local farthestX = player.x + config.WIDTH
    -- obtenemos la posicion x de la ultima pieza de suelo (o 0 si no hay)
    local lastGroundX = groundPieces[#groundPieces] and groundPieces[#groundPieces].x or 0
    
    -- si el jugador se acerca al final del terreno generado
    if lastGroundX < farthestX then
        -- generamos nuevos elementos con desplazamiento
        createBackground(lastGroundX + 1000)  -- fondo
        createGround(lastGroundX + 2000)  -- suelo
        createPlatforms(lastGroundX + 1000)  -- plataformas
        createCoins(lastGroundX + 1000)  -- monedas
    end
end

-- funcion para manejar eventos de teclado
local function onKeyEvent(event)
    -- si no hay jugador, salimos sin hacer nada
    if not player then return false end
    
    -- fase "down" (tecla presionada)
    if event.phase == "down" then
        -- tecla derecha: mover jugador a la derecha
        if event.keyName == "right" then
            player:setLinearVelocity(200, select(2, player:getLinearVelocity()))
            player:setSequence("right")  -- animacion de correr derecha
            player:play()
        -- tecla izquierda: mover jugador a la izquierda
        elseif event.keyName == "left" then
            player:setLinearVelocity(-200, select(2, player:getLinearVelocity()))
            player:setSequence("left")  -- animacion de correr izquierda
            player:play()
        -- tecla espacio/arriba: saltar
        elseif event.keyName == "space" or event.keyName == "up" then
            -- primer salto si no esta saltando
            if not player.isJumping then
                player:setLinearVelocity(select(1, player:getLinearVelocity()), -550)
                player.isJumping = true
                player:setSequence("jump")  -- animacion de salto
                player:play()
            -- doble salto si esta permitido
            elseif player.canDoubleJump then
                player:setLinearVelocity(select(1, player:getLinearVelocity()), -500)
                player.canDoubleJump = false
            end
        end
    -- fase "up" (tecla liberada)
    elseif event.phase == "up" then
        -- si se libera derecha o izquierda, detener movimiento horizontal
        if event.keyName == "right" or event.keyName == "left" then
            player:setLinearVelocity(0, select(2, player:getLinearVelocity()))
            -- cambiar animacion segun si esta saltando o no
            if player.isJumping then
                player:setSequence("right")
            else
                player:setSequence("idle")  -- animacion de estar quieto
            end
            player:play()
        end
    end
    return false
end

-- funcion para cambiar de personaje (version corregida)
local function switchCharacter()
    -- guardamos la posicion y velocidad actual del jugador
    local currentX = player.x
    local currentY = player.y
    local velX, velY = player:getLinearVelocity()
    local currentSequence = player.sequence
    local isPlaying = player.isPlaying
    local isJumping = player.isJumping  -- guardamos estado de salto
    local canDoubleJump = player.canDoubleJump  -- guardamos estado de doble salto
    
    -- eliminamos el jugador actual
    player:removeSelf()
    player = nil
    
    -- cambiamos el personaje seleccionado
    if _G.selectedCharacter == "alex" then
        _G.selectedCharacter = "billy"
    else
        _G.selectedCharacter = "alex"
    end
    
    -- creamos el nuevo personaje en la misma posicion
    player = Character.createCharacter(currentX, currentY)
    cameraGroup:insert(player)
    
    -- restauramos la velocidad
    player:setLinearVelocity(velX, velY)
    
    -- restauramos los estados de movimiento
    player.isJumping = isJumping
    player.canDoubleJump = canDoubleJump
    
    -- restauramos la animacion correcta basada en el estado actual
    if isJumping then
        player:setSequence("jump")
    elseif velX > 0 then
        player:setSequence("right")
    elseif velX < 0 then
        player:setSequence("left")
    else
        player:setSequence("idle")
    end
    
    -- si estaba reproduciendo, volvemos a play
    if isPlaying then
        player:play()
    end
    
    -- reasignamos la funcion de colision
    player.collision = function(self, event)
        if event.phase == "began" then
            self.isJumping = false
            self.canDoubleJump = true
        end
    end
    player:addEventListener("collision")
    
    -- aseguramos que el nuevo personaje este en el grupo de la camara
    cameraGroup:insert(player)
end

-- funcion de creacion de la escena (se llama una vez al crear la escena)
function scene:create(event)
    -- obtenemos el grupo principal de la escena
    local sceneGroup = self.view
    -- creamos un grupo para los elementos que se mueven con la camara
    cameraGroup = display.newGroup()
    sceneGroup:insert(cameraGroup)  -- lo añadimos a la escena

    -- creamos elementos iniciales del juego
    createBackground(0)  -- fondo inicial
    createGround(0)  -- suelo inicial
    createLeftBoundary()  -- limite izquierdo
    createTopBoundary()  -- limite superior
    createPlatforms(0)  -- plataformas iniciales
    createCoins(0)  -- monedas iniciales

    -- creamos al jugador en la posicion inicial
    player = Character.createCharacter(100, groundY - 100)
    cameraGroup:insert(player)  -- lo añadimos al grupo de la camara

    -- creamos el contador de monedas
    createCoinCounter()

    -- boton de salir (para volver al menu principal)
    local menuButton = display.newRoundedRect(sceneGroup, display.contentCenterX, 30, 100, 30, 12)
    menuButton:setFillColor(0.8, 0.6, 0.3)  -- color naranja
    menuButton.strokeWidth = 2  -- borde
    menuButton:setStrokeColor(0.5, 0.3, 0.1)  -- color del borde
    local menuText = display.newText({ 
        parent = sceneGroup, 
        text = "Salir", 
        x = menuButton.x, 
        y = menuButton.y, 
        fontSize = 16,
        font = "Minecraftia-Regular.ttf" })
    -- evento para volver al menu con transicion de fade
    menuButton:addEventListener("tap", function()
        composer.gotoScene("menu", { effect = "fade", time = 500 })
    end)

    -- boton para cambiar modo de camara
    local cameraButton = display.newRoundedRect(sceneGroup, display.contentCenterX + 120, 30, 80, 30, 12)
    cameraButton:setFillColor(1, 0.2, 0.2)  -- color verde 
    cameraButton.strokeWidth = 2
    cameraButton:setStrokeColor(1, 0.6, 0.6)
    local cameraText = display.newText({ 
        parent = sceneGroup, 
        text = "Cámara", 
        x = cameraButton.x, 
        y = cameraButton.y, 
        fontSize = 14, 
        font = "Minecraftia-Regular.ttf" })

    -- evento para cambiar entre modos de camara
    cameraButton:addEventListener("tap", function()
        if currentCameraMode == "follow" then
            currentCameraMode = "center"
            fixedCameraX = -player.x + display.contentCenterX
        elseif currentCameraMode == "center" then
            currentCameraMode = "panoramic"
        else
            currentCameraMode = "follow"
        end
    end)

    -- boton de superpoder (cambio de personaje)
    local superButton = display.newRoundedRect(sceneGroup, display.contentCenterX - 200, 30, 120, 30, 12)
    superButton:setFillColor(0.5, 0.6, 0.2)  -- color rojo
    superButton.strokeWidth = 2
    superButton:setStrokeColor(0.4, 0.5, 0.1) 
    local superText = display.newText({ 
        parent = sceneGroup, 
        text = "SUPERPODER", 
        x = superButton.x, 
        y = superButton.y, 
        fontSize = 14, 
        font = "Minecraftia-Regular.ttf" })

    -- funcion para el efecto de explosion al usar el superpoder
    local function activateSuperpower()
        -- creamos un grupo para la explosion
        local explosionGroup = display.newGroup()
        sceneGroup:insert(explosionGroup)

        -- creamos 50 circulos para el efecto de explosion
        for i = 1, 50 do
            local circle = display.newCircle(explosionGroup, 
                math.random(90, config.WIDTH),  -- posicion x aleatoria
                math.random(90, config.HEIGHT),  -- posicion y aleatoria
                math.random(90, 400))  -- radio aleatorio
            circle:setFillColor(1, math.random(), 0)  -- color rojo/amarillo aleatorio
            
            -- animamos cada circulo para que se mueva y desaparezca
            transition.to(circle, {
                x = circle.x + math.random(-700, 700),  -- movimiento aleatorio en x
                y = circle.y + math.random(-700, 700),  -- movimiento aleatorio en y
                alpha = 0,  -- desvanecer
                time = 800,  -- duracion
                transition = easing.outQuad,  -- tipo de interpolacion
                onComplete = function(obj)
                    display.remove(obj)  -- eliminar al completar
                end
            })
        end

        -- tiempo de cambio de personaje
        timer.performWithDelay(300, function()
            switchCharacter()  -- cambiamos al otro personaje
        end)
    end

    -- asignamos el evento al boton de superpoder
    superButton:addEventListener("tap", activateSuperpower)
    
    -- posicionamos inicialmente la camara para seguir al jugador
    cameraGroup.x = -player.x + display.contentCenterX
end

-- funcion que se llama cuando la escena se muestra
function scene:show(event)
    -- solo nos interesa la fase "did" (despues de que la escena esta visible)
    if event.phase == "did" then
        -- si por alguna razon no hay jugador, lo creamos
        if not player then
            player = Character.createCharacter(100, groundY - 100)
            cameraGroup:insert(player)
        end

        -- configuramos el evento de colision para el jugador
        if player then
            player.collision = function(self, event)
                -- cuando comienza una colision (con el suelo o plataforma)
                if event.phase == "began" then
                    self.isJumping = false  -- ya no esta saltando
                    self.canDoubleJump = true  -- puede hacer doble salto otra vez
                end
            end
            player:addEventListener("collision")  -- añadimos el listener
        end

        -- añadimos el listener de teclado
        Runtime:addEventListener("key", onKeyEvent)
        
        -- creamos y añadimos el listener de enterframe (se ejecuta cada frame)
        enterFrameListener = function()
            if player and cameraGroup then
                -- modo de camara que sigue al jugador
                if currentCameraMode == "follow" then
                    local offsetX = -player.x + display.contentCenterX
                    cameraGroup.x = offsetX
                -- modo de camara centrada
                elseif currentCameraMode == "center" then
                    cameraGroup.x = fixedCameraX
                -- modo panoramico (suavizado)
                elseif currentCameraMode == "panoramic" then
                    local targetX = -player.x + display.contentCenterX * 1.5
                    cameraGroup.x = cameraGroup.x + (targetX - cameraGroup.x) * 0.05
                end
                checkAndGenerate()  -- verificamos si necesitamos generar mas terreno
            end
        end
        Runtime:addEventListener("enterFrame", enterFrameListener)

        -- reiniciamos el contador de monedas si existe
        if coinText then
            coinText:removeSelf()
        end
        coinCount = 0
        createCoinCounter()  -- creamos el contador
    end
end

-- funcion que se llama cuando la escena se oculta
function scene:hide(event)
    -- solo nos interesa la fase "will" (antes de ocultar la escena)
    if event.phase == "will" then
        -- eliminamos todos los listeners
        Runtime:removeEventListener("key", onKeyEvent)
        if enterFrameListener then
            Runtime:removeEventListener("enterFrame", enterFrameListener)
        end

        -- eliminamos al jugador si existe
        if player then
            player:removeSelf()
            player = nil
        end

        -- eliminamos el texto de monedas si existe
        if coinText then
            coinText:removeSelf()
            coinText = nil
        end

        -- reiniciamos el contador de monedas
        coinCount = 0
        if coinText then
            coinText.text = "$: " .. coinCount
        end
    end
end

-- añadimos listeners para los eventos de la escena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

-- devolvemos la escena para que corona sdk pueda usarla
return scene