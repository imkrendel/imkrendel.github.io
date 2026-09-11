return function(p1, p2) -- Line: 1
    local v1 = p1:Clone()
    v1.Name = "ThrowingKnife"
    v1.Anchored = true
    v1.CanCollide = false
    v1.CanTouch = false
    v1.Transparency = 0
    for k, v in pairs(v1:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanTouch = false
        end
    end
    v1.CFrame = CFrame.new(p1.CFrame.p, p2.p)
    local v2 = Instance.new("Vector3Value", v1)
    v2.Name = "VelocityV"
    v1.Velocity = Vector3.new()
    v1.RotVelocity = Vector3.new()
    return v1
end