
local Animator, Character, Equipped, Gun, Gun_2, Humanoid, Name, Unequipped, u353, v1, v2, v3
local KnifeServer = script.Parent:WaitForChild("KnifeServer")
local ShootGun = KnifeServer:WaitForChild("ShootGun")
ShootGun.Name = "RemoteFunction"
ShootGun.Parent = script:WaitForChild("CreateBeam")
local Players = game:GetService("Players")
game:GetService("HttpService")
local RunService = game:GetService("RunService")
game:GetService("UserInputService")
local UserInputService_3 = game:GetService("UserInputService")
local TouchEnabled = UserInputService_3.TouchEnabled
if TouchEnabled then
    TouchEnabled = not UserInputService_3.KeyboardEnabled
end
local MainGUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("MainGUI")
local MouseLock = game.Players.LocalPlayer.PlayerScripts:FindFirstChild("MouseLock")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Parent = script.Parent
local u67 = nil
local u68 = nil
local function playDualHoldAnimation() -- Line: 20 -- upvalues: Parent (val), LocalPlayer (val), u67 (ref), u68 (ref)
    if Parent:FindFirstChild("DualEffect") and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            u67 = Instance.new("Animation")
            u67.AnimationId = "rbxassetid://136534782838815"
            local Animator = Humanoid:FindFirstChildOfClass("Animator")
            if not Animator then
                Animator = Instance.new("Animator")
                Animator.Parent = Humanoid
            end
            u68 = Animator:LoadAnimation(u67)
            u68:Play()
        end
    end
end
local function stopDualHoldAnimation() -- Line: 38 -- upvalues: u68 (ref), u67 (ref)
    if u68 then
        u68:Stop()
        u68 = nil
    end
    if u67 then
        u67:Destroy()
        u67 = nil
    end
end
local u71 = nil
local u72 = nil
local function playGingerscopeAnimation() -- Line: 53 -- upvalues: Parent (val), LocalPlayer (val), u71 (ref), u72 (ref)
    local Handle = Parent:FindFirstChild("Handle")
    if Handle and Handle:FindFirstChild("IsGingerscope") and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if Humanoid then
            local Animator = Humanoid:FindFirstChildOfClass("Animator")
            if Animator then
                u71 = Instance.new("Animation")
                u71.AnimationId = "http://www.roblox.com/Asset?ID=89283464841482"
                u72 = Animator:LoadAnimation(u71)
                u72:Play()
            end
        end
    end
end
local function stopGingerscopeAnimation() -- Line: 73 -- upvalues: u72 (ref), u71 (ref)
    if u72 then
        u72:Stop()
        u72:Destroy()
        u72 = nil
    end
    if u71 then
        u71:Destroy()
        u71 = nil
    end
end
if Parent:FindFirstChild("DualEffect") and Parent.Parent == LocalPlayer.Character then
    playDualHoldAnimation()
end
Parent.Equipped:Connect(function() -- Line: 91 -- upvalues: playDualHoldAnimation (val), playGingerscopeAnimation (val)
    task.wait(0.1)
    playDualHoldAnimation()
    playGingerscopeAnimation()
end)
Parent.Unequipped:Connect(function() -- Line: 98 -- upvalues: u68 (ref), u67 (ref), u72 (ref), u71 (ref)
    if u68 then
        u68:Stop()
        u68 = nil
    end
    if u67 then
        u67:Destroy()
        u67 = nil
    end
    if u72 then
        u72:Stop()
        u72:Destroy()
        u72 = nil
    end
    if u71 then
        u71:Destroy()
        u71 = nil
    end
end)
local function updateGunButtonVisibility() -- Line: 104 -- upvalues: MainGUI (val), LocalPlayer (val), Parent (val), TouchEnabled (val)
    local Gun = MainGUI.Game:FindFirstChild("Gun")
    if not Gun then
        return
    end
    local v1 = LocalPlayer.Backpack:FindFirstChild(Parent.Name)
    local v2 = Parent.Parent == LocalPlayer.Character
    local v3 = TouchEnabled
    if v3 then
        v3 = v2 or v1
    end
    Gun.Visible = v3
