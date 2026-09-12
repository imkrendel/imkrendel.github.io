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
    SifityExtender v1.0
    Created by imkrendel | https://github.com/imkrendel
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Settings = {
    enabled         = false,
    targetLimb      = "HumanoidRootPart",
    limbSize        = 15,
    transparency    = 0.9,
    teamCheck       = true,
    forcefieldCheck = true,
}

local modifiedLimbs = {}
local playerData = {}
local engineConns = {}

local function disconnectList(list)
    for _, c in ipairs(list) do
        if typeof(c) == "RBXScriptConnection" and c.Connected then
            c:Disconnect()
        end
    end
end

local function isTeammate(player)
    if not Settings.teamCheck then return false end
    return LocalPlayer.Team ~= nil and player.Team == LocalPlayer.Team
end

local function restoreLimb(limb)
    local d = modifiedLimbs[limb]
    if not d then return end
    disconnectList(d.conns)
    if limb and limb.Parent then
        limb.Size         = d.origSize
        limb.Transparency = d.origTransparency
        limb.CanCollide   = d.origCanCollide
    end
    modifiedLimbs[limb] = nil
end

local function applyLimb(limb)
    if not limb or not limb.Parent then return end
    if modifiedLimbs[limb] then return end

    local sz = Vector3.new(Settings.limbSize, Settings.limbSize, Settings.limbSize)
    local tr = Settings.transparency
    local cc = Settings.canCollide

    modifiedLimbs[limb] = {
        origSize         = limb.Size,
        origTransparency = limb.Transparency,
        origCanCollide   = limb.CanCollide,
        conns            = {},
    }
    local conns = modifiedLimbs[limb].conns

    limb.Size         = sz
    limb.Transparency = tr
    limb.CanCollide   = false

    table.insert(conns, limb:GetPropertyChangedSignal("Size"):Connect(function()
        if modifiedLimbs[limb] then limb.Size = sz end
    end))
    table.insert(conns, limb:GetPropertyChangedSignal("Transparency"):Connect(function()
        if modifiedLimbs[limb] then limb.Transparency = tr end
    end))
    table.insert(conns, limb:GetPropertyChangedSignal("CanCollide"):Connect(function()
        if modifiedLimbs[limb] then limb.CanCollide = false end
    end))
end

local function restoreAllLimbs()
    for limb in pairs(modifiedLimbs) do
        restoreLimb(limb)
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then return end
    if isTeammate(player) then return end
    if playerData[player.Name] then return end

    local pd = { conns = {} }
    playerData[player.Name] = pd

    local function handleChar(char)
        if not char then return end

        local function tryApply()
            if Settings.forcefieldCheck and char:FindFirstChildOfClass("ForceField") then
                local ffConn
                ffConn = char.ChildRemoved:Connect(function(c)
                    if c:IsA("ForceField") then
                        ffConn:Disconnect()
                        tryApply()
                    end
                end)
                table.insert(pd.conns, ffConn)
                return
            end

            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then return end

            local limb = char:FindFirstChild(Settings.targetLimb)
            if limb then applyLimb(limb) end

            table.insert(pd.conns, char.ChildAdded:Connect(function(c)
                if c.Name == Settings.targetLimb and c:IsA("BasePart") then
                    applyLimb(c)
                end
            end))

            table.insert(pd.conns, hum.Died:Connect(function()
                local l = char:FindFirstChild(Settings.targetLimb)
                if l then restoreLimb(l) end
            end))
        end

        task.delay(0.15, function()
            if playerData[player.Name] then tryApply() end
        end)

        table.insert(pd.conns, player.CharacterRemoving:Connect(function()
            local l = char:FindFirstChild(Settings.targetLimb)
            if l then restoreLimb(l) end
        end))
    end

    table.insert(pd.conns, player.CharacterAdded:Connect(handleChar))
    if player.Character then handleChar(player.Character) end
end

local function removePlayer(player)
    local pd = playerData[player.Name]
    if not pd then return end
    disconnectList(pd.conns)
    playerData[player.Name] = nil
    if player.Character then
        local l = player.Character:FindFirstChild(Settings.targetLimb)
        if l then restoreLimb(l) end
    end
end

