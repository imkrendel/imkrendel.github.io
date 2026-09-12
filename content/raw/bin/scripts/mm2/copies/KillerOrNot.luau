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
    Killer or Not v1.1 by ImKrendel
]]
local MacLib = loadstring(readfile("imkrendel.github.io/content/raw/library/maclib/source.lua"))()


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local espConnections = {}
local espHighlights = {}
local killAllRunning = false
local autoKillAllRunning = false
local autoGunPickRunning = false
local knifeThrowEnabled = false
local silentAimEnabled = false
local blatantAimEnabled = false
local currentWeapon = nil

local function GetCharacter(player)
    if player and player.Character then
        return player.Character
    end
    return nil
end

local function GetHumanoid(player)
    local char = GetCharacter(player)
    if char then
        return char:FindFirstChild("Humanoid")
    end
    return nil
end

local function GetRootPart(player)
    local char = GetCharacter(player)
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    end
    return nil
end

local function HasBoolValue(player, boolName)
    if not player then return false end
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return false end
    
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local boolValue = tool:FindFirstChild(boolName)
            if boolValue and boolValue:IsA("BoolValue") and boolValue.Value then
                return true
            end
        end
    end

    local char = GetCharacter(player)
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local boolValue = tool:FindFirstChild(boolName)
                if boolValue and boolValue:IsA("BoolValue") and boolValue.Value then
                    return true
                end
            end
        end
    end
    
    return false
end

local function HasKnife(player)
    return HasBoolValue(player, "IsKnife")
end

local function HasGun(player)
    return HasBoolValue(player, "IsGun")
end

local function GetWeapon(player)
    if not player then return nil end
    
    local char = GetCharacter(player)
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                if HasKnife(player) or HasGun(player) then
                    return tool
                end
            end
        end
    end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                if HasKnife(player) or HasGun(player) then
                    return tool
                end
            end
        end
    end
    
    return nil
end

local function GetFirstWeapon(player)
    if not player then return nil end
    
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                return tool
            end
        end
    end
    
    local char = GetCharacter(player)
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                return tool
            end
        end
    end
    
    return nil
end

local function FindGunDrop()
    for _, part in pairs(Workspace:GetDescendants()) do
        if part.Name == "GunDrop" and part:IsA("Part") then
            return part
        end
    end
    return nil
end

local function TeleportToPosition(position)
    local char = GetCharacter(LocalPlayer)
    local root = GetRootPart(LocalPlayer)
    if char and root then
        root.CFrame = CFrame.new(position)
        return true
    end
    return false
end

