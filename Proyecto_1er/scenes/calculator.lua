local composer = require("composer")
local scene = composer.newScene()

local inputText, resultText
local currentInput = ""

local function setTheme(theme)
    theme = theme or "light"
    if theme == "dark" then
        return {
            background = {0.1, 0.1, 0.1},
            text = {1, 1, 1},
            button = {0.2, 0.2, 0.2, 0.8},
            accent = {0.3, 0.6, 1, 0.8},
            special = {0, 0.6, 0.2}
        }
    else
        return {
            background = {1, 1, 1},
            text = {0, 0, 0},
            button = {0.9, 0.9, 0.9, 0.8},
            accent = {0.2, 0.4, 1, 0.8},
            special = {0, 0.6, 0.2}
        }
    end
end

local function evaluateExpression(expr)
    local func, err = loadstring("return " .. expr)
    if func then
        local ok, result = pcall(func)
        if ok then
            return tostring(result)
        end
    end
    return "Error"
end

local function updateDisplay()
    inputText.text = currentInput
end

local function handleInput(value)
    if value == "C" then
        currentInput = ""
        resultText.text = "Resultado:"
    elseif value == "=" then
        resultText.text = "Resultado: " .. evaluateExpression(currentInput)
    elseif value == "sqrt" then
        currentInput = "math.sqrt(" .. currentInput .. ")"
    elseif value == "round" then
        currentInput = "math.floor(" .. currentInput .. " + 0.5)"
    elseif value == "pow2" then
        currentInput = "(" .. currentInput .. ")^2"
    elseif value == "+/-" then
        currentInput = "-(" .. currentInput .. ")"
    elseif value == "log10" then
        currentInput = "math.log10(" .. currentInput .. ")"
    elseif value == "%" then
        currentInput = currentInput .. " % "
    elseif value == "^" then
        currentInput = currentInput .. " ^ "
    else
        currentInput = currentInput .. value
    end
    updateDisplay()
end

local function createButton(config, group, theme)
    local btn = display.newRect(0, 0, config.width, config.height)
    btn.anchorX, btn.anchorY = 0, 0
    btn.x, btn.y = config.x, config.y

    local fill = config.fillColor or theme.button
    btn:setFillColor(unpack(fill))
    btn.strokeWidth = 2
    btn:setStrokeColor(0)
    group:insert(btn)

    local txt = display.newText({
        text = config.label,
        x = config.x + config.width / 2,
        y = config.y + config.height / 2,
        font = native.systemFontBold,
        fontSize = config.fontSize or 18,
    })
    txt:setFillColor(unpack(theme.text))
    txt.anchorX, txt.anchorY = 0.5, 0.5
    group:insert(txt)

    btn:addEventListener("tap", function()
        handleInput(config.label)
    end)
end

function scene:create(event)
    local sceneGroup = self.view

    local themeName = (event.params and event.params.theme) or "dark"
    local theme = setTheme(themeName)

    local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
    background.anchorX, background.anchorY = 0, 0
    background:setFillColor(unpack(theme.background))
    sceneGroup:insert(background)

    inputText = display.newText({
        parent = sceneGroup,
        text = "",
        x = display.contentCenterX,
        y = 50,
        fontSize = 24
    })
    inputText:setFillColor(unpack(theme.text))

    resultText = display.newText({
        parent = sceneGroup,
        text = "Resultado:",
        x = display.contentCenterX,
        y = 90,
        fontSize = 20
    })
    resultText:setFillColor(unpack(theme.text))

    local accent = theme.accent
    local special = theme.special
    local utility = {0.4, 0.4, 0.4, 0.8}

    local buttonsConfig = {
        {label="7", x=60, y=160, width=60, height=50},
        {label="8", x=130, y=160, width=60, height=50},
        {label="9", x=200, y=160, width=60, height=50},
        {label="/", x=270, y=160, width=60, height=50, fillColor=accent},

        {label="4", x=60, y=220, width=60, height=50},
        {label="5", x=130, y=220, width=60, height=50},
        {label="6", x=200, y=220, width=60, height=50},
        {label="*", x=270, y=220, width=60, height=50, fillColor=accent},

        {label="1", x=60, y=280, width=60, height=50},
        {label="2", x=130, y=280, width=60, height=50},
        {label="3", x=200, y=280, width=60, height=50},
        {label="-", x=270, y=280, width=60, height=50, fillColor=accent},

        {label="0", x=60, y=340, width=130, height=50},
        {label=".", x=200, y=340, width=60, height=50},
        {label="+", x=270, y=340, width=60, height=50, fillColor=accent},

        {label="sqrt", x=60, y=400, width=60, height=40, fillColor=utility},
        {label="pow2", x=130, y=400, width=60, height=40, fillColor=utility},
        {label="^", x=200, y=400, width=60, height=40, fillColor=utility},
        {label="round", x=270, y=400, width=60, height=40, fillColor=utility},

        {label="log10", x=60, y=450, width=60, height=40, fillColor=utility},
        {label="+/-", x=130, y=450, width=60, height=40, fillColor=utility},
        {label="%", x=200, y=450, width=60, height=40, fillColor=utility},
        {label="C", x=270, y=450, width=60, height=40, fillColor=utility},

        {label="=", x=60, y=510, width=270, height=50, fillColor=special, fontSize=20},
    }

    for _, config in ipairs(buttonsConfig) do
        createButton(config, sceneGroup, theme)
    end

    local btnBack = display.newRect(60, 570, 270, 40)
    btnBack.anchorX, btnBack.anchorY = 0, 0
    btnBack.strokeWidth = 2
    btnBack:setFillColor(0.2, 0.8, 0.5)
    btnBack:setStrokeColor(0)
    sceneGroup:insert(btnBack)

    local txtSettings = display.newText("Volver a Menu", btnBack.x + btnBack.width/2, btnBack.y + btnBack.height/2, native.systemFontBold, 20)
    txtSettings:setFillColor(unpack(theme.text))
    sceneGroup:insert(btnBack)
    sceneGroup:insert(txtSettings)

    btnBack:addEventListener("tap", function()
        composer.removeScene("scenes.calculator")
        composer.gotoScene("scenes.menu", {params = {theme = themeName}, effect = "slideRight"})
    end)    

end

scene:addEventListener("show", scene)
scene:addEventListener("create", scene)
return scene