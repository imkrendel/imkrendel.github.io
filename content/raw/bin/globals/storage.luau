getgenv().Run = getgenv().Run or {}
local function exec(url)
    local success, code = pcall(game.HttpGet, game, url)
    if success and code then
        print("Response preview from " .. url .. ":\n" .. string.sub(code, 1, 100))
        
        if code:find("<!DOCTYPE") or code:find("404") then
            warn("Файл не найден (404/HTML) по ссылке: " .. url)
            return
        end

        local func, err = loadstring(code)
        if func then
            func()
        else
            warn("Ошибка компиляции: " .. tostring(err))
        end
    else
        warn("Не удалось выполнить HttpGet: " .. tostring(url))
    end
end

Run.WAESP = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/combat/WA/source.luau") end
Run.LimbExtender_rewrite = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/combat/Hitbox/AAPVDEV/source.luau") end
Run.Spin = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/combat/Spin.lua") end
Run.Fly = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/movement/fly.lua") end
Run.Cframe = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/movement/cframe-speed/source.luau") end

Run.Gaze = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/universal/animations/gaze/source.luau") end
Run.afem = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/universal/animations/AFEM.lua") end
Run.IY = function()   exec("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source") end
Run.SysBroken = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/sysbrokenU.lua") end
Run.External_Shift = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/universal/movement/external-shift.luau") end

-- Tools
Run.ExecutorBydzenero = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/tools/executor.lua") end
Run.Executor = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/tools/executor.lua") end
Run.OldConsoleBywally = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/tools/console.lua") end
Run.DexByIY = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/tools/dex.lua") end
Run.InfinityYield = function() 


-- Games
Run.VDTexRBLX = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/violence-district/TexRBLX-script.lua") end
Run.VDTexRBLXRewrite = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/violence-district/TexRBLX-Rewrite.lua") end
Run.DisableStopEmote = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/violence-district/DisableStopEmote.lua") end
Run.MoonWalk = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/violence-district/MoonWalk.lua") end

-- EVADE
Run.WhakazhiHubX = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/backups/evade/WhakizashiHubX.lua") end
Run.DaraHub = function() exec("https://darahub.vercel.app/main.lua") end -- COLLAB
Run.ODHMM2 = function() exec("https://api.overdrivehub.xyz/v1/auth") end
Run.XHubMM2 = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/games/evade/XhubMM2.lua") end

Run.KronHub = function() exec("https://imkrendel.github.io/content/raw/bin/scripts/games/evade/Kron_Hub.lua") end
Run.LuaWare = function() exec("https://raw.githubusercontent.com/frencaliber/LuaWareLoader.lw/main/luawareloader.wtf") end
Run.SchoolHub = function() exec("https://raw.githubusercontent.com/IHateSchoolIsCool/FuckCheapShops/main/Schoolhub%20Selector") end