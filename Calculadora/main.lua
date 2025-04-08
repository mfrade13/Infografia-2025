display.setStatusBar(display.HiddenStatusBar)

local widget = require("widget")

-- Constantes de pantalla
local CW, CH = display.contentWidth, display.contentHeight

-- Variables globales
local screenGroup = display.newGroup()
local textbox
local calculate = ""

-- Paleta de colores moderna
local bgColor = {0.1, 0.1, 0.1}
local btnColor = {default = {0.2, 0.2, 0.25}, over = {0.3, 0.3, 0.35}}
local textColor = {default = {1, 1, 1, 1}, over = {1, 1, 1, 1}}

-- Función para actualizar la orientación
local function onOrientationChange(event)
    local orientation = system.orientation
    local text = textbox.text
    display.remove(screenGroup)
    screenGroup = display.newGroup()
    if orientation == "portrait" or orientation == "portraitUpsideDown" then
        portrait()
    else
        landscape()
    end
    textbox.text = text
end

Runtime:addEventListener("orientation", onOrientationChange)

-- Fondo y caja de texto
function DisplayBackground(x, y)
    local background = display.newRect(screenGroup, CW / 2, CH / 2, CW * 2, CH * 2)
    background:setFillColor(unpack(bgColor))

    textbox = display.newText({
        parent = screenGroup,
        text = "",
        x = x,
        y = y,
        font = native.systemFontBold,
        fontSize = 40,
        align = "right",
    })
    textbox.anchorX = 1
    textbox:setFillColor(1, 1, 1)
end

-- Funciones
function cleanEvent()
    textbox.text = ''
    calculate = ""
    textbox.size = 40
end

function operation(event)
    local val = event.target.value
    if textbox.text == "Syntax Error" then
        textbox.text = val
        calculate = val
        return
    end

    local specialOps = {
        sin = " math.sin(", cos = " math.cos(", tan = " math.tan(",
        ln = " math.log(", log = " math.log10(", e = " math.exp(1)",
        ["π"] = " math.pi", ["√"] = " math.sqrt(", ["x^2"] = "^2",
        ["1/x"] = "1/"
    }

    if specialOps[val] then
        calculate = calculate .. specialOps[val]
        textbox.text = textbox.text .. " " .. val .. (val:match("[%a√]") and "(" or "")
    else
        calculate = calculate .. val
        textbox.text = textbox.text .. val
    end
    verify_border()
end

function delete()
    textbox.text = textbox.text:sub(1, -2)
    calculate = calculate:sub(1, -2)
end

function Calculate()
    local expression = "return " .. calculate
    local func = loadstring(expression)
    if pcall(func) then
        textbox.text = func()
        calculate = textbox.text
    else
        textbox.text = "Syntax Error"
        calculate = ""
    end
end

function isNumber(value)
    return value:match("^[-+]?%d*%.?%d+$") ~= nil
end

function round()
    if isNumber(textbox.text) then
        local expression = "return math.floor(" .. calculate .. " + 0.5)"
        local func = loadstring(expression)
        textbox.text = func()
        calculate = textbox.text
    end
end

-- Crear botones
function createButton(options, value, group)
    local button = widget.newButton(options)
    button.value = value
    group:insert(button)
end

function createStyleButton(label, x, y, width, height, event, group)
    return createButton({
        label = label,
        labelAlign = "center",
        id = label,
        left = x,
        top = y,
        width = width,
        height = height,
        shape = "roundedRect",
        cornerRadius = 12,
        fontSize = 22,
        fillColor = btnColor,
        labelColor = textColor,
        onPress = function(e)
            transition.to(e.target, {time = 50, xScale = 0.95, yScale = 0.95, onComplete = function()
                transition.to(e.target, {time = 50, xScale = 1, yScale = 1})
            end})
            event(e)
        end
    }, label, group)
end

function landscape()
    DisplayBackground(CH - 30, 60)
    local btns = {
        "AC", "7", "8", "9", "*", "sin", "^", "√",
        "(", "4", "5", "6", "+", "cos", "e", "x^2",
        ")", "1", "2", "3", "-", "tan", "log", "1/x",
        "/", "0", ".", "<-", "=", "π", "ln", ".00"
    }

    local cols, rows = 8, 4
    local margin = 10
    local btnW = (CH - margin * (cols + 1)) / cols
    local btnH = 50
    local startY = CW * 0.25

    for i, label in ipairs(btns) do
        local col = (i - 1) % cols
        local row = math.floor((i - 1) / cols)
        local x = margin + col * (btnW + margin)
        local y = startY + row * (btnH + margin)

        local event
        if label == "=" then event = Calculate
        elseif label == "AC" then event = cleanEvent
        elseif label == "<-" then event = delete
        elseif label == ".00" then event = round
        else event = operation end

        createStyleButton(label, x, y, btnW, btnH, event, screenGroup)
    end
end

function portrait()
    DisplayBackground(CW - 30, 120)
    local btns = {
        "AC", "(", ")", "/", 
        "7", "8", "9", "*",
        "4", "5", "6", "+",
        "1", "2", "3", "-",
        "0", ".", "<-", "="
    }

    local cols, rows = 4, 5
    local margin = 12
    local btnW = (CW - margin * (cols + 1)) / cols
    local btnH = 60
    local startY = CH * 0.35

    for i, label in ipairs(btns) do
        local col = (i - 1) % cols 
        local row = math.floor((i - 1) / cols)
        local x = margin + col * (btnW + margin)
        local y = startY + row * (btnH + margin)

        local event
        if label == "=" then event = Calculate
        elseif label == "AC" then event = cleanEvent
        elseif label == "<-" then event = delete
        else event = operation end

        createStyleButton(label, x, y, btnW, btnH, event, screenGroup)
    end
end

-- Adaptar tamaño de texto según contenido
function verify_border()
    if textbox.size > 20 then
        if string.len(textbox.text) > CW / textbox.size then
            textbox.size = textbox.size - 2
        end
    end
end

-- Iniciar con modo retrato
portrait()
