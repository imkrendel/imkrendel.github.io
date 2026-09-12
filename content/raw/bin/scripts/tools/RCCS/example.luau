local watermark = [[
      ____  ____________        __   __             __________   _____       ______                         
     / __ \/ ____/ ____/____   / /  / /_  __  __   / ___/__  /  / ___/____  / __/ /__      ______ _________ 
    / /_/ / /   / /   / ___/  / /  / __ \/ / / /   \__ \  / /   \__ \/ __ \/ /_/ __/ | /| / / __ `/ ___/ _ \
   / _, _/ /___/ /___(__  )  / /  / /_/ / /_/ /   ___/ / / /   ___/ / /_/ / __/ /_ | |/ |/ / /_/ / /  /  __/
  /_/ |_|\____/\____/____/  / /  /_.___/\__, /   /____/ /_/   /____/\____/_/  \__/ |__/|__/\__,_/_/   \___/ 
                           /_/         /____/                                                               
]]

local HVU = {
    Stable = "url",
    Beta   = "url",
}

local HVL = {
    Beta = { 000000000, 111111111 }
}

local HS = {
    Title = "[IHL]",
    HN    = "IoaHelperLuv",
    Close = "Closing.. Thanks for using Vapo.",
    UID   = tostring(game.Players.LocalPlayer.UserId),
    PID   = tostring(game.PlaceId),
}

local AP = {
    "Developer     - https://github.com/imkrendel",
    "Yoxi Hub      - https://www.yoxi-hub.fun/",
    "Exterium      - https://www.extorium.art/",
}

local FF = {
    "I know Yomka",
    "Vapo loves cats",
    "s7nc cooked this",
}

local RCCs = loadstring(game:HttpGet("https://raw.githubusercontent.com/misterlerp/s7nc.softworks/refs/heads/main/RCCs/testing/universal.lua"))()
local _t0 = os.clock()
local _ff = FF[math.random(1, #FF)]
local _elapsed = string.format("%.1f", os.clock() - _t0)

RCCs.Run([[
    title(" | by imkrendel")
    clear()
    print(WM)
    transfer()
    wait(1)
    print(PFX .. " Fun Fact: " .. FACT)
    transfer()
    print(PFX .. " UID - " .. UID .. " | PID - " .. PID)
    transfer()
    transfer()
    wait(1)
    print(PFX .. " Another Projects:")
    transfer()
    for i, project in ipairs(PROJS) do
        wait(0.5)
        transfer()
        print(PFX .. " " .. project)
    end
    transfer()
    wait(1)  
    print(PFX .. " Loaded for " .. TIME .. "s")
    transfer()
]], { 
    WM = watermark,
    PFX = HS.Title,
    FACT = _ff,
    UID = HS.UID,
    PID = HS.PID,
    PROJS = AP,
    TIME = _elapsed
})
task.wait(3)
RCCs.print(HS.Title .. " " .. HS.Close)
task.wait(3)
RCCs.destroy()