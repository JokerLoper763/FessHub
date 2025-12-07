-- FessHub - Blox Fruits Edition
-- Advanced Auto Farm & Automation System
-- Version: 1.0.0

local Fetcher, UserSettings = ...

print("[FessHub] Loading Blox Fruits module...")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Game References
local Workspace = workspace
local Enemies = Workspace:WaitForChild("Enemies")
local NPCs = Workspace:WaitForChild("NPCs")

-- Default Settings
local Settings = {
    -- Team
    Team = "Pirates",
    
    -- Main Farm
    AutoFarm = false,
    FarmMode = "Quest", -- "Quest" or "Nearest"
    AutoQuest = true,
    BringMobs = true,
    BringMode = "Normal", -- "Normal" or "Advanced"
    FastAttack = true,
    AttackDistance = 15,
    SpinPosition = true, -- Anti-ban rotation
    
    -- Weapon
    SelectWeapon = "Melee",
    
    -- Boss
    AutoBoss = false,
    SelectBoss = "All",
    
    -- Mastery System
    AutoMastery = false,
    MasteryMode = "Fruit", -- "Fruit", "Sword", "Gun"
    MasteryHealth = 25, -- % HP threshold to farm mastery
    UseSkillZ = true,
    UseSkillX = true,
    UseSkillC = true,
    UseSkillV = false,
    UseSkillF = false,
    
    -- Auto Stats
    AutoStats = false,
    StatMelee = false,
    StatDefense = false,
    StatFruit = false,
    StatSword = false,
    StatGun = false,
    StatPoints = 1, -- Points per allocation
    
    -- Sea Events
    AutoSeaEvent = false,
    SelectedBoat = "Guardian",
    FarmTerrorshark = false,
    FarmPiranha = false,
    FarmShark = false,
    FarmSeaBeast = false,
    BoatSpeed = 300,
    
    -- Misc
    AutoHaki = true,
    AutoObservation = false,
    AntiAFK = true,
    WhiteScreen = false,
    NoClip = true
}

-- Merge user settings
if UserSettings and type(UserSettings) == "table" then
    for k, v in pairs(UserSettings) do
        Settings[k] = v
    end
end

print("[FessHub] Settings loaded")
print("[FessHub] Team: " .. Settings.Team)

-- World Detection
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
end

-- Quest System Variables
local QuestData = {
    Mon = "",
    LevelQuest = 1,
    NameQuest = "",
    NameMon = "",
    CFrameQuest = CFrame.new(0, 0, 0),
    CFrameMon = CFrame.new(0, 0, 0)
}

-- FessHub Module
local FessHub = {}
FessHub.Version = "1.0.0"
FessHub.Loaded = false
FessHub.CurrentAngle = 0

-- Utility Functions
function FessHub:IsAlive(char)
    char = char or Character
    if not char or not char.Parent then return false end
    
    local hum = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    
    return hum and root and hum.Health > 0
end

function FessHub:GetDistance(pos)
    if not self:IsAlive() then return math.huge end
    return (HumanoidRootPart.Position - pos).Magnitude
end

function FessHub:AutoHaki()
    if not LocalPlayer.Character:FindFirstChild("HasBuso") then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

function FessHub:Click()
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

function FessHub:EquipTool(toolName)
    if not self:IsAlive() then return false end
    
    local tool = LocalPlayer.Backpack:FindFirstChild(toolName)
    if tool then
        Humanoid:EquipTool(tool)
        return true
    end
    
    return false
end

function FessHub:GetCurrentWeapon()
    return Character:FindFirstChildOfClass("Tool")
end

function FessHub:UseSkill(skillKey)
    if not self:IsAlive() then return end
    
    VirtualInputManager:SendKeyEvent(true, skillKey, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, skillKey, false, game)
end

function FessHub:Tween(cframe, speed)
    if not self:IsAlive() then return end
    
    speed = speed or 300
    local distance = self:GetDistance(cframe.Position)
    local duration = distance / speed
    
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = cframe}
    )
    
    tween:Play()
    return tween
