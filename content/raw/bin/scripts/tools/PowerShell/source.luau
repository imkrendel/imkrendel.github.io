--[[
    .-./`) ,---.    ,---..--.   .--.  .-------.        .-''-.  ,---.   .--. ______         .-''-.    .---.      
    \ .-.')|    \  /    ||  | _/  /   |  _ _   \     .'_ _   \ |    \  |  ||    _ `''.   .'_ _   \   | ,_|      
    / `-' \|  ,  \/  ,  || (`' ) /    | ( ' )  |    / ( ` )   '|  ,  \ |  || _ | ) _  \ / ( ` )   ',-./  )      
     `-'`"`|  |\_   /|  ||(_ ()_)     |(_ o _) /   . (_ o _)  ||  |\_ \|  ||( ''_'  ) |. (_ o _)  |\  '_ '`)    
     .---. |  _( )_/ |  || (_,_)   __ | (_,_).' __ |  (_,_)___||  _( )_\  || . (_) `. ||  (_,_)___| > (_)  )    
     |   | | (_ o _) |  ||  |\ \  |  ||  |\ \  |  |'  \   .---.| (_ o _)  ||(_    ._) ''  \   .---.(  .  .-'    
     |   | |  (_,_)  |  ||  | \ `'   /|  | \ `'   / \  `-'    /|  (_,_)\  ||  (_.\.' /  \  `-'    / `-'`-'|___  
     |   | |  |      |  ||  |  \    / |  |  \    /   \       / |  |    |  ||       .'    \       /   |        \ 
     '---' '--'      '--'`--'   `'-'  ''-'   `'-'     `'-..-'  '--'    '--''-----'`       `'-..-'    `--------` 
    PowerShell
    Developed by imkrendel | https://github.com/imkrendel
]]

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Config
local USE_DISPLAY_NAME = true
local currentPath = ""

-- Creating rconsole
rconsolecreate()
rconsolesettitle("Powershell")

-- Color Helpers
local function printWarn(text)
    if rconsolewarn then rconsolewarn(text) else rconsoleprint("[WARN] " .. text) end
end

local function printErr(text)
    if rconsoleerr then rconsoleerr(text) elseif rconsoleerror then rconsoleerror(text) else rconsoleprint("[ERR] " .. text) end
end

local function printInfo(text)
    rconsoleprint(text)
end

-- Helpers
local function trim(str)
    if not str then return "" end
    return str:gsub("[\r\n]", ""):match("^%s*(.-)%s*$") or ""
end

local function fixSlashes(str)
    return str:gsub("\\", "/")
end

local function getPrompt()
    local name = USE_DISPLAY_NAME and LocalPlayer.DisplayName or LocalPlayer.Name
    local displayPath = currentPath == "" and "/" or "/" .. currentPath
    return string.format("%s@%s> ", name, displayPath)
end

local function getCleanName(path)
    path = fixSlashes(path)
    if path:sub(-1) == "/" then path = path:sub(1, -2) end
    return path:match("([^/]+)$") or path
end

