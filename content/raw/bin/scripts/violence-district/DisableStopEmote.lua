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
-- Author lixal | https://github.com/lixeal

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local DisableStopEmoteEnabled = false
local StopEmoteConnection = nil

local function ToggleDisableStopEmote(enabled)
	DisableStopEmoteEnabled = enabled

	if enabled then
		print("[DisableStopEmote] Ob")
		if StopEmoteConnection then StopEmoteConnection:Disconnect() end

		StopEmoteConnection = RunService.Heartbeat:Connect(function()
			if not DisableStopEmoteEnabled then return end
			local character = LocalPlayer.Character
			if not character then return end

			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if not humanoid then return end

			for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
				local name = track.Name:lower()
				if not (name:find("idle") or name:find("stun") or name:find("fall")) then
					if not track.IsPlaying then
						track:Play()
					end
					track.Looped = true
				end
			end
		end)
	else
		print("[DisableStopEmote] Off")
		if StopEmoteConnection then
			StopEmoteConnection:Disconnect()
			StopEmoteConnection = nil
		end

		local character = LocalPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
					local name = track.Name:lower()
					if not (name:find("idle") or name:find("stun") or name:find("fall")) then
						track:Stop()
						track.Looped = false
					end
				end
			end
		end
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.N then
		ToggleDisableStopEmote(not DisableStopEmoteEnabled)
	end
end)

-- Экспорт (если нужно вызвать откуда-то ещё)
_G.ToggleDisableStopEmote = ToggleDisableStopEmote
