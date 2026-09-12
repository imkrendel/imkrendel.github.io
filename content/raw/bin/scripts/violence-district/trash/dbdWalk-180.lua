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
local TURN_SMOOTH_NORMAL = 65
local TURN_SMOOTH_180 = 100
local TURN_TRIGGER = math.rad(170) -- почти 180
local RETURN_DELAY = 0.4          -- сколько держать 65 после разворота

-- ================= VARS =================
local smoothYaw
local lastRealYaw
local accumTurn = 0
local lowSmoothUntil = 0

-- ================= UTILS =================
local function getYaw(cf)
	local _, y, _ = cf:ToEulerAnglesYXZ()
	return y
end

local function angleDiff(a, b)
	return (b - a + math.pi) % (math.pi * 2) - math.pi
end

-- ================= LOOP =================
RunService.RenderStepped:Connect(function(dt)
	if not root then return end

	local now = os.clock()
	local realYaw = getYaw(root.CFrame)

	if not smoothYaw then
		smoothYaw = realYaw
		lastRealYaw = realYaw
		accumTurn = 0
		return
	end

	-- разница за кадр
	local diff = angleDiff(lastRealYaw, realYaw)
	lastRealYaw = realYaw

	-- накапливаем ОБЩИЙ поворот
	accumTurn += diff

	-- если суммарно провернули ~180° в любую сторону
	if math.abs(accumTurn) >= TURN_TRIGGER then
		lowSmoothUntil = now + RETURN_DELAY
		accumTurn = 0 -- сбрасываем, чтобы не триггерилось бесконечно
	end

	-- выбираем smoothing
	local smooth =
		(now < lowSmoothUntil)
		and TURN_SMOOTH_180
		or TURN_SMOOTH_NORMAL

	-- плавно догоняем
	smoothYaw += angleDiff(smoothYaw, realYaw) * math.clamp(dt * smooth, 0, 1)

	-- применяем
	root.CFrame =
		CFrame.new(root.Position) *
		CFrame.Angles(0, smoothYaw, 0)
end)

-- ================= RESPAWN =================
player.CharacterAdded:Connect(function(c)
	char = c
	root = c:WaitForChild("HumanoidRootPart")
	smoothYaw = nil
	lastRealYaw = nil
	accumTurn = 0
	lowSmoothUntil = 0
end)
