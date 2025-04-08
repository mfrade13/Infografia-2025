local composer = require("composer")
local scene = composer.newScene()

local CW = display.contentWidth
local CH = display.contentHeight

local nombreElemento = nil
local simbolo = nil
local masa = nil
local electrones = nil
local atomo = nil

local imagen=nil

local dynamicGroup = nil


local function calcularConfiguracionElectronica(numeroAtomico)
    -- Orden de llenado de los orbitales según la regla de Aufbau
    local niveles = {
        {"1s", 2}, {"2s", 2}, {"2p", 6}, {"3s", 2}, {"3p", 6}, {"4s", 2},
        {"3d", 10}, {"4p", 6}, {"5s", 2}, {"4d", 10}, {"5p", 6}, {"6s", 2},
        {"4f", 14}, {"5d", 10}, {"6p", 6}, {"7s", 2}, {"5f", 14}, {"6d", 10}, {"7p", 6}
    }

       -- Anomalía para Rodio (Rh) - Z = 45
     if numeroAtomico == 45 then
        local configuracion = {
            {"1s", 2}, {"2s", 2}, {"2p", 6},
            {"3s", 2}, {"3p", 6}, {"3d", 10},
            {"4s", 2}, {"4p", 6}, {"4d", 8},
            {"5s", 1}
        }

        local configString = "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d⁸ 5s¹"
        return configuracion, configString
    end

    -- Anomalía para Paladio (Pd) - Z = 46
     if numeroAtomico == 46 then
        local configuracion = {
            {"1s", 2}, {"2s", 2}, {"2p", 6},
            {"3s", 2}, {"3p", 6}, {"3d", 10},
            {"4s", 2}, {"4p", 6}, {"4d", 10}
            -- sin 5s
        }

        local configString = "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰"
        return configuracion, configString
    end

    -- Anomalía para Plata (Ag) - Z = 47
	if numeroAtomico == 47 then
	    local configuracion = {
	        {"1s", 2}, {"2s", 2}, {"2p", 6},
	        {"3s", 2}, {"3p", 6}, {"3d", 10},
	        {"4s", 2}, {"4p", 6}, {"4d", 10},
	        {"5s", 1}  -- 5s¹
	    }

	    local configString = "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s² 4p⁶ 4d¹⁰ 5s¹"
	    return configuracion, configString
	end

	-- Anomalía para Cromo (Cr) - Z = 24
	if numeroAtomico == 24 then
	    local configuracion = {
	        {"1s", 2}, {"2s", 2}, {"2p", 6},
	        {"3s", 2}, {"3p", 6}, {"3d", 5},
	        {"4s", 1}   -- 4s¹
	    }

	    local configString = "1s² 2s² 2p⁶ 3s² 3p⁶ 3d⁵ 4s¹"
	    return configuracion, configString
	end

	-- Anomalía para Cobre (Cu) - Z = 29
	if numeroAtomico == 29 then
	    local configuracion = {
	        {"1s", 2}, {"2s", 2}, {"2p", 6},
	        {"3s", 2}, {"3p", 6}, {"3d", 10},
	        {"4s", 1}   -- 4s¹
	    }

	    local configString = "1s² 2s² 2p⁶ 3s² 3p⁶ 3d¹⁰ 4s¹"
	    return configuracion, configString
	end

    local electronesRestantes = numeroAtomico
    local configuracion = {}

    -- Distribuir los electrones en los niveles
    for _, orbital in ipairs(niveles) do
        local nombre, capacidad = orbital[1], orbital[2]
        if electronesRestantes > 0 then
            local electronesEnOrbital = math.min(electronesRestantes, capacidad)
            table.insert(configuracion, {nombre, electronesEnOrbital})
            electronesRestantes = electronesRestantes - electronesEnOrbital
        else
            break
        end
    end

    -- Convertir a string formateado
    local configString = ""
    for _, item in ipairs(configuracion) do
        configString = configString .. item[1] .. "⁰" .. item[2] .. " "
    end

    return configuracion, configString
end

