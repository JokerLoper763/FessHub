print("[FessHub] Loading...")

local VERSION = "1.0.1"

local URLs = {}
URLs.GitHub = "https://raw.githubusercontent.com/"
URLs.Repository = URLs.GitHub .. "JokerLoper763/FessHub/main/"
URLs.Games = URLs.Repository .. "Games/"
URLs.Library = URLs.Repository .. "Library/"
URLs.Utils = URLs.Repository .. "Utils/"

local Fetcher = {}

local function LoadScript(url)
    local success, code = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        warn("[FessHub] Failed to fetch: " .. url)
        return nil
    end
    
    local func, err = loadstring(code)
    if not func then
        warn("[FessHub] Failed to load: " .. url)
        warn("[FessHub] Error: " .. tostring(err))
        return nil
    end
    
    return func
end

function Fetcher.Get(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    return success and response or nil
end

function Fetcher.Load(url)
    local code = Fetcher.Get(url)
    if code then
        return loadstring(code)
    end
    return nil
end

pcall(function()
    if _G.fess_execute_debounce and (tick() - _G.fess_execute_debounce) <= 3 then
        warn("[FessHub] Please wait before re-executing!")
        return
    end
    _G.fess_execute_debounce = tick()
end)

pcall(function()
    local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport)
    if queueTeleport and not _G.fess_teleport_queued then
        _G.fess_teleport_queued = true
        local code = string.format("loadstring(game:HttpGet('%smain.luau'))()", URLs.Repository)
        queueTeleport(code)
    end
end)

print("[FessHub] Version " .. VERSION)
print("[FessHub] Initializing...")

if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    print("[FessHub] Detected: Blox Fruits")
    local loader = LoadScript(URLs.Games .. "BloxFruits.luau")
    if loader then
        loader(Fetcher, ...)
    end
elseif game.PlaceId == 10260193230 then
    print("[FessHub] Detected: Meme Sea")
    local loader = LoadScript(URLs.Games .. "MemeSea.luau")
    if loader then
        loader(Fetcher, ...)
    end
else
    warn("[FessHub] Game not supported!")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "FessHub",
            Text = "Game not supported!",
            Duration = 10
        })
    end)
end


