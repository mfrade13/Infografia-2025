local composer = require("composer")
local scene = composer.newScene()
local btn_volver
local mensaje_final
--variables para puntaje
local disparosPato = 0
local disparosPajaro = 0
local texto_puntaje_pato
local texto_puntaje_pajaro
local isGameOver = false
--variables del juego
local perro
local pato
local cuenta_regresiva_texto
local gameStarted = false
local duckActive = false
local pajaros = {}


local duckSound = audio.loadSound("quack.mp3")
local gunSound = audio.loadSound("shot.mp3")
local victorySound = audio.loadSound("victory.mp3")


function goToStart(self, event)
    if event.phase == "ended" then
        composer.removeScene("juego") 
        local options = { effect = "fade", time = 500}
        composer.gotoScene( "start", options )
    end
    return true 
end

--Funciones generales

-- Efecto de destello
function flash()
    local destello = display.newRect(CW/2, CH/2,  CW, CH)
    destello:setFillColor(1, 1, 1)
    destello.alpha = 0
    transition.to(destello, {alpha = 0.9, time = 75,
        onComplete = function()
            transition.to(destello, {alpha = 0, time = 75,
                onComplete = function() 
                    display.remove(destello) 
                end
            })
        end
    })
end

-- Funcion cuando el pato u otra ave es tocado 
function onTargetTap(event)
    if duckActive then
        audio.play(gunSound)
        flash()
        
        local target = event.target
        if target == pato then
            disparosPato = disparosPato + 1
            texto_puntaje_pato.text = "Patos: " .. disparosPato
        else
            disparosPajaro = disparosPajaro + 1
            texto_puntaje_pajaro.text = "Pájaros: " .. disparosPajaro
        end
        
        target.isVisible = false
        transition.cancel(target)
        
        
        if disparosPato >= 10 then
            gameOver(true)
        elseif disparosPajaro >= 3 then
            gameOver(false)
        end
        
        return true
    end
end

function gameOver(victoria)
    isGameOver = true
    transition.cancelAll()
    timer.cancelAll()

    if victoria then
        victory_text = "¡GANASTE!"
        audio.play(victorySound)
    else
        victory_text = "¡PERDISTE!"
    end

    mensaje_final.text = victory_text
    mensaje_final.isVisible = true
   
    
    btn_volver.isVisible = true
    btn_volver.touch = goToStart
    btn_volver:addEventListener("touch", boton_volver)
    
end


-- Funcion para que el pato y aves se muevan aleatoriamente
local function moveTarget(target)
    if duckActive and target.isVisible then
        local randomX = math.random(25, CW-25)
        local randomY = math.random(0, CH-125)
        
        transition.to(target, { x = randomX, y = randomY, time = 560,
            onComplete = function()
                moveTarget(target)
            end
        })
    end
end



function activateDuck()
    duckActive = true
    audio.play(duckSound)
    pato.isVisible = true
    pato.x = math.random(25, CW-25)
    pato.y = CH/1.35
    moveTarget(pato)
    
    
    for i = 1, 3 do
        pajaros[i].isVisible = true
        pajaros[i].x = math.random(25, CW-25)
        pajaros[i].y = CH/1.35
        moveTarget(pajaros[i])
    end
    
    timer.performWithDelay(4500, function()
        duckActive = false
        pato.isVisible = false
        for i = 1, 3 do
            pajaros[i].isVisible = false
            transition.cancel(pajaros[i])
        end
    end)
end


-- Función para que el perro aparezca y anuncie al pato siguiente
function dogCycle()
    perro.isVisible = true
    transition.to(perro, {
        time = 1000,
        onComplete = function()
            perro.isVisible = false
            activateDuck()
            timer.performWithDelay(4500, dogCycle)
        end
    })
end


function startGame()
    gameStarted = true
    isGameOver = false
    disparosPato = 0
    disparosPajaro = 0
    texto_puntaje_pato.text = "Patos: 0"
    texto_puntaje_pajaro.text = "Pájaros: 0"
    perro.isVisible = false
    dogCycle()
end


function startCountdown()
    local count = 3
    cuenta_regresiva_texto.text = count
    
    local function updateCount()
        count = count - 1
        if count > 0 then
            cuenta_regresiva_texto.text = count
        else
            cuenta_regresiva_texto.text = "¡EMPECEMOS!"
            timer.performWithDelay(500, function()
                cuenta_regresiva_texto.isVisible = false
                startGame()
            end)
        end
    end
    
    timer.performWithDelay(1000, updateCount, 3)
end


-- Funciones de la escena


function scene:create(event)
    local sceneGroup = self.view

    local fondo_juego = display.newImageRect(sceneGroup, "juego.png", CW, CH)
    fondo_juego.x = CW/2
    fondo_juego.y = CH/2

    perro = display.newImageRect(sceneGroup, "perro.png", 70, 70)
    perro.x = CW/1.45
    perro.y = CH/1.54

   
    pato = display.newImageRect(sceneGroup, "pato.png", 68, 68)
    pato.x = CW/2
    pato.y = CH/1.35
    pato.isVisible = false
    pato:addEventListener("touch", onTargetTap)

    for i = 1, 3 do
        pajaros[i] = display.newImageRect(sceneGroup, "pajaro.png", 670/6.5, 372/6.5)
        pajaros[i].x = CW/2
        pajaros[i].y = CH/1.35
        pajaros[i].isVisible = false
        pajaros[i]:addEventListener("touch", onTargetTap)
    end

    cuenta_regresiva_texto = display.newText(sceneGroup, "3", CW/2, CH/2, native.systemFont, 50)
    cuenta_regresiva_texto:setFillColor(1, 1, 1)

    texto_puntaje_pato = display.newText(sceneGroup, "Patos: 0", 25, CH-25, native.systemFont, 15)
    texto_puntaje_pato.anchorX = 0
    texto_puntaje_pato:setFillColor(1, 1, 1)
    
    texto_puntaje_pajaro = display.newText(sceneGroup, "Pájaros: 0", CW-25, CH-25, native.systemFont, 15)
    texto_puntaje_pajaro.anchorX = 1
    texto_puntaje_pajaro:setFillColor(1, 1, 1)

    mensaje_final = display.newText(sceneGroup, "Vacio", CW/2, CH/2, native.systemFontBold, 30)
    mensaje_final:setFillColor(1, 1, 1)
    mensaje_final.isVisible = false

    btn_volver = display.newImageRect(sceneGroup, "btn_volver.png", 298/2, 169/2)
    btn_volver.x = CW/2
    btn_volver.y = CH/1.5
    
    btn_volver.isVisible = false
    
end

function scene:show(event)
    if event.phase == "did" and not gameStarted then
        startCountdown()
        
    end
end

function scene:hide(event)
    if event.phase == "will" then
        transition.cancelAll()
        timer.cancelAll()
        
        duckActive = false
    end
end

function scene:destroy(event)
    audio.dispose(duckSound)
    audio.dispose(gunSound)
    audio.dispose(victorySound)
    btn_volver:removeEventListener( "touch", btn_volver )
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene