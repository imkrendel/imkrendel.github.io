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
    C4 v1.1
    Developed by imkrendel | https://github.com/imkrendel
]]
local assetId = "rbxassetid://128278777324449"
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera

--[[ Config C4 ]]

local throwKey = Enum.KeyCode.Q
local explosionRadius = 15 
local damageRadius = 3   
local throwForce = 65
local cooldownTime = 0.4
local lastThrow = 0
local objectHits = {} 
local allC4Models = {}


local function getDestructionData(part)
    local surfaceArea = part.Size.X * part.Size.Y
    local unanchorHits = 4
    local destroyHits = 8

    if surfaceArea <= 100 then
        unanchorHits, destroyHits = 2, 4
    elseif surfaceArea <= 2500 then
        unanchorHits, destroyHits = 8, 12
    elseif surfaceArea <= 10000 then
        unanchorHits, destroyHits = 15, 25
    elseif surfaceArea <= 40000 then
        unanchorHits, destroyHits = 25, 45
    else
        unanchorHits, destroyHits = 40, 70 
    end

    local mult = 1
    if part.Material == Enum.Material.Concrete or part.Material == Enum.Material.Brick then mult = 1.5
    elseif part.Material == Enum.Material.Metal or part.Material == Enum.Material.DiamondPlate then mult = 2.5 end

    return {unanchor = math.floor(unanchorHits * mult), destroy = math.floor(destroyHits * mult)}
end

local function detonate(pos)
    task.spawn(function()
        local sphere = Instance.new("Part")
        sphere.Shape = Enum.PartType.Ball
        sphere.Color = Color3.fromRGB(255, 120, 0)
        sphere.Material = Enum.Material.Neon
        sphere.Size = Vector3.new(1, 1, 1)
        sphere.Position = pos
        sphere.Anchored = true
        sphere.CanCollide = false
        sphere.Parent = workspace
        for i = 1, 10 do
            sphere.Size = sphere.Size + Vector3.new(explosionRadius/10, explosionRadius/10, explosionRadius/10)
            sphere.Transparency = i / 10
            task.wait(0.01)
        end
        sphere:Destroy()
    end)

    local params = OverlapParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {player.Character}
    local parts = workspace:GetPartBoundsInRadius(pos, damageRadius, params)
    for _, part in pairs(parts) do
        if part:IsA("BasePart") and part.Name ~= "C4_Part" and not part:IsDescendantOf(player.Character) then
            if not objectHits[part] then objectHits[part] = 0 end
            objectHits[part] = objectHits[part] + 1
            local data = getDestructionData(part)
            if objectHits[part] >= data.destroy then
                objectHits[part] = nil
                part:Destroy()
            elseif objectHits[part] >= data.unanchor then
                part.Anchored = false
                part:BreakJoints() 
                local direction = (part.Position - pos).Unit
                if direction.Magnitude == 0 then direction = Vector3.new(0, 1, 0) end
                part.AssemblyLinearVelocity = direction * 15 + Vector3.new(0, 5, 0) 
                part:ApplyImpulse(direction * 450)
                part.Color = part.Color:Lerp(Color3.new(0, 0, 0), 0.4)
            else
                local oldColor = part.Color
                part.Color = Color3.new(1, 0, 0)
                if not part.Anchored then
                    part:ApplyImpulse((part.Position - pos).Unit * 100)
                end
                task.delay(0.1, function() 
                    if part and part.Parent then part.Color = oldColor end 
                end)
            end
        end
    end
end

local function throw()
    if tick() - lastThrow < cooldownTime then return end
    lastThrow = tick()

    local char = player.Character
    if not char then return end
    
    local success, result = pcall(function() return game:GetObjects(assetId) end)
    if not success or type(result) ~= "table" or #result == 0 then return end
    
    local model = result[1]
    model.Parent = workspace
    table.insert(allC4Models, model)

    local root = model:FindFirstChild("MainPart") or model:FindFirstChild("Screen") or model:FindFirstChildWhichIsA("BasePart")
    
    for _, v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = false
            v.CanCollide = false 
            v.Name = "C4_Part" 
            if v ~= root then
                local w = Instance.new("WeldConstraint")
                w.Part0 = root
                w.Part1 = v
                w.Parent = root
            end
        end
    end

    root.CFrame = camera.CFrame * CFrame.new(0, 0, -6)
    root.AssemblyLinearVelocity = (camera.CFrame.LookVector * throwForce) + Vector3.new(0, 20, 0)
    root.AssemblyAngularVelocity = Vector3.new(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15))

    local hasStuck = false
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if hasStuck then connection:Disconnect() return end
        local vel = root.AssemblyLinearVelocity
        if vel.Magnitude > 1 then
            local rayParams = RaycastParams.new()
            local ignoreList = {char}
            for i = #allC4Models, 1, -1 do
                if allC4Models[i] and allC4Models[i].Parent then table.insert(ignoreList, allC4Models[i])
                else table.remove(allC4Models, i) end
            end
            rayParams.FilterDescendantsInstances = ignoreList
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            
            local ray = workspace:Raycast(root.Position, vel.Unit * 3, rayParams)
            if ray then
                hasStuck = true
                for _, v in pairs(model:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.AssemblyLinearVelocity = Vector3.zero
                        v.AssemblyAngularVelocity = Vector3.zero
                        v.Anchored = true
                        v.CanCollide = true
                    end
                end
                task.wait(5)
                if model and model.Parent then
                    detonate(root.Position)
                    model:Destroy()
                end
            end
        end
    end)
end

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == throwKey then
        throw()
    end
end)