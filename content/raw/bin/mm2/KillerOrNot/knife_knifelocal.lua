local Button2Down, Button2Up, Equipped, Knife, KnifeIcon, PerkName, Throw, u82, v1
local Parent = script.Parent
local Animation = Instance.new("Animation")
Animation.AnimationId = "rbxassetid://136534782838815"
local u14 = Parent.Parent.Parent.Character.Humanoid:LoadAnimation(Animation)
task.wait(0.5)
local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
if not Character then
    Character = LocalPlayer.CharacterAdded:wait()
end
local UserInputService = game:GetService("UserInputService")
game.Players.LocalPlayer.PlayerScripts:FindFirstChild("MouseLock")
local CheckTapPosition = require(script.CheckTapPosition)
local TouchEnabled = UserInputService.TouchEnabled
if TouchEnabled then
    TouchEnabled = not UserInputService.KeyboardEnabled
end
local u46 = nil
game:GetService("RunService").RenderStepped:Connect(function() -- Line: 15 -- upvalues: u46 (ref)
    local CurrentCamera = workspace.CurrentCamera
    u46 = {Position = CurrentCamera.CFrame.Position, LookVector = CurrentCamera.CFrame.LookVector}
end)
while _G.Database == nil do
    task.wait()
end
local ItemModule = require(game.ReplicatedStorage.Modules.ItemModule)
local function isShiftLockEnabled() -- Line: 30 -- upvalues: UserInputService (val)
    local LocalPlayer = game.Players.LocalPlayer
    local DevEnableMouseLock = LocalPlayer.DevEnableMouseLock
    if DevEnableMouseLock then
        DevEnableMouseLock = if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson else false
    end
    return DevEnableMouseLock
end
local function getShiftLockThrowDirection() -- Line: 39 -- upvalues: LocalPlayer (val)
    local Position_2
    local Character = LocalPlayer.Character
    if not Character or not (Character:FindFirstChild("HumanoidRootPart")) then
        return nil
    end
    local CurrentCamera = workspace.CurrentCamera
    local LookVector = CurrentCamera.CFrame.LookVector
    local Position = CurrentCamera.CFrame.Position
    local v1 = RaycastParams.new()
    v1.FilterDescendantsInstances = {Character}
    v1.FilterType = Enum.RaycastFilterType.Exclude
    local v2 = workspace:Raycast(Position, LookVector * 1000, v1)
    if not v2 then
        Position_2 = Position + LookVector * 1000
    else
        Position_2 = v2.Position
        if not Position_2 then
            Position_2 = Position + LookVector * 1000
        end
    end
    return Position_2
end
while true do
    u82 = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
    wait()
    if u82 then
        break
    end
end
local function isToolEquipped() -- Line: 68 -- upvalues: Parent (val), LocalPlayer (val)
    local v1 = Parent.Parent == LocalPlayer.Character
    return v1
end
local function isVariantItem(p1) -- Line: 73
    local v1 = string.lower(p1)
    local v2 = string.find(v1, "chroma")
    if not v2 then
        v2 = string.find(v1, "godly")
        if not v2 then
            v2 = string.find(v1, "golden")
            if not v2 then
                v2 = string.find(v1, "diamond")
                if not v2 then
                    v2 = string.find(v1, "ruby")
                    if not v2 then
                        v2 = string.find(v1, "sapphire")
                    end
                end
            end
        end
    end
    return v2