function mostrarConfiguracionElectronica(sceneGroup, numeroAtomico)
    
    local _, configString = calcularConfiguracionElectronica(numeroAtomico)

    -- Cuadro de información
    local infoBoxWidth = 300
    local infoBoxHeight = 80
    local infoBox = display.newRect(sceneGroup, CW - infoBoxWidth / 2 - 350, CH-130, infoBoxWidth, infoBoxHeight)
    infoBox:setFillColor(0.9, 0.9, 0.9) 
    infoBox:setStrokeColor(0.2, 0.2, 0.7)  
    infoBox.strokeWidth = 3

    -- Texto con la configuración electrónica
    local infoText = "Configuración Electrónica:\n" .. configString

    local info = display.newText({
        parent = dynamicGroup,
        text = infoText,
        x = CW - infoBoxWidth / 2-350,
        y = CH-130,
        font = native.systemFontBold,
        fontSize = 18,
        align = "center",
        width = infoBoxWidth - 10
    })
    info:setFillColor(0) 
end

local function calcularDistribucionNiveles(numeroAtomico)
    local niveles = {
        {"1s", 2}, {"2s", 2}, {"2p", 6}, {"3s", 2}, {"3p", 6}, {"4s", 2},
        {"3d", 10}, {"4p", 6}, {"5s", 2}, {"4d", 10}, {"5p", 6}, {"6s", 2},
        {"4f", 14}, {"5d", 10}, {"6p", 6}, {"7s", 2}, {"5f", 14}, {"6d", 10}, {"7p", 6}
    }

    local electronesRestantes = numeroAtomico--electrones que aún quedan por distribuir
    local distribucionNiveles = {} --tabla vacía que almacenará la cantidad de electrones en cada subnivel de energía.

    --Anomalia Escandio
    if numeroAtomico == 45 then
        return {
            [1] = 2,  -- 1s²
            [2] = 8,  -- 2s² 2p⁶
            [3] = 18, -- 3s² 3p⁶ 3d¹⁰
            [4] = 9,  -- 4s² 4p⁶ 4d⁸
            [5] = 1   -- 5s¹
        }
    end

    -- Anomalía para Paladio (Pd) - Z = 46
    if numeroAtomico == 46 then
        return {
            [1] = 2,   -- 1s²
            [2] = 8,   -- 2s² 2p⁶
            [3] = 18,  -- 3s² 3p⁶ 3d¹⁰
            [4] = 10,  -- 4s² 4p⁶ 4d¹⁰
            [5] = 0    -- 5s⁰ (anómalo)
        }
    end

     -- Anomalía para la Plata (Ag) - Z = 47
    if numeroAtomico == 47 then
        return {
            [1] = 2,   -- 1s²
            [2] = 8,   -- 2s² 2p⁶
            [3] = 18,  -- 3s² 3p⁶ 3d¹⁰
            [4] = 18,  -- 4s² 4p⁶ 4d¹⁰
            [5] = 1    -- 5s¹
        }
    end

    -- Anomalía para Cromo (Cr) - Z = 24
	if numeroAtomico == 24 then
	    return {
	        [1] = 2,   -- 1s²
	        [2] = 8,   -- 2s² 2p⁶
	        [3] = 6,   -- 3s² 3p⁶ 3d⁵
	        [4] = 1    -- 4s¹
	    }
	end

	-- Anomalía para Cobre (Cu) - Z = 29
	if numeroAtomico == 29 then
	    return {
	        [1] = 2,   -- 1s²
	        [2] = 8,   -- 2s² 2p⁶
	        [3] = 18,  -- 3s² 3p⁶ 3d¹⁰
	        [4] = 1    -- 4s¹
	    }
	end
    -- Recorre la tabla 'niveles', que contiene configuraciones de orbitales
    for _, orbital in ipairs(niveles) do
          -- Extrae el número del nivel energético desde el nombre del orbital 
        local nivel = tonumber(orbital[1]:sub(1,1)) 
         -- Obtiene la capacidad máxima de electrones de ese orbital
        local capacidad = orbital[2]

        if electronesRestantes > 0 then
            -- Para evitar que un orbital tenga más electrones de los que puede soportar.
            local electronesEnOrbital = math.min(electronesRestantes, capacidad)
            
            -- Sumar electrones al nivel correspondiente
            distribucionNiveles[nivel] = (distribucionNiveles[nivel] or 0) + electronesEnOrbital
            
            electronesRestantes = electronesRestantes - electronesEnOrbital
        else
            break
        end
    end

    return distribucionNiveles
