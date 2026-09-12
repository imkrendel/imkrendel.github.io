local cloneref = type(cloneref) == "function" and cloneref or function(o) return o end
local Players        = cloneref(game:GetService("Players"))
local RunService     = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Workspace      = cloneref(game:GetService("Workspace"))
local CoreGui        = cloneref(game:GetService("CoreGui"))
local HttpService   = cloneref(game:GetService("HttpService"))

local lp = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local DEFAULTS = {
    ESP_ENABLED          = false,
    ESP_KEYBIND          = "RightControl",
    HIGHLIGHT_ENABLED    = false,
    HIGHLIGHT_OUTLINE    = Color3.fromRGB(255, 50, 50),
    HIGHLIGHT_FILL       = Color3.fromRGB(255, 50, 50),
    HIGHLIGHT_FILL_TRANS = 0.8,
    HIGHLIGHT_OUT_TRANS  = 0,
    CLASSIC_BOX          = false,
    CLASSIC_TRACER       = false,
    CLASSIC_SKELETON     = false,
    CLASSIC_LABELS       = false,
    LABEL_TYPE           = "Nickname",
    WALL_CHECK           = false,
    TEAM_CHECK           = false,
    ESP_MAX_DISTANCE     = 1000,

    -- Aimbot
    AIM_ENABLED          = false,
    AIM_FOV_SIZE         = 150,
    AIM_FOV_TRANS        = 0.5,
    AIM_FOV_COLOR        = Color3.fromRGB(255, 255, 255),
    AIM_PART             = "Closest Part", -- "Closest Part" | "Head" | "Torso" | "HumanoidRootPart"
    AIM_SMOOTH           = 0.1,
    AIM_MODE             = "Mouse",
    AIM_KEYBIND          = "RightAlt",
    AIM_BIND_MODE        = "Hold",         -- "Hold" | "Toggle"
    AIM_WALL_CHECK       = true,
    AIM_TEAM_CHECK       = true,
    AIM_MIN_DIST         = 0,
    AIM_MAX_DIST         = 500,
    AIM_BLACKLIST        = {},
    AIM_WHITELIST        = {},
}

-- =====================================================
--  CONFIG SYSTEM
-- =====================================================
local CONFIG_PATH = "RX.LTD/RXCheat/Config.json"
local cfg = {}
getgenv().RXCheat_Config = cfg

do
    for k, v in pairs(DEFAULTS) do
        if type(v) == "table" then
            local t = {}
            for kk, vv in pairs(v) do t[kk] = vv end
            cfg[k] = t
        else
            cfg[k] = v
        end
    end
end

local function colorToTable(c)
    return {r = math.floor(c.R*255), g = math.floor(c.G*255), b = math.floor(c.B*255)}
end
local function tableToColor(t)
    return Color3.fromRGB(t.r or 255, t.g or 255, t.b or 255)
end

local function serializeCfg()
    local out = {}
    for k, v in pairs(cfg) do
        local def = DEFAULTS[k]
        local skip = false
        if type(v) == "table" and type(def) == "table" then
            local same = true
            for kk, vv in pairs(v) do if def[kk] ~= vv then same = false break end end
            for kk in pairs(def) do if v[kk] == nil then same = false break end end
            if same then skip = true end
        elseif v == def then
            skip = true
        end
        if not skip then
            if typeof and typeof(v) == "Color3" or (type(v) ~= "table" and pcall(function() return v.R end)) then
                out[k] = {__color = colorToTable(v)}
            else
                out[k] = v
            end
        end
    end
    return HttpService:JSONEncode(out)
end

local function loadCfg()
    local ok, data = pcall(function()
        if not isfolder("RX.LTD/RXCheat") then makefolder("RX.LTD/RXCheat") end
        if isfile(CONFIG_PATH) then
            return HttpService:JSONDecode(readfile(CONFIG_PATH))
        end
    end)
    if ok and type(data) == "table" then
        for k, v in pairs(data) do
            if type(v) == "table" and v.__color then
                cfg[k] = tableToColor(v.__color)
            else
                cfg[k] = v
            end
        end
    end
end

local function saveCfg()
    pcall(function()
        if getgenv().RX_AimBindElement then
            cfg.AIM_KEYBIND = getgenv().RX_AimBindElement.CurrentKeybind
        end
        if getgenv().RX_EspBindElement then
            cfg.ESP_KEYBIND = getgenv().RX_EspBindElement.CurrentKeybind
        end
        if not isfolder("RX.LTD") then makefolder("RX.LTD") end
        if not isfolder("RX.LTD/RXCheat") then makefolder("RX.LTD/RXCheat") end
        writefile(CONFIG_PATH, serializeCfg())
    end)
end

pcall(loadCfg)

-- =====================================================
--  HELPERS & CACHE
-- =====================================================
local highlightCache = {}
local classicCache = {}
local aimActive = false

local function getCharacter(player)
    return player ~= lp and player.Character
end

local function isEnemy(player)
    if not cfg.TEAM_CHECK then return true end
    return player.Team ~= lp.Team
end

local function worldToViewport(pos)
    local vp, vis = camera:WorldToViewportPoint(pos)
    return Vector2.new(vp.X, vp.Y), vis, vp.Z
end

local function isVisible(part)
    if not part then return false end
    local origin = camera.CFrame.Position
    local dir = (part.Position - origin)
    local ray = Ray.new(origin, dir)
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {lp.Character, camera, CoreGui})
    if not hit then return true end
    return hit:IsDescendantOf(part.Parent)
end

-- Динамическое определение абсолютно любых частей тела (Любые риги)
local function getResolvedPart(char, mode)
    if not char then return nil end
    
    if mode == "Closest Part" then
        local closestPart, minDelta = nil, math.huge
        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        
        -- Полный динамический скан всех BasePart хитбоксов в модели
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                local screenPos, vis = worldToViewport(obj.Position)
                if vis then
                    local delta = (screenPos - center).Magnitude
                    if delta < minDelta then
                        minDelta = delta
                        closestPart = obj
                    end
                end
            end
        end
        return closestPart or char:FindFirstChild("HumanoidRootPart")
    end
    
    if mode == "Head" then
        return char:FindFirstChild("Head") or char:FindFirstChildWhichIsA("BasePart")
    elseif mode == "Torso" then
        return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("LowerTorso") or char:FindFirstChildWhichIsA("BasePart")
    elseif mode == "HumanoidRootPart" then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
    end
    
    return char:FindFirstChildWhichIsA("BasePart")
end

-- =====================================================
--  ESP — Highlight Management
-- =====================================================
local function addHighlight(player)
    local char = getCharacter(player)
    if not char or highlightCache[char] then return end
    local hl = Instance.new("Highlight")
    hl.OutlineColor = cfg.HIGHLIGHT_OUTLINE
    hl.FillColor    = cfg.HIGHLIGHT_FILL
    hl.FillTransparency    = cfg.HIGHLIGHT_FILL_TRANS
    hl.OutlineTransparency = cfg.HIGHLIGHT_OUT_TRANS
    hl.Adornee = char
    hl.Parent  = CoreGui
    highlightCache[char] = hl
end

local function removeHighlight(char)
    if highlightCache[char] then
        highlightCache[char]:Destroy()
        highlightCache[char] = nil
    end
end

local function clearAllHighlights()
    for char, hl in pairs(highlightCache) do hl:Destroy() end
    highlightCache = {}
end

local function updateHighlightColors()
    for _, hl in pairs(highlightCache) do
        hl.OutlineColor = cfg.HIGHLIGHT_OUTLINE
        hl.FillColor    = cfg.HIGHLIGHT_FILL
        hl.FillTransparency    = cfg.HIGHLIGHT_FILL_TRANS
        hl.OutlineTransparency = cfg.HIGHLIGHT_OUT_TRANS
    end
end

-- =====================================================
--  ESP — Classic (Drawing API)
-- =====================================================
local function newDrawing(type_, props)
    local d = Drawing.new(type_)
    for k, v in pairs(props) do d[k] = v end
    return d
end

