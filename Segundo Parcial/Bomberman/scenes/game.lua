local composer = require("composer")
local scene = composer.newScene()

local rows = 13
local cols = 13
local map = {}

local minScreen = math.min(display.contentWidth, display.contentHeight)
local cellSize = math.floor(minScreen / math.max(rows, cols))


-- Variables globales para el jugador
local player
local playerRow = 2
local playerCol = 2

-- Variables de control para las bombas
local activeBombs = {}
local explosionRange = 2 

-- Variables para enemigos
local nEnemies = 3
local enemies = {}
local enemySpeed = 500 -- milisegundos entre movimientos


-- Variables para animacion
local sprite_options = {width = 64, height = 96, numFrames = 40}
local sprite_sheet = graphics.newImageSheet("bomberman_sprite.png", sprite_options)
local sequence = {
    {name = "up", frames = {16, 17, 18, 19, 20}, time = 50, loopCount = 0},
    {name = "down", frames = {26, 27, 28, 29, 30}, time = 50, loopCount = 0},
    {name = "left", frames = {31, 32, 33, 34, 35}, time = 50, loopCount = 0},
    {name = "right", frames = {21, 22, 23, 24, 25}, time = 50, loopCount = 0}
}

local enemy_options = {width = 64, height = 96, numFrames = 40}
local enemy_sheet = graphics.newImageSheet("enemy_sprite.png", enemy_options)
local enemy_sequence = {
    {name = "up", frames = {16, 17, 18, 19, 20}, time = 50, loopCount = 0},
    {name = "down", frames = {26, 27, 28, 29, 30}, time = 50, loopCount = 0},
    {name = "left", frames = {31, 32, 33, 34, 35}, time = 50, loopCount = 0},
    {name = "right", frames = {21, 22, 23, 24, 25}, time = 50, loopCount = 0}
}

-- Funcion para llenar la matriz del mapa
local function generateMap()
    for row = 1, rows do
        map[row] = {}
        for col = 1, cols do
            if row == 1 or col == 1 or row == rows or col == cols or (row % 2 == 1 and col % 2 == 1) then
                map[row][col] = 1 -- muro indestructible
            else
                map[row][col] = math.random() < 0.2 and 2 or 0 -- aleatoriamente bloques
            end
        end
    end

    -- Zonas libres iniciales (esquinas seguras)
    map[2][2] = 0
    map[2][3] = 0
    map[3][2] = 0
end

-- Función para renderizar el mapa
local function drawMap(group)
    for row = 1, rows do
        for col = 1, cols do
            local cellType = map[row][col]
            local x = (col - 1) * cellSize + cellSize / 2
            local y = (row - 1) * cellSize + cellSize / 2

            local image

            if cellType == 1 then
                image = display.newImageRect(group, "block.png", cellSize, cellSize) 
            elseif cellType == 2 then
                image = display.newImageRect(group, "wall.png", cellSize, cellSize) 
            else
                image = display.newImageRect(group, "grass.png", cellSize, cellSize) 
            end

            image.x = x
            image.y = y
        end
    end
end


-- Funcion para crear al jugador
local function spawnPlayer(group)
    local x = (playerCol - 1) * cellSize + cellSize / 2
    local y = (playerRow - 1) * cellSize + cellSize / 2

    player = display.newSprite(sprite_sheet, sequence)
    player.x = x
    player.y = y
    player:setSequence("down")
    group:insert(player)

end

-- Funcion para mover al jugador
local function movePlayer(dRow, dCol)
    if not player then return end

    local newRow = playerRow + dRow
    local newCol = playerCol + dCol

    if newRow < 1 or newRow > rows or newCol < 1 or newCol > cols then
        return
    end

    local destination = map[newRow][newCol]

    -- Solo se permite mover a celdas vacias (0).
    if destination == 0 then
        playerRow = newRow
        playerCol = newCol

        local newX = (playerCol - 1) * cellSize + cellSize / 2
        local newY = (playerRow - 1) * cellSize + cellSize / 2
        
        if player then
            -- Cambiar la secuencia de animación según la dirección
            if dRow == -1 then
                player:setSequence("up")
            elseif dRow == 1 then
                player:setSequence("down")
            elseif dCol == -1 then
                player:setSequence("left")
            elseif dCol == 1 then
                player:setSequence("right")
            end
            player:play()

            transition.to(player, {
                time = 100,
                x = newX,
                y = newY,
                onComplete = function()
                    player:pause()
                    player.parent:insert(player)
                end
            })
        end
    end
end