end

-- Función para dibujar el modelo de Bohr
local function dibujarModeloBohr(dynamicGroup, simbolo, numeroAtomico, masaAtomica)
    local nivelesElectronicos = calcularDistribucionNiveles(numeroAtomico)
    
    local centroX, centroY = CW / 2, CH / 2  -- Centro del átomo
    local radioBase = 50  -- Radio base del primer nivel
    local incrementoRadio = 30  -- Separación entre niveles

    local contadorNivel = 1
     -- Dibujar el núcleo
    local nucleo = display.newCircle(dynamicGroup, centroX, centroY, 30)
    nucleo:setFillColor(1, 0, 0)  -- Rojo para el núcleo
    nucleo:setStrokeColor(0)
    nucleo.strokeWidth = 3

    -- Nombre del elemento en el núcleo
    local textoNucleo = display.newText({
        parent = dynamicGroup,
        text = simbolo,
        x = centroX,
        y = centroY,
        font = native.systemFontBold,
        fontSize = 18,
        align = "center"
    })
    textoNucleo:setFillColor(1, 1, 1)  -- Texto blanco

    -- Calcular protones y neutrones
    local protones = numeroAtomico
    local neutrones = masaAtomica - numeroAtomico

    -- Dibujar el recuadro de información del núcleo
    local infoBoxWidth, infoBoxHeight = 120, 50
    local infoBox = display.newRect(dynamicGroup, centroX +360, centroY -150 , infoBoxWidth, infoBoxHeight)
    infoBox:setFillColor(1, 1, 1)  
    infoBox:setStrokeColor(1, 0, 0) 
    infoBox.strokeWidth = 2

    -- Texto de protones y neutrones
    local infoText = display.newText({
        parent = dynamicGroup,
        text ="Info Núcleo:\np+: " .. protones .. "\nn: " .. neutrones,
        x = centroX +360,
        y = centroY-150,
        font = native.systemFontBold,
        fontSize = 16,
        align = "center"
    })
    infoText:setFillColor(0) 
    infoBox:setStrokeColor(0.2, 0.2, 0.7)  
    infoBox.strokeWidth = 3

    -- Dibujar los orbitales (círculos vacíos con solo borde)
    for nivel, _ in pairs(nivelesElectronicos) do
        local radio = radioBase + (nivel - 1) * incrementoRadio
        local orbital = display.newCircle(dynamicGroup, centroX, centroY, radio)
        orbital:setFillColor(0, 0, 0, 0) 
        orbital:setStrokeColor(1, 0, 1) 
        orbital.strokeWidth = 2

	    local etiqueta = display.newText({
	        parent = dynamicGroup,
	        text = "n=" .. contadorNivel,
	        x = centroX - radio -5, 
    		y = centroY+15,   
	        font = native.systemFontBold,
	        fontSize = 14
	    })
	    etiqueta:setFillColor(0, 0, 0)

        contadorNivel = contadorNivel + 1
    end

    -- Dibujar electrones en cada nivel
    for nivel, electrones in pairs(nivelesElectronicos) do
        local radio = radioBase + (nivel - 1) * incrementoRadio
        for i = 1, electrones do
            local angulo = (i - 1) * (360 / electrones)
            local radianes = math.rad(angulo)
            local electronX = centroX + radio * math.cos(radianes)
            local electronY = centroY + radio * math.sin(radianes)

            local electron = display.newCircle(dynamicGroup, electronX, electronY, 5, 2)
            electron:setFillColor(0, 0, 1)  
            
        end
    end

     -- texto informativo caso especial
    if numeroAtomico == 24 or numeroAtomico == 29 or numeroAtomico == 45 or numeroAtomico == 46 or numeroAtomico == 47 then
        local casoEspecialText = "Caso Especial"
        local casoEspecial = display.newText({
            parent = dynamicGroup,
            text = casoEspecialText,
            x = centroX,
            y = centroY + 180,
            font = native.systemFontBold,
            fontSize = 16,
            align = "center"
        })
        casoEspecial:setFillColor(1, 0, 0) 
    end
end

