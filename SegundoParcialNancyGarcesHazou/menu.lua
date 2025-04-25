-- requiere el modulo composer para la gestion de escenas
local composer = require("composer")

-- requiere el modulo widget para usar botones y otros elementos ui
local widget = require("widget")

-- crea una nueva escena con composer
local scene = composer.newScene()

-- variable global para saber que personaje fue seleccionado
_G.selectedCharacter = "alex"
_G.coinCount = 0 

-- funcion que se ejecuta al crear la escena
function scene:create(event)
    local sceneGroup = self.view -- agrupa todos los elementos de la escena

    -- crea un rectangulo de fondo del tamano de la pantalla
    local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg:setFillColor(0.7, 0.9, 1) -- color azul claro de fondo

    -- titulo del juego en la parte superior
    local title = display.newText({
        parent = sceneGroup,
        text = "Calcifer Valley",
        x = display.contentCenterX,
        y = 90,
        fontSize = 48,
        font = "Minecraftia-Regular.ttf"
    })
    title:setFillColor(0.6, 0.2, 0.1)
    

    -- muestra la imagen del personaje alex
    local alexImage = display.newImageRect(sceneGroup, "assets/alex.png", 100, 100)
    alexImage.x = display.contentCenterX - 100 -- posicionada a la izquierda del centro
    alexImage.y = 180 -- posicion vertical

    -- muestra la imagen del personaje billy
    local billyImage = display.newImageRect(sceneGroup, "assets/billy.png", 100, 100)
    billyImage.x = display.contentCenterX + 100 -- a la derecha del centro
    billyImage.y = 180

    -- crea un grupo para los botones de radio
    local radioGroup = display.newGroup()
    sceneGroup:insert(radioGroup)

    -- funcion que se ejecuta cuando se cambia de personaje
    local function onRadioChange(event)
        if event.target.id == "alex" then
            _G.selectedCharacter = "alex" -- si se elige alex
        elseif event.target.id == "billy" then
            _G.selectedCharacter = "billy" -- si se elige billy
        end
    end

    -- boton de seleccion para alex (radio)
    local alexRadio = widget.newSwitch({
        style = "radio",           -- estilo radio button
        id = "alex",               -- identificador unico
        x = alexImage.x,           -- posicion horizontal igual a su imagen
        y = alexImage.y + 75,      -- debajo de su imagen
        initialSwitchState = true, -- inicia seleccionado
        onPress = onRadioChange    -- funcion que se ejecuta al presionar
    })
    radioGroup:insert(alexRadio) -- se anade al grupo

    local alexLabel = display.newText({
        text = "Alex",
        x = alexRadio.x,
        y = alexRadio.y + 45,
        fontSize = 21,
        font = "Minecraftia-Regular.ttf"
    })
    alexLabel:setFillColor(0.0, 0.0, 0.0)
    sceneGroup:insert(alexLabel)
    local billyRadio = widget.newSwitch({
        style = "radio",
        id = "billy",
        x = billyImage.x,
        y = billyImage.y + 75,
        onPress = onRadioChange
    })
    radioGroup:insert(billyRadio)

    local billyLabel = display.newText({
        text = "Billy",
        x = billyRadio.x,
        y = billyRadio.y + 45,
        fontSize = 21,
        font = "Minecraftia-Regular.ttf"
    })
    billyLabel:setFillColor(0.0, 0.0, 0.0)
    sceneGroup:insert(billyLabel)

    local playBtn = display.newRoundedRect(sceneGroup, display.contentCenterX, 420, 240, 60, 20)
    playBtn:setFillColor(0.9, 0.7, 0.4)
    playBtn.strokeWidth = 3
    playBtn:setStrokeColor(0.5, 0.3, 0.1)


    local playText = display.newText({
        parent = sceneGroup,
        text = "Iniciar juego",
        x = playBtn.x,
        y = playBtn.y,
        fontSize = 24,
        font = "Minecraftia-Regular.ttf"
    })
    playText:setFillColor(0.2, 0.1, 0)

    -- funcion que cambia a la escena del juego
    local function goToGame()

        composer.gotoScene("game", { effect = "slideLeft", time = 500 })
    end
    
    


    playBtn:addEventListener("tap", goToGame)
end

scene:addEventListener("create", scene)

return scene
