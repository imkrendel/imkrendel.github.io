local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- === НАСТРОЙКИ АНИМАЦИЙ ===
local ANIM_1_ID = "79155929355612"
local ANIM_2_ID = "75586690784894"

local KEY_ANIM_1 = Enum.KeyCode.X
local KEY_ANIM_2 = Enum.KeyCode.Z

-- === СОСТОЯНИЕ АНИМАЦИЙ ===
local anim1Playing = false
local anim2Playing = false

local humanoid
local animator
local track1
local track2

-- === СОЗДАНИЕ ТРЕКА С ПРИОРИТЕТОМ ALWAYS ON TOP ===
local function loadAnimation(animId)
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. animId
    local track = animator:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action
    return track
end

-- === БЛОКИРОВКА ДРУГИХ АНИМАЦИЙ ===
local function blockOtherAnimations(track)
    humanoid.AnimationPlayed:Connect(function(otherTrack)
        if (anim1Playing or anim2Playing) and otherTrack ~= track1 and otherTrack ~= track2 then
            otherTrack:Stop()
        end
    end)
end

-- === НАСТРОЙКА ПЕРСОНАЖА ===
local function setupCharacter(character)
    humanoid = character:WaitForChild("Humanoid")

    animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end

    track1 = loadAnimation(ANIM_1_ID)
    track2 = loadAnimation(ANIM_2_ID)

    blockOtherAnimations(track1)
    blockOtherAnimations(track2)

    -- Автоматический рестарт, если включено
    if anim1Playing then track1:Play() end
    if anim2Playing then track2:Play() end
end

-- === РЕСПАВН ===
if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    setupCharacter(char)
end)

-- === ТОГГЛЫ АНИМАЦИЙ ===
local function toggleAnim1()
    if not track1 then return end
    anim1Playing = not anim1Playing
    if anim1Playing then
        track1:Play()
        print("▶ Anim1 ON (блокируем другие анимации)")
    else
        track1:Stop()
        print("⏹ Anim1 OFF")
    end
end

local function toggleAnim2()
    if not track2 then return end
    anim2Playing = not anim2Playing
    if anim2Playing then
        track2:Play()
        print("▶ Anim2 ON (блокируем другие анимации)")
    else
        track2:Stop()
        print("⏹ Anim2 OFF")
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == KEY_ANIM_1 then
        toggleAnim1()
    elseif input.KeyCode == KEY_ANIM_2 then
        toggleAnim2()
    end
end)
