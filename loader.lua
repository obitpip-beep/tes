local baseURL = "https://raw.githubusercontent.com/obitpip-beep/tes/refs/heads/main/"

local function loadFile(name)
    local ok, src = pcall(game.HttpGet, game, baseURL .. name)
    if ok and type(src) == "string" and src ~= "" then
        local func = loadstring(src)
        if func then pcall(func) end
    end
end

-- 1. Proses Bypass (Backend)
loadFile("bypass.lua")

-- 2. Jeda 5 Detik (Proses Lag)
task.wait(5)

-- 3. Munculin Menu
loadFile("logic.lua")