local function removeClassicESP(player)
    local cache = classicCache[player]
    if not cache then return end
    if cache.box then cache.box:Remove() end
    if cache.tracer then cache.tracer:Remove() end
    if cache.label then cache.label:Remove() end
    if cache.skeleton then for _, l in ipairs(cache.skeleton) do l:Remove() end end
    classicCache[player] = nil
end

local function clearAllClassic()
    for player in pairs(classicCache) do removeClassicESP(player) end
end

local R6_BONES = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},{"Torso","HumanoidRootPart"},
}

local function getCharBounds(char)
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
    if not root then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local height = hum and (hum.HipHeight * 2 + 1) or 5
    local topWorld = root.Position + Vector3.new(0, height * 0.6, 0)
    local botWorld = root.Position - Vector3.new(0, height * 0.5, 0)
    local top2D, visTop = worldToViewport(topWorld)
    local bot2D, visBot = worldToViewport(botWorld)
    if not visTop and not visBot then return nil end
    local h = math.abs(bot2D.Y - top2D.Y)
    local w = h * 0.5
    return {
        topLeft  = Vector2.new(top2D.X - w/2, top2D.Y),
        botRight = Vector2.new(top2D.X + w/2, bot2D.Y),
        center   = Vector2.new(top2D.X, top2D.Y),
        root2D   = bot2D,
    }
end

local function updateClassicESP(player)
    local char = getCharacter(player)
    if not char or not cfg.ESP_ENABLED or not isEnemy(player) then
        if classicCache[player] then removeClassicESP(player) end
        return
    end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local dist = (root.Position - camera.CFrame.Position).Magnitude
    if dist > cfg.ESP_MAX_DISTANCE or (cfg.WALL_CHECK and not isVisible(root)) then
        if classicCache[player] then removeClassicESP(player) end
        return
    end

    local bounds = getCharBounds(char)
    if not bounds then return end

    local color = cfg.HIGHLIGHT_OUTLINE

    if not classicCache[player] then
        classicCache[player] = {
            box      = newDrawing("Square", {Color=color, Thickness=1, Transparency=1, Filled=false, Visible=false}),
            tracer   = newDrawing("Line",   {Color=color, Thickness=1, Transparency=1, Visible=false}),
            label    = newDrawing("Text",   {Color=Color3.new(1,1,1), Size=14, Center=true, Outline=true, Visible=false, Font = Drawing.Fonts.UI}),
            skeleton = {},
        }
        for i = 1, #R6_BONES do
            classicCache[player].skeleton[i] = newDrawing("Line", {Color=color, Thickness=1, Transparency=1, Visible=false})
        end
    end

    local c = classicCache[player]
    local tl, br = bounds.topLeft, bounds.botRight

    c.box.Position, c.box.Size, c.box.Visible, c.box.Color = tl, br - tl, cfg.CLASSIC_BOX, color
    
    if cfg.CLASSIC_TRACER then
        local vp = camera.ViewportSize
        c.tracer.From, c.tracer.To, c.tracer.Visible, c.tracer.Color = Vector2.new(vp.X/2, vp.Y), bounds.root2D, true, color
    else
        c.tracer.Visible = false
    end

    if cfg.CLASSIC_LABELS then
        local name = cfg.LABEL_TYPE == "Username" and player.Name or player.DisplayName
        c.label.Text, c.label.Position, c.label.Visible = name .. " [" .. math.floor(dist) .. "]", bounds.center - Vector2.new(0, 16), true
    else
        c.label.Visible = false
    end

    if cfg.CLASSIC_SKELETON then
        for i, pair in ipairs(R6_BONES) do
            local p1, p2 = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
            local line = c.skeleton[i]
            if line and p1 and p2 then
                local a2, avis = worldToViewport(p1.Position)
                local b2, bvis = worldToViewport(p2.Position)
                line.From, line.To, line.Visible, line.Color = a2, b2, avis or bvis, color
            elseif line then
                line.Visible = false
            end
        end
    else
        for _, line in ipairs(c.skeleton) do line.Visible = false end
    end
end

