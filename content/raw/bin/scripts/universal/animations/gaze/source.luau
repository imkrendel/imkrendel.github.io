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
    Updated by imkrendel 
    Repack by ImKrednel | https://github.com/imkrendel
    Author - Gazer Ha   | https://github.com/Gazer-Ha
]]


pcall(function()

if not game.Players.LocalPlayer.Character or game.Players.LocalPlayer.Character:WaitForChild("Humanoid").RigType ~= Enum.HumanoidRigType.R15 then 
    game.StarterGui:SetCore("SendNotification", {Title = "R6", Text = "You're on R6, bro. Change to R15!", Duration = 60})
    return
end

local st = os.clock()
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local camera = workspace.CurrentCamera

cloneref = cloneref or function(o) return o end
local GazeGoGui = cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local GAZE_FOLDER = "Sifity/Gaze/"
local ANIMATIONS_FILE = GAZE_FOLDER .. "animations.json"
local LAST_ANIMATIONS_FILE = GAZE_FOLDER .. "last_used.json"
local CUSTOM_ANIMATIONS_FILE = GAZE_FOLDER .. "custom_animations.json"
local ANIMATIONS_URL = "https://imkrendel.github.io/content/raw/bin/scripts/universal/animations/gaze/animations.json"

local function ensureFolderExists()
    if not isfolder("Sifity") then
        makefolder("Sifity")
    end
    if not isfolder("Sifity/Gaze") then
        makefolder("Sifity/Gaze")
    end
    if not isfolder(GAZE_FOLDER) then
        makefolder(GAZE_FOLDER)
    end
end

local function downloadAnimations()
    local success, result = pcall(function()
        return game:HttpGet(ANIMATIONS_URL)
    end)
    
    if success and result then
        writefile(ANIMATIONS_FILE, result)
        return true
    end
    return false
end

ensureFolderExists()


local Notifbro = {}
function Notify(titletxt, text, time)
    coroutine.wrap(function()
        local GUI = Instance.new("ScreenGui")
        local Main = Instance.new("Frame", GUI)
        local title = Instance.new("TextLabel", Main)
        local message = Instance.new("TextLabel", Main)

        GUI.Name = "BackgroundNotif"
        GUI.Parent = GazeGoGui

        local sw = workspace.CurrentCamera.ViewportSize.X
        local sh = workspace.CurrentCamera.ViewportSize.Y
        local nh = sh / 7
        local nw = sw / 5

        Main.Name = "MainFrame"
        Main.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        Main.BackgroundTransparency = 0.2
        Main.BorderSizePixel = 0
        Main.Size = UDim2.new(0, nw, 0, nh)

        title.BackgroundColor3 = Color3.new(0, 0, 0)
        title.BackgroundTransparency = 0.9
        title.Size = UDim2.new(1, 0, 0, nh / 2)
        title.Font = Enum.Font.GothamBold
        title.Text = titletxt
        title.TextColor3 = Color3.new(1, 1, 1)
        title.TextScaled = true

        message.BackgroundColor3 = Color3.new(0, 0, 0)
        message.BackgroundTransparency = 1
        message.Position = UDim2.new(0, 0, 0, nh / 2)
        message.Size = UDim2.new(1, 0, 1, -nh / 2)
        message.Font = Enum.Font.Gotham
        message.Text = text
        message.TextColor3 = Color3.new(1, 1, 1)
        message.TextScaled = true

        local offset = 50
        for _, notif in ipairs(Notifbro) do
            offset = offset + notif.Size.Y.Offset + 10
        end

        Main.Position = UDim2.new(1, 5, 0, offset)
        table.insert(Notifbro, Main)

        task.wait(0.1)
        Main:TweenPosition(UDim2.new(1, -nw, 0, offset), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
        Main:TweenSize(UDim2.new(0, nw * 1.06, 0, nh * 1.06), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.5, true)
        task.wait(0.1)
        Main:TweenSize(UDim2.new(0, nw, 0, nh), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 0.2, true)

        task.wait(time)

        Main:TweenSize(UDim2.new(0, nw * 1.06, 0, nh * 1.06), Enum.EasingDirection.In, Enum.EasingStyle.Elastic, 0.2, true)
        task.wait(0.2)
        Main:TweenSize(UDim2.new(0, nw, 0, nh), Enum.EasingDirection.In, Enum.EasingStyle.Elastic, 0.2, true)
        task.wait(0.2)
        Main:TweenPosition(UDim2.new(1, 5, 0, offset), Enum.EasingDirection.In, Enum.EasingStyle.Bounce, 0.5, true)
        task.wait(0.1)

        GUI:Destroy()
        for i, notif in ipairs(Notifbro) do
            if notif == Main then
                table.remove(Notifbro, i)
                break
            end
        end

        for i, notif in ipairs(Notifbro) do
            local newOffset = 50 + (nh + 10) * (i - 1)
            notif:TweenPosition(UDim2.new(1, -nw, 0, newOffset), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
        end
    end)()
end

task.wait(0.1)

local guiName = "GazeVerificator"
if GazeGoGui:FindFirstChild(guiName) then
    Notify("Error","Script Already Executed", 1)
    return
end

local Animations = {}
if not isfile(ANIMATIONS_FILE) then
    Notify("Downloading", "Downloading animations database...", 3)
    if downloadAnimations() then
        Notify("Success", "Animations downloaded!", 2)
    else
        Notify("Error", "Failed to download animations!", 5)
        return
    end
end

if isfile(ANIMATIONS_FILE) then
    local data = readfile(ANIMATIONS_FILE)
    Animations = HttpService:JSONDecode(data)
    Notify("Loaded", "Main animations loaded", 2)
end

if isfile(CUSTOM_ANIMATIONS_FILE) then
    local customData = readfile(CUSTOM_ANIMATIONS_FILE)
    local customAnims = HttpService:JSONDecode(customData)
    for animType, anims in pairs(customAnims) do
        if not Animations[animType] then
            Animations[animType] = {}
        end
        for name, ids in pairs(anims) do
            Animations[animType][name] = ids
        end
    end
    Notify("Loaded", "Custom animations loaded", 2)
end


local function getScaledSize(relativeWidth, relativeHeight)
    local viewportSize = camera.ViewportSize
    return UDim2.new(0, math.floor(viewportSize.X * relativeWidth), 0, math.floor(viewportSize.Y * relativeHeight))
end


local core = cloneref(game.CoreGui)
local old = core:FindFirstChild("DraggableGui")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggableGui"
screenGui.Parent = core


local frame = Instance.new("TextButton")
frame.Name = "GazeBro"
frame.Text = ""
frame.Size = getScaledSize(0.3, 0.4)
frame.Position = UDim2.new(0.5, -getScaledSize(0.3,0.4).X.Offset/2, 0.5, -getScaledSize(0.3,0.4).Y.Offset/2)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(0,0,0)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local holding = false
local startTime = 0
local startPos

local function fadeOut()
    local t = frame.BackgroundTransparency
    while t < 1 do
        if t < 0.7 then
            t = t + 0.05
        else
            t = t + 0.015
        end
        if t > 1 then t = 1 end
        frame.BackgroundTransparency = t
        task.wait(0.02)
    end
end

local function fadeIn()
    local t = frame.BackgroundTransparency
    while t > 0.2 do
        if t > 0.7 then
            t = t - 0.015
        else
            t = t - 0.05
        end
        if t < 0.2 then t = 0.2 end
        frame.BackgroundTransparency = t
        task.wait(0.02)
    end
end

local function movedFar()
    local currentPos = frame.AbsolutePosition
    local dx = math.abs(currentPos.X - startPos.X)
    local dy = math.abs(currentPos.Y - startPos.Y)
    return dx >= 20 or dy >= 20
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        holding = true
        startTime = os.clock()
        startPos = frame.AbsolutePosition
        while holding do
            if movedFar() then
                break
            end
            if os.clock() - startTime >= 3 then
                if frame.BackgroundTransparency < 1 then
                    fadeOut()
                else
                    fadeIn()
                end
                break
            end
            task.wait()
        end
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        holding = false
    end
end)

local labelSize = UDim2.new(1, 0, 0.1, 0)

local gazeLabel = Instance.new("TextLabel")
gazeLabel.Name = "GazeLabel"
gazeLabel.Text = "GAZE"
gazeLabel.Font = Enum.Font.SourceSansBold
gazeLabel.TextScaled = true
gazeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gazeLabel.BackgroundTransparency = 1
gazeLabel.Size = labelSize
gazeLabel.Position = UDim2.new(0, 0, 0, 0)
gazeLabel.Parent = frame

local searchBar = Instance.new("TextBox")
searchBar.Name = "SearchBar"
searchBar.Text = ""
searchBar.PlaceholderText = "Search..."
searchBar.Font = Enum.Font.SourceSans
searchBar.TextScaled = true
searchBar.TextColor3 = Color3.fromRGB(200, 200, 200)
searchBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
searchBar.BorderSizePixel = 0
searchBar.Size = UDim2.new(0.9, 0, 0.2, 0)
searchBar.Position = UDim2.new(0.05, 0, 0.10, 0)
searchBar.ClearTextOnFocus = true
searchBar.Parent = frame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
scrollFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 0
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarImageTransparency = 1
scrollFrame.Parent = frame


local buttons = {}

local createdSet = {}


local function createTheButton(text, callback)
    if createdSet[text] then
        return
    end
    createdSet[text] = true

    local button = Instance.new("TextButton")
    button.Text = text
    button.Font = Enum.Font.SourceSansBold
    button.TextScaled = true
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(1, 0, 0, #buttons * 45)
    button.BackgroundTransparency = 1
    button.BorderSizePixel = 0
    button.Parent = scrollFrame

    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    local tweenInfoLocal = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {
        Position = UDim2.new(0, 0, 0, #buttons * 45),
        BackgroundTransparency = 0
    }
    local tween = TweenService:Create(button, tweenInfoLocal, goal)
    tween:Play()

    table.insert(buttons, button)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #buttons * 45)
end


searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = searchBar.Text:lower()
    local order = 0
    for _, button in ipairs(buttons) do
        if searchText == "" or button.Text:lower():find(searchText) then
            button.Visible = true
            button:TweenPosition(UDim2.new(0, 0, 0, order * 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.12, true)
            order += 1
        else
            button.Visible = false
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, order * 45)
end)


local managerFrame = Instance.new("Frame")
managerFrame.Name = "AnimationManager"
managerFrame.Size = getScaledSize(0.3, 0.4) 
managerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
managerFrame.BackgroundTransparency = 0.2
managerFrame.BorderSizePixel = 2
managerFrame.BorderColor3 = Color3.new(0, 0, 0)
managerFrame.Parent = screenGui

local managerTitle = Instance.new("TextLabel")
managerTitle.Name = "ManagerTitle"
managerTitle.Text = "Animation Manager"
managerTitle.Font = Enum.Font.SourceSansBold
managerTitle.TextScaled = true
managerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
managerTitle.BackgroundTransparency = 1
managerTitle.Size = UDim2.new(1, 0, 0.1, 0)
managerTitle.Position = UDim2.new(0, 0, 0, 0)
managerTitle.Parent = managerFrame


local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0.1, 0)
tabFrame.Position = UDim2.new(0, 0, 0.1, 0)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = managerFrame

local addTabButton = Instance.new("TextButton")
addTabButton.Text = "Add Anim"
addTabButton.Font = Enum.Font.SourceSansBold
addTabButton.TextScaled = true
addTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
addTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
addTabButton.Size = UDim2.new(0.5, 0, 1, 0)
addTabButton.Position = UDim2.new(0, 0, 0, 0)
addTabButton.Parent = tabFrame

local removeTabButton = Instance.new("TextButton")
removeTabButton.Text = "Remove Anim"
removeTabButton.Font = Enum.Font.SourceSansBold
removeTabButton.TextScaled = true
removeTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
removeTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
removeTabButton.Size = UDim2.new(0.5, 0, 1, 0)
removeTabButton.Position = UDim2.new(0.5, 0, 0, 0)
removeTabButton.Parent = tabFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 0.8, 0)
contentFrame.Position = UDim2.new(0, 0, 0.2, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = managerFrame


local addContent = Instance.new("Frame")
addContent.Size = UDim2.new(1, 0, 1, 0)
addContent.BackgroundTransparency = 1
addContent.Visible = true
addContent.Parent = contentFrame

local typeToggleButton = Instance.new("TextButton")
typeToggleButton.Name = "TypeToggle"
typeToggleButton.Text = "Idle"
typeToggleButton.Font = Enum.Font.SourceSansBold
typeToggleButton.TextScaled = true
typeToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
typeToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
typeToggleButton.Size = UDim2.new(0.9, 0, 0.14, 0)
typeToggleButton.Position = UDim2.new(0.05, 0, 0.05, 0)
typeToggleButton.Parent = addContent

local nameTextBox = Instance.new("TextBox")
nameTextBox.Name = "NameTextBox"
nameTextBox.Text = ""
nameTextBox.PlaceholderText = "Name"
nameTextBox.Font = Enum.Font.SourceSans
nameTextBox.TextScaled = true
nameTextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
nameTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nameTextBox.BorderSizePixel = 0
nameTextBox.Size = UDim2.new(0.9, 0, 0.18, 0)
nameTextBox.Position = UDim2.new(0.05, 0, 0.22, 0)
nameTextBox.Parent = addContent

local animIdTextBox1 = Instance.new("TextBox")
animIdTextBox1.Name = "AnimIdTextBox1"
animIdTextBox1.Text = ""
animIdTextBox1.PlaceholderText = "AnimID 1"
animIdTextBox1.Font = Enum.Font.SourceSans
animIdTextBox1.TextScaled = true
animIdTextBox1.TextColor3 = Color3.fromRGB(200, 200, 200)
animIdTextBox1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
animIdTextBox1.BorderSizePixel = 0
animIdTextBox1.Size = UDim2.new(0.9, 0, 0.18, 0)
animIdTextBox1.Position = UDim2.new(0.05, 0, 0.44, 0)
animIdTextBox1.Parent = addContent

local animIdTextBox2 = Instance.new("TextBox")
animIdTextBox2.Name = "AnimIdTextBox2"
animIdTextBox2.Text = ""
animIdTextBox2.PlaceholderText = "AnimID 2 (Idle only)"
animIdTextBox2.Font = Enum.Font.SourceSans
animIdTextBox2.TextScaled = true
animIdTextBox2.TextColor3 = Color3.fromRGB(200, 200, 200)
animIdTextBox2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
animIdTextBox2.BorderSizePixel = 0
animIdTextBox2.Size = UDim2.new(0.9, 0, 0.18, 0)
animIdTextBox2.Position = UDim2.new(0.05, 0, 0.66, 0)
animIdTextBox2.Visible = true
animIdTextBox2.Parent = addContent

local animationTypes = {"Idle", "Walk", "Run", "Jump", "Fall", "Swim", "SwimIdle", "Climb"}
local currentTypeIndex = 1


typeToggleButton.MouseButton1Click:Connect(function()
    currentTypeIndex = currentTypeIndex % #animationTypes + 1
    typeToggleButton.Text = animationTypes[currentTypeIndex]
    if animationTypes[currentTypeIndex] == "Idle" then
        animIdTextBox2.Visible = true
    else
        animIdTextBox2.Visible = false
    end
end)

local removeContent = Instance.new("Frame")
removeContent.Size = UDim2.new(1, 0, 1, 0)
removeContent.BackgroundTransparency = 1
removeContent.Visible = false
removeContent.Parent = contentFrame

local removeSearchBox = Instance.new("TextBox")
removeSearchBox.Name = "RemoveSearch"
removeSearchBox.Text = ""
removeSearchBox.PlaceholderText = "Search animations to remove..."
removeSearchBox.Font = Enum.Font.SourceSans
removeSearchBox.TextScaled = true
removeSearchBox.TextColor3 = Color3.fromRGB(200,200,200)
removeSearchBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
removeSearchBox.BorderSizePixel = 0
removeSearchBox.Size = UDim2.new(0.9,0,0.12,0)
removeSearchBox.Position = UDim2.new(0.05,0,0,0)
removeSearchBox.Parent = removeContent

local removeScrollFrame = Instance.new("ScrollingFrame")
removeScrollFrame.Size = UDim2.new(0.9, 0, 0.76, 0)
removeScrollFrame.Position = UDim2.new(0.05, 0, 0.14, 0)
removeScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
removeScrollFrame.BorderSizePixel = 0
removeScrollFrame.ScrollBarThickness = 5
removeScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
removeScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
removeScrollFrame.Parent = removeContent

local removeButtons = {}
local URADOPTED = nil
local HUHGO = nil

local function FIVEHUNDREDCIGARETTES(filter)
    filter = filter or ""
    
    for _, btn in ipairs(removeButtons) do
        if btn and btn.Parent then btn:Destroy() end
    end
    removeButtons = {}
    local yPos = 0
    local typeOrder = {"Idle", "Walk", "Run", "Jump", "Fall", "Swim", "SwimIdle", "Climb"}
    local customAnims = {}
    if isfile(CUSTOM_ANIMATIONS_FILE) then
        local data = readfile(CUSTOM_ANIMATIONS_FILE)
        customAnims = HttpService:JSONDecode(data)
    end

    for _, animType in ipairs(typeOrder) do
        local anims = customAnims[animType] or {}
        for name, _ in pairs(anims) do
            local combined = name .. " (" .. animType .. ")"
            if filter == "" or combined:lower():find(filter:lower()) then
                local button = Instance.new("TextButton")
                button.Text = combined
                button.Font = Enum.Font.SourceSansBold
                button.TextScaled = true
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                button.Size = UDim2.new(1, 0, 0, 40)
                button.Position = UDim2.new(0, 0, 0, yPos)
                button.Parent = removeScrollFrame

                button.MouseButton1Click:Connect(function()
                    if URADOPTED and URADOPTED.type == animType and URADOPTED.name == name then
                        URADOPTED = nil
                        if HUHGO then
                            HUHGO.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                            HUHGO = nil
                        end
                    else
                        if HUHGO then HUHGO.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end
                        URADOPTED = {type = animType, name = name}
                        HUHGO = button
                        button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    end
                end)

                table.insert(removeButtons, button)
                yPos += 45
            end
        end
    end
    removeScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

FIVEHUNDREDCIGARETTES()


local actionButton = Instance.new("TextButton")
actionButton.Text = "Create Anim"
actionButton.Font = Enum.Font.SourceSansBold
actionButton.TextScaled = true
actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
actionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
actionButton.Size = UDim2.new(0.9, 0, 0.1, 0)
actionButton.Position = UDim2.new(0.05, 0, 0.9, 0)
actionButton.Parent = managerFrame

addTabButton.MouseButton1Click:Connect(function()
    addContent.Visible = true
    removeContent.Visible = false
    addTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    removeTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    actionButton.Text = "Create Anim"
end)

removeTabButton.MouseButton1Click:Connect(function()
    addContent.Visible = false
    removeContent.Visible = true
    addTabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    removeTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    actionButton.Text = "Remove Anim"
    FIVEHUNDREDCIGARETTES(removeSearchBox.Text)
end)

removeSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    FIVEHUNDREDCIGARETTES(removeSearchBox.Text)
end)


local function REFREHSTHEMAINBUTTONS()
    for _, btn in ipairs(buttons) do
        if btn and btn.Parent then btn:Destroy() end
    end
    buttons = {}
    createdSet = {}

    local function addAnimButton(name, animType, id)
        local buttonText = name .. " - " .. animType
        createTheButton(buttonText, function()
            pcall(function()
                setAnimation(animType, id)
                Notify(animType, name, 1)
            end)
        end)
    end

    local typeOrder = {"Idle", "Walk", "Run", "Jump", "Fall", "Swim", "SwimIdle", "Climb"}
    local RunService = game:GetService("RunService")

    local count = 0
    for _, animType in ipairs(typeOrder) do
        local anims = Animations[animType]
        if anims then
            for name, ids in pairs(anims) do
                addAnimButton(name, animType, ids)
                count += 1
                if count >= 10 then
                    count = 0
                    RunService.RenderStepped:Wait()
                end
            end
        end
    end
end

REFREHSTHEMAINBUTTONS()

actionButton.MouseButton1Click:Connect(function()
    if addContent.Visible then
        local name = "[UGC] ".. nameTextBox.Text
        
        local function GetReal(id)
            local ok, obj = pcall(function()
                return game:GetObjects("rbxassetid://"..tostring(id))
            end)
            if ok and obj and #obj > 0 then
                local anim = obj[1]
                if anim:IsA("Animation") and anim.AnimationId ~= "" then
                    return tonumber(anim.AnimationId:match("%d+")) or id
                end
            end
            return id
        end

        local animId1 = GetReal(animIdTextBox1.Text)
        local animId2 = GetReal((animIdTextBox2.Text ~= "" and animIdTextBox2.Text) or (animIdTextBox1.Text ~= "" and animIdTextBox1.Text) or 0)
local animType = animationTypes[currentTypeIndex]
    if name ~= "" and animIdTextBox1.Text ~= "" then
        local customAnims = {}
        if isfile(CUSTOM_ANIMATIONS_FILE) then
            local data = readfile(CUSTOM_ANIMATIONS_FILE)
            customAnims = HttpService:JSONDecode(data)
        end
        
        if animType == "Idle" then
            if animIdTextBox2.Text == "" then
                Notify("Error", "For Idle, provide both AnimIDs", 3)
                return
            end
            customAnims[animType] = customAnims[animType] or {}
            customAnims[animType][name] = {tostring(animId1), tostring(animId2)}
        else
            customAnims[animType] = customAnims[animType] or {}
            customAnims[animType][name] = tostring(animId1)
        end

        writefile(CUSTOM_ANIMATIONS_FILE, HttpService:JSONEncode(customAnims))

        Animations[animType] = Animations[animType] or {}
        Animations[animType][name] = customAnims[animType][name]
        
        Notify("Added", name .. " to " .. animType, 3)
        nameTextBox.Text = ""
        animIdTextBox1.Text = ""
        animIdTextBox2.Text = ""
        REFREHSTHEMAINBUTTONS()
    else
        Notify("Error", "Fill all fields", 3)
    end
elseif removeContent.Visible then
    if URADOPTED then
        local customAnims = {}
        if isfile(CUSTOM_ANIMATIONS_FILE) then
            local data = readfile(CUSTOM_ANIMATIONS_FILE)
            customAnims = HttpService:JSONDecode(data)
        end
        
        if customAnims[URADOPTED.type] and customAnims[URADOPTED.type][URADOPTED.name] then
            customAnims[URADOPTED.type][URADOPTED.name] = nil
            writefile(CUSTOM_ANIMATIONS_FILE, HttpService:JSONEncode(customAnims))
            
            if Animations[URADOPTED.type] then
                Animations[URADOPTED.type][URADOPTED.name] = nil
            end
            
            Notify("Removed", URADOPTED.name .. " from " .. URADOPTED.type, 3)
            URADOPTED = nil
            if HUHGO then
                HUHGO.BackgroundColor3 = Color3.fromRGB(60,60,60)
                HUHGO = nil
            end
            FIVEHUNDREDCIGARETTES(removeSearchBox.Text)
            REFREHSTHEMAINBUTTONS()
        else
            Notify("Error", "Cannot remove default animations", 3)
        end
    else
        Notify("Error", "Select an animation to remove", 3)
    end
end
end)
local managerTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function updateManagerPosition()
local targetPos = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset + frame.Size.X.Offset + 10, frame.Position.Y.Scale, frame.Position.Y.Offset)
managerFrame:SetAttribute("TargetPosition", targetPos)
end
local function lerpPosition()
local targetPos = managerFrame:GetAttribute("TargetPosition")
if targetPos then
local currentPos = managerFrame.Position
local lerpSpeed = 0.1
    local newXScale = currentPos.X.Scale + (targetPos.X.Scale - currentPos.X.Scale) * lerpSpeed
    local newXOffset = currentPos.X.Offset + (targetPos.X.Offset - currentPos.X.Offset) * lerpSpeed
    local newYScale = currentPos.Y.Scale + (targetPos.Y.Scale - currentPos.Y.Scale) * lerpSpeed
    local newYOffset = currentPos.Y.Offset + (targetPos.Y.Offset - currentPos.Y.Offset) * lerpSpeed
    
    managerFrame.Position = UDim2.new(newXScale, newXOffset, newYScale, newYOffset)
