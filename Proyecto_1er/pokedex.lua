local composer = require( "composer" )
local json = require( "json" )
local audio = require( "audio" )
 
local scene = composer.newScene()

local CW = display.contentWidth
local CH = display.contentHeight
local btn_volver = nil

local input_numero = nil
local pokemon_actual = nil
local fondo_pokedex = nil
local region
local min_pokedex = nil
local max_pokedex = nil
local limite_regiones = {0, 151, 251, 386, 493, 649, 721, 809, 905, 1025}
local desfase_regional = 0

local id_pkm = nil
local imagen_pkm = nil
local nombre_pkm = nil
local tipo1_pkm = nil
local tipo2_pkm = nil
local peso_pkm = nil
local sonido_pkm = nil

local btn_buscar = nil
local btn_anterior = nil
local btn_siguiente = nil
local btn_rugido = nil
local btn_shiny = nil
local shiny = false

local function gotoMenu(self, event)
    if event.phase == "ended" then
        local options = {effect ="fade", time=100}
        composer.gotoScene("menu", options)
        composer.removeScene("pokedex")
    end
    return true
end

local function reproducirRugido(self, event)
    if event.phase == "ended" and sonido_pkm then
        audio.setVolume(0.1)
        audio.play(sonido_pkm)
    end
    return true
end

local function rugidoDescargado(event)
    if event.isError then
        print("Error al descargar rugido.")
    else
        sonido_pkm = audio.loadStream(event.response.filename, event.response.baseDirectory)
    end
end

local function imagenDescargada(event)
    if event.isError then
        print("Error al descargar la imagen del Pokémon.")
    else
        imagen_pkm = display.newImageRect(event.response.filename, event.response.baseDirectory, 96, 96)
        imagen_pkm.x = CW/2 - 186; imagen_pkm.y = CH/2
        imagen_pkm.alpha = 0 
        imagen_pkm:scale(2, 2)
        transition.to(imagen_pkm, { time = 300, alpha = 1 }) 
    end
end

local function mostrarDatosPokemon(data)

    if imagen_pkm then
        imagen_pkm:removeSelf()
        imagen_pkm = nil
    end

    if sonido_pkm then 
        audio.dispose(sonido_pkm)
        sonido_pkm = nil
    end

    pokemon_actual = data.id
    local id_regional = data.id - desfase_regional

    id_pkm.text = "ID: " .. id_regional
    nombre_pkm.text = "Nombre: " .. data.name:gsub("^%l", string.upper)
    tipo1_pkm.text = "Tipo 1: " .. data.types[1].type.name:gsub("^%l", string.upper)
    tipo2_pkm.text = "Tipo 2: " .. (data.types[2] and data.types[2].type.name or "---"):gsub("^%l", string.upper)
    peso_pkm.text = "Peso: " .. (data.weight/10) .. " kg"

    input_numero.text = tostring(id_regional)

    if shiny then
        network.download(
            data.sprites.front_shiny,
            "GET",
            imagenDescargada,
            "pokemon.png",
            system.TemporaryDirectory
        )
    else
        network.download(
            data.sprites.front_default,
            "GET",
            imagenDescargada,
            "pokemon.png",
            system.TemporaryDirectory
        )
    end
    
    network.download(
        data.cries.latest,
        "GET",
        rugidoDescargado,
        "rugido.mp3",
        system.TemporaryDirectory
    )
    
end

local function networkListener(event)
    if event.isError then
        print("Error en la red")
        nombre_pkm.text = "No se pudo conectar"
    else
        local data = json.decode(event.response)
        if data then
            mostrarDatosPokemon(data)
        else
            print("Error al parsear JSON")
        end
    end
end

local function consultarPokemonPorNumero(numero)    
    if numero >= 0 and numero <= (max_pokedex - min_pokedex + 1) then
        numero = numero + desfase_regional
        local url = "https://pokeapi.co/api/v2/pokemon/" .. numero
        print("Consultando: " .. url)
        network.request(url, "GET", networkListener)
    else
        print("Número fuera de rango: " .. numero)
    end