end
local v4 = tick()
while _G.Database == nil do
    task.wait()
    v1 = tick() - v4
    if 10 < v1 then
        warn("[KnifeLocal] Database failed to load after 10 seconds")
        break
    end
end
local ItemModule = require(game.ReplicatedStorage.Modules.ItemModule)
local function isVariantItem(p1) -- Line: 124
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
local function updateGunIconImage() -- Line: 135 -- upvalues: MainGUI (val), Parent (val), isVariantItem (val), ItemModule (val)
    if not _G.Database or not _G.Database.Item then
        return
    end
    local Game = MainGUI:FindFirstChild("Game")
    if not Game then
        return
    end
    local Gun = Game:FindFirstChild("Gun")
    if not Gun then
        return
    end
    local ImageLabel = Gun:FindFirstChild("ImageLabel")
    if not ImageLabel then
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
        ImageLabel.Image = ItemModule.GetImage(v2.Image)
    end
end
local function updateEquippedFrame(p1) -- Line: 211 -- upvalues: MainGUI (val)
    local Gun = MainGUI.Game:FindFirstChild("Gun")
    if Gun then
        local Equipped = Gun:FindFirstChild("Equipped")
        if Equipped then
            Equipped.Visible = p1
        end
    end
end
local function checkInitialWeaponState() -- Line: 222 -- upvalues: LocalPlayer (val), Parent (val), MainGUI (val), TouchEnabled (val), updateGunIconImage (val)
    LocalPlayer.Backpack:FindFirstChild(Parent.Name)
    local v1 = Parent.Parent == LocalPlayer.Character
    local Gun = MainGUI.Game:FindFirstChild("Gun")
    if Gun then
        local v2 = LocalPlayer.Backpack:FindFirstChild(Parent.Name)
        local v3 = Parent.Parent == LocalPlayer.Character
        local v4 = TouchEnabled
        if v4 then
            v4 = v3 or v2
        end
        Gun.Visible = v4
    end
    local Gun_2 = MainGUI.Game:FindFirstChild("Gun")
    if Gun_2 then
        local Equipped = Gun_2:FindFirstChild("Equipped")
        if Equipped then
            Equipped.Visible = v1
        end
    end
    updateGunIconImage()
end
Name = Parent.Name
LocalPlayer.Backpack:FindFirstChild(Name)
local v5 = Parent.Parent == LocalPlayer.Character
Gun_2 = MainGUI.Game:FindFirstChild("Gun")
if Gun_2 then
    local v6 = LocalPlayer.Backpack:FindFirstChild(Parent.Name)
    v2 = Parent.Parent == LocalPlayer.Character
    local v7 = TouchEnabled
    if v7 then
        v7 = v2 or v6
    end
    Gun_2.Visible = v7
end
local Gun_3 = MainGUI.Game:FindFirstChild("Gun")
if Gun_3 then
    Equipped = Gun_3:FindFirstChild("Equipped")
    if Equipped then
        Equipped.Visible = v5
    end
