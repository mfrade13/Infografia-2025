-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local CW = display.contentWidth
local CH = display.contentHeight

local fondo = display.newImageRect("bg_1.jpg", CW, CH)
fondo.anchorX = 0
fondo.anchorY = 0

local options_sprite_1 = {
    width = 300,
    height = 300,
    numFrames = 8
}

local options_acciones = {
    width = 1599/3,
    height = 600/2,
    numFrames = 6  
}

local sprite_sheet_izq_1 = graphics.newImageSheet("avanza_izquierda.png", options_sprite_1 )
local sprite_sheet_1 = graphics.newImageSheet("avanza_derecha.png", options_sprite_1)
local sprite_sheet_acciones = graphics.newImageSheet("accion_derecha.png", options_acciones)


local sequence_1 = {
    {
        name = "saltar_derecha",
        frames = {4,6,6,5,4},
        time = 6/6 *1000,
        sheet = sprite_sheet_acciones
    },
    {
        name = "atacar_derecha",
        start = 1,
        count = 3,
        time = 3/6 *1000,
        loopCount = 1,
        sheet = sprite_sheet_acciones
    },
    {
        name = "avanza_derecha",
        start = 1,
        count = 8,
        time= 8/12 *1000,
        sheet = sprite_sheet_1
    },{
        name = "reposo",
        sheet = sprite_sheet_acciones,
        frames = {4},
        loopCount = 1

    },
    {
        name = "avanza_izquierda",
        sheet = sprite_sheet_izq_1,
        time = 8/12*1000,
        frames = {4,3,2,1,8,7,6,5}
    }
}

local sprite = display.newSprite(sprite_sheet_acciones, sequence_1)
sprite.x = CW/2; sprite.y= CH/2
sprite.puedeAtacar = true
sprite.orientacion = "derecha"
print(sprite.numFrames, sprite.isPlaying, sprite.frame, sprite.sequence)
sprite:setSequence("reposo")
sprite:play()

local options_sprite_2 = {
    width = 2060/3,
    height = 3508/5,
    numFrames = 14
} 
local options_frames = {
    frames = {
        {
            x = 0,
            y = 0,
            width = 687,
            height = 700
        },
        {
            x = 687,
            y = 0,
            width = 687,
            height = 700
        },
        {
            x = 687*2,
            y = 0,
            width = 687,
            height = 700
        },        {
            x = 0,
            y = 700,
            width = 687,
            height = 700
        },
    },
    sheetContentWidth = 2060,
    sheetContentHeight = 3508
}



local sprite_sheet_2 = graphics.newImageSheet("Spritesheet_Chems.png", options_frames)

local sequence_2 = {
    {
        name = "avanzar",
        start = 1,
        count = 2,
        time= 4/12 *1000
    },{
        name = "atacar_derecha",
        start = 1,
        count = 3,
        time= 8/12 *1000
    },
    {
        name = "atacar_abajo",
        frames={1,2},
        time= 4/12 *1000,
        loopCount=3
    }
}

local btn_atacar = display.newImageRect("atacar.png", 100, 100)
btn_atacar.x = CW - 200; btn_atacar.y = 150
btn_atacar.anchorX = 0; btn_atacar.anchorY = 0
btn_atacar:scale(-1,-1)
--btn_atacar.rotation = 180
function reanudarAtaque()
    sprite.puedeAtacar = true
end

function atacar(event)
    if event.phase == "ended" then
        if sprite.puedeAtacar then 
            sprite.puedeAtacar = false
            sprite:setSequence("atacar_derecha")
            sprite:play()
            -- if sprite.orientacion == "derecha" then
            --     sprite:scale(-1,1)
            -- elseif sprite.orientacion == "izquierda" then
            --     sprite
            -- end
            timer.performWithDelay(3/6 *1000, function() 
                sprite.puedeAtacar = true
                sprite:setSequence("reposo")
            end
            )
        end
    end
    return true
end

function moverPersonaje (event)
    if event.phase == "began" then
        print(sprite.orientacion)
        if event.x > CW/2 then
            if sprite.orientacion == "izquierda" then
                sprite:scale(-1,1)
            end
            sprite:setSequence("avanza_derecha")
            sprite:play()
            sprite:translate(15,0)
            sprite.orientacion = "derecha"
        else
            if sprite.orientacion == "derecha" then
                sprite:scale(-1,1)
            end
            sprite:setSequence("avanza_derecha")
            sprite:play()
            sprite:translate(-15,0)
            sprite.orientacion = "izquierda"
        end
    elseif event.phase == "ended" then

        sprite:setSequence("reposo")
        sprite:play()
    end
end

fondo:addEventListener("touch", moverPersonaje)
btn_atacar:addEventListener("touch", atacar)

-- local chems = display.newSprite(sprite_sheet_2, sequence_2)
-- chems.x = CW/4; chems.y= CH/2
-- chems.xScale = 0.4; chems.yScale = 0.4
-- print(chems.numFrames, chems.isPlaying, chems.frame, chems.sequence)
-- chems:setSequence("avanzar")
-- chems:play()