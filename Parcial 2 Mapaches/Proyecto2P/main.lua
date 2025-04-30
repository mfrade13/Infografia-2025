-- Iniciar físicas
local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

-- Ocultar la barra de estado
display.setStatusBar(display.HiddenStatusBar)

-- Medidas de pantalla
local screenW = display.contentWidth
local screenH = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- === CARGAR FONDO ===
local background = display.newImage("assets/fondo_grilla.png")
background.x = centerX
background.y = centerY

-- Escalar para que TODA la imagen quepa en pantalla (aunque deje bordes)
local scale = math.min(screenW / background.width, screenH / background.height)
background:scale(scale, scale)

-- === CARGAR MAPACHE (animación de caminar hacia la izquierda) ===
local mapacheSheetOptions = {
    width = 100,  -- Ancho de cada imagen
    height = 150, -- Alto de cada imagen
    numFrames = 3,  -- Número total de imágenes en la hoja (3 en este caso)
    sheetContentWidth = 300,  -- 100 px * 3 imágenes
    sheetContentHeight = 150 -- Alto total de la hoja de sprites (150 px * 1 imagen)
}

-- Crear la hoja de sprites para el Mapache caminando hacia la izquierda
local mapacheSheet = graphics.newImageSheet("assets/Mapache/Mapache_I.png", mapacheSheetOptions)

-- Crear la hoja de sprites para el Mapache caminando hacia la derecha
local mapacheSheetDerecha = graphics.newImageSheet("assets/Mapache/Mapache_D.png", mapacheSheetOptions)

-- === CARGAR CONEJA (animación de Coneja) ===
local conejaSheetOptions = {
    width = 100,  -- Ancho de cada imagen
    height = 150, -- Alto de cada imagen
    numFrames = 3,  -- Número total de imágenes en la hoja (3 en este caso)
    sheetContentWidth = 300,  -- 100 px * 3 imágenes
    sheetContentHeight = 150 -- Alto total de la hoja de sprites (150 px * 1 imagen)
}

-- Crear la hoja de sprites para la Coneja
local conejaSheet = graphics.newImageSheet("assets/Coneja/Coneja.png", conejaSheetOptions)

-- Animación estática de la Coneja (solo Coneja_1)
local conejaEstatica = display.newSprite(conejaSheet, {name="estatica", start=1, count=1, time=500, loopCount=0})  -- Solo Coneja_1
conejaEstatica.x = centerX
conejaEstatica.y = centerY
conejaEstatica:play()

-- Animación de ataque (Coneja lanza helado con Coneja_1, Coneja_2, Coneja_3)
local conejaAtacar = display.newSprite(conejaSheet, {name="atacar", start=1, count=3, time=500, loopCount=0})  -- Coneja_1, Coneja_2, Coneja_3
conejaAtacar.isVisible = false  -- No mostrarla al principio

-- Mantener la posición de la Coneja
local conejaX = conejaEstatica.x
local conejaY = conejaEstatica.y

-- === GRILLA LÓGICA ===
local columnas = 10
local filas = 5
local gridWidth = 1200
local gridHeight = 715
local anchoCelda = gridWidth / columnas   -- ~108 px
local altoCelda = gridHeight / filas      -- ~144 px
local gridOffsetX = 700  -- alineado al primer cuadro visible horizontalmente
local gridOffsetY = 300  -- alineado verticalmente con la fila superior

-- Función para obtener posición de una celda (columna = horizontal, fila = vertical)
function getPosicionCelda(fila, columna)
    local x = gridOffsetX + (columna - 0.5) * anchoCelda
    local y = gridOffsetY + (fila - 0.5) * altoCelda
    return x, y
end

-- Obtener la posición de la primera casilla (fila 1, columna 1)
local x, y = getPosicionCelda(1, 1)

-- Colocar la Coneja en la primera casilla de la grilla
conejaEstatica.x = x
conejaEstatica.y = y
conejaX = x
conejaY = y