end
updateGunIconImage()
LocalPlayer.Backpack.ChildAdded:Connect(function(p1) -- Line: 240 -- upvalues: Parent (val), MainGUI (val), LocalPlayer (val), TouchEnabled (val), updateGunIconImage (val)
    if p1.Name == Parent.Name then
        local Gun = MainGUI.Game:FindFirstChild("Gun")
        if Gun then
            local v1 = LocalPlayer.Backpack:FindFirstChild(Parent.Name)
            local v2 = Parent.Parent == LocalPlayer.Character
            local v3 = TouchEnabled
            if v3 then
                v3 = v2 or v1
            end
            Gun.Visible = v3
        end
        updateGunIconImage()
        local Gun_2 = MainGUI.Game:FindFirstChild("Gun")
        if Gun_2 then
            local Equipped = Gun_2:FindFirstChild("Equipped")
            if Equipped then
                Equipped.Visible = false
            end
        end
    end
end)
LocalPlayer.Backpack.ChildRemoved:Connect(function(p1) -- Line: 247 -- upvalues: Parent (val), MainGUI (val), LocalPlayer (val), TouchEnabled (val)
    if p1.Name == Parent.Name then
        local Gun = MainGUI.Game:FindFirstChild("Gun")
        if Gun then
            local v1 = LocalPlayer.Backpack:FindFirstChild(Parent.Name)
            local v2 = Parent.Parent == LocalPlayer.Character
            local v3 = TouchEnabled
            if v3 then
                v3 = v2 or v1
            end
            Gun.Visible = v3
        end
        local Gun_2 = MainGUI.Game:FindFirstChild("Gun")
        if Gun_2 then
            local Equipped = Gun_2:FindFirstChild("Equipped")
            if Equipped then
                Equipped.Visible = true
            end
        end
    end
end)
Parent.Equipped:Connect(function() -- Line: 255 -- upvalues: MainGUI (val)
    local Gun = MainGUI.Game:FindFirstChild("Gun")
    if Gun then
        local Equipped = Gun:FindFirstChild("Equipped")
        if Equipped then
            Equipped.Visible = true
        end
    end
end)
Parent.Unequipped:Connect(function() -- Line: 259 -- upvalues: MainGUI (val)
    local Gun = MainGUI.Game:FindFirstChild("Gun")
    if Gun then
        local Equipped = Gun:FindFirstChild("Equipped")
        if Equipped then
            Equipped.Visible = false
        end
    end
end)
if TouchEnabled then
    local Gun_4 = MainGUI.Game:FindFirstChild("Gun")
    local Knife = MainGUI.Game:FindFirstChild("Knife")
    if Gun_4 then
        if Knife and Knife.Visible then
            Knife.Position = UDim2.new(Knife.Position.X.Scale, Knife.Position.X.Offset - 75, Knife.Position.Y.Scale, Knife.Position.Y.Offset)
        end
        MainGUI.Game.Gun.Visible = true
    end
end
updateGunIconImage()
if MainGUI.Game:FindFirstChild("Gun") then
    Gun = MainGUI.Game.Gun
    local ImageColor3 = Gun.ImageColor3
    Gun.MouseButton1Down:Connect(function() -- Line: 281 -- upvalues: Gun (val)
        Gun.ImageColor3 = Color3.new(1, 1, 1)
    end)
    Gun.MouseButton1Up:Connect(function() -- Line: 284 -- upvalues: Gun (val), ImageColor3 (val)
        Gun.ImageColor3 = ImageColor3
    end)
    Gun.MouseLeave:Connect(function() -- Line: 287 -- upvalues: Gun (val), ImageColor3 (val)
        Gun.ImageColor3 = ImageColor3
    end)
end
local function v_u_18(p1, p2, p3) -- Line: 292
    local v1, v2, v3, v4
    local v5 = p1 ~= nil
    assert(v5, "Parent is nil")
    local v6 = type(p2) == "string"
    assert(v6, "Name is not a string.")
    local v7 = p1:FindFirstChild(p2)
    local v8 = tick()
    local v9 = false
    v1, v2, v3 = p1, p2, p3
    while not v7 do
        if not v1 then
            break
        end
        task.wait()
        v7 = v1:FindFirstChild(v2)
        if not v9 then
            v4 = v8 + (v3 or 5)
            if v4 <= tick() then
                warn("Infinite yield possible for WaitForChild(" .. v1:GetFullName() .. ", " .. v2 .. ")")
                if v3 then
                    return v1:FindFirstChild(v2)
                end
                v9 = true
            end
        end
    end
    if not v1 then
        warn("Parent became nil.")
    end
    return v7
end
local function v8(p1, p2) -- Line: 316
    local v1 = type(p2) == "table"
    assert(v1, "Values is not a table")
    local v2 = next
    local v3 = p2
    local v4 = nil
    for k, v in v2, v3, v4 do
        if type(k) ~= "number" then
            p1[k] = v
        else
            v.Parent = p1
        end
    end
    return p1
