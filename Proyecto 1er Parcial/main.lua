-- main.lua

local mainGroup = display.newGroup()

-- Informacionde los elementos definidos
local elementos = {
    {symbol = "H", name = "Hidrógeno", weight = 1.008, protons = 1, neutrons = 0, electrons = 1, color = {1,1,1}},
    {symbol = "He", name = "Helio", weight = 4.0026, protons = 2, neutrons = 2, electrons = 2, color = {0.5,0.5,1}},
    {symbol = "Li", name = "Litio", weight = 6.94, protons = 3, neutrons = 4, electrons = 3, color = {0.9,0.5,0.5}},
    {symbol = "Be", name = "Berilio", weight = 9.0122, protons = 4, neutrons = 5, electrons = 4, color = {0.5,1,0.5}},
    {symbol = "B", name = "Boro", weight = 10.81, protons = 5, neutrons = 6, electrons = 5, color = {1,1,0.5}},
    {symbol = "C", name = "Carbono", weight = 12.011, protons = 6, neutrons = 6, electrons = 6, color = {0.5,1,1}},
    {symbol = "N", name = "Nitrógeno", weight = 14.007, protons = 7, neutrons = 7, electrons = 7, color = {1,0.5,1}},
    {symbol = "O", name = "Oxígeno", weight = 15.999, protons = 8, neutrons = 8, electrons = 8, color = {1,0.5,0.5}},
    {symbol = "F", name = "Flúor", weight = 18.998, protons = 9, neutrons = 10, electrons = 9, color = {0.5,1,0.5}},
    {symbol = "Ne", name = "Neón", weight = 20.180, protons = 10, neutrons = 10, electrons = 10, color = {0.5,0.5,1}}
}

local celda = 60
local CW = display.contentWidth
local CH = display.contentHeight

-- Funciones declaradas
local drawElementList, showElementDetails

-- Mostramos lista de elementos
drawElementList = function()
    display.remove(mainGroup)
    mainGroup = display.newGroup()

    local yOffset = 80
    local xOffset = CW/4

    for i = 1, 5 do
        for j = 1, 2 do
            local index = (i - 1) * 2 + j
            local element = elementos[index]

            local x = (j - 1) * (CW / 2) + xOffset
            local y = yOffset + (i - 1) * celda

            local rect = display.newRect(mainGroup, x, y, celda, celda)
            rect:setFillColor(unpack(element.color))
            rect.strokeWidth = 2
            rect:setStrokeColor(0)

            local label = display.newText(mainGroup, element.symbol, x, y, native.systemFont, 20)
            label:setFillColor(0)

            rect:addEventListener("tap", function()
                showElementDetails(element)
            end)
        end
    end
end

-- Mostramos una leyenda del modelo
showElementDetails = function(element)
    display.remove(mainGroup)
    mainGroup = display.newGroup()

    local CW = display.contentWidth
    local CH = display.contentHeight

    -- Nombre del Elemento que mostramos
    local title = display.newText(mainGroup, "Elemento: "..element.name, CW/2, 30, native.systemFontBold, 24)

    -- Nuveles de s2 para dibujar
    local configuraciones = {
        H={1},He={2},Li={2,1},Be={2,2},B={2,3},C={2,4},N={2,5},O={2,6},F={2,7},Ne={2,8}
    }

    local radioInicial = 25
    local incrementoRadio = 25
    local conf = configuraciones[element.symbol]

    -- Modelo Bohr centrado
    for i = 1, #conf do
        local radio = radioInicial + incrementoRadio * (i - 1)

        local orbital = display.newCircle(mainGroup, CW/2, CH/2 - 30, radio)
        orbital:setFillColor(0,0,0,0)
        orbital:setStrokeColor(1)
        orbital.strokeWidth = 2

        local electrones = conf[i]

        for e = 1, electrones do
            local angle = math.rad((360/electrones)*e)
            local ex = CW/2 + radio*math.cos(angle)
            local ey = CH/2 - 30 + radio*math.sin(angle)

            local electron = display.newCircle(mainGroup, ex, ey, 4)
            electron:setFillColor(1,0,0)
        end
    end

    -- Descripcion del modelo Bohr mostrado
    local orbitalText = display.newText(mainGroup,
        "Modelo de Bohr: "..element.electrons.." electrones ("..table.concat(conf,",")..")",
        CW/2, CH/2 + 90, native.systemFont, 16)

    -- Info
    local info = display.newText(mainGroup, 
        "Peso atómico: "..element.weight.."\n"..
        "Electrones: "..element.electrons.."\n"..
        "Protones: "..element.protons.."\n"..
        "Neutrones: "..element.neutrons,
        CW/2, CH/2 + 150, native.systemFont, 16)

    -- BTn REgresar
    local backButton = display.newText(mainGroup, "Regresar a la lista", CW/2, CH - 25, native.systemFontBold, 18)
    backButton:setFillColor(0,0.4,1)

    backButton:addEventListener("tap", drawElementList)
end

-- Dibujamos lista
drawElementList()