end
local function updateKnifeIconImage() -- Line: 84 -- upvalues: u82 (ref), Parent (val), isVariantItem (val), ItemModule (val)
    local Knife = u82.Game:FindFirstChild("Knife")
    if not Knife then
        return
    end
    local KnifeIcon = Knife:FindFirstChild("KnifeIcon")
    if not KnifeIcon then
        return
    end
    local Name = Parent.Name
    local v1 = string.lower(Name)
    local v2 = nil
    if not _G.Database or not _G.Database.Item then
        return
    end
    if _G.Database.Item[Name] then
        v2 = _G.Database.Item[Name]
    end
    if not v2 then
        for k, v in pairs(_G.Database.Item) do
            if string.lower(k) == v1 and not (isVariantItem(k)) then
                v2 = v
                break
            end
        end
    end
    if not v2 then
        for k2, i in pairs(_G.Database.Item) do
            if i.ItemName == Name and not (isVariantItem(k2)) then
                v2 = i
                break
            end
        end
    end
    if not v2 then
        for k3, j in pairs(_G.Database.Item) do
            if j.ItemName and string.lower(j.ItemName) == v1 and not (isVariantItem(k3)) then
                v2 = j
                break
            end
        end
    end
    if not v2 then
        local v3
        for k4, k5 in pairs(_G.Database.Item) do
            if k5.ItemName and not (isVariantItem(k4)) then
                v3 = string.lower(k5.ItemName)
                if not (string.find(v1, v3, 1, true)) and not (string.find(v3, v1, 1, true)) then
                    continue
                end
                v2 = k5
                break
            end
        end
    end
    if v2 and v2.Image then
        KnifeIcon.Image = ItemModule.GetImage(v2.Image)
    end
end
local function updateThrowButtonUI(p1) -- Line: 158 -- upvalues: u82 (ref)
    local v1
    local Throw = u82.Game:FindFirstChild("Throw")
    if not Throw then
        return
    end
    if not p1 then
        v1 = 0.5
    else
        v1 = 0
    end
    Throw.ImageTransparency = v1
    local KnifeIcon = Throw:FindFirstChild("KnifeIcon")
    if KnifeIcon then
        KnifeIcon.ImageTransparency = v1
    end
    local PerkName = Throw:FindFirstChild("PerkName")
    if PerkName then
        PerkName.TextTransparency = v1
    end
end
local function updateEquippedFrame(p1) -- Line: 181 -- upvalues: u82 (ref)
    local Knife = u82.Game:FindFirstChild("Knife")
    if Knife then
        local Equipped = Knife:FindFirstChild("Equipped")
        if Equipped then
            Equipped.Visible = p1
        end
    end
end
if not TouchEnabled then
    v1 = Parent.Parent == LocalPlayer.Character
    local Throw_2 = u82.Game:FindFirstChild("Throw")
    if Throw_2 then
        local v2
        if not v1 then
            v2 = 0.5
        else
            v2 = 0
        end
        Throw_2.ImageTransparency = v2
        KnifeIcon = Throw_2:FindFirstChild("KnifeIcon")
        if KnifeIcon then
            KnifeIcon.ImageTransparency = v2
        end
        PerkName = Throw_2:FindFirstChild("PerkName")
        if PerkName then
            PerkName.TextTransparency = v2
        end
    end
elseif u82.Game:FindFirstChild("Knife") then
    u82.Game.Knife.Visible = true
    u82.Game.Throw.Visible = true
end
updateKnifeIconImage()
v1 = Parent.Parent == LocalPlayer.Character
local Knife_2 = u82.Game:FindFirstChild("Knife")
if Knife_2 then
    Equipped = Knife_2:FindFirstChild("Equipped")
    if Equipped then
        Equipped.Visible = v1
    end
end
LocalPlayer.Backpack.ChildAdded:Connect(function(p1) -- Line: 207 -- upvalues: Parent (val), updateKnifeIconImage (val), u82 (ref)
    if p1 == Parent then
        updateKnifeIconImage()
        local Throw = u82.Game:FindFirstChild("Throw")
        if Throw then
            Throw.ImageTransparency = 0.5
            local KnifeIcon = Throw:FindFirstChild("KnifeIcon")
            if KnifeIcon then
                KnifeIcon.ImageTransparency = 0.5
            end
            local PerkName = Throw:FindFirstChild("PerkName")
            if PerkName then
                PerkName.TextTransparency = 0.5
            end
        end
        local Knife = u82.Game:FindFirstChild("Knife")
        if Knife then
            local Equipped = Knife:FindFirstChild("Equipped")
            if Equipped then
                Equipped.Visible = false
            end
        end
    end
end)
LocalPlayer.Backpack.ChildRemoved:Connect(function(p1) -- Line: 215 -- upvalues: Parent (val), u82 (ref)
    if p1 == Parent then
        local Throw = u82.Game:FindFirstChild("Throw")
        if Throw then
            Throw.ImageTransparency = 0
            local KnifeIcon = Throw:FindFirstChild("KnifeIcon")
            if KnifeIcon then
                KnifeIcon.ImageTransparency = 0
            end
            local PerkName = Throw:FindFirstChild("PerkName")
            if PerkName then
                PerkName.TextTransparency = 0
            end
        end
        local Knife = u82.Game:FindFirstChild("Knife")
        if Knife then
            local Equipped = Knife:FindFirstChild("Equipped")
            if Equipped then
                Equipped.Visible = true
            end
        end
    end
end)
if u82.Game:FindFirstChild("Knife") then
    Knife = u82.Game.Knife
    local ImageColor3 = Knife.ImageColor3
    Knife.MouseButton1Down:Connect(function() -- Line: 227 -- upvalues: Knife (val)
        Knife.ImageColor3 = Color3.new(1, 1, 1)
    end)
    Knife.MouseButton1Up:Connect(function() -- Line: 231 -- upvalues: Knife (val), ImageColor3 (val)
        Knife.ImageColor3 = ImageColor3
    end)
    Knife.MouseLeave:Connect(function() -- Line: 235 -- upvalues: Knife (val), ImageColor3 (val)
        Knife.ImageColor3 = ImageColor3
    end)