end

function FessHub:BTP(cframe)
    if not self:IsAlive() then return end
    
    local distance = self:GetDistance(cframe.Position)
    
    if distance >= 2000 then
        repeat
            task.wait()
            HumanoidRootPart.CFrame = cframe
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
            Character.Head:Destroy()
            task.wait()
        until self:GetDistance(cframe.Position) <= 2000
    end
end

-- Quest System
function FessHub:CheckQuest()
    local myLevel = LocalPlayer.Data.Level.Value
    
    if World1 then
        if myLevel >= 1 and myLevel <= 9 then
            QuestData.Mon = "Bandit"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "BanditQuest1"
            QuestData.NameMon = "Bandit"
            QuestData.CFrameQuest = CFrame.new(1059.37, 15.45, 1550.42)
            QuestData.CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
        elseif myLevel >= 10 and myLevel <= 14 then
            QuestData.Mon = "Monkey"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "JungleQuest"
            QuestData.NameMon = "Monkey"
            QuestData.CFrameQuest = CFrame.new(-1598.09, 35.55, 153.38)
            QuestData.CFrameMon = CFrame.new(-1448.52, 67.85, 11.47)
        elseif myLevel >= 15 and myLevel <= 29 then
            QuestData.Mon = "Gorilla"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "JungleQuest"
            QuestData.NameMon = "Gorilla"
            QuestData.CFrameQuest = CFrame.new(-1598.09, 35.55, 153.38)
            QuestData.CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)
        elseif myLevel >= 30 and myLevel <= 39 then
            QuestData.Mon = "Pirate"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "BuggyQuest1"
            QuestData.NameMon = "Pirate"
            QuestData.CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.55)
            QuestData.CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)
        elseif myLevel >= 40 and myLevel <= 59 then
            QuestData.Mon = "Brute"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "BuggyQuest1"
            QuestData.NameMon = "Brute"
            QuestData.CFrameQuest = CFrame.new(-1141.07, 4.10, 3831.55)
            QuestData.CFrameMon = CFrame.new(-1140.08, 14.81, 4322.92)
        elseif myLevel >= 60 and myLevel <= 74 then
            QuestData.Mon = "Desert Bandit"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "DesertQuest"
            QuestData.NameMon = "Desert Bandit"
            QuestData.CFrameQuest = CFrame.new(894.49, 5.14, 4392.43)
            QuestData.CFrameMon = CFrame.new(924.80, 6.45, 4481.59)
        elseif myLevel >= 75 and myLevel <= 89 then
            QuestData.Mon = "Desert Officer"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "DesertQuest"
            QuestData.NameMon = "Desert Officer"
            QuestData.CFrameQuest = CFrame.new(894.49, 5.14, 4392.43)
            QuestData.CFrameMon = CFrame.new(1608.28, 8.61, 4371.01)
        elseif myLevel >= 90 and myLevel <= 99 then
            QuestData.Mon = "Snow Bandit"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "SnowQuest"
            QuestData.NameMon = "Snow Bandit"
            QuestData.CFrameQuest = CFrame.new(1389.74, 88.15, -1298.91)
            QuestData.CFrameMon = CFrame.new(1354.35, 87.27, -1393.95)
        elseif myLevel >= 100 and myLevel <= 119 then
            QuestData.Mon = "Snowman"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "SnowQuest"
            QuestData.NameMon = "Snowman"
            QuestData.CFrameQuest = CFrame.new(1389.74, 88.15, -1298.91)
            QuestData.CFrameMon = CFrame.new(1201.64, 144.58, -1550.07)
        elseif myLevel >= 120 and myLevel <= 149 then
            QuestData.Mon = "Chief Petty Officer"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "MarineQuest2"
            QuestData.NameMon = "Chief Petty Officer"
            QuestData.CFrameQuest = CFrame.new(-5039.59, 27.35, 4324.68)
            QuestData.CFrameMon = CFrame.new(-4881.23, 22.65, 4273.75)
        elseif myLevel >= 150 and myLevel <= 174 then
            QuestData.Mon = "Sky Bandit"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "SkyQuest"
            QuestData.NameMon = "Sky Bandit"
            QuestData.CFrameQuest = CFrame.new(-4839.53, 716.37, -2619.44)
            QuestData.CFrameMon = CFrame.new(-4953.21, 295.74, -2899.23)
        elseif myLevel >= 175 and myLevel <= 189 then
            QuestData.Mon = "Dark Master"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "SkyQuest"
            QuestData.NameMon = "Dark Master"
            QuestData.CFrameQuest = CFrame.new(-4839.53, 716.37, -2619.44)
            QuestData.CFrameMon = CFrame.new(-5259.84, 391.40, -2229.04)
        elseif myLevel >= 190 and myLevel <= 209 then
            QuestData.Mon = "Prisoner"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "PrisonerQuest"
            QuestData.NameMon = "Prisoner"
            QuestData.CFrameQuest = CFrame.new(5308.93, 1.66, 475.12)
            QuestData.CFrameMon = CFrame.new(5098.97, -0.32, 474.24)
        elseif myLevel >= 210 and myLevel <= 249 then
            QuestData.Mon = "Dangerous Prisoner"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "PrisonerQuest"
            QuestData.NameMon = "Dangerous Prisoner"
            QuestData.CFrameQuest = CFrame.new(5308.93, 1.66, 475.12)
            QuestData.CFrameMon = CFrame.new(5654.56, 15.63, 866.30)
        elseif myLevel >= 250 and myLevel <= 274 then
            QuestData.Mon = "Toga Warrior"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "ColosseumQuest"
            QuestData.NameMon = "Toga Warrior"
            QuestData.CFrameQuest = CFrame.new(-1580.05, 6.35, -2986.48)
            QuestData.CFrameMon = CFrame.new(-1820.21, 51.68, -2740.67)
        elseif myLevel >= 275 and myLevel <= 299 then
            QuestData.Mon = "Gladiator"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "ColosseumQuest"
            QuestData.NameMon = "Gladiator"
            QuestData.CFrameQuest = CFrame.new(-1580.05, 6.35, -2986.48)
            QuestData.CFrameMon = CFrame.new(-1292.84, 56.38, -3339.03)
        elseif myLevel >= 300 and myLevel <= 324 then
            QuestData.Mon = "Military Soldier"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "MagmaQuest"
            QuestData.NameMon = "Military Soldier"
            QuestData.CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29)
            QuestData.CFrameMon = CFrame.new(-5411.16, 11.08, 8454.29)
        elseif myLevel >= 325 and myLevel <= 374 then
            QuestData.Mon = "Military Spy"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "MagmaQuest"
            QuestData.NameMon = "Military Spy"
            QuestData.CFrameQuest = CFrame.new(-5313.37, 10.95, 8515.29)
            QuestData.CFrameMon = CFrame.new(-5802.87, 86.26, 8828.86)
        elseif myLevel >= 375 then
            QuestData.Mon = "Fishman Warrior"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "FishmanQuest"
            QuestData.NameMon = "Fishman Warrior"
            QuestData.CFrameQuest = CFrame.new(61122.65, 18.50, 1569.40)
            QuestData.CFrameMon = CFrame.new(60878.30, 18.48, 1543.76)
        end
    elseif World2 then
        if myLevel >= 700 and myLevel <= 724 then
            QuestData.Mon = "Raider"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "Area1Quest"
            QuestData.NameMon = "Raider"
            QuestData.CFrameQuest = CFrame.new(-429.54, 71.77, 1836.18)
            QuestData.CFrameMon = CFrame.new(-728.33, 52.78, 2345.77)
        elseif myLevel >= 725 and myLevel <= 774 then
            QuestData.Mon = "Mercenary"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "Area1Quest"
            QuestData.NameMon = "Mercenary"
            QuestData.CFrameQuest = CFrame.new(-429.54, 71.77, 1836.18)
            QuestData.CFrameMon = CFrame.new(-1004.32, 80.16, 1424.62)
        elseif myLevel >= 775 and myLevel <= 799 then
            QuestData.Mon = "Swan Pirate"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "Area2Quest"
            QuestData.NameMon = "Swan Pirate"
            QuestData.CFrameQuest = CFrame.new(638.44, 71.77, 918.28)
            QuestData.CFrameMon = CFrame.new(1068.66, 137.61, 1322.11)
        elseif myLevel >= 800 then
            QuestData.Mon = "Factory Staff"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "Area2Quest"
            QuestData.NameMon = "Factory Staff"
            QuestData.CFrameQuest = CFrame.new(632.70, 73.11, 918.67)
            QuestData.CFrameMon = CFrame.new(73.08, 81.86, -27.47)
        end
    elseif World3 then
        if myLevel >= 1500 and myLevel <= 1524 then
            QuestData.Mon = "Pirate Millionaire"
            QuestData.LevelQuest = 1
            QuestData.NameQuest = "PiratePortQuest"
            QuestData.NameMon = "Pirate Millionaire"
            QuestData.CFrameQuest = CFrame.new(-290.07, 42.90, 5581.59)
            QuestData.CFrameMon = CFrame.new(-245.99, 47.31, 5584.10)
        elseif myLevel >= 1525 then
            QuestData.Mon = "Pistol Billionaire"
            QuestData.LevelQuest = 2
            QuestData.NameQuest = "PiratePortQuest"
            QuestData.NameMon = "Pistol Billionaire"
            QuestData.CFrameQuest = CFrame.new(-290.07, 42.90, 5581.59)
            QuestData.CFrameMon = CFrame.new(-187.33, 86.24, 6013.51)
        end
    end