end
end
frame:GetPropertyChangedSignal("Position"):Connect(updateManagerPosition)
frame:GetPropertyChangedSignal("Size"):Connect(updateManagerPosition)
local RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(lerpPosition)
updateManagerPosition()
local normalSize = getScaledSize(0.3, 0.4)
local normalPosition = UDim2.new(0.5, -normalSize.X.Offset / 2, 0.5, -normalSize.Y.Offset / 2)
local smallerSize = getScaledSize(0.15, 0.2)
local smallerPosition = UDim2.new(0.5, -smallerSize.X.Offset / 2, 0.5, -smallerSize.Y.Offset / 2)
local isSmall = false
local clickCount = 0
local function handleDoubleClick()
if isSmall then
frame.Size = normalSize
frame.Position = normalPosition
scrollFrame.Visible = true
searchBar.Visible = true
gazeLabel.Size = labelSize
managerFrame.Visible = true
updateManagerPosition()
else
frame.Size = smallerSize
frame.Position = smallerPosition
scrollFrame.Visible = false
searchBar.Visible = false
gazeLabel.Size = UDim2.new(1, 0, 1, 0)
managerFrame.Visible = false
end
isSmall = not isSmall
end
frame.MouseButton1Click:Connect(function()
clickCount += 1
if clickCount == 1 then
task.delay(0.45, function()
clickCount = 0
end)
elseif clickCount == 2 then
handleDoubleClick()
clickCount = 0
end
end)
updateManagerPosition()
local lastAnimations = {}
local function StopAnim()
local speaker = Players.LocalPlayer
local Char = speaker.Character or speaker.CharacterAdded:Wait()
local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
if Hum then
for _, track in ipairs(Hum:GetPlayingAnimationTracks()) do
track:Stop(0)
end
end
end
local function refresh()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:wait(0.1)
local humanoid = character:WaitForChild("Humanoid")
humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
end
local function refreshswim()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:wait(0.1)
local humanoid = character:WaitForChild("Humanoid")
humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
task.wait(0.1)
humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
end
local function refreshclimb()
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:wait(0.1)
local humanoid = character:WaitForChild("Humanoid")
humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
task.wait(0.1)
humanoid:ChangeState(Enum.HumanoidStateType.Climbing)
end
local function ResetIdle()
local speaker = Players.LocalPlayer
local Char = speaker.Character
local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop(0) end
pcall(function()
local Animate = Char.Animate
Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=0"
Animate.idle.Animation2.AnimationId = "http://www.roblox.com/asset/?id=0"
end)
end
local function ResetWalk()
local speaker = Players.LocalPlayer
local Char = speaker.Character
local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop(0) end
pcall(function()
local Animate = Char.Animate
Animate.walk.WalkAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
end)
end
local function ResetRun()
local speaker = Players.LocalPlayer
local Char = speaker.Character
local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop(0) end
pcall(function()
local Animate = Char.Animate
Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
end)
end
local function ResetJump()
local speaker = Players.LocalPlayer
local Char = speaker.Character
local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop(0) end
pcall(function()
local Animate = Char.Animate
Animate.jump.JumpAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
end)
end
local function ResetFall()
local speaker = Players.LocalPlayer
local Char = speaker.Character
local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop(0) end
pcall(function()
local Animate = Char.Animate
Animate.fall.FallAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
end)
end
local function ResetSwim()
local speaker = Players.LocalPlayer
local Char = speaker.Character
local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop(0) end
pcall(function()
local Animate = Char.Animate
if Animate.swim then Animate.swim.Swim.AnimationId = "http://www.roblox.com/asset/?id=0" end
end)
end
local function ResetSwimIdle()
local speaker = Players.LocalPlayer
local Char = speaker.Character
local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop(0) end
pcall(function()
local Animate = Char.Animate
if Animate.swimidle then Animate.swimidle.SwimIdle.AnimationId = "http://www.roblox.com/asset/?id=0" end
end)
end
local function ResetClimb()
local speaker = Players.LocalPlayer
local Char = speaker.Character
local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
for _, v in next, Hum:GetPlayingAnimationTracks() do v:Stop(0) end
pcall(function()
local Animate = Char.Animate
Animate.climb.ClimbAnim.AnimationId = "http://www.roblox.com/asset/?id=0"
end)
end
local function freeze()
local player = cloneref(game:GetService("Players")).LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
humanoid.PlatformStand = true
if player and player.Character then
task.spawn(function()
for i, part in ipairs(player.Character:GetDescendants()) do
if part:IsA("BasePart") and not part.Anchored then
part.Anchored = true
end
end
end)
end
end
local function unfreeze()
local player = cloneref(game:GetService("Players")).LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
humanoid.PlatformStand = false
if player and player.Character then
task.spawn(function()
for i, part in ipairs(player.Character:GetDescendants()) do
if part:IsA("BasePart") and part.Anchored then
part.Anchored = false
end
end
end)
end
end
local function saveLastAnimations()
local data = HttpService:JSONEncode(lastAnimations)
pcall(function()
writefile(LAST_ANIMATIONS_FILE, data)
end)
end
function setAnimation(animationType, animationId)
    if type(animationId) ~= "table" and type(animationId) ~= "string" then return end
    local player = Players.LocalPlayer
    if not player.Character then return end
    local Char = player.Character
    local Humanoid = Char:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    local success, err = pcall(function()
        for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end

        local function forceRunAnimation(runId)
            local Animate = Char:FindFirstChild("Animate")
            if not Animate then return end
            Animate.Disabled = true
            task.wait(0.1)

            local runFolder = Animate:FindFirstChild("run")
            if runFolder then
                local oldAnim = runFolder:FindFirstChild("RunAnim")
                if oldAnim then
                    oldAnim:Destroy()
                end

                local newAnim = Instance.new("Animation")
                newAnim.Name = "RunAnim"
                newAnim.AnimationId = "rbxassetid://" .. tostring(runId)
                newAnim.Parent = runFolder
                
                task.wait(0.1)
            end

            Animate.Disabled = false
            task.wait(0.1)

            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            task.wait(0.05)
            Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end

        local function setAnimId(folder, animName, newId)
            if not folder then return end
            
            local oldAnim = folder:FindFirstChild(animName)
            if oldAnim then
                oldAnim:Destroy()
            end
            
            local newAnim = Instance.new("Animation")
            newAnim.Name = animName
            newAnim.AnimationId = "rbxassetid://" .. tostring(newId)
            newAnim.Parent = folder
        end

        local Animate = Char:FindFirstChild("Animate")
        if not Animate then return end

        if animationType == "Idle" then
            lastAnimations.Idle = animationId
            local idleFolder = Animate:FindFirstChild("idle")
            if idleFolder then
                setAnimId(idleFolder, "Animation1", animationId[1])
                setAnimId(idleFolder, "Animation2", animationId[2])
            end
            refresh()
            
        elseif animationType == "Walk" then
            lastAnimations.Walk = animationId
            local walkFolder = Animate:FindFirstChild("walk")
            if walkFolder then
                setAnimId(walkFolder, "WalkAnim", animationId)
            end
            refresh()
            
        elseif animationType == "Run" then
            lastAnimations.Run = animationId
            forceRunAnimation(animationId)
            
        elseif animationType == "Jump" then
            lastAnimations.Jump = animationId
            local jumpFolder = Animate:FindFirstChild("jump")
            if jumpFolder then
                setAnimId(jumpFolder, "JumpAnim", animationId)
            end
            refresh()
            
        elseif animationType == "Fall" then
            lastAnimations.Fall = animationId
            local fallFolder = Animate:FindFirstChild("fall")
            if fallFolder then
                setAnimId(fallFolder, "FallAnim", animationId)
            end
            refresh()
            
        elseif animationType == "Swim" then
            lastAnimations.Swim = animationId
            local swimFolder = Animate:FindFirstChild("swim")
            if swimFolder then
                setAnimId(swimFolder, "Swim", animationId)
            end
            refreshswim()
            
        elseif animationType == "SwimIdle" then
            lastAnimations.SwimIdle = animationId
            local swimidleFolder = Animate:FindFirstChild("swimidle")
            if swimidleFolder then
                setAnimId(swimidleFolder, "SwimIdle", animationId)
            end
            refreshswim()
            
        elseif animationType == "Climb" then
            lastAnimations.Climb = animationId
            local climbFolder = Animate:FindFirstChild("climb")
            if climbFolder then
                setAnimId(climbFolder, "ClimbAnim", animationId)
            end
            refreshclimb()
        end
        
            saveLastAnimations()
    end)

    if not success then
        warn("Failed to set animation:", err)
        Notify("Error", "Animation failed: " .. tostring(err), 3)
    end
