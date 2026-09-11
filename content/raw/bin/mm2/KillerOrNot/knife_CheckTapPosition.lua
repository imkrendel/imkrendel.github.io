local LocalPlayer = game.Players.LocalPlayer
return function(p1) -- Line: 2 -- upvalues: LocalPlayer (val)
    local AbsolutePosition, AbsoluteSize, v1
    if type(p1) ~= "table" then
        v1 = p1
    else
        v1 = p1[1]
    end
    local v2 = {}
    for k, v in pairs(LocalPlayer.PlayerGui:FindFirstChild("TouchGui").TouchControlFrame:GetChildren()) do
        if v.Visible then
            table.insert(v2, v)
        end
    end
    for k2, i in pairs(v2) do
        AbsoluteSize = i.AbsoluteSize
        AbsolutePosition = i.AbsolutePosition
        if AbsolutePosition.X <= v1.X and v1.X <= AbsolutePosition.X + math.abs(AbsoluteSize.X) and AbsolutePosition.Y <= v1.Y and v1.Y <= AbsolutePosition.Y + math.abs(AbsoluteSize.Y) then
            return nil
        end
    end
    return v1
end
