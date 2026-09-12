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
    RCCs v1.0.1
    Developed by imkrendel | https://github.com/imkrendel
]]

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

local _aliases = {
    ["^%s*transfer%(%s*%)%s*$"] = function() return "RCCs.transfer()" end,
    ["^%s*title%((.-)%)%s*$"]   = function(a) return "RCCs.name("..a..")" end,
    ["^%s*print%((.-)%)%s*$"]   = function(a) return "RCCs.print("..a..")" end,
    ["^%s*warn%((.-)%)%s*$"]    = function(a) return "RCCs.warn("..a..")" end,
    ["^%s*clear%(%s*%)%s*$"]    = function() return "RCCs.clear()" end,
}

local function _run(code, ctx)
    if code:find("[\u{0400}-\u{04FF}]") then print("[RCCs] DSIC Blocked") return end
    local lines = {}
    for line in (code .. "\n"):gmatch("([^\n]*)\n") do
        local replaced = false
        for p, fn in pairs(_aliases) do 
            local cap = line:match(p) 
            if cap then table.insert(lines, fn(cap)) replaced = true break end 
        end
        if not replaced then table.insert(lines, line) end
    end
    local fn, err = loadstring(table.concat(lines, "\n"))
    if not fn then print("[RCCs] Parse Error: "..tostring(err)) return end
    local env = setmetatable(ctx or {}, {__index = getfenv()})
    env.RCCs = RCCs
    setfenv(fn, env)
    fn()
end

-- Основные функции
function RCCs.transfer() _E.print("\n") end
function RCCs.print(...) _E.print(...) end
function RCCs.warn(...) _E.warn(...) end
function RCCs.name(...) _E.name(...) end
function RCCs.clear() _E.clear() end
function RCCs.Run(code, ctx) _run(code, ctx) end

-- Метатаблица для RCCs.Madium(...) и RCCs.Scripts
setmetatable(RCCs, {
    __index = function(t, key)
        local target = _cmds[key]
        if not target then return nil end
        return {
            __call = function(_, code, ctx)
                local prev = _E; _E = target; _run(code, ctx); _E = prev
            end,
            Run = function(name, ctx)
                local code = RCCs.Scripts[name]
                if code then local prev = _E; _E = target; _run(code, ctx); _E = prev end
            end
        }
    end
})

return RCCs