local function FindSpawn(hasDecal)
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") then
            local hasDecalCheck = false
            if hasDecal then
                for _, child in pairs(model:GetDescendants()) do
                    if child:IsA("Decal") then
                        hasDecalCheck = true
                        break
                    end
                end
            end

            local spawns = nil
            for _, child in pairs(model:GetChildren()) do
                if child:IsA("Model") and child.Name == "Spawns" then
                    spawns = child
                    break
                end
            end
            
            if spawns and hasDecalCheck == hasDecal then
                local parts = {}
                for _, child in pairs(spawns:GetChildren()) do
                    if child:IsA("Part") or child:IsA("SpawnLocation") then
                        table.insert(parts, child)
                    end
                end
                if #parts > 0 then
                    return parts[math.random(1, #parts)]
                end
            end
        end
    end
    return nil
end

local function GetTargetPlayer(hasKnife, hasGun)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local hasKnifeCheck = hasKnife and HasKnife(player)
            local hasGunCheck = hasGun and HasGun(player)
            
            if (hasKnife and hasKnifeCheck) or (hasGun and hasGunCheck) then
                return player
            end
        end
    end
    return nil
end

local function GetAllTargetPlayers(hasKnife, hasGun)
    local targets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local hasKnifeCheck = hasKnife and HasKnife(player)
            local hasGunCheck = hasGun and HasGun(player)
            
            if (hasKnife and hasKnifeCheck) or (hasGun and hasGunCheck) then
                table.insert(targets, player)
            end
        end
    end
    return targets
end

local function GetPlayerFromCharacter(character)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character == character then
            return player
        end
    end
    return nil
end

local function UpdateESP()
    for _, conn in pairs(espConnections) do
        pcall(function() conn:Disconnect() end)
    end
    espConnections = {}
    
    for _, highlight in pairs(espHighlights) do
        pcall(function() highlight:Destroy() end)
    end
    espHighlights = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = GetCharacter(player)
            if char then
                local highlight = Instance.new("Highlight")
                highlight.Parent = char
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0.2
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                if HasKnife(player) then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif HasGun(player) then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end
                
                table.insert(espHighlights, highlight)

                local function CheckWeaponChange()
                    if highlight and highlight.Parent then
                        if HasKnife(player) then
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        elseif HasGun(player) then
                            highlight.FillColor = Color3.fromRGB(0, 0, 255)
                        else
                            highlight.FillColor = Color3.fromRGB(0, 255, 0)
                        end
                    end
                end
                
                local conn1
                if player:FindFirstChild("Backpack") then
                    conn1 = player.Backpack.ChildAdded:Connect(CheckWeaponChange)
                    table.insert(espConnections, conn1)
                end
                
                local conn2 = player:GetPropertyChangedSignal("Character"):Connect(function()
                    task.wait(0.5)
                    CheckWeaponChange()
                end)
                table.insert(espConnections, conn2)
            end
        end
    end
end

local function ToggleESP(state)
    if state then
        UpdateESP()
        local conn1 = Players.PlayerAdded:Connect(function()
            task.wait(0.5)
            UpdateESP()
        end)
        local conn2 = Players.PlayerRemoving:Connect(UpdateESP)
        table.insert(espConnections, conn1)
        table.insert(espConnections, conn2)
    else
        for _, conn in pairs(espConnections) do
            pcall(function() conn:Disconnect() end)
        end
        espConnections = {}
        for _, highlight in pairs(espHighlights) do
            pcall(function() highlight:Destroy() end)
        end
        espHighlights = {}
    end
end

local function AutoGunPick()
    if not autoGunPickRunning then return end
    if HasKnife(LocalPlayer) then
        task.wait(0.5)
        if autoGunPickRunning then
            AutoGunPick()
        end
        return
    end
    
    local gunDrop = FindGunDrop()
    if gunDrop then
        local root = GetRootPart(LocalPlayer)
        if root then
            local cf = root.CFrame * CFrame.new(0, -2, 4)
            gunDrop.CFrame = cf
            if not gunDrop:FindFirstChild("TouchInterest") then
                local touch = Instance.new("TouchTransmitter")
                touch.Parent = gunDrop
            end

            local character = GetCharacter(LocalPlayer)
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function()
                            gunDrop.Touched:Fire(part)
                        end)
                    end
                end
            end
        end
    end
    
    task.wait(0.5)
    if autoGunPickRunning then
        AutoGunPick()
    end
end

local function ToggleKnifeThrow(state)
    knifeThrowEnabled = state
    
    local char = GetCharacter(LocalPlayer)
    if char then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local disable = tool:FindFirstChild("DisableThrowing")
                    if disable and disable:IsA("Configuration") then
                        disable:Destroy()
                    end
                    
                    if not knifeThrowEnabled then
                        local config = Instance.new("Configuration")
                        config.Name = "DisableThrowing"
                        config.Parent = tool
                    end
                end
            end
        end
    end
end

local function TeleportToSheriff()
    local target = GetTargetPlayer(false, true)
    if target then
        local root = GetRootPart(target)
        if root then
            TeleportToPosition(root.Position + Vector3.new(0, 3, 0))
            Window:Notify({
                Title = "Телепорт",
                Description = "Телепортирован к шерифу: " .. target.Name,
                Lifetime = 2
            })
        end
    else
        Window:Notify({
            Title = "Телепорт",
            Description = "Шериф не найден!",
            Lifetime = 2,
            Style = "Cancel"
        })
    end
end

local function TeleportToMurder()
    local target = GetTargetPlayer(true, false)
    if target then
        local root = GetRootPart(target)
        if root then
            TeleportToPosition(root.Position + Vector3.new(0, 3, 0))
            Window:Notify({
                Title = "Телепорт",
                Description = "Телепортирован к убийце: " .. target.Name,
                Lifetime = 2
            })
        end
    else
        Window:Notify({
            Title = "Телепорт",
            Description = "Убийца не найден!",
            Lifetime = 2,
            Style = "Cancel"
        })
    end
end

local function TeleportToMap()
    local spawn = FindSpawn(true)
    if spawn then
        TeleportToPosition(spawn.Position + Vector3.new(0, 5, 0))
        Window:Notify({
            Title = "Телепорт",
            Description = "Телепортирован на карту",
            Lifetime = 2
        })
    else
        Window:Notify({
            Title = "Телепорт",
            Description = "Точка карты не найдена!",
            Lifetime = 2,
            Style = "Cancel"
        })
    end
end

local function TeleportToLobby()
    local spawn = FindSpawn(false)
    if spawn then
        TeleportToPosition(spawn.Position + Vector3.new(0, 5, 0))
        Window:Notify({
            Title = "Телепорт",
            Description = "Телепортирован в лобби",
            Lifetime = 2
        })
    else
        Window:Notify({
            Title = "Телепорт",
            Description = "Точка лобби не найдена!",
            Lifetime = 2,
            Style = "Cancel"
        })
    end
end

local function GetKnifeServer(player)
    local weapon = GetWeapon(player)
    if weapon then
        return weapon:FindFirstChild("KnifeServer")
    end
    return nil
end

local function GetShootGun(player)
    local knifeServer = GetKnifeServer(player)
    if knifeServer then
        return knifeServer:FindFirstChild("ShootGun")
    end
    return nil
end

local function GetSlashStart(player)
    local knifeServer = GetKnifeServer(player)
    if knifeServer then
        return knifeServer:FindFirstChild("SlashStart")
    end
    return nil
end

local function ProcessSilentAim()
    if not silentAimEnabled then return end

    local target = GetTargetPlayer(true, false)
    if not target then
        target = GetTargetPlayer(false, true)
        if not target then return end
    end
    
    local targetRoot = GetRootPart(target)
    if not targetRoot then return end
    
    local char = GetCharacter(LocalPlayer)
    if not char then return end

    local weapon = nil
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and HasGun(LocalPlayer) then
                weapon = tool
                break
            end
        end
    end
    
    if not weapon then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and HasGun(LocalPlayer) then
                weapon = tool
                break
            end
        end
    end
    
    if not weapon then return end
    
    local knifeServer = weapon:FindFirstChild("KnifeServer")
    if not knifeServer then return end
    
    local shootGun = knifeServer:FindFirstChild("ShootGun")
    if shootGun and shootGun:IsA("RemoteFunction") then
        local origin = GetRootPart(LocalPlayer)
        if origin then
            local direction = (targetRoot.Position - origin.Position).Unit
            local targetPos = targetRoot.Position + direction * 2
            
            pcall(function()
                shootGun:InvokeServer(1, targetPos, "AH2")
            end)
            
            local slashStart = knifeServer:FindFirstChild("SlashStart")
            if slashStart and slashStart:IsA("RemoteEvent") then
                pcall(function()
                    slashStart:FireServer(1, targetPos)
                end)
            end
        end
    end
end


local function ProcessBlatantAim()
    if not blatantAimEnabled then return end

    local target = GetTargetPlayer(true, false)
    if not target then return end
    
    local targetRoot = GetRootPart(target)
    if not targetRoot then return end
    
    local char = GetCharacter(LocalPlayer)
    if not char then return end

    if not HasGun(LocalPlayer) then
        local gunDrop = FindGunDrop()
        if gunDrop then
            local root = GetRootPart(LocalPlayer)
            if root then
                gunDrop.CFrame = root.CFrame * CFrame.new(0, -2, 4)
            end
        end
        return
    end
    
    local weapon = nil
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and HasGun(LocalPlayer) then
                weapon = tool
                break
            end
        end
    end
    
    if not weapon then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and HasGun(LocalPlayer) then
                weapon = tool
                break
            end
        end
    end
    
    if not weapon then return end
    
    local knifeServer = weapon:FindFirstChild("KnifeServer")
    if not knifeServer then return end
    
    local root = GetRootPart(LocalPlayer)
    if root then
        root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 0, 2))
        task.wait(0.05)
    end

    local shootGun = knifeServer:FindFirstChild("ShootGun")
    if shootGun and shootGun:IsA("RemoteFunction") then
        local origin = GetRootPart(LocalPlayer)
        if origin then
            local direction = (targetRoot.Position - origin.Position).Unit
            local targetPos = targetRoot.Position + direction * 2
            
            pcall(function()
                shootGun:InvokeServer(1, targetPos, "AH2")
            end)
            
            local slashStart = knifeServer:FindFirstChild("SlashStart")
            if slashStart and slashStart:IsA("RemoteEvent") then
                pcall(function()
                    slashStart:FireServer(1, targetPos)
                end)
            end
        end
    end
