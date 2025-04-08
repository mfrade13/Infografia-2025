local composer = require( "composer" )
local network = require( "network" ) 
local url = "http://localhost:3000/word"
local json = require( "json" )
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local language;
local difficulty;
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local qwerty = { "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
                    "A", "S", "D", "F", "G", "H", "J", "K", "L", "Ñ",
                    "Z", "X", "C", "V", "B", "N", "M" } 


local keyfont = "Cooper Black";
local keys = {}   
local guessWord; 
local guessWordLen;

local playerWord = {};


local guessKeyGrid;
local guessSpace;
local guessKeySize;
local TRIES = 5;

local keyboardGroup = display.newGroup();
local guessWordGroup = display.newGroup();
local endGameGroup = display.newGroup();

guessWordGroup.y = 150;

local userWordBlocksDisplay = {};
local userWordDisplay = {};
local playerGuess = 1;

function wordRequestCoroutine()
    local co = coroutine.running() -- Get the current coroutine

    -- Define the network request callback
    local function wordRequest(event)
        if (event.isError) then
            print("Network error: ", event.response)
            coroutine.resume(co, nil, "Network error") -- Resume coroutine with error
        else
            print("RESPONSE: ", event.response)
            local response = json.decode(event.response)
            if response then
                coroutine.resume(co, response.word, tonumber(response.length)) -- Resume coroutine with word and length
            else
                coroutine.resume(co, nil, "Failed to decode JSON response") -- Resume coroutine with error
            end
        end
    end

    -- Make the network request
    local param_url = url .. "/" .. language .. "/" .. difficulty
    network.request(param_url, "GET", wordRequest)

    -- Pause the coroutine until the callback resumes it
    return coroutine.yield()
end


function initGuessDisplay()
    for i=1, TRIES do
        userWordBlocksDisplay[i] = {};
        userWordDisplay[i] = {};
    end
end

function clearGuessDisplay()
    for i=1, TRIES do
        for j=1, guessWordLen do
            if userWordBlocksDisplay[i][j] then
                display.remove(userWordBlocksDisplay[i][j]);
                userWordBlocksDisplay[i][j] = nil;
            end
            if userWordDisplay[i][j] then
                display.remove(userWordDisplay[i][j]);
                userWordDisplay[i][j] = nil;
            end
        end
    end
end


function deleteChar()
    local last = #playerWord
    if last > 0 then
        table.remove(playerWord, last) -- Remove last character from the array
        display.remove(userWordDisplay[playerGuess][last]) -- Remove last character from display
        print("Current word: ", table.concat(playerWord)) -- Print the array as a string
    end
end

function addChar(key)
    if #playerWord < guessWordLen then
        table.insert(playerWord, key) -- Add character to the array
        local pos = #playerWord

        local textOptions = {
            parent = guessWordGroup,
            text = key,
            x = (pos - 1) * guessKeyGrid + guessKeySize / 4,
            y = (playerGuess - 1) * guessKeyGrid + guessKeySize / 4,
            font = keyfont,
            fontSize = guessKeySize / 2,
            align = "center"
        }
        userWordDisplay[playerGuess][pos] = display.newText(textOptions)
        userWordDisplay[playerGuess][pos]:setFillColor(1)
        userWordDisplay[playerGuess][pos].anchorX = 0
        userWordDisplay[playerGuess][pos].anchorY = 0
        print("playerWord: ", table.concat(playerWord)) -- Print the array as a string
    end
end

function keyScreeenPressed(event)
    if event.phase == "ended" then
        local key = event.target.text;
        if key == "Enter" then
            checkWord();
        elseif key == "Delete" then
            deleteChar();
        else
            addChar(key);
        end
    end
end


function onKeyEvent(event)
    local phase = event.phase
    local keyName = string.upper(event.keyName)

    if phase == "up" then
        if keyName == "DELETEBACK" then
            deleteChar()
        elseif keyName == "ENTER" then
            checkWord();
        elseif isValidKey(keyName) then
            addChar(keyName)
        end
    end

    return false -- Return false to allow other listeners to handle the event

end

function isValidKey(keyName)
    local val = string.byte(keyName);
    if val >= 65 and val <= 90 then -- A-Z
        return true
    end
    return false
end


