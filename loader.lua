-- ==========================================
-- PATRICK AI - LOADER
-- ==========================================

-- Copy link RAW dari file dtyhub.lua lu, paste di bawah ini:
local URL = "https://raw.githubusercontent.com/obitpip-beep/tes/refs/heads/main/dtyhub.lua"

-- Notifikasi Loading
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Patrick AI",
    Text = "Memuat Script Utama...",
    Duration = 3
})

-- Eksekusi Script
local ok, source = pcall(game.HttpGet, game, URL) 
    
if ok and type(source) == "string" and source ~= "" then 
    local chunk = loadstring(source) 
    if chunk then 
        chunk() 
        print("[Patrick AI] Sukses load script!")
    else
        warn("[Patrick AI] Gagal compile script.")
    end
else
    warn("[Patrick AI] Gagal load dari GitHub.")
end