end
if u82.Game:FindFirstChild("Throw") then
    Throw = u82.Game.Throw
    local ImageColor3_2 = Throw.ImageColor3
    Throw.MouseButton1Down:Connect(function() -- Line: 244 -- upvalues: Throw (val)
        Throw.ImageColor3 = Color3.new(1, 1, 1)
    end)
    Throw.MouseButton1Up:Connect(function() -- Line: 248 -- upvalues: Throw (val), ImageColor3_2 (val)
        Throw.ImageColor3 = ImageColor3_2
    end)
    Throw.MouseLeave:Connect(function() -- Line: 252 -- upvalues: Throw (val), ImageColor3_2 (val)
        Throw.ImageColor3 = ImageColor3_2
    end)
end
local Mouse = LocalPlayer:GetMouse()
if Parent:FindFirstChild("DualEffect") then
    Parent.Animations.Slash.AnimationId = Parent.Animations.Dual.DualSlash.AnimationId
    Parent.Animations.Down.AnimationId = Parent.Animations.Dual.DualStab.AnimationId
end
local u260 = {}
local function v3(p1) -- Line: 262 -- upvalues: u260 (val), LocalPlayer (val)
    u260[p1.Name] = {}
    local v1 = u260[p1.Name]
    v1.Name = p1.Name
    v1 = u260[p1.Name]
    local Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    v1.Track = Humanoid:LoadAnimation(p1)
    u260[p1.Name].Object = p1
    v1 = u260[p1.Name]
    function v1:Play(p2) -- Line: 267
        self.Track:Play()
    end
    v1 = u260[p1.Name]
    function v1:Stop(p2) -- Line: 270
        self.Track:Stop()
    end
    v1 = u260[p1.Name]
    function v1:Speed(p2) -- Line: 273
        self.Track:AdjustSpeed(p2)
    end
    u260[p1.Name].Track.KeyframeReached:Connect(function(a1) -- Line: 276 -- upvalues: u260 (upval), p1 (val)
        if a1 == "End" then
            u260[p1.Name]:Stop()
        end
    end)
end
Parent.DescendantAdded:Connect(function(p1) -- Line: 282 -- upvalues: v9 (val)
    if p1:IsA("Animation") then
        v1(p1)
    end
end)
for k, v in pairs(Parent:GetDescendants()) do
    if v:IsA("Animation") then
        v3(v)
    end
end
if Parent:FindFirstChild("CustomAnimations") and Parent.CustomAnimations:FindFirstChild("CustomIdle") then
    local v4 = Parent.CustomAnimations.CustomIdle:Clone()
    v4.Name = "Override"
    v4.Parent = LocalPlayer.Character.Animate
