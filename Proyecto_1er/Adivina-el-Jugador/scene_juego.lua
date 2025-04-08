local composer = require( "composer" )
local widget = require("widget")
local json = require("json")
 
local scene = composer.newScene()

local scrollView
local inputField
local contador
local intentosRealizados
local intentosTotales = 5
local currentRow
local jugadorObjetivo


---------------Cargar jugadores-----------------
local function cargarJugadores()
    local path = system.pathForFile("jugadores.json", system.ResourceDirectory)
    local file = io.open(path, "r")

    if not file then
        print("No se pudo abrir el archivo JSON.")
        return
    end

    local contenido = file:read("*a")
    io.close(file)

    local data = json.decode(contenido)

    if not data or #data == 0 then
        print("El JSON está vacío o no es válido.")
        return
    end
    return data
end

local jugadores = cargarJugadores()


----------Elegir jugador aleatorio----------------
local function cargarJugadorAleatorio()
    local data = jugadores
    local indice = math.random(1, #data)
    jugadorObjetivo = data[indice]

    print("Jugador elegido:")
    for k, v in pairs(jugadorObjetivo) do
        print(k .. ": " .. tostring(v))
    end
end

--------------------Normalizar el texto---------------------------
local function normalizarTexto(texto)
    texto = texto:lower()

    -- Reemplaza tildes y letras con acentos
    local acentos = {
        ["á"] = "a", ["é"] = "e", ["í"] = "i", ["ó"] = "o", ["ú"] = "u",
        ["ä"] = "a", ["ë"] = "e", ["ï"] = "i", ["ö"] = "o", ["ü"] = "u",
        ["ñ"] = "n", ["ç"] = "c"
    }

    texto = texto:gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
        return acentos[c] or c
    end)

    -- Elimina cualquier carácter que no sea letra o número
    texto = texto:gsub("[^%w]", "")
    
    return texto
end

--------------Popup derrota-------------------------
local function mostrarPopupDerrota()

    local overlay = display.newRect(CW/2, CH/2, CW, CH)
    overlay:setFillColor(0, 0, 0, 0.5)

    local popupGroup = display.newGroup()
    local emojiGroup = display.newGroup()
    local cuadro = display.newRoundedRect(popupGroup, CW/2, CH/2, CW*3/4, CH/3, 20)
    cuadro:setFillColor(0.8, 0.8, 0.8)
    cuadro.strokeWidth = 6
    cuadro:setStrokeColor( 0.3, 0.3, 0.3 )


    local texto = display.newText({
        parent = popupGroup,
        text = "Derrota... :(",
        x = CW/2,
        y = CH/2,
        font = native.systemFontBold,
        fontSize = 22
    })
    texto:setFillColor(0)

    local function cambiarEscena()
        display.remove(popupGroup)
        display.remove(overlay)
        display.remove(emojiGroup)
        popupGroup = nil
        overlay = nil
        emojiGroup = nil

        composer.gotoScene("scene_menu", { effect = "fade", time = 500 })
    end

    local function emojis()
        local emoji = display.newImageRect("emoji_triste.png", 100, 100)
        emoji.anchorY = 0
        emoji.x = CW*3/4
        emoji.y = CH*2/3
        emojiGroup:insert(emoji)

        local emoji2 = display.newImageRect("emoji_negando.png", 40, 40)
        emoji2.anchorY = 0
        emoji2.x = CW/5
        emoji2.y = CH*5/7
        emojiGroup:insert(emoji2)

        transition.to(emoji, {time = 3000, delay=100, y = CH/12, transition = easing.inBounce})
        transition.to(emoji2, {time = 3000, delay=100,  width = emoji2.width*2.5, height = emoji2.height*2.5,
        onComplete = cambiarEscena})
    end

    popupGroup.y = popupGroup.y+100
    transition.to(popupGroup, {time =1000, delay=100, y = popupGroup.y-100, onComplete = emojis})
end