-- =====================================================
--  AIMBOT MAIN LOGIC
-- =====================================================
local aimFovCircle = newDrawing("Circle", {
    Radius = cfg.AIM_FOV_SIZE,
    Color  = cfg.AIM_FOV_COLOR,
    Transparency = cfg.AIM_FOV_TRANS,
    Thickness = 1,
    Filled = false,
    Visible = false,
})

local function updateFovCircle()
    aimFovCircle.Radius = cfg.AIM_FOV_SIZE
    aimFovCircle.Color  = cfg.AIM_FOV_COLOR
    aimFovCircle.Transparency = cfg.AIM_FOV_TRANS
    local vp = camera.ViewportSize
    aimFovCircle.Position = Vector2.new(vp.X/2, vp.Y/2)
end

local function isBlacklisted(player) return cfg.AIM_BLACKLIST[tostring(player.UserId)] == true end
local function isWhitelisted(player)
    if next(cfg.AIM_WHITELIST) == nil then return true end
    return cfg.AIM_WHITELIST[tostring(player.UserId)] == true
end

local function getAimTarget()
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closest, bestPos = math.huge, nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player == lp or not isWhitelisted(player) or isBlacklisted(player) or (cfg.AIM_TEAM_CHECK and player.Team == lp.Team) then continue end

        local char = player.Character
        if not char then continue end
        
        local part = getResolvedPart(char, cfg.AIM_PART)
        local root = char:FindFirstChild("HumanoidRootPart")
        if not part or not root then continue end

        local dist = (root.Position - camera.CFrame.Position).Magnitude
        if dist < cfg.AIM_MIN_DIST or dist > cfg.AIM_MAX_DIST or (cfg.AIM_WALL_CHECK and not isVisible(part)) then continue end

        local screen2D, visible = worldToViewport(part.Position)
        if not visible then continue end

        local delta = (screen2D - center).Magnitude
        if delta < cfg.AIM_FOV_SIZE and delta < closest then
            closest, bestPos = delta, part.Position
        end
    end
    return bestPos
end

local function doAimbot()
    local targetPos = getAimTarget()
    if not targetPos then return end

    local smooth = math.clamp(cfg.AIM_SMOOTH, 0.01, 1)

    -- Стабильная фиксация горизонта (Убирает тряску и стрейч)
    if cfg.AIM_MODE == "Camera" or cfg.AIM_MODE == "Both" then
        local currentCamPos = camera.CFrame.Position
        local targetLook = CFrame.lookAt(currentCamPos, targetPos, Vector3.new(0, 1, 0))
        camera.CFrame = camera.CFrame:Lerp(targetLook, smooth)
    end

    -- Оптимизированный MouseMove с компенсацией фракционного округления
    if cfg.AIM_MODE == "Mouse" or cfg.AIM_MODE == "Both" then
        local screenPos, vis = worldToViewport(targetPos)
        if vis and type(mousemoverel) == "function" then
            local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            local delta = screenPos - center
            
            local moveX = delta.X * smooth
            local moveY = delta.Y * smooth
            
            -- Выталкиваем мышь из "мертвой зоны", предотвращая залипания
            if moveX > 0 and moveX < 1 then moveX = 1
            elseif moveX < 0 and moveX > -1 then moveX = -1 end
            
            if moveY > 0 and moveY < 1 then moveY = 1
            elseif moveY < 0 and moveY > -1 then moveY = -1 end
            
            mousemoverel(math.round(moveX), math.round(moveY))
        end
    end
end

