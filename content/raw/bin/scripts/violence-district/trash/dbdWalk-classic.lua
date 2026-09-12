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
-- Only for example

-- ================= SERVICES =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

-- ================= SETTINGS =================
local TURN_SMOOTH = 79   -- меньше = более инертно (DBD ~8–12)

-- ================= VARS =================
local smoothYaw = nil

-- ================= UTILS =================
local function getYaw(cf)
	local _, y, _ = cf:ToEulerAnglesYXZ()
	return y
end

local function lerpAngle(a, b, t)
	local diff = (b - a + math.pi) % (math.pi * 2) - math.pi
	return a + diff * t
end

-- ================= LOOP =================
RunService.RenderStepped:Connect(function(dt)
	if not root then return end

	local realYaw = getYaw(root.CFrame)

	if not smoothYaw then
		smoothYaw = realYaw
		return
	end

	-- плавно догоняем поворот, который сделал Roblox
	smoothYaw = lerpAngle(
		smoothYaw,
		realYaw,
		math.clamp(dt * TURN_SMOOTH, 0, 1)
	)

	-- применяем СГЛАЖЕННЫЙ yaw
	root.CFrame =
		CFrame.new(root.Position) *
		CFrame.Angles(0, smoothYaw, 0)
end)

-- ================= RESPAWN =================
player.CharacterAdded:Connect(function(c)
	char = c
	root = c:WaitForChild("HumanoidRootPart")
	smoothYaw = nil
end)
