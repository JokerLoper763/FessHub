print("[FessHub] Loading...")

local VERSION = "1.0.1"
local URLs = {}
URLs.GitHub = "https://raw.githubusercontent.com/"
URLs.Repository = URLs.GitHub .. "JokerLoper763/FessHub/main/"
URLs.Games = URLs.Repository .. "Games/"

local function LoadScript(url)
    local success, code = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        error("[FessHub] Failed to fetch: " .. url)
    end
    
    local func = loadstring(code)
    if not func then
        error("[FessHub] Failed to load: " .. url)
    end
    
    return func
end

if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    print("[FessHub] Detected: Blox Fruits")
    LoadScript(URLs.Games .. "BloxFruits.luau")(...)
elseif game.PlaceId == 10260193230 then
    print("[FessHub] Detected: Meme Sea")
    LoadScript(URLs.Games .. "MemeSea.luau")(...)
else
    warn("[FessHub] Game not supported!")
end