--------------Popup Victoria-------------------------
local function mostrarPopupVictoria()
    local overlay = display.newRect(CW/2, CH/2, CW, CH)
    overlay:setFillColor(0, 0, 0, 0.5)

    local popupGroup = display.newGroup()
    local emojiGroup = display.newGroup()
    local cuadro = display.newRoundedRect(popupGroup, CW/2, CH/2, CW*3/4, CH/3, 20)
    cuadro:setFillColor(0.8, 0.8, 0.8)
    cuadro.strokeWidth = 6
    cuadro:setStrokeColor( 0.3, 0.3, 0.3 )

    local texto = display.newText({
        parent = popupGroup,
        text = "¡Felicidades, ganaste!",
        x = CW/2,
        y = CH/2,
        font = native.systemFontBold,
        fontSize = 22
    })
    texto:setFillColor(0)

    local function cambiarEscena()
        display.remove(popupGroup)
        display.remove(overlay)
        display.remove(emojiGroup)
        popupGroup = nil
        overlay = nil
        emojiGroup = nil

        composer.gotoScene("scene_menu", { effect = "fade", time = 500 })
    end

    local function emojis()
        local emoji = display.newImageRect("emoji_nerd.png", 100, 100)
        emoji.anchorY = 0
        emoji.x = CW*3/4
        emoji.y = CH*5/6
        emojiGroup:insert(emoji)

        local emoji2 = display.newImageRect("emoji_pulgar.jpg", 40, 40)
        emoji2.anchorY = 0
        emoji2.x = CW/5
        emoji2.y = CH*5/7
        emojiGroup:insert(emoji2)

        transition.to(emoji, {time = 3000, delay=100, y = CH/12, transition = easing.inOutBack})
        transition.to(emoji2, {time = 3000, delay=100,  width = emoji2.width*2.5, height = emoji2.height*2.5,
        onComplete = cambiarEscena})
    end

    popupGroup.y = popupGroup.y+100
    transition.to(popupGroup, {time =1000, delay=100, y = popupGroup.y-100, onComplete = emojis})
    
end


--------------Generar feedback----------------------
local function generarFeedback(objetivo, intento, grupo)
    local feedback = {}

    -- Comparación simple
    local function compararCampo(campo)
        local estado = (objetivo[campo] == intento[campo]) and "acierto" or "error"
        table.insert(feedback, {
            campo = campo,
            valor = intento[campo],
            estado = estado
        })
    end

    -- Comparación con mayor/menor
    local function compararNumerico(campo)
        local estado = "error"
        if intento[campo] == objetivo[campo] then
            estado = "acierto"
        elseif intento[campo] < objetivo[campo] then
            estado = "mayor"
        elseif intento[campo] > objetivo[campo] then
            estado = "menor"
        end
        table.insert(feedback, {
            campo = campo,
            valor = intento[campo],
            estado = estado
        })
    end

    compararCampo("nacionalidad")
    compararCampo("liga")
    compararCampo("equipo")
    compararCampo("posicion")
    compararNumerico("edad")
    compararNumerico("dorsal")
    

    return feedback
end


-------------------------------------------------

