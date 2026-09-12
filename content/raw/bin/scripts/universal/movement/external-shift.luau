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
    External Shift v1.1
    Developed by imkrendel | https://github.com/imkrendel
]]

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local enabled = false
local debounce = false

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Delete then
		if debounce then return end
		debounce = true
		enabled = not enabled
		if enabled then
			VIM:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
		else
			VIM:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
		end

		task.delay(0.2, function()
			debounce = false
		end)
	end
end)


--[[ v1.0 (not working)
local UserInputService = game:GetService("UserInputService")
local shiftHeld = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or input.KeyCode ~= Enum.KeyCode.Delete then return end
    shiftHeld = not shiftHeld
    if shiftHeld then
        keypress(0xA0)
    else
        keyrelease(0xA0)
    end
end)
]]