-- =====================================================
--  DYNAMIC INPUT PROCESSING (UIS)
-- =====================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    -- Проверка бинда Аимбота из UI элемента напрямую
    local currentAimKey = getgenv().RX_AimBindElement and getgenv().RX_AimBindElement.CurrentKeybind
    if currentAimKey and input.KeyCode.Name == currentAimKey then
        if cfg.AIM_BIND_MODE == "Hold" then
            aimActive = true
        elseif cfg.AIM_BIND_MODE == "Toggle" then
            aimActive = not aimActive
        end
    end

    -- Проверка бинда ESP из UI элемента напрямую
    local currentEspKey = getgenv().RX_EspBindElement and getgenv().RX_EspBindElement.CurrentKeybind
    if currentEspKey and input.KeyCode.Name == currentEspKey then
        cfg.ESP_ENABLED = not cfg.ESP_ENABLED
        if not cfg.ESP_ENABLED then
            clearAllHighlights()
            clearAllClassic()
        end
        if getgenv().RX_EspToggleElement then
            getgenv().RX_EspToggleElement:Set(cfg.ESP_ENABLED)
        end
        saveCfg()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    local currentAimKey = getgenv().RX_AimBindElement and getgenv().RX_AimBindElement.CurrentKeybind
    if currentAimKey and input.KeyCode.Name == currentAimKey and cfg.AIM_BIND_MODE == "Hold" then
        aimActive = false
    end
end)

-- =====================================================
--  UI — Rayfield Initialization
-- =====================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RXCheat | OverㄨSoft.team",
    LoadingTitle = "RXCheat Hub",
    LoadingSubtitle = "by OverㄨSoft.team",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

-- =====================================================
--  TAB: ESP
-- =====================================================
local EspTab = Window:CreateTab("ESP", 4483345998)

getgenv().RX_EspToggleElement = EspTab:CreateToggle({
    Name = "ESP включён",
    CurrentValue = cfg.ESP_ENABLED,
    Flag = "ESP_Main",
    Callback = function(Value)
        cfg.ESP_ENABLED = Value
        if not Value then
            clearAllHighlights()
            clearAllClassic()
        end
        saveCfg()
    end,
})

getgenv().RX_EspBindElement = EspTab:CreateKeybind({
    Name = "Клавиша переключения ESP",
    CurrentKeybind = cfg.ESP_KEYBIND,
    HoldToInteract = false,
    Flag = "ESP_Bind_Flag",
    Callback = function() end, -- Логика полностью перенесена в чистый UIS loop
})

local EspSection = EspTab:CreateSection("Highlight")
EspTab:CreateToggle({ Name = "Highlight", CurrentValue = cfg.HIGHLIGHT_ENABLED, Flag = "HL_Enable", Callback = function(v) cfg.HIGHLIGHT_ENABLED = v; if not v then clearAllHighlights() end; saveCfg() end })
EspTab:CreateColorPicker({ Name = "Highlight — обводка", Color = cfg.HIGHLIGHT_OUTLINE, Flag = "HL_Outline", Callback = function(v) cfg.HIGHLIGHT_OUTLINE = v; updateHighlightColors(); saveCfg() end })
EspTab:CreateColorPicker({ Name = "Highlight — заливка", Color = cfg.HIGHLIGHT_FILL, Flag = "HL_Fill", Callback = function(v) cfg.HIGHLIGHT_FILL = v; updateHighlightColors(); saveCfg() end })
EspTab:CreateSlider({ Name = "Highlight — прозрачность заливки", Range = {0, 1}, Increment = 0.05, CurrentValue = cfg.HIGHLIGHT_FILL_TRANS, Flag = "HL_FillTrans", Callback = function(v) cfg.HIGHLIGHT_FILL_TRANS = v; updateHighlightColors(); saveCfg() end })

local ClassicSection = EspTab:CreateSection("Classic ESP")
EspTab:CreateToggle({ Name="Box", CurrentValue=cfg.CLASSIC_BOX, Flag="Box_Flag", Callback=function(v) cfg.CLASSIC_BOX=v; saveCfg() end })
EspTab:CreateToggle({ Name="Tracer", CurrentValue=cfg.CLASSIC_TRACER, Flag="Tracer_Flag", Callback=function(v) cfg.CLASSIC_TRACER=v; saveCfg() end })
EspTab:CreateToggle({ Name="Skeleton (R6)", CurrentValue=cfg.CLASSIC_SKELETON, Flag="Skeleton_Flag", Callback=function(v) cfg.CLASSIC_SKELETON=v; saveCfg() end })
EspTab:CreateToggle({ Name="Labels", CurrentValue=cfg.CLASSIC_LABELS, Flag="Labels_Flag", Callback=function(v) cfg.CLASSIC_LABELS=v; saveCfg() end })
EspTab:CreateDropdown({ Name = "Тип метки", Options = {"Nickname", "Username"}, CurrentOption = {cfg.LABEL_TYPE}, MultipleOptions = false, Flag = "LabelDropdown", Callback = function(o) cfg.LABEL_TYPE = o[1]; saveCfg() end })

