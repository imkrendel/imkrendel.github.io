--[[ RCCs - RConsole Command Shortner | by S7 softworks | https://github.com/misterlerp/s7nc.softworks | License: S7M 1.0 ]]

local RCCs = {}
local _executor = (identifyexecutor and identifyexecutor())
               or (getexecutorname and getexecutorname())
               or "Universal"
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

local _DSIC = {"[\u{0400}-\u{04FF}]"}
local _aliases = {
    ["^%s*transfer%(%s*%)%s*$"] = function() return "RCCs.transfer()" end,
    ["^%s*title%((.-)%)%s*$"]   = function(a) return "RCCs.name("..a..")" end,
    ["^%s*print%((.-)%)%s*$"]   = function(a) return "RCCs.print("..a..")" end,
    ["^%s*warn%((.-)%)%s*$"]    = function(a) return "RCCs.warn("..a..")" end,
    ["^%s*clear%(%s*%)%s*$"]    = function() return "RCCs.clear()" end,
}

local function _preprocess(code)
    local lines = {}
    for line in (code .. "\n"):gmatch("([^\n]*)\n") do
        local replaced = false
        for pattern, fn in pairs(_aliases) do
            local cap = line:match(pattern)
            if cap then table.insert(lines, fn(cap)) replaced = true break end
        end
        if not replaced then table.insert(lines, line) end
    end
    return table.concat(lines, "\n")
end

function RCCs.transfer() _E.print("\n") end
function RCCs.print(...) _E.print(...) end
function RCCs.warn(...) _E.warn(...) end
function RCCs.name(...) _E.name(...) end
function RCCs.clear() _E.clear() end

function RCCs.Run(code, ctx)
    for _, p in ipairs(_DSIC) do if code:find(p)
        then 
            print("[RCCs] Blocked: Cyrillic")
        return 
    end 
end            

local processed = _preprocess(code)
local fn, err = loadstring(processed)
    if not fn then print("[RCCs] Error: "..tostring(err)) return end
        setfenv(fn, setmetatable(ctx or {}, {__index = getfenv()}))
    fn()
end
return RCCs