function createKeyBoard()
      
    local keyboardCell = CW/10;
    local keySpace = keyboardCell/9;
    local keysize = keyboardCell - keySpace;

    
    -- keyboard
    local backgrouynd = display.newRect(keyboardGroup, 0, 0, CW, 3*keyboardCell);
    backgrouynd:setFillColor(0.8);
    backgrouynd.anchorX = 0;
    backgrouynd.anchorY = 0;
    
      
    for y = 1, 2 do
        for x = 1, 10 do
            local index = (y-1)*10 + x;
            local letter = qwerty[index];
            local pos_x = (x-1)*keyboardCell;
            local pos_y = (y-1)*keyboardCell;
            keys[letter] = display.newRoundedRect(keyboardGroup, pos_x, pos_y, keysize, keysize, 5);
            keys[letter]:setFillColor(0.5);
            keys[letter].anchorX = 0;
            keys[letter].anchorY = 0;
            keys[letter].text = letter;
            
            local text = display.newText(keyboardGroup, qwerty[index], pos_x + keysize/2, pos_y + keysize/2, keyfont, keysize/2);
        end        
    end

    --last row
    for x = 1, 7 do
        local index = 20 + x;
        local letter = qwerty[index];
        local pos_x = (x)*keyboardCell;
        local pos_y = 2*keyboardCell;
        keys[letter] = display.newRoundedRect(keyboardGroup, pos_x, pos_y, keysize, keysize, 5);
        keys[letter]:setFillColor(0.5);
        keys[letter].anchorX = 0;
        keys[letter].anchorY = 0;
        keys[letter].text = letter;
        local text = display.newText(keyboardGroup, qwerty[index], pos_x + keysize/2, pos_y + keysize/2, keyfont, keysize/2);
    end

    -- buttons
    delete_button = display.newRoundedRect(keyboardGroup, 0, 2*keyboardCell, keysize, keysize, 5);
    delete_button.text = "Delete";
    delete_button.anchorX = 0;
    delete_button.anchorY = 0;
    delete_button:setFillColor(0.3);
   
    local icon = display.newImageRect(keyboardGroup, "Assets/backspace1.png", keysize/2, keysize/2);
    icon.anchorX = 0; icon.anchorY = 0;
    icon.x = 0+(keysize/4); icon.y = (2*keyboardCell)+(keysize/4);

    enter_button = display.newRoundedRect(keyboardGroup, 8*keyboardCell, 2*keyboardCell, 2*keysize + keySpace, keysize, 5);
    enter_button.anchorX = 0;
    enter_button.anchorY = 0;
    enter_button.text = "Enter";
    enter_button:setFillColor(green[1], green[2], green[3]);
    enter_text = display.newText(keyboardGroup, "Enter", 8*keyboardCell + keysize/4, 2*keyboardCell + keysize/4, keyfont, keysize/2);
    enter_text.anchorX = 0;
    enter_text.anchorY = 0;

    keyboardGroup.y = CH - keyboardCell*3.5;

end

function createHeader(sceneGroup)
    
    homeButton = display.newRoundedRect(sceneGroup, 0.25*gridSize, 0.25*gridSize, 1.5*gridSize, 1.5*gridSize, 20);
    homeButton:setFillColor(green[1], green[2], green[3]);
    homeButton.anchorX = 0;
    homeButton.anchorY = 0;
    homeButton.touch = goHome;
   
    local homeIcon = display.newImageRect(sceneGroup, "Assets/home.png", gridSize, gridSize);
    homeIcon.anchorX = 0; homeIcon.anchorY = 0;
    homeIcon.x = 0.25*gridSize + gridSize/4; homeIcon.y = 0.25*gridSize + gridSize/4;

    local tittle_options = {
        parent = sceneGroup,
        text = "Wordle",
        x = 2*gridSize,
        y = 0.1*gridSize,
        font = "Gill Sans Ultra Bold",
        fontSize = 75,
        align = "center"
    }
    local title = display.newText( tittle_options );
    title.anchorX = 0;
    title.anchorY = 0;
    title:setFillColor( 0.2 );  
end

function createGuessSpace(wordlen)
     
    guessKeyGrid = CW/wordlen;
    guessSpace = 5;
    guessKeySize = guessKeyGrid - guessSpace;

    for y=1, TRIES do
        for x=1, wordlen do
            userWordBlocksDisplay[y][x] = display.newRoundedRect(guessWordGroup, (x-1)*guessKeyGrid, (y-1)*guessKeyGrid, guessKeySize, guessKeySize, 10);
            userWordBlocksDisplay[y][x]:setFillColor(0.7);
            userWordBlocksDisplay[y][x].anchorX = 0; userWordBlocksDisplay[y][x].anchorY = 0;
        end
    end
end