end
local u302 = false
local u303 = 0
local u304 = 0
local u305 = false
local Stealth = game.ReplicatedStorage.Game.Remotes.Gameplay.Stealth
local u312 = 1
local function v5() -- Line: 304 -- upvalues: u302 (ref), u303 (ref), u304 (ref), u305 (ref), Stealth (val), u260 (val), u312 (ref)
    if not u302 then
        return
    end
    local v1 = time() - u303
    if 1 <= v1 then
        v1 = time() - u304
        if 2 <= v1 and not u305 then
            local Slash
            Stealth:FireServer(false)
            u305 = false
            u260.ThrowCharge:Speed(u312)
            u303 = time()
            if math.random(1, 2) ~= 1 then
                Slash = u260.Down
            else
                Slash = u260.Slash
                if not Slash then
                    Slash = u260.Down
                end
            end
            Slash:Play()
            script.Parent.KnifeServer.SlashStart:FireServer(1)
        end
    end
end
local u316 = false
local u317 = 1
local Handle = Parent.Handle
if TouchEnabled then
    local UserInputService_2 = game:GetService("UserInputService")
    Button2Down = nil
    Button2Up = nil
    UserInputService_2.TouchStarted:Connect(function(p1, p2) -- Line: 332 -- upvalues: Button2Down (ref), Button2Up (ref)
        if p2 then
            return
        end
        Button2Down = p1.Position
        Button2Up = tick()
    end)
    UserInputService_2.TouchEnded:Connect(function(p1, p2) -- Line: 339 -- upvalues: Button2Down (ref), u302 (ref), u305 (ref), Button2Up (ref), v13 (val)
        if p2 or not Button2Down or not u302 or u305 then
            return
        end
        local v1 = tick() - Button2Up
        if (p1.Position - Button2Down).Magnitude <= 15 and v1 <= 0.25 then
            v2()
        end
        Button2Down = nil
    end)
end
if CheckTapPosition then
    Mouse.Button1Down:Connect(v5)
end
local u351 = 0
Mouse.Button2Down:Connect(function() -- Line: 357 -- upvalues: u351 (ref)
    u351 = time()
end)
function Button2Down() -- Line: 360 -- upvalues: u302 (ref), u303 (ref), u304 (ref), Parent (val), Stealth (val), u316 (ref), u260 (val), u312 (ref), u317 (ref), UserInputService (val), LocalPlayer (val), Mouse (val), Handle (val)
    if not u302 then
        return
    end
    local v1 = time() - u303
    if 1 <= v1 then
        v1 = time() - u304
        if 2 <= v1 and not (Parent:FindFirstChild("DisableThrowing")) then
            local Position, v2, v3, v4
            Stealth:FireServer(false)
            u316 = true
            u304 = time()
            u260.ThrowCharge:Speed(u312)
            u260.ThrowCharge:Play()
            wait(u317)
            v1 = {game.Players.LocalPlayer.Character}
            local CurrentCamera = workspace.CurrentCamera
            local LocalPlayer_2 = game.Players.LocalPlayer
            local DevEnableMouseLock = LocalPlayer_2.DevEnableMouseLock
            if DevEnableMouseLock then
                DevEnableMouseLock = if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then LocalPlayer_2.CameraMode ~= Enum.CameraMode.LockFirstPerson else false
            end
            if not DevEnableMouseLock then
                v2 = CurrentCamera:ScreenPointToRay(Mouse.X, Mouse.Y)
                v3 = RaycastParams.new()
                v3.FilterType = Enum.RaycastFilterType.Exclude
                v3.FilterDescendantsInstances = {LocalPlayer.Character}
                v4 = workspace:Raycast(v2.Origin, v2.Direction * 1000, v3)
                if not v4 then
                    Position = v2.Origin + v2.Direction * 1000
                else
                    Position = v4.Position
                end
            else
                v2 = RaycastParams.new()
                v2.FilterType = Enum.RaycastFilterType.Exclude
                v2.FilterDescendantsInstances = {LocalPlayer.Character}
                v3 = workspace:Raycast(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector * 1000, v2)
                if not v3 then
                    Position = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 1000
                else
                    Position = v3.Position
                end
            end
            v4 = CFrame.new(Position)
            script.Parent.KnifeServer.FlingKnifeEvent:FireServer(v4, Handle.Position)
            script.Parent.KnifeServer.SetKnifeGoneTime:FireServer(1)
            u260.ThrowCharge:Stop()
            u260.Throw:Play()
        end
    end
    wait(1)
