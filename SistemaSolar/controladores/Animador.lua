-- controladores/Animador.lua
local Animador = {}

local centerX = display.contentCenterX
local centerY = display.contentCenterY

function Animador.colapsar(planetas, cometa)
    for _, planeta in ipairs(planetas) do
        transition.cancel(planeta.image)
        transition.to(planeta.image, {
            time = 1000,
            x = centerX,
            y = centerY,
            transition = easing.inExpo
        })

        if planeta.lunas then
            for _, luna in ipairs(planeta.lunas) do
                transition.cancel(luna.image)
                transition.to(luna.image, {
                    time = 1000,
                    x = centerX,
                    y = centerY,
                    transition = easing.inExpo
                })
            end
        end
    end

    if cometa then
        transition.cancel(cometa.image)
        transition.to(cometa.image, {
            time = 1000,
            x = centerX,
            y = centerY,
            transition = easing.inExpo
        })
    end
end

function Animador.expandir(planetas, cometa, callback)
    for _, planeta in ipairs(planetas) do
        transition.cancel(planeta.image)
        transition.to(planeta.image, {
            time = 1000,
            x = planeta.finalX,
            y = planeta.finalY,
            transition = easing.outExpo
        })

        if planeta.lunas then
            for _, luna in ipairs(planeta.lunas) do
                transition.cancel(luna.image)
                transition.to(luna.image, {
                    time = 1500,
                    x = luna.finalX,
                    y = luna.finalY,
                    transition = easing.outExpo
                })
            end
        end
    end

    if cometa then
        transition.cancel(cometa.image)
        transition.to(cometa.image, {
            time = 1000,
            x = cometa.finalX,
            y = cometa.finalY,
            transition = easing.outExpo
        })
    end

    if callback then
        timer.performWithDelay(1600, callback)
    end
end

function Animador.absorberPorAgujeroNegro(planetas, cometa)
    for _, planeta in ipairs(planetas) do
        transition.cancel(planeta.image)
        transition.to(planeta.image, {
            time = 1000,
            x = centerX,
            y = centerY,
            transition = easing.inExpo,
            onComplete = function()
                planeta:hide()
            end
        })

        if planeta.lunas then
            for _, luna in ipairs(planeta.lunas) do
                transition.cancel(luna.image)
                transition.to(luna.image, {
                    time = 1000,
                    x = centerX,
                    y = centerY,
                    transition = easing.inExpo,
                    onComplete = function()
                        luna:hide()
                    end
                })
            end
        end
    end

    if cometa then
        transition.cancel(cometa.image)
        transition.to(cometa.image, {
            time = 1000,
            x = centerX,
            y = centerY,
            transition = easing.inExpo,
            onComplete = function()
                cometa:hide()
            end
        })
    end
end


return Animador