-- === CARGAR PROYECTIL (bola de helado) ===
local proyectiles = {}  -- Asegúrate de que la tabla se inicialice aquí

local proyectilSpeed = 1000  -- Velocidad del proyectil


-- === FUNCIONES DE LA CONEJA ===

-- Función para lanzar un nuevo proyectil
function lanzarProyectil()
    local proyectil = display.newImage("assets/Proyectil/Proyectil.png")
    proyectil.width = 50  -- Ajustar tamaño del proyectil
    proyectil.height = 50
    proyectil.x = conejaX  -- Posición horizontal de la Coneja
    proyectil.y = conejaY  -- Posición vertical de la Coneja
    proyectil.isVisible = true  -- Hacerlo visible
    proyectil.tag = "proyectil"  -- Asignar el tag "proyectil" para la colisión

    -- Agregarlo a la tabla de proyectiles
    table.insert(proyectiles, proyectil)

    -- Agregar física al proyectil para que pueda colisionar
    physics.addBody(proyectil, "dynamic", {isSensor=true})  -- Usamos isSensor para evitar efectos físicos no deseados

    -- Mover el proyectil hacia la derecha (hasta el límite de la grilla)
    transition.to(proyectil, {
        x = gridOffsetX + gridWidth,  -- Límite derecho de la grilla
        time = proyectilSpeed,  -- Velocidad de movimiento
        onComplete = function()
            -- El proyectil desaparece después de llegar al límite derecho
            proyectil.isVisible = false
        end
    })
end


-- Función para cambiar la animación a ataque cuando presionemos la barra espaciadora
function iniciarAtaque()
    conejaEstatica.isVisible = false  -- Ocultar animación estática
    conejaAtacar.isVisible = true    -- Mostrar animación de ataque
    conejaAtacar.x = conejaX  -- Mantener la misma posición
    conejaAtacar.y = conejaY
    conejaAtacar:play()  -- Iniciar animación de ataque

    -- Lanzar el proyectil (bola de helado)
    lanzarProyectil()
end

-- Función para volver a la animación estática cuando no se presione la barra espaciadora
function volverACaminar()
    conejaAtacar.isVisible = false  -- Ocultar animación de ataque
    conejaEstatica.isVisible = true  -- Mostrar animación estática
    conejaEstatica.x = conejaX  -- Mantener la misma posición
    conejaEstatica.y = conejaY
    conejaEstatica:play()  -- Reanudar animación estática
end

-- Función para mover la Coneja dentro de los límites de la grilla (AWSD y flechas)
local moveSpeed = 1  -- Mover 1 celda por vez

local function moverConeja(direccion)
    -- Mover según la dirección, respetando los límites de la grilla
    if direccion == "izquierda" and conejaX > gridOffsetX + anchoCelda then
        conejaX = conejaX - anchoCelda
    elseif direccion == "derecha" and conejaX < gridOffsetX + gridWidth - anchoCelda then
        conejaX = conejaX + anchoCelda
    elseif direccion == "arriba" and conejaY > gridOffsetY + altoCelda then
        conejaY = conejaY - altoCelda
    elseif direccion == "abajo" and conejaY < gridOffsetY + gridHeight - altoCelda then
        conejaY = conejaY + altoCelda
    end
    -- Actualizar la posición de la Coneja
    conejaEstatica.x = conejaX
    conejaEstatica.y = conejaY
    conejaAtacar.x = conejaX
    conejaAtacar.y = conejaY
end

