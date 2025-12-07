print("[FessHub] Loading...")

local VERSION = "1.0.1"
local BETA_MODE = _G.FESS_BETA_MODE or false

local URLs = {}
URLs.GitHub = "https://raw.githubusercontent.com/"
URLs.Repository = URLs.GitHub .. "JokerLoper763/FessHub/main/"
URLs.Games = URLs.Repository .. "Games/"
URLs.Library = URLs.Repository .. "Library/"
URLs.Utils = URLs.Repository .. "Utils/"

local Fetcher = {}

if _G.fess_execute_debounce and (tick() - _G.fess_execute_debounce) <= 3 then
    return warn("[FessHub] Please wait before re-executing!")
end
_G.fess_execute_debounce = tick()

if _G.fess_error_message then
    pcall(function() _G.fess_error_message:Destroy() end)
    _G.fess_error_message = nil
end

local queueTeleport = queue_on_teleport or (syn and syn.queue_on_teleport)
if queueTeleport and type(queueTeleport) == "function" and not _G.fess_teleport_queued then
    _G.fess_teleport_queued = true
    
    local scriptSettings = {...}
    local settingsCode = ""
    
    local success, encoded = pcall(function()
        return game:GetService("HttpService"):JSONEncode(scriptSettings)
    end)
    
    if success and encoded then
        settingsCode = string.format(
            "loadstring(game:HttpGet('%smain.luau'))(game:GetService('HttpService'):JSONDecode('%s'))",
            URLs.Repository,
            encoded
        )
    else
        settingsCode = string.format("loadstring(game:HttpGet('%smain.luau'))()", URLs.Repository)
    end
    
    if BETA_MODE then
        settingsCode = "_G.FESS_BETA_MODE=true;" .. settingsCode
    end
    
    pcall(queueTeleport, settingsCode)
end

local function CreateError(text)
    _G.fess_farm_loaded = nil
    _G.fess_farm_active = false
    
    local message = Instance.new("Message", workspace)
    message.Text = "[FessHub Error] " .. text
    _G.fess_error_message = message
    
    task.delay(10, function()
        if message and message.Parent then
            pcall(function() message:Destroy() end)
        end
    end)
    
    error(text, 2)
end

local function FormatURL(url)
    for key, path in pairs(URLs) do
        url = url:gsub("{" .. key .. "}", path)
    end
    return url
end

function Fetcher.Get(url)
    local success, response = pcall(function()
        return game:HttpGet(FormatURL(url))
    end)
    
    if success then
        return response
    else
        CreateError(string.format("Failed to fetch: %s\nError: %s", url, tostring(response)))
    end
end

function Fetcher.Load(url, extraCode)
    local rawCode = Fetcher.Get(url) .. (extraCode or "")
    local loadedFunc, errorMsg = loadstring(rawCode)
    
    if type(loadedFunc) ~= "function" then
        CreateError(string.format("Syntax error in: %s\nError: %s", url, tostring(errorMsg)))
    end
    
    return loadedFunc
end

local SupportedGames = {
    {
        Name = "Blox Fruits",
        GameId = 2753915549,
        PlaceIds = {2753915549, 4442272183, 7449423635},
        ScriptPath = "BloxFruits.luau"
    },
    {
        Name = "Meme Sea",
        PlaceIds = {10260193230},
        ScriptPath = "MemeSea.luau"
    }
}

local function IsGameSupported(gameConfig)
    if gameConfig.PlaceIds then
        for _, placeId in ipairs(gameConfig.PlaceIds) do
            if game.PlaceId == placeId then
                return true
            end
        end
    end
    
    if gameConfig.GameId and game.GameId == gameConfig.GameId then
        return true
    end
    
    return false
end

print("[FessHub] Version " .. VERSION)
print("[FessHub] Initializing...")

for _, gameConfig in ipairs(SupportedGames) do
    if IsGameSupported(gameConfig) then
        print("[FessHub] Detected: " .. gameConfig.Name)
        print("[FessHub] Loading game script...")
        
        local success, result = pcall(function()
            return Fetcher.Load(URLs.Games .. gameConfig.ScriptPath)(Fetcher, ...)
        end)
        
        if success then
            print("[FessHub] Successfully loaded!")
            return result
        else
            warn("[FessHub] Failed to load: " .. tostring(result))
        end
    end
end

warn("[FessHub] This game is not supported yet!")
warn("[FessHub] Join discord.gg/fesshub for updates")

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "FessHub",
        Text = "Game not supported!\nJoin discord.gg/fesshub",
        Duration = 10
    })
end)


