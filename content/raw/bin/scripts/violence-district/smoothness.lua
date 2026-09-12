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

-- Repacked by lixal | sunity community
-- Author - lixeal | https://github.com/lixeal
--       Delete this shit 

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

local smoothness = 0.005 
local followCamera = true

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.L then
        followCamera = not followCamera
        print("Camera follow:", followCamera and "ON" or "OFF")
    end
end)

RunService.RenderStepped:Connect(function()
    if not character or not rootPart or not humanoid then return end
  
    local velocity = rootPart.Velocity
    local moveSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    
    if moveSpeed > 1 and followCamera then
        local lookVector = camera.CFrame.LookVector
        local targetDirection = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        
        local targetCFrame = CFrame.new(rootPart.Position, rootPart.Position + targetDirection)
        
        rootPart.CFrame = rootPart.CFrame:Lerp(targetCFrame, smoothness)
    end
end)

print("=== EXTREME Smooth walking loaded ===")
print("L - Toggle camera follow ON/OFF")
