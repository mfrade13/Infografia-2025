-- controladores/UI.lua
local Animador = require("controladores.Animador")

local UI = {}

function UI.crearBotones(planetas, cometa, estadoMovimiento)
    -- Botones Play y Pause
    local playBtn = display.newImageRect("assets/botones/play.png", 60, 60)
    playBtn.x, playBtn.y = 10, 60

    local pauseBtn = display.newImageRect("assets/botones/pause.png", 60, 60)
    pauseBtn.x, pauseBtn.y = 90, 60

    -- Botón Agujero Negro (Big Crunch con desaparición)
    local agujeroBtn = display.newImageRect("assets/botones/AgujeroNegro.png", 60, 60)
    agujeroBtn.x, agujeroBtn.y = 180, 60

    agujeroBtn:addEventListener("tap", function()
        estadoMovimiento.enMovimiento = false

    -- Guardar nuevas posiciones finales antes de absorber
        for _, planeta in ipairs(planetas) do
            planeta:guardarPosicionFinal()
            if planeta.lunas then
                for _, luna in ipairs(planeta.lunas) do
                    luna:guardarPosicionFinal()
                end
            end
        end
    cometa:guardarPosicionFinal()

    -- Animar absorción
    Animador.absorberPorAgujeroNegro(planetas, cometa)
    end)


    -- Botón Play
    playBtn:addEventListener("tap", function()
        -- Asegurar que todos los elementos estén visibles antes de expandir
        for _, planeta in ipairs(planetas) do
            planeta:show()
            if planeta.lunas then
                for _, luna in ipairs(planeta.lunas) do
                    luna:show()
                end
            end
        end
        if cometa then
            cometa:show()
        end
    
        -- Expandir posiciones
        Animador.expandir(planetas, cometa, function()
            estadoMovimiento.enMovimiento = true
        end)
    end)
    

    -- Botón Pause
    pauseBtn:addEventListener("tap", function()
        estadoMovimiento.enMovimiento = false

        -- Guardar nuevas posiciones finales antes de colapsar
        for _, planeta in ipairs(planetas) do
            planeta:guardarPosicionFinal()
            if planeta.lunas then
                for _, luna in ipairs(planeta.lunas) do
                    luna:guardarPosicionFinal()
                end
            end
        end
        cometa:guardarPosicionFinal()

        Animador.colapsar(planetas, cometa)
    end)

    -- Botones para cada planeta
    local spacing = 30
    local startY = 100

    for i, planeta in ipairs(planetas) do
        -- Crear botón de ocultar/mostrar planeta
        local btn = display.newText("Planeta " .. i, 10, startY + (i * spacing), native.systemFont, 18)  -- Cambié de 80 a 10
        btn:setFillColor(0.9, 0.9, 1)
        btn.isVisibleFlag = true

        -- Acción del botón
        btn:addEventListener("tap", function()
            btn.isVisibleFlag = not btn.isVisibleFlag
            if btn.isVisibleFlag then
                planeta:show() -- Mostrar planeta y lunas
            else
                planeta:hide() -- Ocultar planeta y lunas
            end

            -- Cambiar texto del botón dependiendo de la visibilidad
            if btn.isVisibleFlag then
                btn.text = "Planeta " .. i
                btn:setFillColor(0.9, 0.9, 1)
            else
                btn.text = "Mostrar " .. i
                btn:setFillColor(0.5, 0.5, 0.5)
            end
        end)

        -- Botones para ocultar/mostrar lunas individualmente
        if planeta.lunas then
            local lunaStartX = 90  -- Cambié de 180 a 90
            for j, luna in ipairs(planeta.lunas) do
                -- Crear un botón para cada luna
                local lunaBtn = display.newText("Luna " .. j, lunaStartX + (j - 1) * 80, startY + (i * spacing), native.systemFont, 18)
                lunaBtn:setFillColor(0.8, 0.8, 0.8)
                lunaBtn.isVisibleFlag = true

                lunaBtn:addEventListener("tap", function()
                    lunaBtn.isVisibleFlag = not lunaBtn.isVisibleFlag
                    if lunaBtn.isVisibleFlag then
                        luna:show() -- Mostrar luna
                    else
                        luna:hide() -- Ocultar luna
                    end

                    -- Cambiar texto del botón dependiendo de la visibilidad
                    if lunaBtn.isVisibleFlag then
                        lunaBtn.text = "Luna " .. j
                        lunaBtn:setFillColor(0.8, 0.8, 0.8)
                    else
                        lunaBtn.text = "Mostrar Luna " .. j
                        lunaBtn:setFillColor(0.5, 0.5, 0.5)
                    end
                end)
            end
        end
    end

    -- Botón para ocultar/mostrar el cometa
    local cometaBtn = display.newText("Cometa", 10, startY + (#planetas + 1) * spacing, native.systemFont, 18)  -- Cambié de 80 a 10
    cometaBtn:setFillColor(0.8, 0.8, 0.8)
    cometaBtn.isVisibleFlag = true

    cometaBtn:addEventListener("tap", function()
        cometaBtn.isVisibleFlag = not cometaBtn.isVisibleFlag
        if cometaBtn.isVisibleFlag then
            cometa:show() -- Mostrar cometa
        else
            cometa:hide() -- Ocultar cometa
        end

        -- Cambiar texto del botón dependiendo de la visibilidad
        if cometaBtn.isVisibleFlag then
            cometaBtn.text = "Cometa"
            cometaBtn:setFillColor(0.8, 0.8, 0.8)
        else
            cometaBtn.text = "Mostrar Cometa"
            cometaBtn:setFillColor(0.5, 0.5, 0.5)
        end
    end)
end

return UI