end

local function loadLastAnimations()
if isfile(LAST_ANIMATIONS_FILE) then
local data = readfile(LAST_ANIMATIONS_FILE)
local lastAnimationsData = HttpService:JSONDecode(data)
Notify("Yippe", "Saved Animation Found, loading it", 3)
if lastAnimationsData.Idle then setAnimation("Idle", lastAnimationsData.Idle) end
if lastAnimationsData.Walk then setAnimation("Walk", lastAnimationsData.Walk) end
if lastAnimationsData.Run then setAnimation("Run", lastAnimationsData.Run) end
if lastAnimationsData.Jump then setAnimation("Jump", lastAnimationsData.Jump) end
if lastAnimationsData.Fall then setAnimation("Fall", lastAnimationsData.Fall) end
if lastAnimationsData.Climb then setAnimation("Climb", lastAnimationsData.Climb) end
if lastAnimationsData.Swim then setAnimation("Swim", lastAnimationsData.Swim) end
if lastAnimationsData.SwimIdle then setAnimation("SwimIdle", lastAnimationsData.SwimIdle) end
else
Notify("First?", "No Saved Animations Found", 5)
end
end
local function PlayEmote(animationId)
StopAnim()
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:wait(0.1)
local humanoid = character:WaitForChild("Humanoid")
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://" .. animationId
local animationTrack = humanoid:LoadAnimation(animation)
animationTrack:Play()
local function onMoved()
local moveDirection = humanoid.MoveDirection
if moveDirection.Magnitude > 0 then
animationTrack:Stop()
end
end
local checkMovement
checkMovement = game:GetService("RunService").RenderStepped:Connect(onMoved)
end
local function Buy(gamePassID)
local MarketplaceService = game:GetService("MarketplaceService")
local success, _ = pcall(function()
MarketplaceService:PromptGamePassPurchase(game:GetService("Players").LocalPlayer, gamePassID)
end)
if not success then
setclipboard("https://www.roblox.com/game-pass/" .. gamePassID)
Notify("Copied", "Gamepass Link", 5)
end
end
local function AddEmote(name, id)
createTheButton(name .. " - Emote", function() PlayEmote(id) end)
end
local function AddDonate(Price, Id)
createTheButton("Donate " .. Price .. " Robux", function() Buy(Id) end)
end
AddDonate(20, 1131371530)
AddDonate(200, 1131065702)
AddDonate(183, 1129915318)
AddDonate(2000, 1128299749)
AddEmote("Dance 1", 12521009666)
AddEmote("Dance 2", 12521169800)
AddEmote("Dance 3", 12521178362)
AddEmote("Cheer", 12521021991)
AddEmote("Laugh", 12521018724)
AddEmote("Point", 12521007694)
AddEmote("Wave", 12521004586)
loadLastAnimations()
Players.LocalPlayer.CharacterAdded:Connect(function(character)
local hum = character:WaitForChild("Humanoid")
local animate = character:WaitForChild("Animate", 10)
if not animate then
Notify("Error", "Animate script not found after respawn!", 5)
return
end
if lastAnimations.Idle then setAnimation("Idle", lastAnimations.Idle) end
if lastAnimations.Walk then setAnimation("Walk", lastAnimations.Walk) end
if lastAnimations.Run then setAnimation("Run", lastAnimations.Run) end
if lastAnimations.Jump then setAnimation("Jump", lastAnimations.Jump) end
if lastAnimations.Fall then setAnimation("Fall", lastAnimations.Fall) end
if lastAnimations.Climb then setAnimation("Climb", lastAnimations.Climb) end
if lastAnimations.Swim then setAnimation("Swim", lastAnimations.Swim) end
if lastAnimations.SwimIdle then setAnimation("SwimIdle", lastAnimations.SwimIdle) end
end)

