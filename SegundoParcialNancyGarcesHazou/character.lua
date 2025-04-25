-- requerimos el modulo de fisica para usarlo en el juego
local physics = require("physics")

-- requerimos la configuracion del juego
local config = require("settings")

local M = {}

function M.createCharacter(x, y)
    local selected = _G.selectedCharacter or "alex"
    
    local imagePath = selected == "billy" and "assets/character2.png" or "assets/character.png"
    
    local characterSheetOptions = {
        width = 47, height = 61,
        numFrames = 16
    }
    
    local characterSheet = graphics.newImageSheet(imagePath, characterSheetOptions)
    
    local sequences = {
        { name = "idle", frames = { 1, 2 }, time = 500, loopCount = 1 },
        { name = "right", frames = { 5, 6, 7, 8 }, time = 600, loopCount = 0 },
        { name = "left", frames = { 9, 10, 11, 12 }, time = 600, loopCount = 0 },
        { name = "jump", frames = { 13, 14, 15, 16 }, time = 800, loopCount = 1 }
    }

    local player = display.newSprite(characterSheet, sequences)
    player.x, player.y = x, y
    player:setSequence("idle")
    player:play()

    physics.addBody(player, "dynamic", { bounce = 0, friction = 1 })
    player.isFixedRotation = true
    
    player.isJumping = false
    player.canDoubleJump = true

    function player:collision(event)
        if event.phase == "began" then
            if event.contact and event.contact.normal and event.contact.normal.y < 0 then
                player.isJumping = false
                player.canDoubleJump = true
            end
        end
    end
    player:addEventListener("collision")

    local function onEnterFrame()
        if player and player.bodyType == "dynamic" then -- verificacion para ver si existe el personaje
            local vx, vy = player:getLinearVelocity()

            if player.isJumping then
                if player.sequence ~= "jump" then
                    player:setSequence("jump")
                    player:play()
                end
            else
                if math.abs(vx) > 1 then
                    if vx > 0 and player.sequence ~= "right" then
                        player:setSequence("right")
                        player:play()
                    elseif vx < 0 and player.sequence ~= "left" then
                        player:setSequence("left")
                        player:play()
                    end
                else
                    if player.sequence ~= "idle" then
                        player:setSequence("idle")
                        player:play()
                    end
                end
            end
        end
    end
    Runtime:addEventListener("enterFrame", onEnterFrame)

    return player
end

return M