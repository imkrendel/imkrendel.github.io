-- ThreeLibrary | v1

local Library = loadstring(game:HttpGet("https://imkrendel.github.io/content/raw/library/ThreeLib/obf.luau"))()

local Window = Library:CreateWindow3D(
    "ThreeLibrary",
    "v1",
    nil, -- icon asset id
    Color3.fromRGB(135, 255, 135),
    {
        Mode = "3D",
        Persist = true,
        Folder = "ThreeLib",
        AlwaysOnTop = true,
    }
)

Window:SetToggleKey(Enum.KeyCode.RightShift)


local MainTab = Window:CreateTab("Main")
local Main = MainTab:CreateFrame("Dashboard")

Main:CreateSection("Welcome")

Main:CreateParagraph(
    "ThreeLib",
    "This example demonstrates the main elements, callbacks, flags, tooltips, configs and notifications."
)

local StatusLabel = Main:CreateLabel("Status: Ready")
    :SetTooltip("Shows the current state of the example.")

Main:CreateSeparator("Basic")

Main:CreateButton(
    "Test notification",
    "Shows a normal notification.",
    function()
        StatusLabel:Set("Status: Notification fired")
        Window:Notify(
            "Hello!",
            "The notification system is working.",
            nil,
            3
        )
    end
):SetTooltip("Click to test Window:Notify().")

local Enabled = Main:CreateToggle(
    "Enable feature",
    "Example boolean setting.",
    function(state)
        StatusLabel:Set("Status: Feature " .. (state and "enabled" or "disabled"))
    end,
    true
):SetTooltip("Example toggle.")
 :Flag("Enabled")

local Power = Main:CreateSlider(
    "Power",
    0,
    100,
    function(value)
        StatusLabel:Set("Status: Power = " .. value)
    end,
    50,
    0,
    "%"
):SetTooltip("Drag the slider or enter a value.")
 :Flag("Power")

Main:CreateSection("Inputs")

local NameBox = Main:CreateBox(
    "Enter your name...",
    "Default",
    function(text, enterPressed)
        if enterPressed then
            Window:Notify("Input", "Hello, " .. (text ~= "" and text or "unknown") .. "!", nil, 3)
        end
    end
):SetTooltip("Text input. Press Enter to trigger the callback.")
 :Flag("Name")

local ModeDropdown = Main:CreateDropdown(
    "Mode",
    {"Normal", "Fast", "Safe", "Extreme"},
    function(value)
        StatusLabel:Set("Status: Mode = " .. tostring(value))
    end,
    "Normal"
):SetTooltip("Select one mode.")
 :Flag("Mode")

local FeaturesDropdown = Main:CreateMultiDropdown(
    "Features",
    {"ESP", "Aimbot", "Speed", "Fly", "UI"},
    function(values)
        StatusLabel:Set("Status: " .. #values .. " feature(s) selected")
    end,
    {"ESP", "UI"}
):SetTooltip("Select multiple values.")
 :Flag("Features")

local Stepper = Main:CreateStepper(
    "Amount",
    0,
    100,
    5,
    function(value)
        StatusLabel:Set("Status: Amount = " .. value)
    end,
    25
):SetTooltip("Click < or >. Hold the button for repeated steps.")
 :Flag("Amount")

Main:CreateSection("Controls")

local Bind = Main:CreateBind(
    "Example keybind",
    Enum.KeyCode.F,
    function(active, keyName)
        StatusLabel:Set(
            "Status: " .. tostring(keyName) .. " = " .. (active and "ON" or "OFF")
        )
    end,
    function(keyName, mode)
        Window:Notify(
            "Keybind",
            tostring(keyName) .. " | " .. tostring(mode),
            nil,
            2
        )
    end,
    "Toggle"
):SetTooltip("Modes: Toggle, Hold and Always.")
 :Flag("ExampleBind")

local Accent = Main:CreateColorPicker(
    "Example color",
    function(color)
        Window:SetAccent(color)
    end,
    Color3.fromRGB(135, 255, 135)
):SetTooltip("Changes the window accent color.")
 :Flag("ExampleColor")

Main:CreateSection("Status")

local Progress = Main:CreateProgress(
    "Progress",
    0,
    100,
    65,
    function(value, alpha)
        return string.format("%d%%", value)
    end
):SetTooltip("Example progress bar.")
 :Flag("Progress")

Main:CreateButton(
    "Increase progress",
    "Adds 10 to the progress value.",
    function()
        Progress:Set(math.min(100, Progress:Get() + 10))
        StatusLabel:Set("Status: Progress = " .. Progress:Get())
    end
)

local AdvancedTab = Window:CreateTab("Advanced")
local Advanced = AdvancedTab:CreateFrame("Examples")

Advanced:CreateSection("Dynamic API")

local DynamicDropdown = Advanced:CreateDropdown(
    "Dynamic list",
    {"One", "Two", "Three"},
    function(value)
        Window:Notify("Dropdown", "Selected: " .. tostring(value), nil, 2)
    end,
    "One"
):SetTooltip("This list can be replaced at runtime.")

Advanced:CreateButton(
    "Change dropdown options",
    "Demonstrates :SetOptions().",
    function()
        DynamicDropdown:SetOptions({
            "Alpha",
            "Beta",
            "Gamma",
            "Delta",
            "Epsilon",
        })
        DynamicDropdown:Set("Gamma")
    end
)

local DynamicMulti = Advanced:CreateMultiDropdown(
    "Dynamic multi",
    {"A", "B", "C"},
    function(values)
        print("Selected:", table.concat(values, ", "))
    end,
    {"A"}
)

Advanced:CreateButton(
    "Change multi options",
    "Demonstrates MultiDropdown:SetOptions().",
    function()
        DynamicMulti:SetOptions({
            "Red",
            "Green",
            "Blue",
            "White",
            "Black",
        })
        DynamicMulti:Set({"Green", "Blue"})
    end
)

Advanced:CreateButton(
    "Show confirmation",
    "Demonstrates a notification callback.",
    function()
        Window:Notify(
            "Confirmation",
            "Do you want to continue?",
            function(result)
                Window:Notify(
                    "Result",
                    result and "You selected Yes." or "You selected No.",
                    nil,
                    2
                )
            end,
            8
        )
    end
)

Advanced:CreateSeparator("Config flags")

Advanced:CreateParagraph(
    "Flags",
    "Elements marked with :Flag() are included in SaveConfig/LoadConfig."
)

Advanced:CreateButton(
    "Save demo config",
    "Saves the current flagged values as Example.",
    function()
        if Window:SaveConfig("Example") then
            Window:Notify("Config", "Saved: Example", nil, 3)
        else
            Window:Notify("Config", "writefile is unavailable.", nil, 3)
        end
    end
)

Advanced:CreateButton(
    "Load demo config",
    "Loads the Example config.",
    function()
        if Window:LoadConfig("Example") then
            Window:Notify("Config", "Loaded: Example", nil, 3)
        else
            Window:Notify("Config", "Config not found.", nil, 3)
        end
    end
)

Advanced:CreateButton(
    "Delete demo config",
    "Deletes the Example config.",
    function()
        if Window:DeleteConfig("Example") then
            Window:Notify("Config", "Deleted: Example", nil, 3)
        else
            Window:Notify("Config", "Delete unavailable or config missing.", nil, 3)
        end
    end
)

Window:Notify(
    "ThreeLibrary",
    "Loaded",
    nil,
    4
)