local function engineStart()
    if Settings.enabled then return end
    Settings.enabled = true
    for _, p in ipairs(Players:GetPlayers()) do
        setupPlayer(p)
    end
    table.insert(engineConns, Players.PlayerAdded:Connect(function(p)
        if Settings.enabled then setupPlayer(p) end
    end))
    table.insert(engineConns, Players.PlayerRemoving:Connect(removePlayer))
end

local function engineStop()
    if not Settings.enabled then return end
    Settings.enabled = false
    disconnectList(engineConns)
    engineConns = {}
    for name, pd in pairs(playerData) do
        disconnectList(pd.conns)
        playerData[name] = nil
    end
    restoreAllLimbs()
end

local function engineRestart()
    if not Settings.enabled then return end
    engineStop()
    engineStart()
end

if CoreGui:FindFirstChild("LEMenu") then
    CoreGui:FindFirstChild("LEMenu"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LEMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 280, 0, 330)
Main.Position = UDim2.new(0.5, -140, 0.5, -165)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(60, 60, 75)
Stroke.Thickness = 1

local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)
local TFix = Instance.new("Frame", TitleBar)
TFix.Size = UDim2.new(1, 0, 0, 10)
TFix.Position = UDim2.new(0, 0, 1, -10)
TFix.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TFix.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Size = UDim2.new(1, -44, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Hitbox Extender"
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -30, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.Text = ""
CloseBtn.BorderSizePixel = 0
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
local CloseX = Instance.new("TextLabel", CloseBtn)
CloseX.Size = UDim2.new(1, 0, 1, 0)
CloseX.BackgroundTransparency = 1
CloseX.Text = "×"
CloseX.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseX.TextSize = 16
CloseX.Font = Enum.Font.GothamBold
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -20, 1, -46)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Content)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)

local function SectionLabel(text, order)
    local lbl = Instance.new("TextLabel", Content)
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(100, 100, 120)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.LayoutOrder = order
end

local function ToggleRow(labelText, order, defaultVal, onChange)
    local row = Instance.new("Frame", Content)
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(190, 190, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local togBG = Instance.new("Frame", row)
    togBG.Size = UDim2.new(0, 34, 0, 18)
    togBG.Position = UDim2.new(1, -42, 0.5, -9)
    togBG.BorderSizePixel = 0
    Instance.new("UICorner", togBG).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", togBG)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local val = defaultVal or false
    local api = {}

    function api.Set(v, silent)
        val = v
        local bg  = v and Color3.fromRGB(100, 180, 100) or Color3.fromRGB(55, 55, 65)
        local pos = v and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        if silent then
            togBG.BackgroundColor3 = bg
            knob.Position = pos
        else
            TweenService:Create(togBG, TweenInfo.new(0.15), {BackgroundColor3 = bg}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = pos}):Play()
            if onChange then onChange(v) end
        end
    end

    api.Set(val, true)

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.MouseButton1Click:Connect(function() api.Set(not val) end)

    return api
end