local ChecksSection = EspTab:CreateSection("Checks & Distances")
EspTab:CreateToggle({ Name="Wall Check", CurrentValue=cfg.WALL_CHECK, Flag="WallCheck_Flag", Callback=function(v) cfg.WALL_CHECK=v; saveCfg() end })
EspTab:CreateToggle({ Name="Team Check", CurrentValue=cfg.TEAM_CHECK, Flag="TeamCheck_Flag", Callback=function(v) cfg.TEAM_CHECK=v; saveCfg() end })
EspTab:CreateSlider({ Name = "Макс. дистанция ESP", Range = {100, 5000}, Increment = 50, CurrentValue = cfg.ESP_MAX_DISTANCE, Flag = "EspDist", Callback = function(v) cfg.ESP_MAX_DISTANCE=v; saveCfg() end })

-- =====================================================
--  TAB: Aimbot
-- =====================================================
local AimTab = Window:CreateTab("Aimbot", 4483345998)

AimTab:CreateToggle({
    Name = "Aimbot включён",
    CurrentValue = cfg.AIM_ENABLED,
    Flag = "Aim_Main",
    Callback = function(Value)
        cfg.AIM_ENABLED = Value
        aimFovCircle.Visible = Value
        saveCfg()
    end,
})

local AimBindSection = AimTab:CreateSection("Keybind Settings")

getgenv().RX_AimBindElement = AimTab:CreateKeybind({
    Name = "Клавиша Аимбота",
    CurrentKeybind = cfg.AIM_KEYBIND,
    HoldToInteract = false,
    Flag = "AimBind",
    Callback = function() end, -- Логика полностью перенесена в чистый UIS loop
})

AimTab:CreateDropdown({
    Name = "Режим работы кнопки",
    Options = {"Hold", "Toggle"},
    CurrentOption = {cfg.AIM_BIND_MODE},
    MultipleOptions = false,
    Flag = "AimBindModeDropdown",
    Callback = function(Options)
        cfg.AIM_BIND_MODE = Options[1]
        aimActive = false
        saveCfg()
    end,
})

local FovSection = AimTab:CreateSection("FOV Settings")
AimTab:CreateSlider({ Name = "FOV размер", Range = {10, 600}, Increment = 5, CurrentValue = cfg.AIM_FOV_SIZE, Flag = "AimFovSize", Callback = function(v) cfg.AIM_FOV_SIZE=v; updateFovCircle(); saveCfg() end })
AimTab:CreateSlider({ Name = "FOV прозрачность", Range = {0, 1}, Increment = 0.05, CurrentValue = cfg.AIM_FOV_TRANS, Flag = "AimFovTrans", Callback = function(v) cfg.AIM_FOV_TRANS=v; updateFovCircle(); saveCfg() end })
AimTab:CreateColorPicker({ Name = "FOV цвет", Color = cfg.AIM_FOV_COLOR, Flag = "AimFovColor", Callback = function(v) cfg.AIM_FOV_COLOR=v; updateFovCircle(); saveCfg() end })

local AimLogicSection = AimTab:CreateSection("Aimbot Logic")

AimTab:CreateDropdown({
    Name = "Цель (Все типы ригов)",
    Options = {"Closest Part", "Head", "Torso", "HumanoidRootPart"},
    CurrentOption = {cfg.AIM_PART},
    MultipleOptions = false,
    Flag = "AimPartDropdown",
    Callback = function(Options) cfg.AIM_PART=Options[1]; saveCfg() end,
})

