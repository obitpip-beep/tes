local baseURL = "https://raw.githubusercontent.com/obitpip-beep/tes/refs/heads/main/"

local function loadModule(fileName)
    local ok, source = pcall(game.HttpGet, game, baseURL .. fileName)
    if ok and type(source) == "string" and source ~= "" then
        local chunk = loadstring(source)
        if chunk then pcall(chunk) end
    end
    task.wait(0.5)
end

loadModule("ui1.lua")
loadModule("ui2.lua")
loadModule("logic.lua")

print("[Patrick AI] System Loaded!")