local function SliderRow(labelText, order, min, max, defaultVal, increment, onChange)
    local row = Instance.new("Frame", Content)
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local header = Instance.new("Frame", row)
    header.Size = UDim2.new(1, 0, 0, 20)
    header.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", header)
    lbl.Size = UDim2.new(1, -40, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(190, 190, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local valLbl = Instance.new("TextLabel", header)
    valLbl.Size = UDim2.new(0, 36, 1, 0)
    valLbl.Position = UDim2.new(1, -42, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.TextColor3 = Color3.fromRGB(130, 130, 150)
    valLbl.TextSize = 11
    valLbl.Font = Enum.Font.GothamMedium
    valLbl.TextXAlignment = Enum.TextXAlignment.Right

    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -20, 0, 4)
    track.Position = UDim2.new(0, 10, 0, 28)
    track.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 140, 255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local dotpart = tostring(increment):match("%.(%d+)")
    local decimals = dotpart and #dotpart or 0
    local fmt = "%." .. decimals .. "f"
    local cur = defaultVal or min

    local function setValue(v)
        cur = math.clamp(v, min, max)
        cur = tonumber(string.format(fmt, math.round(cur / increment) * increment))
        fill.Size = UDim2.new((cur - min) / (max - min), 0, 1, 0)
        valLbl.Text = string.format(fmt, cur)
        if onChange then onChange(cur) end
    end

    setValue(cur)

    local dragging = false
    local trackBtn = Instance.new("TextButton", track)
    trackBtn.Size = UDim2.new(1, 0, 0, 14)
    trackBtn.Position = UDim2.new(0, 0, 0.5, -7)
    trackBtn.BackgroundTransparency = 1
    trackBtn.Text = ""
    trackBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local abs = track.AbsolutePosition
            setValue(min + (max - min) * math.clamp((inp.Position.X - abs.X) / track.AbsoluteSize.X, 0, 1))
        end
    end)
end

local function DropdownRow(labelText, order, options, default, onChange)
    local row = Instance.new("Frame", Content)
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ClipsDescendants = false
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(190, 190, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local selected = default or (options[1] or "")

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0.48, 0, 0, 24)
    btn.Position = UDim2.new(0.5, 0, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(36, 36, 46)
    btn.BorderSizePixel = 0
    btn.Text = selected
    btn.TextColor3 = Color3.fromRGB(200, 200, 215)
    btn.TextSize = 11
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local list = Instance.new("Frame", ScreenGui)
    list.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ZIndex = 10
    Instance.new("UICorner", list).CornerRadius = UDim.new(0, 6)
    local ls = Instance.new("UIStroke", list)
    ls.Color = Color3.fromRGB(60, 60, 75); ls.Thickness = 1
    Instance.new("UIListLayout", list).SortOrder = Enum.SortOrder.LayoutOrder

    local api = {}
    function api.Refresh(opts)
        options = opts
        for _, c in pairs(list:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for i, opt in ipairs(opts) do
            local ob = Instance.new("TextButton", list)
            ob.Size = UDim2.new(1, 0, 0, 24)
            ob.BackgroundTransparency = 1
            ob.Text = opt
            ob.TextColor3 = Color3.fromRGB(190, 190, 200)
            ob.TextSize = 11
            ob.Font = Enum.Font.Gotham
            ob.LayoutOrder = i
            ob.ZIndex = 11
            ob.MouseButton1Click:Connect(function()
                selected = opt
                btn.Text = opt
                list.Visible = false
                if onChange then onChange(opt) end
            end)
        end
        list.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, #opts * 24 + 4)
    end
    api.Refresh(options)

    btn.MouseButton1Click:Connect(function()
        local abs = btn.AbsolutePosition
        list.Position = UDim2.new(0, abs.X, 0, abs.Y + btn.AbsoluteSize.Y + 2)
        list.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, #options * 24 + 4)
        list.Visible = not list.Visible
    end)

    return api
end

SectionLabel("CONTROL", 1)
ToggleRow("Enable", 2, false, function(v)
    if v then engineStart() else engineStop() end
end)

SectionLabel("SETTINGS", 3)
ToggleRow("Team Check", 4, Settings.teamCheck, function(v)
    Settings.teamCheck = v; engineRestart()
end)
ToggleRow("ForceField Check", 5, Settings.forcefieldCheck, function(v)
    Settings.forcefieldCheck = v; engineRestart()
end)
SliderRow("Limb Size", 6, 5, 50, Settings.limbSize, 0.5, function(v)
    Settings.limbSize = v; engineRestart()
end)
SliderRow("Limb Transparency", 7, 0, 1, Settings.transparency, 0.1, function(v)
    Settings.transparency = v; engineRestart()
end)

SectionLabel("TARGET", 8)
local limbs = {}
local dd = DropdownRow("Target Limb", 9, { Settings.targetLimb }, Settings.targetLimb, function(v)
    Settings.targetLimb = v; engineRestart()
end)

local function addLimbIfNew(name)
    if not name or table.find(limbs, name) then return end
    table.insert(limbs, name)
    table.sort(limbs)
    dd.Refresh(limbs)
end

local function onCharacter(char)
    if not char then return end
    char.ChildAdded:Connect(function(c)
        if c:IsA("BasePart") then addLimbIfNew(c.Name) end
    end)
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("BasePart") then addLimbIfNew(c.Name) end
    end
end

LocalPlayer.CharacterAdded:Connect(onCharacter)
if LocalPlayer.Character then onCharacter(LocalPlayer.Character) end

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.Insert then
        Main.Visible = not Main.Visible
    end
end)