end
local function v_u_30(p1) -- Line: 328 -- upvalues: Players (val)
    local v1 = p1
    if v1 then
        v1 = p1:IsA("Player")
    end
    if v1 then
        v1 = p1:IsDescendantOf(Players)
    end
    if not v1 then
        warn("[CheckCharacter] - Character Check failed!")
        return nil
    end
    local Character = p1.Character
    if not Character then
        return nil
    end
    local Parent = Character.Parent
    if Parent then
        Parent = Character:FindFirstChild("Humanoid")
        if Parent then
            Parent = Character:FindFirstChild("HumanoidRootPart")
            if Parent then
                Parent = Character:FindFirstChild("Head")
                if Parent then
                    Parent = Character.Humanoid:IsA("Humanoid")
                end
            end
        end
    end
    if Parent then
        local v2
        local v3 = Character.Head:IsA("BasePart")
        if v3 then
            v3 = Character.UpperTorso:IsA("BasePart")
        end
        if not v3 then
            v2 = v3
        else
            v2 = true
        end
        Parent = v2
    end
    return Parent
end
local u748 = v_u_18(Parent, "Handle")
v2 = v_u_18(Parent, "KnifeServer")
v_u_18(v2, "SlashStart")
local u752 = v_u_18(v2, "Lock")
local v9 = v_u_18(v2, "DestroyEvent")
local CustomHold = Parent:FindFirstChild("CustomHold")
if not CustomHold then
    u353 = nil
else
    Character = LocalPlayer.Character
    Humanoid = Character
    if Humanoid then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
    end
    Animator = Humanoid
    if Animator then
        Animator = Humanoid:FindFirstChildOfClass("Animator")
    end
    if not Animator then
        u353 = nil
    else
        u353 = Animator:LoadAnimation(CustomHold)
    end
end
local MakeMaid = require(v_u_18(Parent, "Maid")).MakeMaid
local u660 = {}
local u760 = {}
local v10 = {"Ting", "Gunshot", "Woosh", "Kill"}
for k, v in pairs(v10) do
    v3 = u748:FindFirstChild("Sound_" .. v)
    if not v3 then
        v3 = v_u_18(script, v):Clone()
        v3.Parent = u748
        v3.Name = "Sound_" .. v
    end
    u660[v] = v3
end
function u760.PlaySound(p1, p2) -- Line: 385 -- upvalues: u660 (val)
    if not (u660[p2]) then
        return
    end
    u660[p2]:Play()
end
local u388 = {}
local u389 = {
    "DownStab",
    "StabPunch",
    "Throw",
    "ThrowCharge",
    "Shoot",
    "Reload",
}
local u396 = {}
assert(coroutine.resume(coroutine.create(function() -- Line: 404 -- upvalues: v_u_30 (val), LocalPlayer (val), Parent (val), u389 (val), u396 (val), v_u_18 (val)
    while not (v_u_30(LocalPlayer)) do
        if not (Parent:IsDescendantOf(game)) then
            break
        end
        task.wait()
    end
    for k, v in pairs(u389) do
        u396[v] = LocalPlayer.Character.Humanoid:LoadAnimation(v_u_18(script, v))
    end
end)))
function u388.PlayAnimation(p1, p2) -- Line: 414 -- upvalues: u396 (val)
    if p2 == "Shoot" then
        if _G.DisableGunAnimations then
            return
        end
        if u396[p2] then
            u396[p2]:Play()
            return
        end
        warn("Could not find animation", p2)
        return
    end
    if p2 ~= "Reload" then
        if u396[p2] then
            u396[p2]:Play()
            return
        end
        warn("Could not find animation", p2)
        return
    end
    if _G.DisableGunAnimations then
        return
    end
    if u396[p2] then
        u396[p2]:Play()
        return
    end
    warn("Could not find animation", p2)
end
function u388.StopAnimation(p1, p2) -- Line: 426 -- upvalues: u396 (val)
    if u396[p2] then
        u396[p2]:Stop()
        return
    end
    warn("Could not find animation", p2)
end
local u414 = MakeMaid()
local LocalKnifeRender = workspace:FindFirstChild("LocalKnifeRender")
if not LocalKnifeRender then
    local v11 = {Name = "LocalKnifeRender", Parent = workspace, Archivable = false}
    local Camera = Instance.new("Camera")
    LocalKnifeRender = v8(Camera, v11)
end
for k2, i in pairs(LocalKnifeRender:GetChildren()) do
    i.Parent = nil
