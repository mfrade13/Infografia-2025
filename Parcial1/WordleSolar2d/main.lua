-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here


local network = require("network")
local composer = require("composer")


green = {79/255, 143/255, 40/255}
yellow = {186/255, 175/255, 54/255}

CH = display.contentHeight
CW = display.contentWidth
gridSize = 50  
rows, cols = 16, 9 

composer.gotoScene("menu", {effect = "fade", time = 500})