-- Funcion para añadir filas al scroll
local function addFeedbackRow(intento)
    
    local feedback = generarFeedback(jugadorObjetivo, intento)
    local feedbackText = {}

    for i, f in ipairs(feedback) do
        --print(f.campo, f.valor, f.estado)
        table.insert( feedbackText, f.estado) 
    end

    local rowHeight = 30
    currentRow = currentRow + 1
    local width = scrollView.width
    local yOffset = (currentRow - 1) * rowHeight + rowHeight/2
    local xOffset = width/2

    local cabecerasText = {
        "Nacionalidad", "Liga", "Equipo", "Posición", "Edad", "Dorsal"  -- Feedback ficticio (todo mal)
    }

    local columnCount = #cabecerasText
    local cellWidth = (scrollView.width) / columnCount

    ----------Nombre del jugador-------------
    local background = display.newRect(scrollView, xOffset, yOffset, scrollView.width, rowHeight)
    background:setFillColor(0.1, 0.1, 0.1, 0.5)
    scrollView:insert(background)

    local nom_jugador = display.newText({
        parent = scrollView,
        text = intento["nombre"],
        x = xOffset,
        y = yOffset,
        font = native.systemFont,
        fontSize = 8,
        
    })
    nom_jugador:setFillColor(1, 1, 1)
    scrollView:insert(nom_jugador)

    -----------Cabeceras de feedback-------------
    currentRow = currentRow + 1
    local yOffset2 = (currentRow - 1) * rowHeight + rowHeight/2

    local background1 = display.newRect(scrollView, xOffset, yOffset2, scrollView.width, rowHeight)
    background1:setFillColor(0.1, 0.1, 0.1, 0.3)
    scrollView:insert(background1)

    for i = 1, columnCount do
        local cabecera = display.newText({
            parent = scrollView,
            text = cabecerasText[i],
            x = (i-1) * cellWidth + cellWidth/2,
            y = yOffset2,
            font = native.systemFont,
            fontSize = 8,
            
        })
        cabecera:setFillColor(1, 1, 1)
        scrollView:insert(cabecera)
    end


    ------------Resultados de intento-----------
    currentRow = currentRow + 1
    local yOffset3 = (currentRow - 1) * rowHeight + rowHeight/2

    local background2 = display.newRect(scrollView, xOffset, yOffset3, scrollView.width, rowHeight)
    background2:setFillColor(0.1, 0.1, 0.1, 0.3)
    scrollView:insert(background2)

    for i = 1, columnCount do
        local cell = display.newText({
            parent = scrollView,
            text = feedbackText[i],
            x = (i-1) * cellWidth + cellWidth/2,
            y = yOffset3,
            font = native.systemFont,
            fontSize = 8,
            
        })
        cell:setFillColor(1, 1, 1)
        scrollView:insert(cell)
    end
    
    scrollView:setScrollHeight(currentRow * rowHeight)

    local acertado = false
    for i,v in ipairs(feedback) do
        if v.estado == "acierto" then
            acertado = true
        else
            acertado = false
        end
    end

    return acertado

end

------------------------------------------------------------

----------Función que se llamará cuando se presione el botón exit------------
local function onExitButtonRelease()
    print("Botón 'Exit' presionado")    
    composer.gotoScene("scene_menu", { effect = "fade", time = 500 })
    
end

------------Función para buscar jugador----------------
local function buscarJugadorPorNombre(nombreNormalizado)
    for i = 1, #jugadores do
        if jugadores[i].nombre_normalizado == nombreNormalizado then
            return jugadores[i]  -- Devuelve el jugador si hay coincidencia exacta
        end
    end
    print("jugador no encontrado")
    return nil  -- No se encontró
end

----------Función que se ejecuta al presionar el botón de enviar------------
local function onCheckButtonRelease()
    local texto = inputField.text or ""
    local normalizado = normalizarTexto(texto)
    local jugador = buscarJugadorPorNombre(normalizado)

    
    if jugador ~= nil then
        print("Jugador ingresado:")
        for k, v in pairs(jugador) do
            print(k .. ": " .. tostring(v))
        end
        local acertado = addFeedbackRow(jugador)
        intentosRealizados = intentosRealizados + 1
        contador.text = "Intentos: " .. intentosRealizados

        if acertado then
            print("ganaste")
            if inputField then
                inputField:removeSelf()
                inputField = nil
            end
            mostrarPopupVictoria()
        else
            if intentosRealizados == intentosTotales then
                print("perdiste")
                if inputField then
                    inputField:removeSelf()
                    inputField = nil
                end
                mostrarPopupDerrota()
            end 
        end
        
    end
    
    if inputField then
        inputField.text = ""
    end
    
    print("Texto ingresado:", normalizado)
    --print(normalizado)
    
    
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    ---------- Fondo ----------
    local fondo0 = display.newImageRect( sceneGroup, "fondo4.jpg", CW, CH )
    --display.newRect(sceneGroup, 0, 0, CW, CH)
    fondo0.anchorX = 0; fondo0.anchorY = 0
    --fondo0:setFillColor(0.15, 0.15, 0.2) 
    fondo0:setFillColor(0.5, 0.5, 0.55) 

    ---------- Título ----------
    local adivina_text_options =
    {
        parent = sceneGroup,
        text = "¡Adivina el Jugador!",
        x = CW / 2,
        y = CH / 5,
        font = "Segoe UI Semibold",
        fontSize = 28,
    }
    local adivina_text = display.newText(adivina_text_options)
    adivina_text:setFillColor(1, 1, 1)    
    

    ---------- Botón Exit ----------
    local exitButton = widget.newButton({
        shape = "roundedRect",
        width = CW * 0.2,
        height = CH * 0.06,
        cornerRadius = 8,
        fillColor = { default={ 0.6, 0.1, 0.1, 1 }, over={ 0.9, 0.2, 0.2, 1 } },
        strokeColor = { default={ 0.4, 0.05, 0.05 }, over={ 0.6, 0.1, 0.1 } },
        strokeWidth = 2,
        label = "Salir",
        font = "Franklin Gothic Medium",
        fontSize = 14,
        labelColor = { default={ 1, 1, 1 }, over={ 0.9, 0.9, 0.9 } },
        onRelease = onExitButtonRelease
    })
    exitButton.x = CW / 8
    exitButton.y = CH / 16
    sceneGroup:insert(exitButton)

    