end
local u447 = {}
local u448 = 0
local u449 = nil
function u447.SetTransparency(p1, p2) -- Line: 450 -- upvalues: u449 (ref)
    if u449 then
        u449.Transparency = p2
    end
end
function u447.Enable(p1) -- Line: 456 -- upvalues: u448 (ref), u748 (val), LocalKnifeRender (ref), u449 (ref), v_u_30 (val), LocalPlayer (val), RunService (val)
    local u2 = u448 + 1
    u448 = u2
    assert(coroutine.resume(coroutine.create(function() -- Line: 462 -- upvalues: u748 (upval), LocalKnifeRender (upval), u449 (upval), u448 (upval), u2 (val), v_u_30 (upval), LocalPlayer (upval), RunService (upval)
        local v1, v2
        local v3 = u748:Clone()
        v3.Anchored = true
        v3.Parent = LocalKnifeRender
        v3.Transparency = 0
        u449 = v3
        while u448 == u2 do
            if v_u_30(LocalPlayer) then
                v2 = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 1.5, 0)
                v1 = v2 * CFrame.new(0, 0, 0.5)
                v1 = v1:ToObjectSpace(u748.CFrame)
                u748.Transparency = 1
                v3.CFrame = workspace.CurrentCamera.CFrame:ToWorldSpace(v1)
            end
            RunService.RenderStepped:Wait()
        end
        v3:Destroy()
        u449 = nil
        u748.Transparency = 0
    end)))
end
function u447.Disable(p1) -- Line: 483 -- upvalues: u448 (ref)
    u448 = u448 + 1
end
local u458 = false
local v12 = u748:WaitForChild("Gunshot"):Clone()
v12.Name = "Gunshot_Client"
v12.Parent = u748
local u468 = false
local WeaponEvents = game.ReplicatedStorage:WaitForChild("WeaponEvents")
local u486 = WeaponEvents:WaitForChild("GunBeam").OnClientEvent:Connect(function(p1, p2) -- Line: 498 -- upvalues: u468 (ref), u748 (val), Parent (val), u388 (val)
    if u468 and p1 == u748 then
        u468 = false
        local ismatrix = Parent:FindFirstChild("ismatrix")
        if ismatrix then
            ismatrix = Parent.ismatrix.Value
        end
        if not _G.RoundEnded then
            u388.PlayAnimation(nil, "Shoot")
            if not ismatrix then
                task.delay(0.1, function() -- Line: 512 -- upvalues: u388 (upval)
                    if not _G.RoundEnded then
                        u388.PlayAnimation(nil, "Reload")
                    end
                end)
            end
        end
    end
end)
local function v_u_85(p1, p2) -- Line: 521 -- upvalues: u458 (ref), Mouse (val), LocalPlayer (val), u468 (ref), ShootGun (val), Parent (val)
    local u167, v1, v2
    if _G.RoundEnded or u458 then
        return
    end
    u458 = true
    _G.LockTarget = nil
    local MouseLock = LocalPlayer.PlayerScripts:FindFirstChild("MouseLock")
    local Attribute = MouseLock
    if Attribute then
        Attribute = MouseLock:GetAttribute("Enabled")
    end
    local v3 = Mouse.X + math.random(-10, 10)
    local v4 = Mouse.Y + math.random(-10, 10)
    local Instance = nil
    local Position = nil
    if p1 then
        v2, v1 = p2, p1
    elseif p2 then
        v2, v1 = p2, p1
    else
        local v5, v6, v7
        local v8 = {game.Players.LocalPlayer.Character}
        if not Attribute then
            v5 = workspace.CurrentCamera:ScreenPointToRay(v3, v4)
            v6 = Ray.new(v5.Origin, v5.Direction * 900)
        else
            local CurrentCamera = workspace.CurrentCamera
            local ViewportSize = CurrentCamera.ViewportSize
            v5 = CurrentCamera:ViewportPointToRay(ViewportSize.X / 2, ViewportSize.Y / 2)
            v6 = Ray.new(v5.Origin, v5.Direction * 900)
        end
        local v9 = RaycastParams.new()
        v9.FilterDescendantsInstances = v8
        local v10 = workspace:Raycast(v6.Origin, v6.Direction, v9)
        if not v10 then
            Position = v6.Origin + v6.Direction * 900
            v2, v1 = p2, p1
        else
            Instance = v10.Instance
            Position = v10.Position
            v2, v1 = p2, p1
        end
        while Instance do
            table.insert(v8, Instance)
            v9.FilterDescendantsInstances = v8
            v7 = workspace:Raycast(v6.Origin, v6.Direction, v9)
            if not v7 then
                Instance = nil
            else
                Instance = v7.Instance
                Position = v7.Position
            end
            if Instance == nil then
                break
            end
            if Instance and Instance.Transparency ~= 1 then
                break
            end
            task.wait()
        end
    end
    if v2 then
        Position = v2
    elseif v1 ~= nil then
        Position = v1.Position or Position
    end
    u468 = true
    script.Parent.KnifeServer.SlashStart:FireServer(1, Position)
    coroutine.wrap(function() -- Line: 611 -- upvalues: ShootGun (upval), Position (ref)
        pcall(function() -- Line: 612 -- upvalues: ShootGun (upval), Position (upval)
            ShootGun:InvokeServer(1, Position, "AH2")
        end)
    end)()
    local ismatrix = Parent:FindFirstChild("ismatrix")
    if ismatrix then
        ismatrix = Parent.ismatrix.Value
    end
    if not ismatrix then
        u167 = 0.5
    else
        u167 = 0.1
    end
    task.spawn(function() -- Line: 620 -- upvalues: u167 (val), u458 (upval), u468 (upval)
        task.wait(u167)
        u458 = false
        u468 = false
    end)
