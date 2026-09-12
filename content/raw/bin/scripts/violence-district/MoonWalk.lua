--     SSSSSSSSSSSSSSS YYYYYYY       YYYYYYYNNNNNNNN        NNNNNNNNIIIIIIIIIITTTTTTTTTTTTTTTTTTTTTTTYYYYYYY       YYYYYYY
--   SS:::::::::::::::SY:::::Y       Y:::::YN:::::::N       N::::::NI::::::::IT:::::::::::::::::::::TY:::::Y       Y:::::Y
--  S:::::SSSSSS::::::SY:::::Y       Y:::::YN::::::::N      N::::::NI::::::::IT:::::::::::::::::::::TY:::::Y       Y:::::Y
--  S:::::S     SSSSSSSY::::::Y     Y::::::YN:::::::::N     N::::::NII::::::IIT:::::TT:::::::TT:::::TY::::::Y     Y::::::Y
--  S:::::S            YYY:::::Y   Y:::::YYYN::::::::::N    N::::::N  I::::I  TTTTTT  T:::::T  TTTTTTYYY:::::Y   Y:::::YYY
--  S:::::S               Y:::::Y Y:::::Y   N:::::::::::N   N::::::N  I::::I          T:::::T           Y:::::Y Y:::::Y   
--   S::::SSSS             Y:::::Y:::::Y    N:::::::N::::N  N::::::N  I::::I          T:::::T            Y:::::Y:::::Y    
--    SS::::::SSSSS         Y:::::::::Y     N::::::N N::::N N::::::N  I::::I          T:::::T             Y:::::::::Y     
--      SSS::::::::SS        Y:::::::Y      N::::::N  N::::N:::::::N  I::::I          T:::::T              Y:::::::Y      
--        SSSSSS::::S        Y:::::Y       N::::::N   N:::::::::::N  I::::I          T:::::T               Y:::::Y       
--              S:::::S       Y:::::Y       N::::::N    N::::::::::N  I::::I          T:::::T               Y:::::Y       
--              S:::::S       Y:::::Y       N::::::N     N:::::::::N  I::::I          T:::::T               Y:::::Y       
--  SSSSSSS     S:::::S       Y:::::Y       N::::::N      N::::::::NII::::::II      TT:::::::TT             Y:::::Y       
-- S::::::SSSSSS:::::S    YYYY:::::YYYY    N::::::N       N:::::::NI::::::::I      T:::::::::T          YYYY:::::YYYY    
-- S:::::::::::::::SS     Y:::::::::::Y    N::::::N        N::::::NI::::::::I      T:::::::::T          Y:::::::::::Y    
--  SSSSSSSSSSSSSSS       YYYYYYYYYYYYY    NNNNNNNN         NNNNNNNIIIIIIIIII      TTTTTTTTTTT          YYYYYYYYYYYYY    

-- Created by lixeal | sunity community
-- Author - lixeal | https://github.com/lixeal/

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local PlayerGui = player:WaitForChild("PlayerGui")

local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local ALLOWED_TEAMS = {
	["Survivor's"] = true,
	["Survivors"] = true,   
	["Spectator"] = true,
}

local function teamAllowed()
	if not player.Team then return false end
	return ALLOWED_TEAMS[player.Team.Name] == true
end


local gui = Instance.new("ScreenGui")
gui.Name = "DBD_Controller"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local btnV = Instance.new("TextButton")
btnV.Size = UDim2.new(0,45,0,45)
btnV.Position = UDim2.new(1,-70,1,-95)
btnV.BackgroundColor3 = Color3.fromRGB(40,40,40)
btnV.Text = "V"
btnV.TextColor3 = Color3.new(1,1,1)
btnV.TextScaled = true
btnV.Parent = gui

local btnR = Instance.new("TextButton")
btnR.Size = UDim2.new(0,45,0,45)
btnR.Position = UDim2.new(1,-70,1,-160)
btnR.BackgroundColor3 = Color3.fromRGB(40,40,40)
btnR.Text = "R"
btnR.TextColor3 = Color3.new(1,1,1)
btnR.TextScaled = true
btnR.Parent = gui

local modeV, modeR = false, false
local turnActive = false
local turnTimer = 0
local TURN1_TIME = 0.18

local yawStart, yawTarget, yawCore = 0, 0, 0
local yawSide, swayVelocity = 0, 0

local SWAY_MAX = 65
local SWAY_ACCEL = 600
local SWAY_FRICTION = 15
local SWAY_INERTIA = 0.85

local pressL, pressR = false, false

