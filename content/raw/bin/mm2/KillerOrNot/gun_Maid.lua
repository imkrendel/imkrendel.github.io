local v1
local v2 = {}
local u2 = {
    GiveTask = function(p1, p2) -- Line: 4
        local v1 = #p1.Tasks + 1
        p1.Tasks[v1] = p2
        return v1
    end,
    DoCleaning = function(p1) -- Line: 9
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
    __index = function(p1, p2) -- Line: 22 -- upvalues: u2 (val)
        if u2[p2] then
            return u2[p2]
        end
        return p1.Tasks[p2]
    end,
    __newindex = function(p1, p2, p3) -- Line: 29
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
function v1() -- Line: 41 -- upvalues: u5 (val)
    local v1 = {Tasks = {}, Instances = {}}
    return (setmetatable(v1, u5))
end
v2.MakeMaid = v1
v2.makeMaid = v1
v2.new = v1
v2.New = v1
return v2