end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        cargarJugadorAleatorio()
        intentosRealizados = 0
        currentRow = 0  

        ---------- Contador de intentos ----------
        local contador_options =
        {
            parent = sceneGroup,
            text = "Intentos: " .. intentosRealizados,
            x =  CW * 3/ 4,
            y = CH / 16,
            font = "Segoe UI Semibold",
            fontSize = 14,
        }
        contador = display.newText(contador_options)
        contador:setFillColor(1, 1, 1)

        ---------- Input ----------
        inputField = native.newTextField(CW / 2, CH / 3, CW * 5 / 6, CH / 14)
        inputField.placeholder = "Escribe el nombre de un jugador"
        inputField.size = 16
        

        ----------ScrollView listener----------
        --[[
        local function scrollListener( event )
        
            local phase = event.phase
            if ( phase == "began" ) then print( "Scroll view was touched" )
            elseif ( phase == "moved" ) then print( "Scroll view was moved" )
            elseif ( phase == "ended" ) then print( "Scroll view was released" )
            end
        
            -- In the event a scroll limit is reached...
            if ( event.limitReached ) then
                if ( event.direction == "up" ) then print( "Reached bottom limit" )
                elseif ( event.direction == "down" ) then print( "Reached top limit" )
                elseif ( event.direction == "left" ) then print( "Reached right limit" )
                elseif ( event.direction == "right" ) then print( "Reached left limit" )
                end
            end
        
            return true
        end
        --]]

        ---------- ScrollView ----------
        scrollView = widget.newScrollView({
            top = CH * 0.5,
            left = CW * 0.05,
            width = CW * 0.9,
            height = CH * 0.45,
            horizontalScrollDisabled = true,
            backgroundColor = {0.95, 0.95, 0.95},
            --listener = scrollListener
        })
        sceneGroup:insert(scrollView)
        
        ---------- Boton Check ----------
        local checkButton = widget.newButton({
            shape = "roundedRect",
            width = CW * 0.5,
            height = CH * 0.06,
            cornerRadius = 10,
            fillColor = { default={ 0.2, 0.4, 0.3, 1 }, over={ 0.1, 0.8, 0.4, 1 } },
            strokeColor = { default={ 0.1, 0.27, 0.15 }, over={ 0.2, 0.5, 0.2 } },
            strokeWidth = 2,
            label = "Comprobar",
            font = "Franklin Gothic Medium",
            fontSize = 16,
            labelColor = { default={ 1, 1, 1 }, over={ 0.9, 0.9, 0.9 } },
            onRelease = onCheckButtonRelease
        })
        checkButton.x = CW / 2
        checkButton.y = inputField.y + inputField.height * 0.75 + checkButton.height / 2 + 10
        
        sceneGroup:insert(checkButton)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    --local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        if inputField then
            inputField:removeSelf()
            inputField = nil
        end
        if contador then
            contador:removeSelf()
            contador = nil
        end
        if scrollView then
            scrollView:removeSelf()
            scrollView = nil
        end
        if checkButton then
            checkButton:removeSelf()
            checkButton = nil
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