end

function FessHub:TakeQuest()
    if not Settings.AutoQuest then return end
    
    self:CheckQuest()
    
    if self:GetDistance(QuestData.CFrameQuest.Position) > 10 then
        self:Tween(QuestData.CFrameQuest)
        task.wait(1)
    end
    
    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", QuestData.NameQuest, QuestData.LevelQuest)
end

function FessHub:Teleport(cframe)
    if not self:IsAlive() then return end
    HumanoidRootPart.CFrame = cframe
end

function FessHub:Attack()
    if not self:IsAlive() then return end
    
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

-- Auto Stats System
function FessHub:AutoStats()
    if not Settings.AutoStats then return end
    
    local points = LocalPlayer.Data.Points.Value
    
    if points >= Settings.StatPoints then
        if Settings.StatMelee then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", Settings.StatPoints)
        end
        if Settings.StatDefense then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", Settings.StatPoints)
        end
        if Settings.StatFruit then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", Settings.StatPoints)
        end
        if Settings.StatSword then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", Settings.StatPoints)
        end
        if Settings.StatGun then
            ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", Settings.StatPoints)
        end
    end
end

-- Mastery System
function FessHub:UseMasterySkills()
    if not Settings.AutoMastery then return end
    
    local healthPercent = (Humanoid.Health / Humanoid.MaxHealth) * 100
    
    if healthPercent <= Settings.MasteryHealth then
        return -- Don't use skills when mob is low HP
    end
    
    if Settings.UseSkillZ then
        self:UseSkill("Z")
        task.wait(0.5)
    end
    if Settings.UseSkillX then
        self:UseSkill("X")
        task.wait(0.5)
    end
    if Settings.UseSkillC then
        self:UseSkill("C")
        task.wait(0.5)
    end
    if Settings.UseSkillV then
        self:UseSkill("V")
        task.wait(0.5)
    end
    if Settings.UseSkillF then
        self:UseSkill("F")
        task.wait(1)
    end
