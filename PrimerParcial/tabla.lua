local composer = require("composer")
local scene = composer.newScene()

local CW = display.contentWidth
local CH = display.contentHeight

local maxCols = 18  
local cuadros = {}

-- Espaciado entre los elementos
local spacingX = 60
local spacingY = 60

-- Definir el margen de la tabla periódica desde el centro de la pantalla
local centerX = CW / 2
local centerY = CH / 2

-- Este diccionario tiene los primeros 53 elementos con sus propiedades básicas.
local elementos = { 
    {simbolo = "H", nombre = "Hidrógeno", col = 1, row = 1, tipo = "No metal", color = {0.2, 1, 0}, atomo = 1, masa = 1, electrones = 1},
    {simbolo = "He", nombre = "Helio", col = 2, row = 1, tipo = "Gas noble", color = {1, 1, 0}, atomo = 2, masa = 4, electrones = 2},
    {simbolo = "Li", nombre = "Litio", col = 1, row = 2, tipo = "Metal alcalino", color = {0.4, 0.7, 1}, atomo = 3, masa = 7, electrones = 3},
    {simbolo = "Be", nombre = "Berilio", col = 2, row = 2, tipo = "Metal", color = {1, 1, 1}, atomo = 4, masa = 9, electrones = 4},
    {simbolo = "B", nombre = "Boro", col = 3, row = 2, tipo = "Metaloide", color = {0.6, 0, 1}, atomo = 5, masa = 11, electrones = 5},
    {simbolo = "C", nombre = "Carbono", col = 4, row = 2, tipo = "No metal", color = {0.2, 1, 0}, atomo = 6, masa = 12, electrones = 6},
    {simbolo = "N", nombre = "Nitrógeno", col = 5, row = 2, tipo = "No metal", color = {0.2, 1, 0}, atomo = 7, masa = 14, electrones = 7},
    {simbolo = "O", nombre = "Oxígeno", col = 6, row = 2, tipo = "No metal", color = {0.2, 1, 0}, atomo = 8, masa = 16, electrones = 8},
    {simbolo = "F", nombre = "Flúor", col = 7, row = 2, tipo = "Halógeno", color = {1, 0.6, 0}, atomo = 9, masa = 19, electrones = 9},
    {simbolo = "Ne", nombre = "Neón", col = 8, row = 2, tipo = "Gas noble", color = {1, 1, 0}, atomo = 10, masa = 20, electrones = 10},
    {simbolo = "Na", nombre = "Sodio", col = 1, row = 3, tipo = "Metal alcalino", color = {0.4, 0.7, 1}, atomo = 11, masa = 23, electrones = 11},
    {simbolo = "Mg", nombre = "Magnesio", col = 2, row = 3, tipo = "Metal", color = {1, 1, 1}, atomo = 12, masa = 24, electrones = 12},
    {simbolo = "Al", nombre = "Aluminio", col = 13, row = 3, tipo = "Metal", color = {1, 1, 1}, atomo = 13, masa = 27, electrones = 13},
    {simbolo = "Si", nombre = "Silicio", col = 14, row = 3, tipo = "Metaloide", color = {0.6, 0, 1}, atomo = 14, masa = 28, electrones = 14},
    {simbolo = "P", nombre = "Fósforo", col = 15, row = 3, tipo = "No metal", color = {0.2, 1, 0}, atomo = 15, masa = 31, electrones = 15},
    {simbolo = "S", nombre = "Azufre", col = 16, row = 3, tipo = "No metal", color = {0.2, 1, 0}, atomo = 16, masa = 32, electrones = 16},
    {simbolo = "Cl", nombre = "Cloro", col = 17, row = 3, tipo = "Halógeno", color = {1, 0.6, 0}, atomo = 17, masa = 35.5, electrones = 17},
    {simbolo = "K", nombre = "Potasio", col = 1, row = 4, tipo = "Metal alcalino", color = {0.4, 0.7, 1}, atomo = 19, masa = 39, electrones = 19},
    {simbolo = "Ca", nombre = "Calcio", col = 2, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 20, masa = 40, electrones = 20},
    {simbolo = "Sc", nombre = "Escandio", col = 3, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 21, masa = 45, electrones = 21},
    {simbolo = "Ti", nombre = "Titanio", col = 4, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 22, masa = 48, electrones = 22},
    {simbolo = "V", nombre = "Vanadio", col = 5, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 23, masa = 51, electrones = 23},
    {simbolo = "Cr", nombre = "Cromo", col = 6, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 24, masa = 52, electrones = 24},
    {simbolo = "Mn", nombre = "Manganeso", col = 7, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 25, masa = 55, electrones = 25},
    {simbolo = "Fe", nombre = "Hierro", col = 8, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 26, masa = 56, electrones = 26},
    {simbolo = "Co", nombre = "Cobalto", col = 9, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 27, masa = 59, electrones = 27},
    {simbolo = "Ni", nombre = "Níquel", col = 10, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 28, masa = 59, electrones = 28},
    {simbolo = "Cu", nombre = "Cobre", col = 11, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 29, masa = 63.5, electrones = 29},
    {simbolo = "Zn", nombre = "Zinc", col = 12, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 30, masa = 65, electrones = 30},
    {simbolo = "Ga", nombre = "Galio", col = 13, row = 4, tipo = "Metal", color = {1, 1, 1}, atomo = 31, masa = 69, electrones = 31},
    {simbolo = "Ge", nombre = "Germanio", col = 14, row = 4, tipo = "Metaloide", color = {0.6, 0, 1}, atomo = 32, masa = 73, electrones = 32},
    {simbolo = "As", nombre = "Arsénico", col = 15, row = 4, tipo = "Metaloide", color = {0.6, 0, 1}, atomo = 33, masa = 75, electrones = 33},
    {simbolo = "Se", nombre = "Selenio", col = 16, row = 4, tipo = "No metal", color = {0.2, 1, 0}, atomo = 34, masa = 79, electrones = 34},
    {simbolo = "Br", nombre = "Bromo", col = 17, row = 4, tipo = "Halógeno", color = {1, 0.6, 0}, atomo = 35, masa = 80, electrones = 35},
    {simbolo = "Rb", nombre = "Rubidio", col = 1, row = 5, tipo = "Metal alcalino", color = {0.4, 0.7, 1}, atomo = 37, masa = 85, electrones = 37},
    {simbolo = "Sr", nombre = "Estroncio", col = 2, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 38, masa = 87, electrones = 38},
    {simbolo = "Y", nombre = "Itrio", col = 3, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 39, masa = 89, electrones = 39},
    {simbolo = "Zr", nombre = "Zirconio", col = 4, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 40, masa = 91, electrones = 40},
    {simbolo = "Nb", nombre = "Niobio", col = 5, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 41, masa = 93, electrones = 41},
    {simbolo = "Mo", nombre = "Molibdeno", col = 6, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 42, masa = 96, electrones = 42},
    {simbolo = "Tc", nombre = "Tecnecio", col = 7, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 43, masa = 98, electrones = 43},
    {simbolo = "Ru", nombre = "Rutenio", col = 8, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 44, masa = 101, electrones = 44},
    {simbolo = "Rh", nombre = "Rhodio", col = 9, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 45, masa = 103, electrones = 45},
    {simbolo = "Pd", nombre = "Paladio", col = 10, row = 5, tipo = "Metal", color ={1, 1, 1}, atomo = 46, masa = 106, electrones = 46},
    {simbolo = "Ag", nombre = "Plata", col = 11, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 47, masa = 108, electrones = 47},
    {simbolo = "Cd", nombre = "Cadmio", col = 12, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 48, masa = 112, electrones = 48},
    {simbolo = "In", nombre = "Indio", col = 13, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 49, masa = 115, electrones = 49},
    {simbolo = "Sn", nombre = "Estaño", col = 14, row = 5, tipo = "Metal", color = {1, 1, 1}, atomo = 50, masa = 119, electrones = 50},
    {simbolo = "Sb", nombre = "Antimonio", col = 15, row = 5, tipo = "Metaloide", color = {0.6, 0, 1}, atomo = 51, masa = 122, electrones = 51},
    {simbolo = "I", nombre = "Yodo", col = 16, row = 5, tipo = "Halógeno", color = {1, 0.6, 0}, atomo = 53, masa = 127, electrones = 53},
    {simbolo = "At", nombre = "Astato", col = 17, row = 5, tipo = "Halógeno", color = {1, 0.6, 0}, atomo = 85, masa = 210, electrones = 85},

}

 
function crearCuadroConEtiqueta(sceneGroup,x, y, color, tipo)
    local cuadro = display.newRect(sceneGroup,x, y, 30, 30)
    cuadro:setFillColor(color[1], color[2], color[3])      

    --Etiqueta con el tipo de elemento
    local etiqueta = display.newText(sceneGroup,tipo, x, y + 35,native.systemFontBold, 14)
    etiqueta:setFillColor(1, 1, 1)  -- Color de texto negro