-- Funcion para verificar si el jugador ha ganado
local function checkVictory(sceneGroup)
    if #enemies == 0 then
        local victoryText = display.newText({
            parent = sceneGroup,
            text = "¡Ganaste!",
            x = display.contentCenterX,
            y = display.contentCenterY,
            font = native.systemFontBold,
            fontSize = 48
        })
        victoryText:setFillColor(0, 1, 0)

        timer.performWithDelay(2000, function()
            composer.removeScene("scenes.game")
            composer.gotoScene("scenes.menu")
            
        end)
    end
end


local function explodeAt(row, col, group)
    local function damageCell(r, c)
        if r < 1 or r > rows or c < 1 or c > cols then return false end

        local cellType = map[r][c]
        if cellType == 1 then return false end -- muro indestructible

        local x = (c - 1) * cellSize + cellSize / 2
        local y = (r - 1) * cellSize + cellSize / 2

        -- Efecto de llama
        local flame = display.newRect(group, x, y, cellSize - 6, cellSize - 6)
        flame:setFillColor(1, 0.6, 0)
        timer.performWithDelay(300, function()
            if flame.removeSelf then flame:removeSelf() end
        end)

        -- Verificar enemigos
        for i = #enemies, 1, -1 do
            local e = enemies[i]
            if math.abs(e.x - x) < cellSize * 0.5 and math.abs(e.y - y) < cellSize * 0.5 then
                transition.to(e, {
                    time = 200,
                    alpha = 0,
                    xScale = 0.1,
                    yScale = 0.1,
                    onComplete = function()
                        if e and e.removeSelf then e:removeSelf(); e = nil end
                    end
                })
                table.remove(enemies, i)
                checkVictory(group)
            end

            -- Verificar si el jugador está en la explosión
            if player and player.removeSelf and math.abs(player.x - x) < cellSize * 0.5 and math.abs(player.y - y) < cellSize * 0.5 then
                transition.to(player, {
                    time = 200,
                    alpha = 0,
                    xScale = 0.1,
                    yScale = 0.1,
                    onComplete = function()
                        if player and player.removeSelf then player:removeSelf(); player = nil end
                        local loseText = display.newText({
                            parent = group,
                            text = "¡Perdiste!",
                            x = display.contentCenterX,
                            y = display.contentCenterY,
                            font = native.systemFontBold,
                            fontSize = 48
                        })
                        loseText:setFillColor(1, 0, 0)

                        timer.performWithDelay(2000, function()
                            composer.gotoScene("scenes.menu")
                        end)
                    end
                })
            end
        end

        if cellType == 2 then
            -- Buscar y animar el bloque destructible
            for i = group.numChildren, 1, -1 do
                local obj = group[i]
                if math.abs(obj.x - x) < 2 and math.abs(obj.y - y) < 2 then
                    transition.to(obj, {
                        time = 300,
                        alpha = 0,
                        xScale = 0.5,
                        yScale = 0.5,
                        onComplete = function()
                            -- Reemplazar imagen por vacío después de la explosión
                            if obj.removeSelf then obj:removeSelf() end
                            local empty = display.newImageRect(group, "grass.png", cellSize, cellSize)
                            empty.x, empty.y = x, y
                            
                        end
                    })
                    break
                end
            end
            map[r][c] = 0 -- actualizar mapa
            return false -- detener expansión
        end

        return true -- continuar expansión
    end

    -- Celda central
    damageCell(row, col)

    -- 4 direcciones
    local dirs = { {1,0}, {-1,0}, {0,1}, {0,-1} }
    for _, dir in ipairs(dirs) do
        for i = 1, explosionRange do
            local r = row + dir[1]*i
            local c = col + dir[2]*i
            if not damageCell(r, c) then break end
        end
    end
end



-- Funcion para colocar una bomba
local function placeBomb(group)
    local row = playerRow
    local col = playerCol
    local key = row .. "-" .. col

    -- Evitar poner más de una bomba en la misma celda
    if activeBombs[key] then return end

    -- Marcar en el mapa como bomba (4)
    map[row][col] = 4

    -- Crear la bomba
    local x = (col - 1) * cellSize + cellSize / 2
    local y = (row - 1) * cellSize + cellSize / 2
    local bomb = display.newCircle(group, x, y, cellSize * 0.3)
    bomb:setFillColor(0, 0, 0)
    activeBombs[key] = bomb

    -- Timer para explotar
    timer.performWithDelay(2000, function()
        -- Eliminar visual
        if bomb.removeSelf then
            bomb:removeSelf()
        end
        activeBombs[key] = nil

        -- Liberar la celda en el mapa
        map[row][col] = 0

        -- Ejecutar explosión
        explodeAt(row, col, group)
    end)