end

local function KillAll()
    if killAllRunning then return end
    killAllRunning = true
    if not HasKnife(LocalPlayer) then
        Window:Notify({
            Title = "Kill All",
            Description = "У вас нет ножа!",
            Lifetime = 2,
            Style = "Cancel"
        })
        killAllRunning = false
        return
    end

    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pChar = GetCharacter(player)
            if pChar then
                table.insert(players, player)
            end
        end
    end
    
    if #players == 0 then
        Window:Notify({
            Title = "Kill All",
            Description = "Игроки не найдены!",
            Lifetime = 2,
            Style = "Cancel"
        })
        killAllRunning = false
        return
    end

    local weapon = GetFirstWeapon(LocalPlayer)
    if not weapon then
        Window:Notify({
            Title = "Kill All",
            Description = "Оружие не найдено!",
            Lifetime = 2,
            Style = "Cancel"
        })
        killAllRunning = false
        return
    end
    
    local knifeServer = weapon:FindFirstChild("KnifeServer")
    if not knifeServer then
        Window:Notify({
            Title = "Kill All",
            Description = "KnifeServer не найден!",
            Lifetime = 2,
            Style = "Cancel"
        })
        killAllRunning = false
        return
    end
    
    local slashStart = knifeServer:FindFirstChild("SlashStart")
    if not slashStart or not slashStart:IsA("RemoteEvent") then
        Window:Notify({
            Title = "Kill All",
            Description = "SlashStart не найден!",
            Lifetime = 2,
            Style = "Cancel"
        })
        killAllRunning = false
        return
    end
    
    local root = GetRootPart(LocalPlayer)
    if not root then
        killAllRunning = false
        return
    end

    for _, player in pairs(players) do
        local pRoot = GetRootPart(player)
        if pRoot then
            root.CFrame = CFrame.new(pRoot.Position + Vector3.new(0, 0, 2))
            task.wait(0.05)
            pcall(function()
                slashStart:FireServer(1, pRoot.Position)
            end)

            task.wait(0.05)
            pcall(function()
                slashStart:FireServer(1, pRoot.Position)
            end)
        end
        task.wait(0.1)
    end
    
    killAllRunning = false