-- Escuchar las teclas AWSD y las flechas para mover a la Coneja
local function onKeyEvent(event)
    if event.keyName == "space" then
        if event.phase == "down" then
            iniciarAtaque()
        elseif event.phase == "up" then
            volverACaminar()
        end
    elseif event.keyName == "a" or event.keyName == "left" then
        if event.phase == "down" then
            moverConeja("izquierda")
        end
    elseif event.keyName == "d" or event.keyName == "right" then
        if event.phase == "down" then
            moverConeja("derecha")
        end
    elseif event.keyName == "w" or event.keyName == "up" then
        if event.phase == "down" then
            moverConeja("arriba")
        end
    elseif event.keyName == "s" or event.keyName == "down" then
        if event.phase == "down" then
            moverConeja("abajo")
        end
    end
    return false
end

-- Configurar el evento de la tecla
Runtime:addEventListener("key", onKeyEvent)

-- === GENERAR MAPACHE EN LA ÚLTIMA COLUMNA ===
-- Función para generar un mapache en la última columna
local function generarMapache()
    -- Colocar el mapache en la última columna
    local columna = columnas  -- Última columna (columna 10)
    local fila = math.random(1, filas)  -- Colocarlos aleatoriamente en las filas
    
    -- Obtener la posición de la celda
    local x, y = getPosicionCelda(fila, columna)
    
    -- Crear un mapache con la animación de caminar hacia la izquierda
    local mapache = display.newSprite(mapacheSheet, {name="caminar", start=1, count=3, time=500, loopCount=0})
    mapache.x = x
    mapache.y = y
    mapache:play()

    -- Agregar física al mapache para detectar colisiones
    physics.addBody(mapache, "dynamic", {density=1.0, friction=0.3, bounce=0.2})
    mapache.isSensor = true  -- Esto permite que no se vea afectado por la gravedad

    -- Movimiento del mapache hacia la izquierda
    transition.to(mapache, {
        x = gridOffsetX - 50,  -- Límite izquierdo de la grilla
        time = 15000,  -- Tiempo para cruzar la grilla
        onComplete = function()
            if mapache then
                mapache:removeSelf()  -- Eliminar mapache al llegar al límite
            end
        end
    })

    -- Detectar colisiones entre el mapache y las bolas de helado
    function mapache:collision(event)
        if event.phase == "began" then
            if event.other.tag == "proyectil" then
                -- Cambiar la dirección del mapache (caminar hacia la derecha)
                if mapache then  -- Verificar si el mapache aún existe
                    mapache:removeSelf()  -- Eliminar el mapache que se mueve a la izquierda
                    
                    -- Crear un nuevo mapache caminando hacia la derecha
                    local mapacheDerecha = display.newSprite(mapacheSheetDerecha, {name="caminar", start=1, count=3, time=500, loopCount=0})
                    mapacheDerecha.x = x
                    mapacheDerecha.y = y
                    mapacheDerecha:play()

                    -- Movimiento del mapache hacia la derecha
                    transition.to(mapacheDerecha, {
                        x = gridOffsetX + gridWidth,  -- Límite derecho de la grilla
                        time = 15000,  -- Tiempo para cruzar la grilla
                        onComplete = function()
                            if mapacheDerecha then
                                mapacheDerecha:removeSelf()  -- Eliminar mapache al llegar al límite derecho
                            end
                        end
                    })
                end
            end
        end
    end

    -- Agregar el listener de colisión al mapache
    mapache:addEventListener("collision")
end



-- Generar un mapache cada 2 segundos
local function generarMapacheCadaXSegundos()
    generarMapache()  -- Generar un nuevo mapache
end

-- Configurar el temporizador para generar un mapache cada 2000 ms (2 segundos)
timer.performWithDelay(2000, generarMapacheCadaXSegundos, 0)  -- 0 indica que se repetirá indefinidamente


-- === DIBUJAR GRILLA (opcional para depurar) ===
for fila = 1, filas do
    for columna = 1, columnas do
        local x, y = getPosicionCelda(fila, columna)
        local rect = display.newRect(x, y, anchoCelda, altoCelda)
        rect:setFillColor(0, 0, 0, 0.03)
        rect:setStrokeColor(0.1, 0.1, 0.1, 0.2)
        rect.strokeWidth = 1
    end
end