end

function FessHub:GetQuestEnemies()
    local enemies = {}
    
    for _, enemy in pairs(Enemies:GetChildren()) do
        if enemy.Name == QuestData.Mon then
            local enemyHum = enemy:FindFirstChild("Humanoid")
            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
            
            if enemyHum and enemyRoot and enemyHum.Health > 0 then
                table.insert(enemies, {
                    Model = enemy,
                    Humanoid = enemyHum,
                    Root = enemyRoot,
                    Distance = self:GetDistance(enemyRoot.Position)
                })
            end
        end
    end
    
    table.sort(enemies, function(a, b)
        return a.Distance < b.Distance
    end)
    
    return enemies
end

function FessHub:GetEnemies()
    local enemies = {}
    
    for _, enemy in pairs(Enemies:GetChildren()) do
        local enemyHum = enemy:FindFirstChild("Humanoid")
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
        
        if enemyHum and enemyRoot and enemyHum.Health > 0 then
            table.insert(enemies, {
                Model = enemy,
                Humanoid = enemyHum,
                Root = enemyRoot,
                Distance = self:GetDistance(enemyRoot.Position)
            })
        end
    end
    
    -- Sort by distance
    table.sort(enemies, function(a, b)
        return a.Distance < b.Distance
    end)
    
    return enemies