local function LoadAndUpdateAnimations()
Notify("Updating", "Checking for animation updates...", 2)
if downloadAnimations() then
    if isfile(ANIMATIONS_FILE) then
        local data = readfile(ANIMATIONS_FILE)
        local onlineAnimations = HttpService:JSONDecode(data)
        
        local newAnimationsFound = 0
        local updatedAnimations = 0
        
        for animType, typeAnims in pairs(onlineAnimations) do
            if not Animations[animType] then
                Animations[animType] = {}
                Notify("New Type", "Found new animation type: " .. animType, 3)
            end
            
            for animName, animData in pairs(typeAnims) do
                local currentData = Animations[animType][animName]
                
                if not currentData then
                    Animations[animType][animName] = animData
                    newAnimationsFound = newAnimationsFound + 1
                else
                    local isDifferent = false
                    
                    if type(animData) == "table" and type(currentData) == "table" then
                        if #animData ~= #currentData then
                            isDifferent = true
                        else
                            for i = 1, #animData do
                                if tostring(animData[i]) ~= tostring(currentData[i]) then
                                    isDifferent = true
                                    break
                                end
                            end
                        end
                    else
                        if tostring(animData) ~= tostring(currentData) then
                            isDifferent = true
                        end
                    end
                    
                    if isDifferent then
                        Animations[animType][animName] = animData
                        updatedAnimations = updatedAnimations + 1
                    end
                end
            end
        end
        
        if newAnimationsFound > 0 or updatedAnimations > 0 then
            REFREHSTHEMAINBUTTONS()
            Notify("Database Update", 
                string.format("New: %d | Updated: %d", newAnimationsFound, updatedAnimations), 
                5)
        else
            Notify("Database", "All animations are up to date!", 3)
        end
    end
else
    Notify("Error", "Failed to update animations", 3)
end
end
LoadAndUpdateAnimations()
Notify("PLEASE", "Donate to Gazer Ha, he is developer", 1)
local lt = os.clock() - st
Notify("loaded", string.format("in %.2f seconds.", lt), 5)
Notify("Folder System", "Using Sifity/Gaze/", 6)
Notify("Changelog", "New file system + auto-update from GitHub", 6)
end)