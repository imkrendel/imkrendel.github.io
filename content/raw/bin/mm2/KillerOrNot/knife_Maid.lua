local v1 = {}
local u2 = {
    GiveTask = function(p1, p2) -- Line: 21
        local v1 = #p1.Tasks + 1
        p1.Tasks[v1] = p2
        return v1
    end,
    DoCleaning = function(p1) -- Line: 26
        local Tasks = p1.Tasks
        for k, v in pairs(Tasks) do
            if type(v) ~= "function" then
                v:disconnect()
            else
                v()
            end
            Tasks[k] = nil
        end
    end,
}
local u5 = {
    __index = function(p1, p2) -- Line: 41 -- upvalues: u2 (val)
        if u2[p2] then
            return u2[p2]
        end
        return p1.Tasks[p2]
    end,
    __newindex = function(p1, p2, p3) -- Line: 48
        local Tasks = p1.Tasks
        if p3 ~= nil then
            if Tasks[p2] then
                p1[p2] = nil
            end
        elseif type(Tasks[p2]) ~= "function" and Tasks[p2] then
            Tasks[p2]:disconnect()
        end
        Tasks[p2] = p3
    end,
}
local function MakeMaid() -- Line: 63 -- upvalues: u5 (val)
    local v1 = {Tasks = {}, Instances = {}}
    return (setmetatable(v1, u5))
end
v1.MakeMaid = MakeMaid
v1.makeMaid = MakeMaid
v1.new = MakeMaid
v1.New = MakeMaid
return v1