-- Main Loop
task.spawn(function()
    rconsoleclear()
    while true do
        rconsoleprint(getPrompt())

        local rawInput = rconsoleinput()
        local input = trim(rawInput)
        if input == "" then
            rconsoleprint("\n")
            continue
        end
        
        -- Разбор команды
        local cmd, target = input:match("^(%S+)%s*(.*)$")
        cmd = cmd and cmd:lower() or ""
        target = trim(target or "")
        
        local cleanTarget = fixSlashes(target):gsub("^/+", ""):gsub("/+$", "")
        
        if cmd == "exit" then
            printErr("Closing console...\n")
            task.wait(0.5)
            rconsoledestroy()
            break
            
        elseif cmd == "pwd" then
            local displayPath = currentPath == "" and "/" or "/" .. currentPath
            printInfo(displayPath .. "\n")
            
        elseif cmd == "cls" or cmd == "clear" then
            rconsoleclear()
            
        elseif cmd == "cd" then
            if cleanTarget == "" or cleanTarget == "/" then
                currentPath = ""
            elseif cleanTarget == ".." then
                if currentPath ~= "" then
                    local parts = string.split(currentPath, "/")
                    table.remove(parts, #parts)
                    currentPath = table.concat(parts, "/")
                end
            else
                local directPath = currentPath == "" and cleanTarget or (currentPath .. "/" .. cleanTarget)
                
                if isfolder(directPath) then
                    currentPath = directPath
                else
                    local foundFolder = nil
                    local rawFiles = listfiles(currentPath)
                    
                    for _, file in ipairs(rawFiles) do
                        local clean = getCleanName(file)
                        if isfolder(file) and clean:lower() == cleanTarget:lower() then
                            foundFolder = fixSlashes(file)
                            break
                        end
                    end
                    
                    if foundFolder then
                        currentPath = foundFolder:gsub("^workspace/", ""):gsub("^/+", "")
                    else
                        printErr("Error: Directory '" .. target .. "' not found.\n")
                    end
                end
            end
            
        elseif cmd == "tree" or cmd == "ls" or cmd == "dir" or cmd == "listfiles" then
            local rawFiles = listfiles(currentPath)
            if #rawFiles == 0 then
                printWarn("[Empty Directory]\n")
            else
                for _, file in ipairs(rawFiles) do
                    local cleanName = getCleanName(file)
                    if isfolder(file) then
                        printWarn(string.format("[DIR]  %s/\n", cleanName))
                    else
                        printInfo(string.format("[FILE] %s\n", cleanName))
                    end
                end
            end

        elseif cmd == "cat" or cmd == "read" then
            if cleanTarget == "" then
                printErr("Usage: cat <filename>\n")
            else
                local filePath = currentPath == "" and cleanTarget or (currentPath .. "/" .. cleanTarget)
                if isfile(filePath) then
                    local content = readfile(filePath)
                    printInfo("--- " .. getCleanName(filePath) .. " ---\n")
                    printInfo(content .. "\n--------------------\n")
                else
                    printErr("Error: File '" .. target .. "' not found.\n")
                end
            end

        elseif cmd == "mkdir" then
            if cleanTarget == "" then
                printErr("Usage: mkdir <foldername>\n")
            else
                local folderPath = currentPath == "" and cleanTarget or (currentPath .. "/" .. cleanTarget)
                makefolder(folderPath)
                printInfo("Created directory: " .. cleanTarget .. "\n")
            end

        elseif cmd == "touch" or cmd == "write" then
            local fileName, fileContent = target:match("^(%S+)%s*(.*)$")
            if not fileName or fileName == "" then
                printErr("Usage: write <filename> [text]\n")
            else
                local filePath = currentPath == "" and fileName or (currentPath .. "/" .. fileName)
                writefile(filePath, fileContent or "")
                printInfo("File saved: " .. fileName .. "\n")
            end

        elseif cmd == "rm" or cmd == "del" then
            if cleanTarget == "" then
                printErr("Usage: rm <file/folder>\n")
            else
                local path = currentPath == "" and cleanTarget or (currentPath .. "/" .. cleanTarget)
                if isfile(path) then
                    delfile(path)
                    printInfo("Deleted file: " .. cleanTarget .. "\n")
                elseif isfolder(path) then
                    delfolder(path)
                    printInfo("Deleted directory: " .. cleanTarget .. "\n")
                else
                    printErr("Error: File or directory not found.\n")
                end
            end
            
        else
            local targetFile = cmd
            if not targetFile:find("%.lua$") and not targetFile:find("%.luau$") then
                targetFile = targetFile .. ".lua"
            end
            
            local directFile = currentPath == "" and targetFile or (currentPath .. "/" .. targetFile)
            local foundFile = nil
            
            if isfile(directFile) then
                foundFile = directFile
            else
                local rawFiles = listfiles(currentPath)
                for _, file in ipairs(rawFiles) do
                    local clean = getCleanName(file)
                    if isfile(file) and clean:lower() == targetFile:lower() then
                        foundFile = fixSlashes(file)
                        break
                    end
                end
            end
            
            if foundFile then
                printWarn("Executing " .. getCleanName(foundFile) .. "...\n")
                local success, err = pcall(function()
                    dofile(foundFile)
                end)
                if success then
                    printInfo("Executed successfully.\n")
                else
                    printErr("Execution Error: " .. tostring(err) .. "\n")
                end
            else
                printErr("Unknown command or file: " .. cmd .. "\n")
            end
        end
    end
end)