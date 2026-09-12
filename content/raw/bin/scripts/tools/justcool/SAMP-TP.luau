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
    SAMP-TP v1.0
    Developed by imkrendel | https://github.com/imkrendel
]]

local assetId = 92003611074449
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local toggleKey = Enum.KeyCode.F1
local isActive = false
local objects = game:GetObjects("rbxassetid://" .. assetId)
local obj = objects[1]
local mainPart = nil
if obj then
    obj.Parent = workspace
    mouse.TargetFilter = obj
    for _, v in pairs(obj:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
            v.Anchored = true
            v.CanQuery = false
            if v.Name == "MHPart" then 
                mainPart = v 
                v.Transparency = 1
            elseif v.Name == "Pyramid" then
                v.Transparency = 1
                v.Color = Color3.new(1, 1, 1)
                v.Material = Enum.Material.Plastic
            else
                v.Transparency = 1
            end
        end
    end
end

local function playTeleportEffect(char)
    task.spawn(function()
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
        task.wait(0.1)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if part.Name == "HumanoidRootPart" then
                    part.Transparency = 1
                else
                    part.Transparency = 0
                end
            end
        end
    end)
end

local function updateVisibility(active)
    for _, v in pairs(obj:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Name == "MHPart" then
                v.Transparency = 1
            else
                v.Transparency = active and 0 or 1
            end
        end
    end
end

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == toggleKey then
        isActive = not isActive
        updateVisibility(isActive)
    end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 and isActive then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            playTeleportEffect(character)
            character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if isActive and mainPart then
        local targetCFrame = CFrame.new(mouse.Hit.Position) * CFrame.Angles(0, 0, math.rad(90))
        if obj:IsA("Model") then
            local relative = mainPart.CFrame:ToObjectSpace(obj:GetPivot())
            obj:PivotTo(targetCFrame * relative)
        else
            obj.CFrame = targetCFrame
        end
    end
end)