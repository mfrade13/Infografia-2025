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

local sprite_sheet_1 = graphics.newImageSheet("avanza_derecha.png", options_sprite_1)

local sequence_1 = {
    name = "avanza_derecha",
    start = 1,
    count = 8,
    time= 8/12 *1000
}

local sprite = display.newSprite(sprite_sheet_1, sequence_1)
sprite.x = CW/2; sprite.y= CH/2
print(sprite.numFrames, sprite.isPlaying, sprite.frame, sprite.sequence)
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

local chems = display.newSprite(sprite_sheet_2, sequence_2)
chems.x = CW/4; chems.y= CH/2
chems.xScale = 0.4; chems.yScale = 0.4
print(chems.numFrames, chems.isPlaying, chems.frame, chems.sequence)
chems:setSequence("avanzar")
chems:play()