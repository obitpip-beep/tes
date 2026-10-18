-- Loader Anti-Gagal buat Prof Bitsz 'Dty
local url = "https://raw.githubusercontent.com/obitpip-beep/tes/main/dty.lua"

-- Coba ambil script pakai HttpGet biasa
local success, scriptCode = pcall(function()
    return game:HttpGet(url)
end)

if success and type(scriptCode) == "string" and scriptCode ~= "" then
    -- Eksekusi scriptnya
    local func, err = loadstring(scriptCode)
    if func then
        func()
        print("[Patrick AI] Loader Sukses! Script Jalan.")
    else
        warn("[Patrick AI] Gagal nge-load script: " .. tostring(err))
    end
else
    -- Kalau gagal HttpGet, coba pake fungsi bawaan game
    task.spawn(function()
        local chunk = game:HttpGet(url)
        loadstring(chunk)()
    end)
end