end

local function buscarPokemon(self, event)
    if event.phase == "ended" then
        local numero = tonumber(input_numero.text)
        if numero then
            consultarPokemonPorNumero(numero)
        else
            print("Número inválido")
        end
    end
    return true
end

local function buscarShiny(self, event)
    if event.phase == "ended" then
        print("Boolean shiny inicial", shiny)
        shiny = not shiny
        print("Boolean shiny final", shiny)
        if shiny then
            btn_shiny:setFillColor(0, 1, 0)
        else
            btn_shiny:setFillColor(1, 0, 0)
        end
        local numero = tonumber(input_numero.text)
        if numero then
            consultarPokemonPorNumero(numero)
        else
            print("Número inválido")
        end
    end
    return true
end

local function siguientePokemon(self, event)
    if event.phase == "ended" then
        if pokemon_actual and pokemon_actual == max_pokedex then
            pokemon_actual = min_pokedex
            consultarPokemonPorNumero(pokemon_actual - desfase_regional)
        elseif pokemon_actual and pokemon_actual < max_pokedex then
            pokemon_actual = pokemon_actual + 1 
            consultarPokemonPorNumero(pokemon_actual - desfase_regional)
        else
            print("No existe un pokemon de referencia")
        end
    end
    return true
end

local function anteriorPokemon(self, event)
    if event.phase == "ended" then
        if pokemon_actual and pokemon_actual == min_pokedex then
            pokemon_actual = max_pokedex
            consultarPokemonPorNumero(pokemon_actual - desfase_regional)
        elseif pokemon_actual and pokemon_actual > min_pokedex then
            pokemon_actual = pokemon_actual - 1 
            consultarPokemonPorNumero(pokemon_actual - desfase_regional)
        else
            print("No existe un pokemon de referencia")
        end
    end
    return true
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    
    local fondo = display.newImageRect(sceneGroup, "/images/fondo.jpg", 1280, 720)
    fondo.x = CW/2; fondo.y = CH/2
    fondo.xScale = 1.42; fondo.yScale = 1.42
    
    region = event.params.region

    btn_volver = display.newText(sceneGroup, "Volver", CW/2, CH/2 + 400, native.systemFontBold, 30)
    btn_volver:setFillColor(0)
    btn_volver.touch = gotoMenu

    local fondo_titulo = display.newImageRect(sceneGroup, "/images/marco3.png", 750, 190)
    fondo_titulo.x = CW/2; fondo_titulo.y = 100
    fondo_titulo.xScale = 0.8; fondo_titulo.yScale = 0.8

    local titulo = display.newText(sceneGroup, "", CW/2, 100, native.systemFontBold, 40)

    if region == "Nacional" then
        titulo.text = "Pokédex " .. region
        min_pokedex = limite_regiones[1] + 1
        max_pokedex = limite_regiones[#limite_regiones]
    else
        titulo.text = "Pokédex de " .. region
        min_pokedex = limite_regiones[event.params.id_region] + 1
        max_pokedex = limite_regiones[event.params.id_region + 1]
    end

    desfase_regional = min_pokedex - 1
    --print("El desfase es de " .. desfase_regional)
    --print(region, min_pokedex, max_pokedex, max_pokedex - min_pokedex + 1, desfase_regional) -------------------------------------------------------------------------------

    input_numero = native.newTextField(CW/2 - 50, 200, 200, 40)
    input_numero.placeholder = "# de Pokémon"

    btn_buscar = display.newRect(sceneGroup, CW/2 + 101, 200, 100, 40)
    btn_buscar.strokeWidth = 1
    btn_buscar:setStrokeColor(0)
    btn_buscar.touch = buscarPokemon

    local texto_buscar = display.newText(sceneGroup, "Buscar", CW/2 + 101, 200, native.systemFontBold, 25)
    texto_buscar:setFillColor(0)

    local fondo_imagen = display.newRect(sceneGroup, CW/2 - 186, CH/2, 250, 170)

    fondo_pokedex = display.newImageRect(sceneGroup, "/images/pokedex2.png", 781, 567)
    fondo_pokedex.x = CW/2 + 1; fondo_pokedex.y = CH/2 + 30
    fondo_pokedex.xScale = 0.95; fondo_pokedex.yScale = 0.95
    
    nombre_pkm = display.newText(sceneGroup, "Nombre: ---", CW/2 + 195, CH/2 - 45, 230, 25, native.systemFont, 16)
    id_pkm = display.newText(sceneGroup, "ID: ---", CW/2 + 135, CH/2 - 16, 110, 25, native.systemFont, 16)
    tipo1_pkm = display.newText(sceneGroup, "Tipo 1: ---", CW/2 + 135, CH/2 + 13, 110, 25, native.systemFont, 16)
    peso_pkm = display.newText(sceneGroup, "Peso: --- kg", CW/2 + 255, CH/2 - 16, 110, 25, native.systemFont, 16)
    tipo2_pkm = display.newText(sceneGroup, "Tipo 2: ---", CW/2 + 255, CH/2 + 13, 110, 25, native.systemFont, 16)

    btn_anterior = display.newRect(sceneGroup, CW/2 + 131, CH/2 + 234, 107, 37)
    btn_anterior:setFillColor(8/255, 64/255, 53/255)
    btn_siguiente = display.newRect(sceneGroup, CW/2 + 262, CH/2 + 234, 107, 37)
    btn_siguiente:setFillColor(8/255, 64/255, 53/255)

    local anterior_imagen = display.newImageRect(sceneGroup, "/images/arrow.png", 500, 500)
    anterior_imagen.x = CW/2 + 129; anterior_imagen.y = CH/2 + 234
    anterior_imagen:scale(-0.12, 0.1)

    local siguiente_imagen = display.newImageRect(sceneGroup, "/images/arrow.png", 500, 500)
    siguiente_imagen.x = CW/2 + 262; siguiente_imagen.y = CH/2 + 234
    siguiente_imagen:scale(0.12, 0.1)

    btn_anterior.touch = anteriorPokemon
    btn_siguiente.touch = siguientePokemon

    btn_rugido = display.newImageRect(sceneGroup, "/images/sound.png", 320, 320)
    btn_rugido.x = CW/2 - 222; btn_rugido.y = CH/2 + 232
    btn_rugido:scale(0.2, 0.2)

    btn_rugido.touch = reproducirRugido

    btn_shiny = display.newCircle(sceneGroup, CW/2 - 310, CH/2 + 165, 21 )
    btn_shiny:setFillColor(1, 0, 0)
    btn_shiny.alpha = 0.5
    btn_shiny.touch = buscarShiny

    local logo_shiny = display.newImageRect(sceneGroup, "/images/shiny3.png", 160, 160)
    logo_shiny.x = CW/2 - 308; logo_shiny.y = CH/2 + 165
    logo_shiny:scale(0.2, 0.2)
end
 
 
-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        btn_volver:addEventListener("touch", btn_volver)
        btn_buscar:addEventListener("touch", btn_buscar)
        btn_anterior:addEventListener("touch", btn_anterior)
        btn_siguiente:addEventListener("touch", btn_siguiente)
        btn_rugido:addEventListener("touch", btn_rugido)
        btn_shiny:addEventListener("touch", btn_shiny)
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        btn_volver:removeEventListener("touch", btn_volver)
        btn_buscar:removeEventListener("touch", btn_buscar)
        btn_anterior:removeEventListener("touch", btn_anterior)
        btn_siguiente:removeEventListener("touch", btn_siguiente)
        btn_rugido:removeEventListener("touch", btn_rugido)
        btn_shiny:addEventListener("touch", btn_shiny)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    if input_numero then
        input_numero:removeSelf()
        input_numero = nil
    end

    if imagen_pkm then
        imagen_pkm:removeSelf()
        imagen_pkm = nil
    end

    if sonido_pkm then 
        audio.dispose(sonido_pkm)
        sonido_pkm = nil
    end
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