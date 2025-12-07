-- FessHub Main Loader v1.0.0
-- Advanced Automation Framework for Roblox
-- Made with  by FessHub Team

local _ENV = getgenv and getgenv() or _G
local VERSION = "1.0.0"
local BETA_MODE = _ENV.FESS_BETA_MODE

-- Supported Games Configuration
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

local Fetcher = {}
local URLs = {}

-- Anti-Spam Protection
do
    local lastExecution = _ENV.fess_execute_debounce
    
    if lastExecution and (tick() - lastExecution) <= 3 then
        return warn("[FessHub] Please wait before re-executing!")
    end
    
    _ENV.fess_execute_debounce = tick()
end

-- URL Configuration
URLs.GitHub = "https://raw.githubusercontent.com/"
URLs.Repository = URLs.GitHub .. "JokerLoper763/FessHub/main/"
URLs.Games = URLs.Repository .. "Games/"
URLs.Library = URLs.Repository .. "Library/"
URLs.Utils = URLs.Repository .. "Utils/"

-- Queue Teleport (Save settings on server hop)
do
    local queueTeleport = queue_on_teleport or syn and syn.queue_on_teleport
    
    if not _ENV.fess_teleport_queued and type(queueTeleport) == "function" then
        local scriptSettings = {...}
        local settingsCode = ""
        
        _ENV.fess_teleport_queued = true
        
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
            settingsCode = "getgenv().FESS_BETA_MODE=true;" .. settingsCode
        end
        
        pcall(queueTeleport, settingsCode)
    end
end

-- Error Display System
do
    if _ENV.fess_error_message then
        _ENV.fess_error_message:Destroy()
        _ENV.fess_error_message = nil
    end
    
    local function CreateError(text)
        _ENV.fess_farm_loaded = nil
        _ENV.fess_farm_active = false
        
        local message = Instance.new("Message", workspace)
        message.Text = "[FessHub Error] " .. text
        _ENV.fess_error_message = message
        
        task.delay(10, function()
            if message and message.Parent then
                message:Destroy()
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
end

-- Game Detection
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

-- Main Execution
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

-- No Supported Game Found
warn("[FessHub] This game is not supported yet!")
warn("[FessHub] Join discord.gg/fesshub for updates")

local function CreateNotification()
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")
    
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "FessHub",
            Text = "Game not supported!\nJoin discord.gg/fesshub",
            Duration = 10
        })
    end)
end

CreateNotification()
