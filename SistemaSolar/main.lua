local Sol = require("clases.Sol")
local Planeta = require("clases.Planeta")
local Luna = require("clases.Luna")
local Cometa = require("clases.Cometa")

local UI = require("controladores.UI")


local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Fondo
local fondo = display.newImageRect("assets/fondo/galaxia.jpeg", display.actualContentWidth, display.actualContentHeight)
fondo.x = centerX
fondo.y = centerY

-- Estado de movimiento global
local estadoMovimiento = { enMovimiento = false }

-- Crear el Sol
local sol = Sol:new({
    img = "assets/planetas/sol.png",
    width = 350,
    height = 350,
    x = centerX,
    y = centerY,
    rotationSpeed = 0.5
})

local planetas = {}
local lunaCount = 1

-- Planetas 1 al 4 generados con bucle
for i = 1, 4 do
    local planeta = Planeta:new({
        img = "assets/planetas/planeta" .. i .. ".png",
        width = 30 + (i % 2) * 10,
        height = 30 + (i % 2) * 10,
        orbitCenter = sol.image,
        orbitRadius = 120 + i * 40,
        speed = 1.5 - i * 0.15,
        rotationSpeed = 2 + i * 0.2
    })

    planeta:update(0)
    planeta.finalX = planeta.image.x
    planeta.finalY = planeta.image.y
    planeta.image.x = centerX
    planeta.image.y = centerY

    -- A los planetas 2 y 4 les ponemos una luna
    if i == 2 or i == 4 then
        local luna = Luna:new({
            img = "assets/planetas/luna" .. lunaCount .. ".png",
            width = 15,
            height = 15,
            orbitCenter = planeta.image,
            orbitRadius = 30,
            speed = 0.2 + i * 0.2
        })
        luna:update(0)
        luna.finalX = luna.image.x
        luna.finalY = luna.image.y
        luna.image.x = centerX
        luna.image.y = centerY

        planeta:addLuna(luna)
        lunaCount = lunaCount + 1
    end

    table.insert(planetas, planeta)
end

-- Planeta 5 con 2 lunas
local planeta5 = Planeta:new({
    img = "assets/planetas/planeta5.png",
    width = 100,
    height = 100,
    orbitCenter = sol.image,
    orbitRadius = 320,
    speed = 0.5,
    rotationSpeed = 2.5
})
planeta5:update(0)
planeta5.finalX = planeta5.image.x
planeta5.finalY = planeta5.image.y
planeta5.image.x = centerX
planeta5.image.y = centerY

for j = 1, 2 do
    local luna = Luna:new({
        img = "assets/planetas/luna" .. lunaCount .. ".png",
        width = 16,
        height = 16,
        orbitCenter = planeta5.image,
        orbitRadius = 45 + j * 10,
        speed = 0.4 + j * 0.2
    })
    luna:update(0)
    luna.finalX = luna.image.x
    luna.finalY = luna.image.y
    luna.image.x = centerX
    luna.image.y = centerY

    planeta5:addLuna(luna)
    lunaCount = lunaCount + 1
end

table.insert(planetas, planeta5)

-- Planeta 6 con 1 luna lejana
local planeta6 = Planeta:new({
    img = "assets/planetas/planeta6.png",
    width = 70,
    height = 70,
    orbitCenter = sol.image,
    orbitRadius = 380,
    speed = 0.3,
    rotationSpeed = 1.7
})
planeta6:update(0)
planeta6.finalX = planeta6.image.x
planeta6.finalY = planeta6.image.y
planeta6.image.x = centerX
planeta6.image.y = centerY

local luna6 = Luna:new({
    img = "assets/planetas/luna" .. lunaCount .. ".png",
    width = 20,
    height = 20,
    orbitCenter = planeta6.image,
    orbitRadius = 60,
    speed = 0.5
})
luna6:update(0)
luna6.finalX = luna6.image.x
luna6.finalY = luna6.image.y
luna6.image.x = centerX
luna6.image.y = centerY

planeta6:addLuna(luna6)
lunaCount = lunaCount + 1

table.insert(planetas, planeta6)

-- Planeta 7 con 3 lunas pequeñas
local planeta7 = Planeta:new({
    img = "assets/planetas/planeta7.png",
    width = 35,
    height = 35,
    orbitCenter = sol.image,
    orbitRadius = 440,
    speed = 0.2,
    rotationSpeed = 3
})
planeta7:update(0)
planeta7.finalX = planeta7.image.x
planeta7.finalY = planeta7.image.y
planeta7.image.x = centerX
planeta7.image.y = centerY
lunaCount = 5

for j = 1, 3 do
    if lunaCount <= 7 then
        local luna = Luna:new({
            img = "assets/planetas/luna" .. lunaCount .. ".png",
            width = 12,
            height = 12,
            orbitCenter = planeta7.image,
            orbitRadius = 25 + j * 10,
            speed = 0.4 + j * 0.3
        })
        luna:update(0)
        luna.finalX = luna.image.x
        luna.finalY = luna.image.y
        luna.image.x = centerX
        luna.image.y = centerY

        planeta7:addLuna(luna)
        lunaCount = lunaCount + 1
    end
end

table.insert(planetas, planeta7)

-- Cometa
local cometa = Cometa:new({
    img = "assets/planetas/cometa.png",
    width = 40,
    height = 40,
    cx = centerX + 200,
    cy = centerY,
    a = 600,
    b = 100,
    speed = 1,
    rotationSpeed = 1
})

cometa.finalX = cometa.image.x
cometa.finalY = cometa.image.y
cometa.image.x = centerX
cometa.image.y = centerY


-- EnterFrame: solo si está en movimiento
local function onEnterFrame(event)
    if not estadoMovimiento.enMovimiento then return end

    local dt = 1 / display.fps
    sol:update(dt)

    for _, planeta in ipairs(planetas) do
        planeta:update(dt)

        if planeta.lunas then
            for _, luna in ipairs(planeta.lunas) do
                luna:update(dt)
            end
        end
    end

    cometa:update(dt)
end

Runtime:addEventListener("enterFrame", onEnterFrame)

-- Crear los botones de UI
UI.crearBotones(planetas, cometa, estadoMovimiento)