end

-- Cuadros de colores para los tipos de elementos
local tiposDeElementos = {
    {tipo = "No metal", color = {0.2, 1, 0}},  -- Verde
    {tipo = "Gas noble", color = {1, 1, 0}},   -- Amarillo
    {tipo = "Metal alcalino", color = {0.4, 0.7, 1}}, -- Azul claro
    {tipo = "Metal", color = {1, 1, 1}},  -- Blanco
    {tipo = "Metaloide", color = {0.6, 0, 1}},  -- Morado
    {tipo = "Halógeno", color = {1, 0.6, 0}}  -- Naranja
}


-- Función para manejar la selección de un elemento
local function seleccionarElemento(self, event)
        local nombreElemento=self.elemento.nombre
        local masa = self.elemento.masa
        local electrones = self.elemento.electrones
        local atomo = self.elemento.atomo --cantidad de protones
        local simbolo=self.elemento.simbolo

        if event.phase == "ended" then
        local options = {
            effect = "fromTop",  
            time = 1000,      
            params = {        
                nombreElemento = nombreElemento,
                masa = masa,
                electrones = electrones,
                atomo = atomo,
                simbolo = simbolo

            }
        }
        composer.gotoScene("modeloB", options)
        
    end
    return true
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fondo de la tabla periódica
    local fondo = display.newImageRect(sceneGroup, "Wallper.jpg", CW,CH)
    fondo.x = CW/2
    fondo.y = CH/2

    -- Calcular el desplazamiento horizontal para centrar la tabla
    local totalWidth = (maxCols - 1) * spacingX  -- Ancho total de las columnas
    local startX = centerX - totalWidth / 2  -- Posición inicial en X para centrar

     local titulo = display.newText({
        parent = sceneGroup,
        text = "Tabla periódica y representación atómica.", 
        x = centerX, 
        y = 115, 
        font = native.systemFontBold, 
        fontSize = 40
    })
    titulo:setFillColor(1, 1,1)  


    
    -- Dibujar los elementos como rectángulos
    for _, elemento in ipairs(elementos) do
        local xPos = centerX + (elemento.col - 1) * spacingX - (spacingX * 8) -- Ajustar la posición
        local yPos = centerY + (elemento.row - 1) * spacingY - (spacingY * 3) -- Ajustar la posición

        local boton = display.newRect(sceneGroup, xPos, yPos, 40, 40)
        boton:setFillColor(unpack(elemento.color))
        boton.elemento = elemento 
        boton.touch = seleccionarElemento
        boton:addEventListener("touch", boton)

        
        local texto = display.newText({
            parent = sceneGroup,
            text = elemento.simbolo,
            x = xPos,
            y = yPos,
            font = native.systemFontBold, 
            fontSize = 16
        })
        texto:setFillColor(0)  

    end
    
    for i, tipoElemento in ipairs(tiposDeElementos) do
        local x = 50 + (i - 1) * 100
        local y = CH-180
        crearCuadroConEtiqueta(sceneGroup,x, y, tipoElemento.color, tipoElemento.tipo)
    end

end

-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
 
    elseif ( phase == "did" ) then
         
    end
end
 


scene:addEventListener("create", scene)

return scene
