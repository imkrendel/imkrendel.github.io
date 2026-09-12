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
    CLI Version by imkrendel
    Repack by imkrendel | https://github.com/imkrendel
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local runType = type or "gui"
local customSpeed = speed or 1

type = nil
speed = nil

if runType == "cli" then
	rconsoleprint(`[MoralesCLI] Cframe Speed activated. Speed: {customSpeed}`)
	
	RunService.RenderStepped:Connect(function()
		local character = LocalPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			
			if humanoid and rootPart and humanoid.Health > 0 then
				local moveDirection = humanoid.MoveDirection
				if moveDirection.Magnitude > 0 then
					rootPart.CFrame = rootPart.CFrame + moveDirection * (customSpeed / 10)
				end
			end
		end
	end)

else
	local Speed = customSpeed
	local SpeedEnabled = false
	local Dragging = false
	local DragStart, StartPos
	local ToggleDragging = false
	local ToggleDragStart, ToggleStartPos

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game.CoreGui

	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(0, 200, 0, 150)
	Frame.Position = UDim2.new(0.5, -100, 0.4, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = true
	Frame.Parent = ScreenGui

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Frame
	
	pcall(function()
		local TweenService = game:GetService("TweenService")
		TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
	end)

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, 0, 0, 30)
	Title.Text = "CFrame Speed"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.BackgroundTransparency = 1
	Title.Parent = Frame

	local SpeedBox = Instance.new("TextBox")
	SpeedBox.Size = UDim2.new(1, -20, 0, 30)
	SpeedBox.Position = UDim2.new(0, 10, 0, 40)
	SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	SpeedBox.Text = tostring(customSpeed)
	SpeedBox.Font = Enum.Font.Gotham
	SpeedBox.TextSize = 14
	SpeedBox.TextColor3 = Color3.new(1, 1, 1)
	SpeedBox.Parent = Frame

	local UICorner2 = UICorner:Clone()
	UICorner2.Parent = SpeedBox

	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Size = UDim2.new(1, -20, 0, 30)
	ToggleButton.Position = UDim2.new(0, 10, 0, 80)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	ToggleButton.Text = "Bật Speed"
	ToggleButton.Font = Enum.Font.Gotham
	ToggleButton.TextSize = 14
	ToggleButton.TextColor3 = Color3.new(1, 1, 1)
	ToggleButton.Parent = Frame

	local UICorner3 = UICorner:Clone()
	UICorner3.Parent = ToggleButton

	local ToggleGuiButton = Instance.new("TextButton")
	ToggleGuiButton.Size = UDim2.new(0, 100, 0, 30)
	ToggleGuiButton.Position = UDim2.new(0, 10, 0, 10)
	ToggleGuiButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	ToggleGuiButton.Text = "Hide"
	ToggleGuiButton.Font = Enum.Font.Gotham
	ToggleGuiButton.TextSize = 14
	ToggleGuiButton.TextColor3 = Color3.new(1, 1, 1)
	ToggleGuiButton.Active = true
	ToggleGuiButton.Draggable = true
	ToggleGuiButton.Parent = ScreenGui

	local UICorner4 = UICorner:Clone()
	UICorner4.Parent = ToggleGuiButton

	Frame.InputBegan:Connect(function(input) 
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
			Dragging = true 
			DragStart = input.Position 
			StartPos = Frame.Position 
			input.Changed:Connect(function() 
				if input.UserInputState == Enum.UserInputState.End then 
					Dragging = false 
				end 
			end) 
		end 
	end)

	Frame.InputChanged:Connect(function(input) 
		if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
			local Delta = input.Position - DragStart 
			Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y) 
		end 
	end)

	ToggleGuiButton.InputBegan:Connect(function(input) 
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
			ToggleDragging = true 
			ToggleDragStart = input.Position 
			ToggleStartPos = ToggleGuiButton.Position 
			input.Changed:Connect(function() 
				if input.UserInputState == Enum.UserInputState.End then 
					ToggleDragging = false 
				end 
			end) 
		end 
	end)

	ToggleGuiButton.InputChanged:Connect(function(input) 
		if ToggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
			local Delta = input.Position - ToggleDragStart 
			ToggleGuiButton.Position = UDim2.new(ToggleStartPos.X.Scale, ToggleStartPos.X.Offset + Delta.X, ToggleStartPos.Y.Scale, ToggleStartPos.Y.Offset + Delta.Y) 
		end 
	end)

	RunService.RenderStepped:Connect(function()
		if not SpeedEnabled then return end
		
		local character = LocalPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			
			if humanoid and rootPart and humanoid.Health > 0 then
				local moveDirection = humanoid.MoveDirection
				if moveDirection.Magnitude > 0 then
					rootPart.CFrame = rootPart.CFrame + moveDirection * (Speed / 10)
				end
			end
		end
	end)

	ToggleButton.MouseButton1Click:Connect(function() 
		SpeedEnabled = not SpeedEnabled 
		ToggleButton.Text = SpeedEnabled and "🟢" or "🔴" 
	end)

	SpeedBox.FocusLost:Connect(function(enterPressed) 
		if enterPressed then 
			local NewSpeed = tonumber(SpeedBox.Text) 
			if NewSpeed and NewSpeed > 0 then 
				Speed = NewSpeed 
			else 
				SpeedBox.Text = tostring(Speed) 
			end 
		end 
	end)

	local GuiVisible = true 
	ToggleGuiButton.MouseButton1Click:Connect(function() 
		GuiVisible = not GuiVisible 
		Frame.Visible = GuiVisible 
		ToggleGuiButton.Text = GuiVisible and "Hide" or "Show" 
	end)
end