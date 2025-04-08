display.setStatusBar(display.HiddenStatusBar)

local screenW, screenH = display.contentWidth, display.contentHeight

-- =========================
-- GRUPOS PRINCIPALES
-- =========================
local grupoPrincipal = display.newGroup()  -- Contendrá todo
local grupoLienzo = display.newGroup()    -- Para los elementos dibujados
local grupoUI = display.newGroup()        -- Para la interfaz de usuario
local grupoImagen = display.newGroup()    -- Para la imagen superior

grupoPrincipal:insert(grupoImagen)
grupoPrincipal:insert(grupoLienzo)
grupoPrincipal:insert(grupoUI)

-- =========================
-- IMAGEN CALCIFER (arriba de todo)
-- =========================
local calcifer = display.newImageRect(grupoImagen, "assets/calciferpaint.png", 200, 100)

calcifer.x = screenW/2
calcifer.y = 60  -- posición arriba del lienzo

-- =========================
-- LIENZO DE DIBUJO (debajo de la imagen)
-- =========================
local lienzoHeight = screenH - 180  -- reducido para espacio de la imagen
local lienzo = display.newRect(grupoLienzo, screenW/2, 120 + lienzoHeight/2, screenW, lienzoHeight)
lienzo:setFillColor(1)  -- fondo blanco

-- =========================
-- BARRA DE HERRAMIENTAS (parte inferior)
-- =========================
local barra = display.newRect(grupoUI, screenW/2, screenH - 60, screenW, 120)
barra:setFillColor(0.2)  -- color oscuro

-- =========================
-- VARIABLES DEL PROGRAMA
-- =========================
local herramienta = "lapiz"       -- herramienta seleccionada
local colorActual = {0, 0, 0}     -- color actual (negro por defecto)
local colorPrevio = {0, 0, 0}     -- guarda color previo al usar borrador
local tamanoActual = 3            -- grosor del trazo
local lineaActual, inicioFigura, formaTemporal  -- variables temporales
local objetosDibujados = {}       -- tabla para guardar objetos dibujados
local usandoBorrador = false      -- indica si el borrador está activo

-- =========================
-- FUNCIÓN PARA LIMPIAR EL LIENZO (con transición)
-- =========================
local function limpiarLienzo()
    transition.cancel()  -- cancela transiciones pendientes
    for i = #objetosDibujados, 1, -1 do
        if objetosDibujados[i] then
            transition.to(objetosDibujados[i], {
                alpha=0, 
                time=300, 
                onComplete=function(obj) 
                    if obj and obj.removeSelf then obj:removeSelf() end
                end
            })
        end
        objetosDibujados[i] = nil
    end
end

-- =========================
-- FUNCIÓN PARA CREAR CUADRADOS
-- =========================
local function crearCuadrado(x1, y1, x2, y2)
    local w = math.abs(x2 - x1)  -- ancho
    local h = math.abs(y2 - y1)  -- alto
    local cx = (x1 + x2)/2       -- centro x
    local cy = (y1 + y2)/2       -- centro y
    
    -- crear rectángulo en grupoLienzo
    local cuadrado = display.newRect(grupoLienzo, cx, cy, w, h)
    cuadrado:setFillColor(unpack(usandoBorrador and {1,1,1} or colorActual))
    
    -- animación de entrada
    transition.from(cuadrado, {alpha=0, time=200})
    
    -- guardar en lista de objetos
    table.insert(objetosDibujados, cuadrado)
    return cuadrado
end