local function chatFocused()
	if UIS:GetFocusedTextBox() then return true end

	local expChat = CoreGui:FindFirstChild("ExperienceChat")
	if expChat then
		for _,v in pairs(expChat:GetDescendants()) do
			if v:IsA("TextBox") and v:IsFocused() then
				return true
			end
		end
	end

	local oldChat = PlayerGui:FindFirstChild("Chat")
	if oldChat then
		for _,v in pairs(oldChat:GetDescendants()) do
			if v:IsA("TextBox") and v:IsFocused() then
				return true
			end
		end
	end

	return false
end

local function getYaw(cf)
	local _,y,_ = cf:ToEulerAnglesYXZ()
	return math.deg(y)
end

local function setYaw(cf, yaw)
	return CFrame.new(cf.Position) * CFrame.Angles(0, math.rad(yaw), 0)
end

local function camYaw()
	local v = workspace.CurrentCamera.CFrame.LookVector
	return math.deg(math.atan2(v.X, v.Z))
end

local function normalize(a)
	return (a + 180) % 360 - 180
end

local function updateButtons()
	if not teamAllowed() then
		btnV.BackgroundColor3 = Color3.fromRGB(20,20,20)
		btnR.BackgroundColor3 = Color3.fromRGB(20,20,20)
		return
	end

	btnV.BackgroundColor3 = modeV and Color3.fromRGB(0,160,255) or Color3.fromRGB(40,40,40)
	btnR.BackgroundColor3 = modeR and Color3.fromRGB(0,160,255) or Color3.fromRGB(40,40,40)
end

local function startTurn(dir)
	if not teamAllowed() then return end

	yawSide = 0
	swayVelocity = 0
	turnActive = true
	turnTimer = 0

	yawStart = getYaw(root.CFrame)
	yawTarget = (dir == 1) and camYaw() or camYaw() + 180
	yawTarget = yawStart + normalize(yawTarget - yawStart)
end

btnV.MouseButton1Click:Connect(function()
	if not teamAllowed() then return end

	modeV = not modeV
	modeR = false
	updateButtons()
	humanoid.AutoRotate = not modeV
	if modeV then startTurn(1) end
end)

btnR.MouseButton1Click:Connect(function()
	if not teamAllowed() then return end

	modeR = not modeR
	modeV = false
	updateButtons()
	humanoid.AutoRotate = not modeR
	if modeR then startTurn(-1) end
end)

UIS.InputBegan:Connect(function(i, gpe)
	if gpe or chatFocused() or not teamAllowed() then return end

	if i.KeyCode == Enum.KeyCode.A then pressL = true end
	if i.KeyCode == Enum.KeyCode.D then pressR = true end

	if i.KeyCode == Enum.KeyCode.V then
		modeV = not modeV
		modeR = false
		updateButtons()
		humanoid.AutoRotate = not modeV
		if modeV then startTurn(1) end
	end

	if i.KeyCode == Enum.KeyCode.R then
		modeR = not modeR
		modeV = false
		updateButtons()
		humanoid.AutoRotate = not modeR
		if modeR then startTurn(-1) end
	end
end)

UIS.InputEnded:Connect(function(i)
	if chatFocused() or not teamAllowed() then return end
	if i.KeyCode == Enum.KeyCode.A then pressL = false end
	if i.KeyCode == Enum.KeyCode.D then pressR = false end
end)

RunService.RenderStepped:Connect(function(dt)
	if not teamAllowed() then return end
	if not (modeV or modeR) then return end

	if turnActive then
		turnTimer += dt
		local t = math.clamp(turnTimer / TURN1_TIME, 0, 1)
		local s = t*t*(3-2*t)
		yawCore = yawStart + normalize(yawTarget - yawStart) * s
		if t >= 1 then turnActive = false end
	end

	local input = (pressR and 1 or 0) + (pressL and -1 or 0)

	if input == 0 then
		swayVelocity *= 0.65
		yawSide *= 0.75
	else
		swayVelocity = swayVelocity * SWAY_INERTIA + input * SWAY_ACCEL * dt
	end

	swayVelocity -= swayVelocity * SWAY_FRICTION * dt
	yawSide += swayVelocity * dt * 60
	yawSide = math.clamp(yawSide, -SWAY_MAX, SWAY_MAX)

	root.CFrame = setYaw(root.CFrame, yawCore + yawSide)
end)

player:GetPropertyChangedSignal("Team"):Connect(function()
	modeV, modeR = false, false
	pressL, pressR = false, false
	humanoid.AutoRotate = true
	updateButtons()
end)

player.CharacterAdded:Connect(function(new)
	char = new
	humanoid = new:WaitForChild("Humanoid")
	root = new:WaitForChild("HumanoidRootPart")
end)