end
Mouse.Button2Up:Connect(function() -- Line: 413 -- upvalues: u351 (ref), Parent (val), Button2Down (val)
    local v1 = time() - u351
    if v1 <= 0.3 and not (Parent:FindFirstChild("DisableThrowing")) then
        Button2Down()
    end
end)
Button2Up = game:GetService("UserInputService")
Button2Up.InputBegan:Connect(function(p1, p2) -- Line: 420 -- upvalues: Parent (val), Button2Down (val)
    if p2 then
        return
    end
    if p1.KeyCode == Enum.KeyCode.E and not (Parent:FindFirstChild("DisableThrowing")) then
        Button2Down()
    end
end)
game:GetService("UserInputService").InputBegan:Connect(function(p1) -- Line: 429 -- upvalues: Parent (val), v13 (val), u302 (ref), Button2Down (val)
    if p1.KeyCode ~= Enum.KeyCode.ButtonR2 then
        if p1.KeyCode == Enum.KeyCode.ButtonL2 and not (Parent:FindFirstChild("DisableThrowing")) and u302 then
            Button2Down()
        end
        return
    end
    if not (Parent:FindFirstChild("DisableMelee")) then
        v1()
        return
    end
    if p1.KeyCode == Enum.KeyCode.ButtonL2 and not (Parent:FindFirstChild("DisableThrowing")) and u302 then
        Button2Down()
    end
end)
if TouchEnabled then
    local v6
    u82.Game.Throw.MouseButton1Click:Connect(function() -- Line: 439 -- upvalues: u302 (ref), u303 (ref), u304 (ref), u305 (ref), Parent (val), Stealth (val), u260 (val), u312 (ref), u317 (ref)
        if not u302 then
            return
        end
        local v1 = time() - u303
        if 1 <= v1 then
            v1 = time() - u304
            if 2 <= v1 and not u305 and not (Parent:FindFirstChild("DisableThrowing")) then
                Stealth:FireServer(false)
                u304 = time()
                u260.ThrowCharge:Speed(u312)
                u260.ThrowCharge:Play()
                wait(u317)
                u260.ThrowCharge:Speed(0.1)
                u305 = true
            end
        end
    end)
    local function u15(p1) -- Line: 453 -- upvalues: u305 (ref), u302 (ref), Parent (val), Stealth (val), u260 (val), u312 (ref), Handle (val), u304 (ref)
        if u305 and u302 and not (Parent:FindFirstChild("DisableThrowing")) then
            Stealth:FireServer(false)
            u305 = false
            u260.ThrowCharge:Stop()
            u260.ThrowCharge:Speed(u312)
            u260.Throw:Play(0.05)
            local v1 = CFrame.new(p1)
            script.Parent.KnifeServer.FlingKnifeEvent:FireServer(v1, Handle.Position)
            u304 = time() - 1
            wait(0.95)
        end
    end
    UserInputService.TouchTapInWorld:Connect(function(p1, p2) -- Line: 467 -- upvalues: UserInputService (val), LocalPlayer (val), u46 (ref), u15 (val)
        local Position, v1
        if not p1 or p2 then
            return
        end
        local LocalPlayer_2 = game.Players.LocalPlayer
        local DevEnableMouseLock = LocalPlayer_2.DevEnableMouseLock
        if DevEnableMouseLock then
            DevEnableMouseLock = if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then LocalPlayer_2.CameraMode ~= Enum.CameraMode.LockFirstPerson else false
        end
        if DevEnableMouseLock then
            local v2 = RaycastParams.new()
            v2.FilterType = Enum.RaycastFilterType.Exclude
            v2.FilterDescendantsInstances = {LocalPlayer.Character}
            v1 = workspace:Raycast(u46.Position, u46.LookVector * 1000, v2)
            if not v1 then
                Position = u46.Position + u46.LookVector * 1000
            else
                Position = v1.Position
            end
            u15(Position)
            return
        end
        v1 = workspace.CurrentCamera:ViewportPointToRay(p1.X, p1.Y)
        local v3 = RaycastParams.new()
        v3.FilterType = Enum.RaycastFilterType.Exclude
        v3.FilterDescendantsInstances = {LocalPlayer.Character}
        local v4 = workspace:Raycast(v1.Origin, v1.Direction * 500, v3)
        if v4 and v4.Position then
            u15(v4.Position)
        end
    end)
    if TouchEnabled and u82.Game:FindFirstChild("Throw") then
        u82.Game.Throw.MouseButton1Click:Connect(function() -- Line: 509 -- upvalues: u302 (ref), u303 (ref), u304 (ref), u305 (ref), Parent (val), Stealth (val), u260 (val), u312 (ref), u317 (ref), UserInputService (val), LocalPlayer (val), u46 (ref), u15 (val)
            if not u302 then
                return
            end
            local v1 = time() - u303
            if 1 <= v1 then
                v1 = time() - u304
                if 2 <= v1 and not u305 and not (Parent:FindFirstChild("DisableThrowing")) then
                    Stealth:FireServer(false)
                    u304 = time()
                    u260.ThrowCharge:Speed(u312)
                    u260.ThrowCharge:Play()
                    wait(u317)
                    u260.ThrowCharge:Speed(0.1)
                    u305 = true
                    local LocalPlayer_2 = game.Players.LocalPlayer
                    local DevEnableMouseLock = LocalPlayer_2.DevEnableMouseLock
                    if DevEnableMouseLock then
                        DevEnableMouseLock = if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then LocalPlayer_2.CameraMode ~= Enum.CameraMode.LockFirstPerson else false
                    end
                    if DevEnableMouseLock then
                        local Position
                        v1 = RaycastParams.new()
                        v1.FilterType = Enum.RaycastFilterType.Exclude
                        v1.FilterDescendantsInstances = {LocalPlayer.Character}
                        local v2 = workspace:Raycast(u46.Position, u46.LookVector * 1000, v1)
                        if not v2 then
                            Position = u46.Position + u46.LookVector * 1000
                        else
                            Position = v2.Position
                        end
                        u15(Position)
                    end
                end
            end
        end)
    end
    for k2, i in pairs(game.Workspace:GetChildren()) do
        if i:FindFirstChild("Humanoid") and i:FindFirstChild("UpperTorso") and i.Name ~= LocalPlayer.Name and script:FindFirstChild("Target") then
            v6 = script.Target:Clone()
            v6.Parent = i.UpperTorso
            if i.UpperTorso.Target:FindFirstChild("Icon") then
                i.UpperTorso.Target.Icon.ImageColor3 = Color3.new(0, 1, 0)
            end
        end
    end
    local RunService = game:GetService("RunService")
    RunService:BindToRenderStep("Thrower", 1, function() -- Line: 556 -- upvalues: LocalPlayer (val), u305 (ref)
        local Position, v1, v2, v3
        for k, v in pairs(game.Workspace:GetChildren()) do
            if not (v:FindFirstChild("Humanoid")) then
                if v:FindFirstChild("UpperTorso") and v.UpperTorso:FindFirstChild("Target") then
                    v.UpperTorso.Target:Destroy()
                end
            elseif v:FindFirstChild("UpperTorso") and v.UpperTorso:FindFirstChild("Target") and v.Name ~= LocalPlayer.Name and game.Players:GetPlayerFromCharacter(v) then
                v.UpperTorso.Target.Enabled = false
                v.UpperTorso.Target.AlwaysOnTop = false
                if u305 then
                    _, v1 = game.Workspace.CurrentCamera:WorldToScreenPoint(v.UpperTorso.Position)
                    if v1 then
                        Position = LocalPlayer.Character.Head.Position
                        v2 = RaycastParams.new()
                        v2.FilterDescendantsInstances = {LocalPlayer.Character}
                        v2.FilterType = Enum.RaycastFilterType.Exclude
                        v3 = workspace:Raycast(Position, (v.UpperTorso.Position - Position).unit * 300, v2)
                        if v3 and v3.Instance then
                            if v3.Instance.Parent == v then
                                v.UpperTorso.Target.Enabled = true
                                v.UpperTorso.Target.AlwaysOnTop = true
                            elseif v3.Instance.Parent.Parent ~= v then
                            end
                        end
                    end
                end
            end
        end
    end)
    local RunService_2 = game:GetService("RunService")
    RunService_2:BindToRenderStep("Stabber", 1, function() -- Line: 580 -- upvalues: TouchEnabled (val), u302 (ref), LocalPlayer (val), v13 (val)
        if not TouchEnabled then
            return
        end
        if u302 then
            local v1
            for k, v in pairs(workspace:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= LocalPlayer.Name and 0 < v.Humanoid.Health and not (v:GetAttribute("IsRagdoll")) then
                    v1 = LocalPlayer:DistanceFromCharacter(v.HumanoidRootPart.Position)
                    if v1 <= 5 then
                        v2()
                    end
                end
            end
        end
    end)
end
local u541 = nil
local HasteTrail = script:FindFirstChild("HasteTrail")
if HasteTrail then
    u541 = HasteTrail:Clone()
    u541.Parent = Character.UpperTorso
    u541.Attachment0 = Character.UpperTorso.NeckAttachment
    u541.Attachment1 = Character.UpperTorso.WaistRigAttachment
end
u541.Parent = Character.UpperTorso
u541.Attachment0 = Character.UpperTorso.NeckAttachment
u541.Attachment1 = Character.UpperTorso.WaistRigAttachment
Parent.Equipped:Connect(function() -- Line: 614 -- upvalues: u305 (ref), u260 (val), u302 (ref), Parent (val), u14 (val), u312 (ref), u317 (ref), u541 (ref), LocalPlayer (val), updateKnifeIconImage (val), u82 (ref)
    u305 = false
    if u260.ThrowCharge then
        u260.ThrowCharge:Stop()
        u260.ThrowCharge.Track.TimePosition = 0
    end
    u260.Throw:Stop()
    u260.Throw.Track.TimePosition = 0
    u302 = true
    if Parent:FindFirstChild("DualEffect") then
        while true do
            task.wait()
            if Parent:FindFirstChild("Dual") then
                break
            end
        end
        wait()
        if Parent:FindFirstChild("Dual").Transparency ~= 1 then
            u14:Play()
        end
    end
    u302 = true
    if _G.Sleight then
        u312 = 0.93
        u317 = 0.6
    end
    if _G.Haste and u541 then
        u541.Enabled = true
        LocalPlayer.Character.Humanoid.WalkSpeed = 18
    end
    updateKnifeIconImage()
    local Throw = u82.Game:FindFirstChild("Throw")
    if Throw then
        Throw.ImageTransparency = 0
        local KnifeIcon = Throw:FindFirstChild("KnifeIcon")
        if KnifeIcon then
            KnifeIcon.ImageTransparency = 0
        end
        local PerkName = Throw:FindFirstChild("PerkName")
        if PerkName then
            PerkName.TextTransparency = 0
        end
    end
    local Knife = u82.Game:FindFirstChild("Knife")
    if Knife then
        local Equipped = Knife:FindFirstChild("Equipped")
        if Equipped then
            Equipped.Visible = true
        end
    end
end)
Parent.Unequipped:Connect(function() -- Line: 657 -- upvalues: Parent (val), u14 (val), LocalPlayer (val), u541 (ref), u302 (ref), u305 (ref), u316 (ref), u260 (val), u312 (ref), u82 (ref)
    if Parent:FindFirstChild("DualEffect") then
        u14:Stop()
    end
    if _G.Haste then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        u541.Enabled = false
    end
    u302 = false
    u305 = false
    u316 = false
    u260.ThrowCharge:Stop()
    u260.ThrowCharge.Track.TimePosition = 0
    u260.Throw:Stop()
    u260.Throw.Track.TimePosition = 0
    u260.ThrowCharge:Speed(u312)
    for k, v in pairs(u260) do
        if v.Track then
            v.Track:Stop()
        end
    end
    spawn(function() -- Line: 684 -- upvalues: u316 (upval)
        wait(0.1)
        u316 = false
    end)
    local Throw = u82.Game:FindFirstChild("Throw")
    if Throw then
        Throw.ImageTransparency = 0.5
        local KnifeIcon = Throw:FindFirstChild("KnifeIcon")
        if KnifeIcon then
            KnifeIcon.ImageTransparency = 0.5
        end
        local PerkName = Throw:FindFirstChild("PerkName")
        if PerkName then
            PerkName.TextTransparency = 0.5
        end
    end
    local Knife = u82.Game:FindFirstChild("Knife")
    if Knife then
        local Equipped = Knife:FindFirstChild("Equipped")
        if Equipped then
            Equipped.Visible = false
        end
    end
end)