AimTab:CreateSlider({ Name = "Сила притяжения (Smooth)", Range = {0.01, 1}, Increment = 0.01, CurrentValue = cfg.AIM_SMOOTH, Flag = "AimSmooth", Callback = function(v) cfg.AIM_SMOOTH=v; saveCfg() end })
AimTab:CreateDropdown({ Name = "Режим аима", Options = {"Mouse", "Camera", "Both"}, CurrentOption = {cfg.AIM_MODE}, MultipleOptions = false, Flag = "AimModeDropdown", Callback = function(o) cfg.AIM_MODE=o[1]; saveCfg() end })
AimTab:CreateToggle({ Name="Wall Check", CurrentValue=cfg.AIM_WALL_CHECK, Flag="AimWall", Callback=function(v) cfg.AIM_WALL_CHECK=v; saveCfg() end })
AimTab:CreateToggle({ Name="Team Check", CurrentValue=cfg.AIM_TEAM_CHECK, Flag="AimTeam", Callback=function(v) cfg.AIM_TEAM_CHECK=v; saveCfg() end })
AimTab:CreateSlider({ Name="Макс. дистанция", Range={50, 5000}, Increment=50, CurrentValue=cfg.AIM_MAX_DIST, Flag="AimMax", Callback=function(v) cfg.AIM_MAX_DIST=v; saveCfg() end })
AimTab:CreateSlider({ Name="Мин. дистанция", Range={0, 500}, Increment=5, CurrentValue=cfg.AIM_MIN_DIST, Flag="AimMin", Callback=function(v) cfg.AIM_MIN_DIST=v; saveCfg() end })

-- =====================================================
--  TAB: CONFIG MANAGMENT
-- =====================================================
local CfgTab = Window:CreateTab("Config", 4483345998)
CfgTab:CreateButton({ Name = "Сохранить конфиг", Callback = function() saveCfg(); Rayfield:Notify({Title="Config", Content="Сохранено → "..CONFIG_PATH, Duration=3}) end })
CfgTab:CreateButton({ Name = "Загрузить конфиг", Callback = function() loadCfg(); Rayfield:Notify({Title="Config", Content="Загружено! Перезапусти хаб.", Duration=4}) end })

-- =====================================================
--  GAME LOOP & LIFECYCLE
-- =====================================================
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if cfg.ESP_ENABLED and cfg.HIGHLIGHT_ENABLED and isEnemy(player) then addHighlight(player) end
    end)
    player.CharacterRemoving:Connect(function(char) removeHighlight(char) end)
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= lp then onPlayerAdded(p) end end
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(player)
    if player.Character then removeHighlight(player.Character) end
    removeClassicESP(player)
end)

RunService.RenderStepped:Connect(function()
    if cfg.AIM_ENABLED then
        local vp = camera.ViewportSize
        aimFovCircle.Position = Vector2.new(vp.X/2, vp.Y/2)
        aimFovCircle.Visible  = true
    else
        aimFovCircle.Visible = false
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == lp then continue end

        if cfg.ESP_ENABLED and cfg.HIGHLIGHT_ENABLED and isEnemy(player) then
            local char = getCharacter(player)
            if char and not highlightCache[char] then addHighlight(player) end
        elseif not (cfg.ESP_ENABLED and cfg.HIGHLIGHT_ENABLED) then
            local char = player.Character
            if char and highlightCache[char] then removeHighlight(char) end
        end

        if cfg.ESP_ENABLED and cfg.HIGHLIGHT_ENABLED and cfg.WALL_CHECK then
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                local hl = highlightCache[char]
                if hl then hl.Enabled = root and isVisible(root) or false end
            end
        end

        if cfg.ESP_ENABLED and (cfg.CLASSIC_BOX or cfg.CLASSIC_TRACER or cfg.CLASSIC_SKELETON or cfg.CLASSIC_LABELS) then
            updateClassicESP(player)
        else
            if classicCache[player] then removeClassicESP(player) end
        end
    end

    if cfg.AIM_ENABLED and aimActive then doAimbot() end
end)

if lp then lp.Destroying:Connect(function() saveCfg() end) end
Rayfield:Notify({ Title = "Cheat", Content = "Хаб успешно запущен!", Duration = 3 })