end

local function ToggleAutoKillAll(state)
    autoKillAllRunning = state
    if state then
        task.spawn(function()
            while autoKillAllRunning do
                KillAll()
                task.wait(1)
            end
        end)
    end
end

local Window = MacLib:Window({
    Title = "Killer or Not",
    Subtitle = "by Lakisto.wtf",
    Size = UDim2.fromOffset(900, 700),
    DragStyle = 2,
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,
})

local globalSettings = {
    ESPToggle = Window:GlobalSetting({
        Name = "ESP",
        Default = false,
        Callback = function(bool)
            ToggleESP(bool)
            Window:Notify({
                Title = "ESP",
                Description = (bool and "On" or "Off"),
                Lifetime = 2
            })
        end,
    }),
}

local mainTabGroup = Window:TabGroup()

local espTab = mainTabGroup:Tab({ Name = "ESP", Image = "rbxassetid://18821914323" })
local miscTab = mainTabGroup:Tab({ Name = "Misc", Image = "rbxassetid://10734950309" })
local teleportsTab = mainTabGroup:Tab({ Name = "Teleports", Image = "rbxassetid://18821914323" })
local rolesTab = mainTabGroup:Tab({ Name = "Roles", Image = "rbxassetid://18821914323" })

local espLeft = espTab:Section({ Side = "Left" })
local espRight = espTab:Section({ Side = "Right" })

