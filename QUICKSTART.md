#  Quick Start Guide

## What is FessHub?
FessHub is a powerful, modern automation framework for Roblox games. It's completely free, safe, and easy to use!

## 30-Second Setup

1. **Open your executor** (Solara, Wave, Fluxus, etc.)

2. **Copy & paste this code:**
   ```lua
   loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))()
   ```

3. **Execute!** FessHub will auto-detect your game and load

4. **Done!** A UI will appear. Click "Auto Farm: OFF" to start farming

## Current Features (v1.0.0)

 **Blox Fruits:**
- Auto Farm (kill nearest enemies)
- Bring Mobs (teleport enemies to you)
- Fast Attack (3x speed)
- Anti-AFK (never get kicked)
- Smart distance control

 **Meme Sea:**
- Coming soon!

## Controls

- **RightShift** - Toggle UI visibility
- **Mouse** - Drag UI window anywhere

## Safety Tips

 **IMPORTANT:**
1. Test on ALT ACCOUNTS first!
2. Don't use in public servers
3. Disable "Bring Mobs" if you get detected
4. Lower attack distance if too risky

## Custom Settings Example

```lua
local Settings = {
    Team = "Pirates",      -- or "Marines"
    AutoFarm = true,       -- Start farming immediately
    BringMobs = true,      -- Risky but faster
    FastAttack = true,     -- Kill faster
    AttackDistance = 15    -- Distance from mob
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))(Settings)
```

## Need Help?

-  Read **README.md** for full documentation
-  Check **EXAMPLES.lua** for more code samples
-  See **INSTALL.md** if you have errors
-  Join **discord.gg/fesshub** for live support

## What's Next?

Coming in v1.1.0 (December 2025):
-  Auto Quest system
-  Boss farming
-  Auto buy items
-  Multiple UI themes

---

**Made with  by FessHub Team**
**Version 1.0.0 | December 2025**
