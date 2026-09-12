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
    RCCs v1.1.0
    Developed by imkrendel | https://github.com/imkrendel
]]
local RCCs = {Scripts = {}}
local _executor = (identifyexecutor and identifyexecutor())    or (getexecutorname and getexecutorname())    or "Universal"

local _cmds = {
    Solara = {
        print   = rconsoleprint,
        warn    = rconsolewarn,
        error   = rconsoleerr,
        info    = rconsoleinfo,
        destroy = rconsoledestroy,
        name    = rconsolename,
        input   = rconsoleinput,
        clear   = rconsoleclear,
    },
    Madium = {
        print   = rconsoleprint,
        warn    = rconsolewarn,
        error   = rconsoleerr,
        info    = rconsoleinfo,
        destroy = rconsoledestroy,
        name    = rconsolename,
        input   = rconsoleinput,
        clear   = rconsoleclear,
    },
}

_cmds.Universal = _cmds.Solara
local _E = _cmds[_executor] or _cmds.Universal

local _DSIC = {    "[\u{0400}-\u{04FF}]",}

local function _dsic_check(code)
    for _, pattern in ipairs(_DSIC) do
        if code:find(pattern) then
            return false, pattern
        end
    end
    return true
end

local _aliases = {
    ["^%s*wait%((.-)%)%s*$"]    = function(a) return "task.wait(" .. a .. ")"   end,
    ["^%s*transfer%(%s*%)%s*$"] = function() return "RCCs.transfer()"           end,
    ["^%s*title%((.-)%)%s*$"]   = function(a) return "RCCs.name("  .. a .. ")"  end,
    ["^%s*print%((.-)%)%s*$"]   = function(a) return "RCCs.print(" .. a .. ")"  end,
    ["^%s*warn%((.-)%)%s*$"]    = function(a) return "RCCs.warn("  .. a .. ")"  end,
    ["^%s*info%((.-)%)%s*$"]    = function(a) return "RCCs.info("  .. a .. ")"  end,
    ["^%s*error%((.-)%)%s*$"]   = function(a) return "RCCs.error(" .. a .. ")"  end,
    ["^%s*destroy%(%s*%)%s*$"]  = function()  return "RCCs.destroy()"           end,
    ["^%s*clear%(%s*%)%s*$"]    = function()  return "RCCs.clear()"             end,
}

local function _preprocess(code)
    local lines = {}
    for line in (code .. "\n"):gmatch("([^\n]*)\n") do
        local replaced = false
        for pattern, fn in pairs(_aliases) do
            local cap = line:match(pattern)
            if cap ~= nil then
                table.insert(lines, fn(cap))
                replaced = true
                break
            end
        end
        if not replaced then
            table.insert(lines, line)
        end
    end
    return table.concat(lines, "\n")
end

local function _run(code, ctx)
    local ok, reason = _dsic_check(code)
    if not ok then
        print("[RCCs] DSIC blocked: " .. reason)
        return
    end
    local processed = _preprocess(code)
    local env = setmetatable(ctx or {}, { __index = getfenv() })
    env.RCCs = RCCs
    env.wait = task.wait

    local fn, err = loadstring(processed)
    if not fn then
        print("[RCCs] Parse error: " .. tostring(err))
        return
    end
    setfenv(fn, env)
    fn()
end
function RCCs.transfer()     _E.print("\n") end
function RCCs.print(...)     _E.print(...)  end
function RCCs.warn(...)      _E.warn(...)   end
function RCCs.error(...)     _E.error(...)  end
function RCCs.info(...)      _E.info(...)   end
function RCCs.destroy(...)   _E.destroy(...) end
function RCCs.name(...)      _E.name(...)   end
function RCCs.input(...)     _E.input(...)  end
function RCCs.clear(...)     _E.clear(...)  end
function RCCs.Run(code, ctx) _run(code, ctx) end
function RCCs.Mode(name)
    if _cmds[name] then
        _E = _cmds[name]
        print("[RCCs] Mode set to: " .. name)
    else
        warn("[RCCs] Mode '" .. tostring(name) .. "' not found!")
    end
end

function RCCs.Auto(code, ctx)
    local _prev = _E
    _E = _cmds[_executor] or _cmds.Universal
    _run(code, ctx)
    _E = _prev
end

setmetatable(RCCs, {
    __index = function(t, key)
        local target = _cmds[key]
        if not target then return rawget(t, key) end
        
        local api = {}
        setmetatable(api, {
            __call = function(_, code, ctx)
                local _prev = _E
                _E = target
                _run(code, ctx)
                _E = _prev
            end
        })
        api.Run = function(name, ctx)
            local code = RCCs.Scripts[name]
            if not code then
                target.warn("[RCCs] '" .. tostring(name) .. "' not found in RCCs.Scripts")
                return
            end
            local _prev = _E
            _E = target
            _run(code, ctx)
            _E = _prev
        end
        
        return api
    end
})

return RCCs