espLeft:Header({ Name = "Settings ESP" })

espLeft:Paragraph({
    Header = "Информация",
    Body = "Red - Murder\nBlue - Sheriff\nGreen - Innocent"
})

espLeft:Divider()

local espToggle = espLeft:Toggle({
    Name = "Toggle ESP",
    Default = false,
    Callback = function(value)
        ToggleESP(value)
        globalSettings.ESPToggle:UpdateState(value)
    end,
}, "ESPToggle")

local miscLeft = miscTab:Section({ Side = "Left" })
local miscRight = miscTab:Section({ Side = "Right" })

miscLeft:Header({ Name = "Auto Gun Pick" })

miscLeft:Toggle({
    Name = "Автоматический подбор оружия",
    Default = false,
    Callback = function(value)
        autoGunPickRunning = value
        if value then
            task.spawn(AutoGunPick)
        end
    end,
}, "AutoGunPick")

miscLeft:Divider()
miscLeft:Header({ Name = "Knife Throw" })

miscLeft:Toggle({
    Name = "Разрешить бросать нож (Freezer/Infection)",
    Default = false,
    Callback = function(value)
        ToggleKnifeThrow(value)
        Window:Notify({
            Title = "Knife Throw",
            Description = (value and "Разрешено" or "Запрещено") .. " бросать нож",
            Lifetime = 2
        })
    end,
}, "KnifeThrow")

local teleLeft = teleportsTab:Section({ Side = "Left" })
local teleRight = teleportsTab:Section({ Side = "Right" })

teleLeft:Header({ Name = "Телепорты" })

teleLeft:Button({
    Name = "Телепорт к Шерифу",
    Callback = TeleportToSheriff,
})

teleLeft:Button({
    Name = "Телепорт к Убийце",
    Callback = TeleportToMurder,
})

teleLeft:Button({
    Name = "Телепорт на Карту",
    Callback = TeleportToMap,
})

teleLeft:Button({
    Name = "Телепорт в Лобби",
    Callback = TeleportToLobby,
})

local rolesLeft = rolesTab:Section({ Side = "Left" })
local rolesRight = rolesTab:Section({ Side = "Right" })

rolesLeft:Header({ Name = "Sheriff" })

rolesLeft:Toggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(value)
        silentAimEnabled = value
        if value then
            task.spawn(function()
                while silentAimEnabled do
                    ProcessSilentAim()
                    task.wait(0.1)
                end
            end)
        end
    end,
}, "SilentAim")

rolesLeft:Toggle({
    Name = "Blatant Aim (100% попадание)",
    Default = false,
    Callback = function(value)
        blatantAimEnabled = value
        if value then
            task.spawn(function()
                while blatantAimEnabled do
                    ProcessBlatantAim()
                    task.wait(0.3)
                end
            end)
        end
    end,
}, "BlatantAim")

rolesLeft:Divider()

rolesLeft:Header({ Name = "Murder" })

rolesLeft:Button({
    Name = "Kill All (Убить всех)",
    Callback = function()
        KillAll()
        Window:Notify({
            Title = "Kill All",
            Description = "Все игроки убиты!",
            Lifetime = 2,
            Style = "Confirm"
        })
    end,
})

rolesLeft:Toggle({
    Name = "Auto Kill All",
    Default = false,
    Callback = function(value)
        ToggleAutoKillAll(value)
        Window:Notify({
            Title = "Auto Kill All",
            Description = (value and "Включен" or "Выключен"),
            Lifetime = 2
        })
    end,
}, "AutoKillAll")

espTab:Select()

Window.onUnloaded(function()
    ToggleESP(false)
    autoGunPickRunning = false
    autoKillAllRunning = false
    ToggleKnifeThrow(false)
    silentAimEnabled = false
    blatantAimEnabled = false
    
    for _, conn in pairs(espConnections) do
        pcall(function() conn:Disconnect() end)
    end
    espConnections = {}
    
    for _, highlight in pairs(espHighlights) do
        pcall(function() highlight:Destroy() end)
    end
    espHighlights = {}
end)