end
local IsFirstPerson = _G.IsFirstPerson
local function v_u_103(p1) -- Line: 632 -- upvalues: LocalPlayer (val)
    local AbsolutePosition, AbsoluteSize, v1, v2, v3
    if type(p1) ~= "table" then
        v1 = p1
    else
        v1 = p1[1] or p1
    end
    local v4 = {}
    for k, v in pairs(LocalPlayer.PlayerGui.TouchGui.TouchControlFrame:GetChildren()) do
        if v.Visible then
            table.insert(v4, v)
        end
    end
    local Gun = LocalPlayer.PlayerGui.MainGUI.Game.Gun
    if Gun.Visible then
        table.insert(v4, Gun)
    end
    for k2, i in pairs(v4) do
        AbsoluteSize = i.AbsoluteSize
        AbsolutePosition = i.AbsolutePosition
        v2 = AbsolutePosition.X + math.abs(AbsoluteSize.X)
        v3 = AbsolutePosition.Y + math.abs(AbsoluteSize.Y)
        if AbsolutePosition.X <= v1.X and v1.X <= v2 and AbsolutePosition.Y <= v1.Y and v1.Y <= v3 then
            return nil
        end
    end
    return v1
end
local function v_u_106(p1) -- Line: 666 -- upvalues: MouseLock (val)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    if MouseLock:GetAttribute("Enabled") then
        return game.Workspace.CurrentCamera:ViewportPointToRay(ViewportSize.X / 2, ViewportSize.Y / 2)
    end
    return game.Workspace.CurrentCamera:ViewportPointToRay(p1.X, p1.Y)
end
local function v13(p1) -- Line: 675 -- upvalues: LocalPlayer (val)
    local CurrentCamera = workspace.CurrentCamera
    local MouseLock = LocalPlayer.PlayerScripts:FindFirstChild("MouseLock")
    if not MouseLock then
        return (CurrentCamera:ViewportPointToRay(p1.X, p1.Y))
    end
    if MouseLock:GetAttribute("Enabled") then
        return {Origin = CurrentCamera.CFrame.Position, Direction = CurrentCamera.CFrame.LookVector}
    end
    return (CurrentCamera:ViewportPointToRay(p1.X, p1.Y))
