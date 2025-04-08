-- main.lua

-- Definir los elementos con su información
local elementos = {
    {symbol = "H", name = "Hidrógeno", weight = 1.008, protons = 1, neutrons = 0, electrons = 1, color = {1, 1, 1}},  -- Blanco
    {symbol = "He", name = "Helio", weight = 4.0026, protons = 2, neutrons = 2, electrons = 2, color = {0.5, 0.5, 1}},  -- Azul
    {symbol = "Li", name = "Litio", weight = 6.94, protons = 3, neutrons = 4, electrons = 3, color = {0.9, 0.5, 0.5}},  -- Rojo
    {symbol = "Be", name = "Berilio", weight = 9.0122, protons = 4, neutrons = 5, electrons = 4, color = {0.5, 1, 0.5}},  -- Verde
    {symbol = "B", name = "Boro", weight = 10.81, protons = 5, neutrons = 6, electrons = 5, color = {1, 1, 0.5}},  -- Amarillo
    {symbol = "C", name = "Carbono", weight = 12.011, protons = 6, neutrons = 6, electrons = 6, color = {0.5, 1, 1}},  -- Cyan
    {symbol = "N", name = "Nitrógeno", weight = 14.007, protons = 7, neutrons = 7, electrons = 7, color = {1, 0.5, 1}},  -- Rosa
    {symbol = "O", name = "Oxígeno", weight = 15.999, protons = 8, neutrons = 8, electrons = 8, color = {1, 0.5, 0.5}},  -- Rojo
    {symbol = "F", name = "Flúor", weight = 18.998, protons = 9, neutrons = 10, electrons = 9, color = {0.5, 1, 0.5}},  -- Verde claro
    {symbol = "Ne", name = "Neón", weight = 20.180, protons = 10, neutrons = 10, electrons = 10, color = {0.5, 0.5, 1}}  -- Azul claro
}

-- Tamaño de las celdas y de la pantalla
local celda = 60  -- Tamaño de cada celda
local CW = 320  -- Ancho de la pantalla
local CH = 480  -- Alto de la pantalla

-- Función para dibujar la tabla periódica
local function drawElementList()
    local yOffset = 50  -- Espaciado vertical para la lista de elementos

    -- Crear la lista de elementos en dos columnas y cinco filas
    for i = 1, 5 do
        for j = 1, 2 do
            local index = (i - 1) * 2 + j
            local element = elementos[index]
            local x = (j - 1) * (CW / 2) + (CW / 4)  -- Alineación de las columnas
            local y = yOffset + (i - 1) * celda  -- Espaciado vertical para las filas

            -- Crear los rectángulos para los elementos (como botones)
            local rect = display.newRect(x, y, celda, celda)
            -- Aplicar el color correctamente
            rect:setFillColor(unpack(element.color))  -- Usamos element.color directamente
            rect.strokeWidth = 2
            rect:setStrokeColor(0, 0, 0)

            -- Texto con el símbolo del elemento
            local label = display.newText({
                text = element.symbol,
                x = x,
                y = y,
                font = native.systemFont,
                fontSize = 20
            })
            label:setFillColor(0, 0, 0)

            -- Asignar el elemento a la celda
            rect.element = element  -- Guardamos el objeto de elemento dentro del rectángulo

            -- Al hacer clic, mostrar detalles del elemento
            rect:addEventListener("tap", function()
                showElementDetails(element)
            end)
        end
    end
end

-- Función para mostrar los detalles de un elemento
local function showElementDetails(element)
    -- Limpiar la pantalla
    display.removeAll()

    -- Título del elemento
    local title = display.newText({
        text = "Elemento: " .. element.name,
        x = display.contentCenterX,
        y = 20,
        font = native.systemFont,
        fontSize = 30
    })

    -- Información del elemento
    local infoText = "Peso atómico: " .. element.weight .. "\nElectrones: " .. element.electrons ..
        "\nProtones: " .. element.protons .. "\nNeutrones: " .. element.neutrons
    local infoDisplay = display.newText({
        text = infoText,
        x = display.contentCenterX,
        y = display.contentCenterY + 150,
        font = native.systemFont,
        fontSize = 20,
        align = "center"
    })

    -- Visualización simplificada de la configuración de Bohr para hidrógeno
    if element.symbol == "H" then
        local electronOrbitals = display.newCircle(display.contentCenterX, 150, 50)
        electronOrbitals:setStrokeColor(1, 1, 1)
        electronOrbitals.strokeWidth = 2

        local electron1 = display.newCircle(display.contentCenterX + 50, 150, 5)
        electron1:setFillColor(1, 0, 0)

        -- Mostrar configuración de Bohr con el único electrón de H
        local orbitalText = display.newText({
            text = "Modelo de Bohr: 1 electrón",
            x = display.contentCenterX,
            y = 250,
            font = native.systemFont,
            fontSize = 18
        })
    end

    -- Botón para regresar a la lista de elementos
    local backButton = display.newText({
        text = "Regresar a la lista",
        x = display.contentCenterX,
        y = display.contentHeight - 50,
        font = native.systemFont,
        fontSize = 20
    })
    backButton:setFillColor(0, 0, 1)

    backButton:addEventListener("tap", function()
        -- Limpiar la pantalla y mostrar la lista de elementos
        display.removeAll()
        drawElementList()
    end)
end

-- Llamar a la función para dibujar la lista de elementos
drawElementList()