end


-- Funcion para crear enemigo
local function spawnEnemy(group, row, col)
    local x = (col - 1) * cellSize + cellSize / 2
    local y = (row - 1) * cellSize + cellSize / 2

    local enemy = display.newSprite(group, enemy_sheet, enemy_sequence)
    enemy.x = x
    enemy.y = y
    
    enemy:play()

    enemy.row = row
    enemy.col = col

    table.insert(enemies, enemy)

    -- Movimiento automático
    local function moveEnemy()
        if not enemy.removeSelf then return end

        local dirs = {
            { -1,  0, "up" },
            {  1,  0, "down" },
            {  0, -1, "left" },
            {  0,  1, "right" },
        }
        local dir = dirs[math.random(1, #dirs)]
        local newRow = enemy.row + dir[1]
        local newCol = enemy.col + dir[2]
        local sequence = dir[3]

        if newRow >= 1 and newRow <= rows and
           newCol >= 1 and newCol <= cols and
           map[newRow][newCol] == 0 then

            enemy.row = newRow
            enemy.col = newCol
            enemy:setSequence(sequence)
            enemy:play()
            

            transition.to(enemy, {
                time = 200,
                x = (newCol - 1) * cellSize + cellSize / 2,
                y = (newRow - 1) * cellSize + cellSize / 2,

                onComplete = function()
                    if enemy and enemy.pause then
                        enemy:pause()
                        enemy.parent:insert(enemy)
                    end

                    if math.random() < 0.05 then
                        local function enemyPlaceBomb()
                            local row = enemy.row
                            local col = enemy.col
                            local key = row .. "-" .. col

                            if not activeBombs[key] and map[row][col] == 0 then
                                map[row][col] = 4

                                local x = (col - 1) * cellSize + cellSize / 2
                                local y = (row - 1) * cellSize + cellSize / 2
                                local bomb = display.newCircle(group, x, y, cellSize * 0.3)
                                bomb:setFillColor(1, 0, 0) 
                                activeBombs[key] = bomb

                                timer.performWithDelay(2000, function()
                                    if bomb.removeSelf then bomb:removeSelf() end
                                    activeBombs[key] = nil
                                    map[row][col] = 0
                                    explodeAt(row, col, group)
                                end)
                            end
                        end

                        enemyPlaceBomb()
                    end

                    if enemy and enemy.setSequence then
                        enemy:setSequence(sequence)
                        enemy:pause() 
                    end
                end
            })
        end

        timer.performWithDelay(enemySpeed, moveEnemy)
    end

    timer.performWithDelay(enemySpeed, moveEnemy)
end

-- Función para iniciar enemigos
local function spawnEnemies(group, count)
    local spawned = 0
    while spawned < count do
        local r = math.random(1, rows)
        local c = math.random(1, cols)

        -- Asegurarse de que esté libre y no muy cerca del jugador
        if map[r][c] == 0 and math.abs(r - playerRow) + math.abs(c - playerCol) > 2 then
            spawnEnemy(group, r, c)
            spawned = spawned + 1
        end
    end
end


-- Funciones de escena
function scene:create(event)
    local sceneGroup = self.view

    local params = event.params or {}
    local dificultad = params.dificultad or "Fácil"

    if dificultad == "Fácil" then
        nEnemies = 3
    elseif dificultad == "Media" then
        nEnemies = 5
    elseif dificultad == "Difícil" then
        nEnemies = 7
    end

    generateMap()

    local mapGroup = display.newGroup()
    sceneGroup:insert(mapGroup)
    mapGroup.x = display.contentCenterX - (cols * cellSize) / 2
    mapGroup.y = display.contentCenterY - (rows * cellSize) / 2    

    drawMap(mapGroup)
    spawnPlayer(mapGroup)


    local function onKey(event)
        if event.phase == "down" then
            if event.keyName == "up" then
                movePlayer(-1, 0)
            elseif event.keyName == "down" then
                movePlayer(1, 0)
            elseif event.keyName == "left" then
                movePlayer(0, -1)
            elseif event.keyName == "right" then
                movePlayer(0, 1)
            elseif event.keyName == "space" then
                placeBomb(mapGroup)
            end
        end
        return false
    end

    spawnEnemies(mapGroup, nEnemies)

    Runtime:addEventListener("key", onKey)
    
end

function scene:hide(event)
    if event.phase == "will" then
        Runtime:removeEventListener("key", onKey)
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("hide", scene)
return scene