end
local function v_u_117(p1) -- Line: 692 -- upvalues: LocalPlayer (val), v_u_85 (val)
    local Instance, v1
    local v2 = RaycastParams.new()
    local v3 = {game.Players.LocalPlayer.Character}
    v2.FilterDescendantsInstances = v3
    v2.FilterType = Enum.RaycastFilterType.Exclude
    local v4 = false
    local Instance_2 = nil
    local Position = nil
    local v5 = p1
    while true do
        v1 = workspace:Raycast(v5.Origin, v5.Direction * 900, v2)
        if v1 == nil then
            v4 = true
        elseif v1.Instance ~= nil and v1.Instance then
            Instance = v1.Instance
            if not (Instance:IsA("BasePart")) then
                Instance_2 = v1.Instance
                Position = v1.Position
                v4 = true
            elseif Instance.Transparency == 1 then
                table.insert(v3, v1.Instance)
                v2.FilterDescendantsInstances = v3
            end
        end
        if v4 then
            break
        end
    end
    if not Instance_2 or not Instance_2.Parent or not Instance_2.Parent.Parent then
        return
    end
    local PlayerFromCharacter = game.Players:GetPlayerFromCharacter(Instance_2.Parent)
    if not PlayerFromCharacter then
        PlayerFromCharacter = game.Players:GetPlayerFromCharacter(Instance_2.Parent.Parent)
    end
    if not PlayerFromCharacter then
        v_u_85(nil, Position)
        return
    end
    if PlayerFromCharacter ~= LocalPlayer then
        v_u_85(PlayerFromCharacter.Character.HumanoidRootPart)
        return
    end
    v_u_85(nil, Position)
end
_G.LockTarget = nil
local UserInputService = game:GetService("UserInputService")
Parent.Equipped:Connect(function(p1) -- Line: 732 -- upvalues: IsFirstPerson (ref), u447 (val), u760 (val), u353 (ref), u414 (val), UserInputService (val), v_u_85 (val), TouchEnabled (val), v_u_117 (val), v_u_106 (val), v_u_103 (val), LocalPlayer (val)
    if IsFirstPerson then
        u447:Enable()
    end
    u760:PlaySound("Ting")
    if u353 ~= nil then
        u353:Play()
    end
    p1.Icon = "http://www.roblox.com/asset/?id=79658449"
    u414.GamepadShoot = UserInputService.InputBegan:Connect(function(p1, p2) -- Line: 744 -- upvalues: v_u_85 (upval)
        if p1.KeyCode == Enum.KeyCode.ButtonR2 then
            v_u_85()
        end
    end)
    if not TouchEnabled then
        u414.MouseButton1Down = p1.Button1Down:Connect(function() -- Line: 775 -- upvalues: v_u_85 (upval)
            v_u_85()
        end)
        return
    end
    u414.TouchTapInWorld = UserInputService.TouchTapInWorld:Connect(function(p1, p2) -- Line: 751 -- upvalues: v_u_117 (upval), v_u_106 (upval)
        if not p2 then
            v_u_117((v_u_106(p1)))
        end
    end)
    u414.TouchStarted = UserInputService.TouchStarted:Connect(function(p1, p2) -- Line: 757 -- upvalues: v_u_103 (upval), LocalPlayer (upval)
        if not p2 then
            task.wait()
            if v_u_103(p1.Position) then
                _G.LockTarget = nil
                LocalPlayer.PlayerGui.MainGUI.Game.Shoot.Visible = false
            end
        end
    end)
    u414.TouchEnded = UserInputService.TouchEnded:Connect(function() end)
end)
if TouchEnabled then
    local v14
    Unequipped = nil
    for k3, j in pairs(game.Workspace:GetChildren()) do
        if j:FindFirstChild("Humanoid") and j:FindFirstChild("UpperTorso") and j.Name ~= LocalPlayer.Name then
            v14 = script.Target:Clone()
            v14.Parent = j.UpperTorso
        end
    end
    LocalPlayer.PlayerGui.MainGUI.Game.Shoot.Activated:Connect(function() -- Line: 789 -- upvalues: v_u_85 (val)
        if _G.LockTarget then
            v_u_85(_G.LockTarget.HumanoidRootPart)
        end
    end)
    game:GetService("RunService").PreSimulation:Connect(function() -- Line: 795 -- upvalues: LocalPlayer (val), Unequipped (ref)
        local AbsoluteSize, Character, Position, UpperTorso, v1, v2, v3, v4, v5, v6, v7
        if not LocalPlayer.Character or not (LocalPlayer.Character:FindFirstChild("Head")) then
            return
        end
        Unequipped = nil
        for k, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character then
                Character = v.Character
                UpperTorso = Character:FindFirstChild("UpperTorso")
                if UpperTorso and UpperTorso:FindFirstChild("Target") then
                    UpperTorso.Target.Enabled = false
                    UpperTorso.Target.AlwaysOnTop = false
                    _, v7 = game.Workspace.CurrentCamera:WorldToScreenPoint(UpperTorso.Position)
                    if v7 then
                        Position = LocalPlayer.Character.Head.Position
                        v1 = Ray.new(Position, (UpperTorso.Position - Position).unit * 300)
                        v2 = game.Workspace:FindPartOnRay(v1, LocalPlayer.Character)
                        if v2 then
                            if v2.Parent == Character then
                                UpperTorso.Target.Enabled = true
                                UpperTorso.Target.AlwaysOnTop = true
                                AbsoluteSize = LocalPlayer.PlayerGui.MainGUI.AbsoluteSize
                                v3 = Vector2.new(AbsoluteSize.X / 2, AbsoluteSize.Y / 2)
                                v4 = game.Workspace.CurrentCamera:ScreenPointToRay(v3.X, v3.Y)
                                v5 = Ray.new(v4.Origin, v4.Direction * 900)
                                v6 = game.Workspace:FindPartOnRay(v5, game.Players.LocalPlayer.Character)
                                if not v6 then
                                    UpperTorso.Target.Icon.ImageColor3 = Color3.new(1, 0, 0)
                                elseif v6.Parent == Character then
                                    Unequipped = Character
                                    if not _G.LockTarget then
                                        UpperTorso.Target.Icon.ImageColor3 = Color3.new(1, 1, 1)
                                    else
                                        UpperTorso.Target.Icon.ImageColor3 = Color3.new(0, 1, 0)
                                    end
                                end
                                UpperTorso.Target.Icon.ImageTransparency = UpperTorso.Transparency
                            elseif v2.Parent.Parent ~= Character then
                            end
                        end
                    end
                end
            end
        end
    end)