-- =========================
-- FUNCIÓN PARA CREAR TRIÁNGULOS EQUILÁTEROS
-- =========================
local function crearTrianguloEquilatero(x1, y1, x2, y2)
    local base = x2 - x1
    if math.abs(base) < 5 then base = (base >= 0) and 5 or -5 end  -- tamaño mínimo
    
    local alto = math.abs(base * math.sqrt(3)/2)
    if alto < 5 then alto = 5 end  -- altura mínima
    
    local centroX = (x1 + x2)/2  -- centro x
    local centroY = (y1 + y2)/2  -- centro y

    -- puntos del triángulo
    local p1 = {centroX, centroY - alto/2}        -- vértice superior
    local p2 = {centroX - base/2, centroY + alto/2} -- vértice inferior izquierdo
    local p3 = {centroX + base/2, centroY + alto/2} -- vértice inferior derecho

    -- crear triángulo en grupoLienzo
    local triangulo = display.newPolygon(grupoLienzo, centroX, centroY, {
        p1[1], p1[2], p2[1], p2[2], p3[1], p3[2]
    })
    
    if triangulo then
        triangulo:setFillColor(unpack(usandoBorrador and {1,1,1} or colorActual))
        
        -- animación de entrada con escalado
        transition.from(triangulo, {
            alpha=0, 
            xScale=0.5, 
            yScale=0.5, 
            time=300
        })
        
        table.insert(objetosDibujados, triangulo)
        return triangulo
    end
    return nil
end

-- =========================
-- MANEJADORES DE EVENTOS TÁCTILES
-- =========================
local function manejarTouchLapiz(event)
    if event.phase == "began" then
        -- crear nueva línea
        lineaActual = display.newLine(grupoLienzo, event.x, event.y, event.x, event.y)
        lineaActual:setStrokeColor(unpack(usandoBorrador and {1,1,1} or colorActual))
        lineaActual.strokeWidth = tamanoActual
        table.insert(objetosDibujados, lineaActual)
    elseif event.phase == "moved" and lineaActual then
        -- extender línea
        lineaActual:append(event.x, event.y)
    end
end

local function manejarTouchFiguras(event)
    if event.phase == "began" then
        -- guardar punto inicial
        inicioFigura = {x = event.x, y = event.y}
        if formaTemporal then formaTemporal:removeSelf() end
    elseif event.phase == "moved" and inicioFigura then
        -- eliminar figura temporal previa
        if formaTemporal then formaTemporal:removeSelf() end
        
        -- calcular coordenadas limitadas al lienzo
        local x1, y1 = inicioFigura.x, inicioFigura.y
        local x2 = math.max(0, math.min(event.x, screenW))
        local y2 = math.max(0, math.min(event.y, lienzo.y + lienzo.height/2))
        
        -- crear figura temporal si tiene tamaño suficiente
        if math.abs(x2 - x1) >= 5 and math.abs(y2 - y1) >= 5 then
            if herramienta == "cuadrado" then
                formaTemporal = crearCuadrado(x1, y1, x2, y2)
                if formaTemporal then formaTemporal.alpha = 0.4 end
            elseif herramienta == "triangulo" then
                formaTemporal = crearTrianguloEquilatero(x1, y1, x2, y2)
                if formaTemporal then formaTemporal.alpha = 0.4 end
            end
        end
    elseif event.phase == "ended" and inicioFigura then
        -- eliminar figura temporal
        if formaTemporal then 
            formaTemporal:removeSelf()
            formaTemporal = nil
        end
        
        -- calcular coordenadas finales
        local x1, y1 = inicioFigura.x, inicioFigura.y
        local x2 = math.max(0, math.min(event.x, screenW))
        local y2 = math.max(0, math.min(event.y, lienzo.y + lienzo.height/2))
        
        -- crear figura final si tiene tamaño suficiente
        if math.abs(x2 - x1) >= 5 and math.abs(y2 - y1) >= 5 then
            if herramienta == "cuadrado" then
                crearCuadrado(x1, y1, x2, y2)
            elseif herramienta == "triangulo" then
                crearTrianguloEquilatero(x1, y1, x2, y2)
            end
        end
    end
end

-- =========================
-- EVENTO TOUCH PRINCIPAL
-- =========================
local function touchLienzo(event)
    -- limitar al área del lienzo
    if event.y > lienzo.y + lienzo.height/2 or event.y < lienzo.y - lienzo.height/2 or
       event.x < 0 or event.x > screenW then return end

    -- redirigir a manejador según herramienta
    if herramienta == "lapiz" or herramienta == "borrador" then
        manejarTouchLapiz(event)
    elseif herramienta == "cuadrado" or herramienta == "triangulo" then
        manejarTouchFiguras(event)
    end