function info(dynamicGroup, nombreElemento, masa, electrones, atomo)
	  -- Cuadro de información del elemento
    local infoBoxWidth = 200
    local infoBoxHeight = 180
    local infoBox = display.newRect(dynamicGroup, CW - infoBoxWidth / 2 - 20, CH / 2, infoBoxWidth, infoBoxHeight)  
    infoBox:setStrokeColor(0.2, 0.2, 0.7)  
    infoBox.strokeWidth = 3

     -- Calcular el número de protones (Z es el número atómico)
    local protones = atomo  
    print(protones)
    -- Calcular el número de neutrones
    local neutrones = masa - atomo  -- Masa atómica - Número atómico

    -- Texto con la información del elemento
    local infoText = "Elemento: " .. nombreElemento .. "\n" ..
                     "Número Atómico: " .. atomo .. "\n" ..
                     "Masa Atómica: " .. masa .. "\n" ..
                     "Protones: " .. protones .. "\n" ..
                     "Neutrones: " .. neutrones .. "\n" ..
                     "Electrones: " .. electrones

   local info = display.newText({
    parent = dynamicGroup,
    text = infoText,
    x = CW - infoBoxWidth / 2 - 20,
    y = CH / 2,
    font = native.systemFontBold,  
    fontSize = 18, 
    align = "center"
})
   info:setTextColor(0) 
end

function goToTabla( self, event )
	 if event.phase == "ended" then
        local options = {effect = "slideUp", time = 1000}
        composer.gotoScene( "tabla", options)
    end
    return true
end


function scene:create(event)
    local sceneGroup = self.view

-- Fondo de la tabla periódica
    local fondo = display.newImageRect(sceneGroup, "fondo2.jpg", CW,CH)
    fondo.x = CW/2
    fondo.y = CH/2

    local titulo = display.newText({
        parent = sceneGroup,
        text = "Modelo Atómico de Bohr",
        x = CW/2,
        y = CH/2-250,
        font = native.systemFontBold,
        fontSize = 36
    })
    titulo:setFillColor(0) 

    dynamicGroup = display.newGroup()  
    sceneGroup:insert(dynamicGroup)

     -- Obtener los parámetros 
    params = event.params
    nombreElemento = params.nombreElemento
    masa = params.masa
    electrones = params.electrones
    atomo = params.atomo
    simbolo=params.simbolo
    print("Elemento seleccionado: " .. nombreElemento)
    print("Masa: " .. masa)
    print("Electrones: " .. electrones)
    print("Protones (átomo): " .. atomo)
    print("Simbolo: " .. simbolo)

	mostrarConfiguracionElectronica(dynamicGroup, atomo)
	dibujarModeloBohr(dynamicGroup, simbolo, atomo, masa)
	info(dynamicGroup,nombreElemento, masa, electrones, atomo)

	local btn  =  display.newImageRect( sceneGroup,"descarga.jpg", 200, 100)
    btn.x = 150
    btn.y = 120
    btn.touch=goToTabla
    btn:addEventListener("touch")

    imagen=display.newImageRect(dynamicGroup, "Conejito.jpg", 200, 200)
    imagen.x=170;imagen.y=400
end

function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        if dynamicGroup == nil then
            dynamicGroup = display.newGroup()  
            self.view:insert(dynamicGroup)
        end

         -- Volver a dibujar el modelo atómico de Bohr con la nueva selección
        local params = event.params
        if params then
            simbolo=params.simbolo
            nombreElemento = params.nombreElemento
            masa = params.masa
            electrones = params.electrones
            atomo = params.atomo

            mostrarConfiguracionElectronica(dynamicGroup, atomo)
            dibujarModeloBohr(dynamicGroup, simbolo, atomo, masa)
            info(dynamicGroup, nombreElemento, masa, electrones, atomo)
        end
        imagen=display.newImageRect(dynamicGroup, "Conejito.jpg", 200, 200)
        imagen.x=170;imagen.y=400
    end

end


function scene:hide(event)
    local phase = event.phase
    if phase == "will" then -- Limpiar la escena eliminando todos los elementos del grupo
    	dynamicGroup:removeSelf()
        dynamicGroup = nil        
    end
end


function scene:destroy(event)

end

-- Escuchar los eventos de la escena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