end
Parent.Unequipped:Connect(function() -- Line: 842 -- upvalues: u760 (val), u353 (ref), u414 (val), u752 (val), u447 (val), u748 (val)
    u760:PlaySound("Ting")
    if u353 ~= nil then
        u353:Stop()
    end
    u414.MouseButton1Down = nil
    u414.MouseButton2Down = nil
    u414.MouseButton2Up = nil
    u414.TouchTap = nil
    u414.TouchTapInWorld = nil
    u414.TouchEnded = nil
    u414.GamepadShoot = nil
    u752:FireServer(nil)
    u447:Disable()
    if u748 and u748.Parent then
        u748.Transparency = 0
        for k, v in pairs(u748:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = 0
            end
        end
    end
end)
v9.OnClientEvent:Connect(function() -- Line: 867 -- upvalues: u447 (val), u748 (val)
    u447:Disable()
    if u748 and u748.Parent then
        u748.Transparency = 0
    end
end)
Unequipped = IsFirstPerson
game:GetService("RunService").Stepped:Connect(function() -- Line: 876 -- upvalues: IsFirstPerson (ref), Unequipped (ref), u447 (val)
    IsFirstPerson = _G.IsFirstPerson
    if not IsFirstPerson then
        if not IsFirstPerson and Unequipped then
            u447:Disable()
        end
    elseif not Unequipped then
        u447:Enable()
    elseif not IsFirstPerson and Unequipped then
        u447:Disable()
    end
    Unequipped = IsFirstPerson
end)
script.Destroying:Connect(function() -- Line: 887 -- upvalues: u486 (ref), u414 (val), u748 (val)
    if u486 then
        u486:Disconnect()
        u486 = nil
    end
    u414:DoCleaning()
    if u748 and u748.Parent then
        u748.Transparency = 0
    end
end)