end

function FessHub:GetClosestEnemy()
    if Settings.FarmMode == "Quest" then
        local questEnemies = self:GetQuestEnemies()
        return questEnemies[1]
    else
        local enemies = self:GetEnemies()
        return enemies[1]
    end
end

function FessHub:GetSpinPosition()
    if not Settings.SpinPosition then
        return CFrame.new(0, Settings.AttackDistance, 0)
    end
    
    local radius = 20
    local radian = math.rad(self.CurrentAngle)
    local x = math.cos(radian) * radius
    local z = math.sin(radian) * radius
    self.CurrentAngle = (self.CurrentAngle + 30) % 360
    
    return CFrame.new(x, Settings.AttackDistance, z)
end

function FessHub:BringMobs(targetCFrame)
    if not Settings.BringMobs then return end
    
    for _, enemy in pairs(Enemies:GetChildren()) do
        if Settings.FarmMode == "Quest" and enemy.Name ~= QuestData.Mon then
            continue
        end
        
        local enemyHum = enemy:FindFirstChild("Humanoid")
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
        
        if enemyHum and enemyRoot and enemyHum.Health > 0 then
            if self:GetDistance(enemyRoot.Position) <= 350 then
                enemyRoot.CFrame = targetCFrame
                enemyRoot.CanCollide = false
                enemyRoot.Size = Vector3.new(60, 60, 60)
                enemyRoot.Transparency = 1
                enemyHum.WalkSpeed = 0
                enemyHum.JumpPower = 0
                
                if enemyHum:FindFirstChild("Animator") then
                    enemyHum.Animator:Destroy()
                end
                
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            end
        end
    end
end

-- Farm Loop
function FessHub:StartAutoFarm()
    print("[FessHub] Auto Farm started!")
    
    task.spawn(function()
        while task.wait() do
            pcall(function()
                if not Settings.AutoFarm or not self:IsAlive() then
                    return
                end
                
                -- Auto Haki
                if Settings.AutoHaki then
                    self:AutoHaki()
                end
                
                -- Auto Stats
                self:AutoStats()
                
                -- Take Quest
                if Settings.FarmMode == "Quest" then
                    self:TakeQuest()
                end
                
                -- Find Enemy
                local enemy = self:GetClosestEnemy()
                
                if enemy and enemy.Humanoid.Health > 0 then
                    local spinPos = self:GetSpinPosition()
                    local attackCFrame = enemy.Root.CFrame * spinPos
                    
                    -- Move to enemy
                    if self:GetDistance(enemy.Root.Position) > 250 then
                        self:Tween(attackCFrame, 300)
                    else
                        self:Teleport(attackCFrame)
                    end
                    
                    -- Bring Mobs
                    self:BringMobs(enemy.Root.CFrame)
                    
                    -- Attack
                    self:Attack()
                    
                    -- Use Mastery Skills
                    if Settings.AutoMastery then
                        self:UseMasterySkills()
                    end
                    
                    -- Fast Attack
                    if Settings.FastAttack then
                        for i = 1, 5 do
                            self:Attack()
                            task.wait(0.05)
                        end
                    end
                else
                    -- No enemies, go to spawn location
                    if Settings.FarmMode == "Quest" and QuestData.CFrameMon then
                        self:Tween(QuestData.CFrameMon, 300)
                    end
                end
                
                task.wait(0.1)
            end)
        end
    end)