end

-- registrar evento touch
Runtime:addEventListener("touch", touchLienzo)

-- =========================
-- CREACIÓN DE BOTONES CON EFECTOS
-- =========================
local function crearBoton(x, y, emoji, nombre)
    local boton = display.newGroup()
    grupoUI:insert(boton)
    
    -- fondo del botón
    local fondo = display.newCircle(boton, 0, 0, 20)
    fondo:setFillColor(0.8)
    fondo.alpha = 0.3
    
    -- icono del botón
    local txt = display.newText(boton, emoji, 0, 0, native.systemFontBold, 24)
    
    -- posición del botón
    boton.x, boton.y = x, y
    
    -- evento tap
    boton:addEventListener("tap", function()
        -- Cambiar herramienta
        herramienta = nombre
        
        -- Manejar cambio de herramienta a borrador
        if herramienta == "borrador" then
            colorPrevio = {unpack(colorActual)}  -- Guardar color actual
            usandoBorrador = true
        else
            -- Si estaba usando borrador, restaurar color previo
            if usandoBorrador then
                colorActual = {unpack(colorPrevio)}
                usandoBorrador = false
            end
        end
        
        -- efecto de pulsación
        transition.to(boton, {xScale=1.2, yScale=1.2, time=100})
        transition.to(boton, {xScale=1.0, yScale=1.0, delay=100, time=100})
    end)
    
    -- efecto hover
    boton:addEventListener("touch", function(e)
        if e.phase == "began" then
            transition.to(fondo, {alpha=0.6, time=100})
        elseif e.phase == "ended" or e.phase == "cancelled" then
            transition.to(fondo, {alpha=0.3, time=100})
        end
        return true
    end)
    
    return boton
end

-- =========================
-- INTERFAZ DE USUARIO
-- =========================

-- botones de herramientas
crearBoton(40, screenH - 100, "✏️", "lapiz")
crearBoton(100, screenH - 100, "🧽", "borrador")
crearBoton(160, screenH - 100, "⬛", "cuadrado")
crearBoton(220, screenH - 100, "▲", "triangulo")

-- botón para limpiar lienzo
local btnLimpiar = crearBoton(screenW - 40, screenH - 100, "🗑️", "limpiar")
btnLimpiar:addEventListener("tap", limpiarLienzo)

-- selector de colores
local colores = {
    {1, 0, 0},  -- rojo
    {0, 1, 0},  -- verde
    {0, 0, 1},  -- azul
    {0, 0, 0}   -- negro
}

for i = 1, #colores do
    local x = 40 + (i - 1) * 40
    local circ = display.newCircle(grupoUI, x, screenH - 40, 15)
    circ:setFillColor(unpack(colores[i]))
    circ.strokeWidth = 1
    circ:setStrokeColor(0)
    
    circ:addEventListener("tap", function()
        if not usandoBorrador then  -- Solo cambiar color si no estamos usando el borrador
            colorActual = colores[i]
            -- efecto de selección
            transition.to(circ, {xScale=1.3, yScale=1.3, time=100})
            transition.to(circ, {xScale=1.0, yScale=1.0, delay=100, time=100})
        end
    end)
end

-- selector de tamaño
local tamano = {3, 5, 10}  -- grosores disponibles
for i = 1, #tamano do
    local x = 220 + (i - 1) * 40
    local circ = display.newCircle(grupoUI, x, screenH - 40, tamano[i]/2 + 4)
    circ:setFillColor(1)  -- blanco
    circ.strokeWidth = 1
    circ:setStrokeColor(0)  -- borde negro
    
    circ:addEventListener("tap", function()
        tamanoActual = tamano[i]
        -- efecto de selección
        transition.to(circ, {xScale=1.3, yScale=1.3, time=100})
        transition.to(circ, {xScale=1.0, yScale=1.0, delay=100, time=100})
    end)
end