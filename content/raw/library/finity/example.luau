local Library = loadstring(game:HttpGet("https://imkrendel.github.io/content/raw/library/finity/source.luau"))()

local Window, WindowData = Library.new(true, "Example Hub")
Window.ChangeToggleKey(Enum.KeyCode.RightControl)
Library.settitle("Example Hub — Loaded")

local MainTab = Window:Category("Main")

-- Sector inside the category (acts like a grouped section)
local VisualsSector = MainTab:Sector("Visuals")

-- Checkbox / Toggle
local espToggle = VisualsSector:Cheat("checkbox", "ESP Enabled", function(value)
    print("ESP Enabled:", value)
end, { enabled = false })

-- Slider
local fovSlider = VisualsSector:Cheat("slider", "FOV Circle Size", function(value)
    print("FOV Size:", value)
end, { min = 0, max = 360, default = 90, suffix = "°", precise = true })

-- Colorpicker
local espColor = VisualsSector:Cheat("color", "ESP Color", function(value)
    print("ESP Color changed to:", value)
end, { color = Color3.fromRGB(255, 0, 0) })

-- Second sector in the same category
local MovementSector = MainTab:Sector("Movement")

-- Dropdown
local speedMode = MovementSector:Cheat("dropdown", "Speed Mode", function(value)
    print("Speed Mode:", value)
end, { options = { "Normal", "Fast", "Fastest" }, default = "Normal" })

-- Textbox
local speedValue = MovementSector:Cheat("textbox", "Custom Speed Value", function(value)
    print("Custom Speed:", value)
end, { placeholder = "e.g. 32" })

-- Button
local resetButton = MovementSector:Cheat("button", "Reset Movement", function()
    print("Movement values reset!")
end, { text = "Reset" })

-- Keybind
local flyBind = MovementSector:Cheat("keybind", "Fly Keybind", function(key)
    print("Fly key event:", key)
end, { bind = Enum.KeyCode.F })

-- Settings
local SettingsTab = Window:Category("Settings")
local GeneralSector = SettingsTab:Sector("General")

local autoSave = GeneralSector:Cheat("checkbox", "Auto Save Config", function(value)
    print("Auto Save:", value)
end)

local uiScale = GeneralSector:Cheat("slider", "UI Transparency", function(value)
    print("Transparency:", value)
end, { min = 0, max = 1, default = 0.2 })

-- Programmatically updating elements via :SetValue / :Fire
task.wait(2)

-- Force-set a dropdown value
speedMode:SetValue("Fast")

-- Force-set a keybind value
flyBind:SetValue(Enum.KeyCode.G)

-- Add/remove dropdown options dynamically
speedMode:AddOption("Ludicrous")
speedMode:RemoveOption("Normal")

-- Fire a button callback manually
resetButton:Fire()

-- Force-set the colorpicker
espColor:SetValue(Color3.fromRGB(0, 255, 0))