function checkWord()
    if #playerWord ~= guessWordLen then
        print("Word length is incorrect!")
        return
    end

    local playerWordStr = table.concat(playerWord) -- Convert array to string for comparison
    if playerWordStr == guessWord then
        for i = 1, guessWordLen do
            userWordBlocksDisplay[playerGuess][i]:setFillColor(green[1], green[2], green[3])
            local playerWordChar = playerWord[i]
            keys[playerWordChar]:setFillColor(green[1], green[2], green[3])
        end

        endGame(true)
        return
    else
        print("Incorrect!")
        local auxGuessWord = guessWord

        for i = 1, guessWordLen do
            local guessWordChar = string.sub(guessWord, i, i)
            local playerWordChar = playerWord[i]

            if guessWordChar == playerWordChar then
                userWordBlocksDisplay[playerGuess][i]:setFillColor(green[1], green[2], green[3])
                keys[playerWordChar]:setFillColor(green[1], green[2], green[3])
            elseif string.find(auxGuessWord, playerWordChar, 1, true) then
                userWordBlocksDisplay[playerGuess][i]:setFillColor(yellow[1], yellow[2], yellow[3])
                keys[playerWordChar]:setFillColor(yellow[1], yellow[2], yellow[3])
                auxGuessWord = string.gsub(auxGuessWord, playerWordChar, "", 1)
            else
                userWordBlocksDisplay[playerGuess][i]:setFillColor(0.2)
                keys[playerWordChar]:setFillColor(0.2)
            end
        end

        playerWord = {} 
    end

    if playerGuess < TRIES then
        playerGuess = playerGuess + 1
    else
        print("No more attempts left!")
        endGame(false)
    end
end

function disableButtons()
    for i,v in pairs(qwerty) do
        keys[v]:removeEventListener("touch", keyScreeenPressed);
        keys[v]:setFillColor(0.5); 
    end
    delete_button:removeEventListener("touch", keyScreeenPressed);
    enter_button:removeEventListener("touch", keyScreeenPressed);
    homeButton:removeEventListener("touch", goHome);
end


function goHome(event)
    if event.phase == "ended" then
        composer.gotoScene("menu", {effect = "fade", time = 200})
    end
    
end


function endGame (won)
    endGameGroup = display.newGroup();
    endGameGroup.isVisible = true;

    local background = display.newRect(endGameGroup, 0, 0, CW, CH);
    background.anchorX = 0; background.anchorY = 0;
    background:setFillColor(0, 0.5);

    local text_options = {
        parent = endGameGroup,
        text = (won and "¡Ganaste!" or "Perdiste!"),
        x = CW/2,
        y = gridSize*5,
        font = keyfont,
        fontSize = 60,
        align = "center"
    }
    local text = display.newText(text_options);
    local home = display.newImageRect(endGameGroup, "Assets/home.png", 2*gridSize, 2*gridSize);
    home.anchorY = 0;
    home.x = CW/2; home.y = gridSize*7;
    home:addEventListener("touch", goHome);

    if not won then
        local text_options = {
            parent = endGameGroup,
            text = "La palabra era:\n" .. guessWord,
            x = CW/2,
            y = gridSize*12,
            font = keyfont,
            fontSize = 40,
            align = "center"
        }
        local text = display.newText(text_options);
    end


    disableButtons();
end

-- create()
function scene:create( event )
    
    local sceneGroup = self.view
    local params = event.params
    createHeader(sceneGroup);
    createKeyBoard();
    

end
 
 
-- show()
function scene:show( event )
    local params = event.params
    language = params.language;
    difficulty = params.difficulty;
    print("Language: ", language)
    print("Difficulty: ", difficulty)
    
    display.setDefault( "background", 1 )
    playerWord = {};
    playerGuess = 1;

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        keyboardGroup.isVisible = true;
        guessWordGroup.isVisible = true;
        coroutine.wrap(function()
            guessWord, guessWordLen = wordRequestCoroutine();
            guessWord = string.upper(guessWord);
            if guessWord then
                print("word: ", guessWord)
                print("wordlen: ", guessWordLen);
                initGuessDisplay();
                createGuessSpace(guessWordLen);             
                
            else
                print("Failed to retrieve word")
            end
        end)()
 
    elseif ( phase == "did" ) then

        for i,v in pairs(qwerty) do
            keys[v]:addEventListener("touch", keyScreeenPressed);
        end
        delete_button:addEventListener("touch", keyScreeenPressed);
        enter_button:addEventListener("touch", keyScreeenPressed);
        homeButton:addEventListener("touch", keyScreeenPressed);
        -- Add the event listener
        Runtime:addEventListener("key", onKeyEvent)
            
 
    end
end
 
-- hide()
function scene:hide( event )
    
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        keyboardGroup.isVisible = false;
        guessWordGroup.isVisible = false;
        endGameGroup.isVisible = false;
        Runtime:removeEventListener("key", onKeyEvent)
 
    elseif ( phase == "did" ) then
        disableButtons();
        clearGuessDisplay();
    
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
