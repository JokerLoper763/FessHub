#  FessHub Installation Guide

## Quick Start (1 minute)

### Method 1: Auto-Load (Recommended)
Copy and paste this into your executor:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))()
```

That's it! FessHub will auto-detect your game and load the appropriate script.

---

## Custom Settings

### Blox Fruits
```lua
local Settings = {
    Team = "Pirates",        -- or "Marines"
    AutoFarm = true,
    BringMobs = true,
    FastAttack = true,
    AntiAFK = true
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/FessHub/main/main.luau"))(Settings)
```

---

## Supported Executors

 **Tested and Working:**
- Solara
- Wave
- Fluxus
- Synapse X
- Script-Ware
- KRNL

 **Partially Working:**
- Oxygen U (BringMobs disabled)
- Delta (some features limited)

 **Not Supported:**
- Mobile executors (UI issues)
- Very old executors (missing functions)

---

## Requirements

-  HTTP requests enabled
-  Loadstring enabled
-  Basic executor functions
-  For BringMobs: sethiddenproperty() support

---

## Troubleshooting

### "Failed to fetch" error
**Solution:** Enable HTTP requests in your executor settings

### "Syntax error" message
**Solution:** Update your executor to the latest version

### UI not showing
**Solution:** Press RightShift to toggle UI, or rejoin the game

### BringMobs not working
**Solution:** Your executor doesn't support sethiddenproperty(). Disable BringMobs:
```lua
Settings.BringMobs = false
```

### Getting kicked/banned
**Solution:** 
1. Disable BringMobs
2. Disable FastAttack
3. Use lower distances (AttackDistance = 10)
4. Don't farm in public servers

---

## Features by Game

### Blox Fruits (v1.0.0)
-  Auto Farm Level
-  Bring Mobs
-  Fast Attack
-  Anti-AFK
-  Auto Quest (coming soon)
-  Auto Boss (coming soon)
-  Auto Fruit (coming soon)

### Meme Sea (v1.0.0)
-  In Development

---

## Safety Tips

1. **Don't use in public servers** - Less likely to be reported
2. **Use VPN** - Protect your IP address
3. **Disable risky features** - BringMobs, FastAttack on public
4. **Use alt accounts** - Don't risk your main account
5. **Stay updated** - Join Discord for safety updates

---

## Getting Help

**Discord Server:** discord.gg/fesshub
-  General chat
-  Support channel
-  Updates & announcements
-  Bug reports

**GitHub Issues:** github.com/YourUsername/FessHub/issues

---

## Keybinds

- **RightShift** - Toggle UI
- **LeftControl** - Toggle Auto Farm (when UI hidden)

---

**Version:** 1.0.0
**Last Updated:** December 7, 2025