end

-- Sea Events System
function FessHub:GetBoat()
    if not Workspace.Boats:FindFirstChild(Settings.SelectedBoat) then
        return nil
    end
    
    local boat = Workspace.Boats[Settings.SelectedBoat]
    return boat:FindFirstChild("VehicleSeat") and boat or nil
end

function FessHub:TweenBoat(targetCFrame)
    local boat = self:GetBoat()
    if not boat then return end
    
    local seat = boat.VehicleSeat
    local distance = (seat.Position - targetCFrame.Position).Magnitude
    local duration = distance / Settings.BoatSpeed
    
    local tween = TweenService:Create(
        seat,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )
    
    tween:Play()
    return tween
end

function FessHub:GetSeaEnemies()
    local seaEnemies = {}
    
    for _, enemy in pairs(Workspace.SeaBeasts:GetChildren()) do
        if (Settings.FarmTerrorshark and enemy.Name == "Terrorshark") or
           (Settings.FarmPiranha and enemy.Name == "Piranha") or
           (Settings.FarmShark and enemy.Name == "Shark") or
           (Settings.FarmSeaBeast and enemy.Name:find("SeaBeast")) then
            
            local enemyHum = enemy:FindFirstChild("Humanoid")
            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
            
            if enemyHum and enemyRoot and enemyHum.Health > 0 then
                table.insert(seaEnemies, {
                    Model = enemy,
                    Humanoid = enemyHum,
                    Root = enemyRoot,
                    Distance = self:GetDistance(enemyRoot.Position)
                })
            end
        end
    end
    
    table.sort(seaEnemies, function(a, b)
        return a.Distance < b.Distance
    end)
    
    return seaEnemies
end

function FessHub:StartSeaEvents()
    print("[FessHub] Sea Events started!")
    
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                if not Settings.AutoSeaEvent or not self:IsAlive() then
                    return
                end
                
                local boat = self:GetBoat()
                if not boat then
                    warn("[FessHub] Boat not found:", Settings.SelectedBoat)
                    return
                end
                
                -- Get sea enemies
                local seaEnemies = self:GetSeaEnemies()
                
                if #seaEnemies > 0 then
                    local target = seaEnemies[1]
                    
                    -- Move boat to enemy
                    local targetCFrame = target.Root.CFrame * CFrame.new(0, 0, 50)
                    self:TweenBoat(targetCFrame)
                    
                    -- Attack from boat
                    if Settings.UseSkillZ then self:UseSkill("Z") end
                    if Settings.UseSkillX then self:UseSkill("X") end
                    if Settings.UseSkillC then self:UseSkill("C") end
                    
                    task.wait(2)
                end
            end)
        end
    end)
end

-- NoClip System
function FessHub:StartNoClip()
    if not Settings.NoClip then return end
    
    task.spawn(function()
        RunService.Stepped:Connect(function()
            if Settings.NoClip and self:IsAlive() then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end)
    
    print("[FessHub] NoClip enabled")
end

-- Anti AFK
function FessHub:AntiAFK()
    LocalPlayer.Idled:Connect(function()
        VirtualInputManager:SendKeyEvent(true, "W", false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "W", false, game)
    end)
    print("[FessHub] Anti-AFK enabled")
end

-- Initialize
function FessHub:Initialize()
    print("[FessHub] Initializing Blox Fruits...")
    print("[FessHub] World:", World1 and "First Sea" or World2 and "Second Sea" or World3 and "Third Sea" or "Unknown")
    
    -- Enable SimulationRadius for BringMobs
    task.spawn(function()
        RunService.Heartbeat:Connect(function()
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
                end
            end)
        end)
    end)
    
    -- NoClip
    if Settings.NoClip then
        self:StartNoClip()
    end
    
    -- Anti AFK
    if Settings.AntiAFK then
        self:AntiAFK()
    end
    
    -- Start Auto Farm
    if Settings.AutoFarm then
        self:StartAutoFarm()
    end
    
    -- Start Sea Events
    if Settings.AutoSeaEvent then
        self:StartSeaEvents()
    end
    
    -- Create UI
    self:CreateUI()
    
    self.Loaded = true
    print("[FessHub] Successfully loaded!")
    print("[FessHub] ==============================")
    print("[FessHub] Features:")
    print("[FessHub] - Quest System: " .. (Settings.FarmMode == "Quest" and "Enabled" or "Disabled"))
    print("[FessHub] - Auto Mastery: " .. (Settings.AutoMastery and "Enabled" or "Disabled"))
    print("[FessHub] - Auto Stats: " .. (Settings.AutoStats and "Enabled" or "Disabled"))
    print("[FessHub] - Sea Events: " .. (Settings.AutoSeaEvent and "Enabled" or "Disabled"))
    print("[FessHub] - Spin Position: " .. (Settings.SpinPosition and "Enabled" or "Disabled"))
    print("[FessHub] ==============================")
end

-- Simple UI
function FessHub:CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FessHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Corner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Title.BorderSizePixel = 0
    Title.Font = Enum.Font.GothamBold
    Title.Text = "FessHub v" .. self.Version
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Parent = MainFrame
    
    -- Title Corner
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = Title
    
    -- Auto Farm Toggle
    local AutoFarmBtn = Instance.new("TextButton")
    AutoFarmBtn.Name = "AutoFarmBtn"
    AutoFarmBtn.Size = UDim2.new(0.9, 0, 0, 40)
    AutoFarmBtn.Position = UDim2.new(0.05, 0, 0, 70)
    AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    AutoFarmBtn.BorderSizePixel = 0
    AutoFarmBtn.Font = Enum.Font.Gotham
    AutoFarmBtn.Text = "Auto Farm: OFF"
    AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
    AutoFarmBtn.TextSize = 16
    AutoFarmBtn.Parent = MainFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = AutoFarmBtn
    
    AutoFarmBtn.MouseButton1Click:Connect(function()
        Settings.AutoFarm = not Settings.AutoFarm
        
        if Settings.AutoFarm then
            AutoFarmBtn.Text = "Auto Farm: ON"
            AutoFarmBtn.TextColor3 = Color3.fromRGB(85, 255, 85)
            AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 75, 45)
            self:StartAutoFarm()
        else
            AutoFarmBtn.Text = "Auto Farm: OFF"
            AutoFarmBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
            AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
    end)
    
    -- Auto Mastery Toggle
    local MasteryBtn = Instance.new("TextButton")
    MasteryBtn.Name = "MasteryBtn"
    MasteryBtn.Size = UDim2.new(0.9, 0, 0, 40)
    MasteryBtn.Position = UDim2.new(0.05, 0, 0, 120)
    MasteryBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MasteryBtn.BorderSizePixel = 0
    MasteryBtn.Font = Enum.Font.Gotham
    MasteryBtn.Text = "Auto Mastery: " .. (Settings.AutoMastery and "ON" or "OFF")
    MasteryBtn.TextColor3 = Settings.AutoMastery and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
    MasteryBtn.TextSize = 16
    MasteryBtn.Parent = MainFrame
    
    local MasteryCorner = Instance.new("UICorner")
    MasteryCorner.CornerRadius = UDim.new(0, 8)
    MasteryCorner.Parent = MasteryBtn
    
    MasteryBtn.MouseButton1Click:Connect(function()
        Settings.AutoMastery = not Settings.AutoMastery
        MasteryBtn.Text = "Auto Mastery: " .. (Settings.AutoMastery and "ON" or "OFF")
        MasteryBtn.TextColor3 = Settings.AutoMastery and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
    end)
    
    -- Auto Stats Toggle
    local StatsBtn = Instance.new("TextButton")
    StatsBtn.Name = "StatsBtn"
    StatsBtn.Size = UDim2.new(0.9, 0, 0, 40)
    StatsBtn.Position = UDim2.new(0.05, 0, 0, 170)
    StatsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    StatsBtn.BorderSizePixel = 0
    StatsBtn.Font = Enum.Font.Gotham
    StatsBtn.Text = "Auto Stats: " .. (Settings.AutoStats and "ON" or "OFF")
    StatsBtn.TextColor3 = Settings.AutoStats and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
    StatsBtn.TextSize = 16
    StatsBtn.Parent = MainFrame
    
    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 8)
    StatsCorner.Parent = StatsBtn
    
    StatsBtn.MouseButton1Click:Connect(function()
        Settings.AutoStats = not Settings.AutoStats
        StatsBtn.Text = "Auto Stats: " .. (Settings.AutoStats and "ON" or "OFF")
        StatsBtn.TextColor3 = Settings.AutoStats and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
    end)
    
    -- Sea Events Toggle
    local SeaBtn = Instance.new("TextButton")
    SeaBtn.Name = "SeaBtn"
    SeaBtn.Size = UDim2.new(0.9, 0, 0, 40)
    SeaBtn.Position = UDim2.new(0.05, 0, 0, 220)
    SeaBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SeaBtn.BorderSizePixel = 0
    SeaBtn.Font = Enum.Font.Gotham
    SeaBtn.Text = "Sea Events: " .. (Settings.AutoSeaEvent and "ON" or "OFF")
    SeaBtn.TextColor3 = Settings.AutoSeaEvent and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
    SeaBtn.TextSize = 16
    SeaBtn.Parent = MainFrame
    
    local SeaCorner = Instance.new("UICorner")
    SeaCorner.CornerRadius = UDim.new(0, 8)
    SeaCorner.Parent = SeaBtn
    
    SeaBtn.MouseButton1Click:Connect(function()
        Settings.AutoSeaEvent = not Settings.AutoSeaEvent
        SeaBtn.Text = "Sea Events: " .. (Settings.AutoSeaEvent and "ON" or "OFF")
        SeaBtn.TextColor3 = Settings.AutoSeaEvent and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
        
        if Settings.AutoSeaEvent then
            self:StartSeaEvents()
        end
    end)
    
    -- Status Info
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 200)
    StatusLabel.Position = UDim2.new(0.05, 0, 0, 280)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    StatusLabel.BorderSizePixel = 0
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = string.format(
        "FessHub Advanced\n\n" ..
        "Level: %d\n" ..
        "World: %s\n" ..
        "Mode: %s\n" ..
        "Quest: %s\n\n" ..
        "Made with ❤️",
        LocalPlayer.Data.Level.Value,
        World1 and "Sea 1" or World2 and "Sea 2" or World3 and "Sea 3" or "?",
        Settings.FarmMode,
        Settings.AutoQuest and "Enabled" or "Disabled"
    )
    StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusLabel.TextSize = 14
    StatusLabel.TextYAlignment = Enum.TextYAlignment.Top
    StatusLabel.Parent = MainFrame
    
    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(0, 8)
    StatusCorner.Parent = StatusLabel
    
    print("[FessHub] UI Created!")
end

-- Return module
return FessHub:Initialize()
