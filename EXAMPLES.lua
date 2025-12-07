-- FessHub Examples
-- How to use FessHub in different scenarios

print("=== FessHub Usage Examples ===")

-- Example 1: Basic Load (Auto-detect game)
print("\n1. Basic Load:")
print([[
loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))()
]])

-- Example 2: Blox Fruits with Custom Settings
print("\n2. Blox Fruits with Settings:")
print([[
local Settings = {
    Team = "Pirates",
    AutoFarm = true,
    BringMobs = true,
    FastAttack = true,
    AttackDistance = 15,
    SelectWeapon = "Melee",
    AutoHaki = true,
    AntiAFK = true
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))(Settings)
]])

-- Example 3: Marines Team
print("\n3. Marines Team:")
print([[
local Settings = {
    Team = "Marines",
    AutoFarm = true,
    AutoQuest = true
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))(Settings)
]])

-- Example 4: Boss Farming
print("\n4. Boss Farming:")
print([[
local Settings = {
    AutoBoss = true,
    SelectBoss = "All",
    BringMobs = false
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))(Settings)
]])

-- Example 5: Fruit Farming
print("\n5. Fruit Collection:")
print([[
local Settings = {
    AutoFruit = true,
    FruitSniper = true
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))(Settings)
]])

-- Example 6: Mastery Grinding
print("\n6. Mastery Grinding:")
print([[
local Settings = {
    AutoMastery = true,
    SelectWeapon = "Sword",
    BringMobs = true
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))(Settings)
]])

print("\n=== All Settings Reference ===")
print([[
Settings = {
    -- Team Settings
    Team = "Pirates",              -- "Pirates" or "Marines"
    
    -- Farm Settings
    AutoFarm = false,              -- Auto farm nearest enemies
    AutoQuest = false,             -- Auto take and complete quests
    BringMobs = false,             -- Bring mobs to you (risky)
    FastAttack = false,            -- Spam attack (fast kill)
    AttackDistance = 15,           -- Distance from enemy
    
    -- Weapon Settings
    SelectWeapon = "Melee",        -- "Melee", "Sword", "Gun", "Fruit"
    
    -- Boss Settings
    AutoBoss = false,              -- Auto farm bosses
    SelectBoss = "All",            -- "All" or specific boss name
    
    -- Fruit Settings
    AutoFruit = false,             -- Auto collect fruits
    FruitSniper = false,           -- Snipe fruits from other servers
    
    -- Mastery Settings
    AutoMastery = false,           -- Farm for mastery
    
    -- Misc Settings
    AutoHaki = true,               -- Auto enable Buso Haki
    AutoObservationHaki = true,    -- Auto enable Ken Haki
    AntiAFK = true,                -- Prevent AFK kick
    WhiteScreen = false,           -- Hide game for performance
}
]])

print("\n=== Tips ===")
print("1. Use BringMobs carefully - it can trigger anti-cheat")
print("2. FastAttack may cause lag on weak executors")
print("3. Always enable AntiAFK to prevent disconnects")
print("4. Join discord.gg/fesshub for support and updates")
