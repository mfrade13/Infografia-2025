local composer	= require("composer")
local scene = composer.newScene()

local cw = display.contentWidth
local ch = display.contentHeight

local piezas = {}
local matriz = {}
local nivel
local gridSize
local piezaVacia = {row = 1, col = 1}
local movimientos = 0
local tiempo = 0
local temporizador = nil
local marco
local fondo
local textoTiempo
local textoMovs
local juegoIniciado = false

--ACTUALIZAR TEXTOS
local function actualizarTextos()
    textoMovs.text = "Movimientos: " .. movimientos
    textoTiempo.text = "Tiempo: " .. tiempo .. "s"
end 

--CONTAR TIEMPO
local function contarTiempo()
    tiempo = tiempo + 1
    actualizarTextos()
end

--VERIFICAR PIEZA ADYACENTE
local function esAdyacente(row, col)
    local r, c = piezaVacia.row, piezaVacia.col
    return (math.abs(r - row) + math.abs(c - col)) == 1
end

--VERIFICAR VICTORIA
local function verificarVictoria()
    if not juegoIniciado then
        return false
    end

    local index = 1
    for row = 1, gridSize do
        for col = 1, gridSize do
            if not (row == gridSize and col == gridSize) then
                local pieza = matriz[row][col]
                local ordenCorrecto = piezas[index]
                if pieza ~= ordenCorrecto then
                    return false
                end
                index = index + 1
            end
        end
    end
    return true
end

--MOVER PIEZA
local function moverPieza(pieza)
    local row, col = pieza.row, pieza.col
    if esAdyacente(row, col) then
        local size = 360 / gridSize
        transition.to(pieza, {
            x = marco.x - 180 + (piezaVacia.col - 0.5) * size,
            y = marco.y - 180 + (piezaVacia.row - 0.5) * size,
            time = 200
        })

        matriz[piezaVacia.row][piezaVacia.col] = pieza
        matriz[row][col] = nil

        pieza.row, pieza.col = piezaVacia.row, piezaVacia.col
        piezaVacia.row, piezaVacia.col = row, col

        movimientos = movimientos + 1
        actualizarTextos()

        --VERIFICAR VICTORIA
        if verificarVictoria() then
            if temporizador then
                timer.cancel(temporizador)
                temporizador = nil
            end
            composer.setVariable("tiempoFinal", tiempo)
            composer.setVariable("movimientosFinal", movimientos)
            composer.removeScene("victoria")
            composer.gotoScene("victoria", { effect = "fade", time = 500 })
        end
    end
end

local function moverPiezaInicial(pieza)
    local row, col = pieza.row, pieza.col
    if esAdyacente(row, col) then
        local size = 360 / gridSize
        pieza.x = marco.x - 180 + (piezaVacia.col - 0.5) * size
        pieza.y = marco.y - 180 + (piezaVacia.row - 0.5) * size

        matriz[piezaVacia.row][piezaVacia.col] = pieza
        matriz[row][col] = nil

        pieza.row, pieza.col = piezaVacia.row, piezaVacia.col
        piezaVacia.row, piezaVacia.col = row, col
    end
end

function scene:create(event)
    local sceneGroup = self.view
    nivel = composer.getVariable("nivelSeleccionado")

    movimientos = 0
    tiempo = 0
    juegoIniciado = false

    gridSize = nivel == "facil" and 3 or (nivel == "medio" and 4 or 5)
    local piezaSize = 360 / gridSize

    fondo = display.newImageRect(sceneGroup, "fondoGame.jpg", cw, ch)
    fondo.x = cw/2
    fondo.y = ch/2

    marco = display.newImageRect(sceneGroup, "marcoRompecabezas.png", 510, 510)
    marco.x = cw/2 -- 150
    marco.y = ch/2

    local imagenArchivo = {
        facil = "dragonBlancoFacil.jpg",
        medio = "hadesMedio.jpg",
        dificil = "kanekiDificil.jpg"
    }

    --DIVIDIR PIEZAS DE LA IMAGEN
    local sheetOptions = {
        width = piezaSize,
        height = piezaSize,
        numFrames = gridSize * gridSize - 1,
        sheetContentWidth = piezaSize * gridSize,
        sheetContentHeight = piezaSize * gridSize
    }
    local sheet = graphics.newImageSheet(imagenArchivo[nivel], sheetOptions)

    local frameIndex = 1
    for row = 1, gridSize do
        matriz[row] = {}
        for col = 1, gridSize do
            if not (row == gridSize and col == gridSize) then
                local frame = display.newImage(sceneGroup, sheet, frameIndex)
                frame.x = marco.x - 180 + (col - 0.5) * piezaSize
                frame.y = marco.y - 180 + (row - 0.5) * piezaSize
                frame.row = row
                frame.col = col
                frame:addEventListener("tap", function() moverPieza(frame) end)
                piezas[#piezas + 1] = frame
                matriz[row][col] = frame
                frameIndex = frameIndex + 1
            end
        end
    end

    piezaVacia.row = gridSize
    piezaVacia.col = gridSize

    local imagenAyuda = display.newImageRect(sceneGroup, imagenArchivo[nivel], 150, 150)
    imagenAyuda.x = cw - 130
    imagenAyuda.y = ch/2

    local imagenAyuda2 = display.newImageRect(sceneGroup, imagenArchivo[nivel], 150, 150)
    imagenAyuda2.x = 130
    imagenAyuda2.y = ch/2

    --TEXTO TIEMPO
    textoTiempo = display.newText({
        parent = sceneGroup,
        text = "Tiempo: 0s",
        x = display.contentWidth - 180,
        y = 50,
        font = "algerian",
        fontSize = 40
    })
    textoTiempo:setFillColor(0)

    --TEXTO MOVIMIENTOS
    textoMovs = display.newText({
        parent = sceneGroup,
        text = "Movimientos: 0",
        x = 210,
        y = 50,
        font = "algerian",
        fontSize = 40
    })
    textoMovs:setFillColor(0)
    --DESORDENAR ROMPECABEZAS
    for i = 1, 1 do
        local r, c = piezaVacia.row, piezaVacia.col
        local opciones = {}
        if r > 1 then table.insert(opciones, {r - 1, c}) end
        if r < gridSize then table.insert(opciones, {r + 1, c}) end
        if c > 1 then table.insert(opciones, {r, c - 1}) end
        if c < gridSize then table.insert(opciones, {r, c + 1}) end
        local mov = opciones[math.random(#opciones)]
        moverPiezaInicial(matriz[mov[1]][mov[2]]) 
    end

    timer.performWithDelay(200, function()
        juegoIniciado = true
        movimientos = 0
        actualizarTextos()
    end)
       
    --CRONOMETRO
    temporizador = timer.performWithDelay(1000, contarTiempo, 0)
end

function scene:destroy(event)
    local sceneGroup = self.view
    
    if temporizador then
        timer.cancel(temporizador)
        temporizador = nil
    end

    piezas = {}
    matriz = {}
    nivel = nil
    gridSize = 0
    piezaVacia = {row = 1, col = 1}
    movimientos = 0
    tiempo = 0
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then
        if temporizador then
            timer.cancel(temporizador)
        end
    elseif phase == "did" then
    end
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then
    elseif phase == "did" then
        if temporizador then
            timer.cancel(temporizador)
        end
        temporizador = timer.performWithDelay(1000, contarTiempo, 0)
    end
end

--print(temporizador)

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene