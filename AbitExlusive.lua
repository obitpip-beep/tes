--[[
    OPah ICON — Delta Script v9 FINAL (Mesh Detector)
    - UI: Floating "BitszExlusive" -> Klik buka menu -> X tutup
    - Kebal: Nyawa 999 + Auto Refill (Anti Opah)
    - ESP: Deteksi semua bentuk 3D Kunci & Kode
    - Auto Equip + Teleport Instan (Nempel ke Kunci)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====== KAMUS NAMA (Buat jaga-jaga kalo ada namanya) ======
local COLOR_MAP = {
    blue = Color3.fromRGB(0, 150, 255), biru = Color3.fromRGB(0, 150, 255),
    red = Color3.fromRGB(255, 60, 60), merah = Color3.fromRGB(255, 60, 60),
    green = Color3.fromRGB(0, 255, 100), hijau = Color3.fromRGB(0, 255, 100),
    yellow = Color3.fromRGB(255, 230, 0), kuning = Color3.fromRGB(255, 230, 0),
    purple = Color3.fromRGB(170, 0, 255), ungu = Color3.fromRGB(170, 0, 255),
}
local CODE_KEYWORDS = {"kode", "code", "pascode", "password"}

-- ====== UI SYSTEM ======
local gui = Instance.new("ScreenGui")
gui.Name = "BitszExlusiveUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 130, 0, 30)
floatBtn.Position = UDim2.new(0, 20, 0, 20)
floatBtn.BackgroundTransparency = 1
floatBtn.Text = "BitszExlusive"
floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.TextStrokeTransparency = 0
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 18
floatBtn.Active = true
floatBtn.Draggable = true
floatBtn.Parent = gui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 240, 0, 220)
main.Position = UDim2.new(0, 20, 0, 60)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = main
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 24)
title.Position = UDim2.new(0, 8, 0, 4)
title.BackgroundTransparency = 1
title.Text = "BitszExlusive 🗿"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

floatBtn.MouseButton1Click:Connect(function()
    floatBtn.Visible = false
    main.Visible = true
end)
closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    floatBtn.Visible = true
end)

local function makeBtn(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 28)
    b.Position = UDim2.new(0, 8, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.AutoButtonColor = true
    b.Parent = main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local espBtn        = makeBtn("ESP Kunci&Kode: OFF 🚀", 34)
local invulnSelfBtn = makeBtn("Kebal Sendiri: OFF 🗿", 68)
local invulnTeamBtn = makeBtn("Kebal Teman: OFF 😈", 102)
local autoEqBtn     = makeBtn("Auto Equip & TP: OFF ⚡", 136)

-- ====== DETEKTOR KUNCI 3D (MESH & MODEL) ======
local function isKeyObject(inst)
    -- 1. Kalo nama ada key/kunci/code
    local lowerName = inst.Name:lower()
    if lowerName:find("key") or lowerName:find("kunci") or lowerName:find("code") or lowerName:find("kode") then
        return true, Color3.fromRGB(255, 255, 255) -- Warna putih default
    end

    -- 2. Cek apakah ini bentuk 3D unik (MeshPart / ada SpecialMesh)
    if inst:IsA("MeshPart") or inst:FindFirstChildOfClass("SpecialMesh") then
        -- Kasih warna sesuai nama object kalo ada
        for kw, col in pairs(COLOR_MAP) do
            if lowerName:find(kw, 1, true) then return true, col end
        end
        return true, Color3.fromRGB(0, 255, 100) -- Warna hijau kalo mesh gak diketahui namanya
    end

    -- 3. Kalo ini Model, cek apakah isinya ada MeshPart
    if inst:IsA("Model") then
        if inst:FindFirstChildWhichIsA("MeshPart") or inst:FindFirstChildWhichIsA("SpecialMesh") then
            return true, Color3.fromRGB(0, 255, 100)
        end
    end

    return false, nil
end

-- ====== ESP TRACER ======
local espEnabled = false
local tracers = {}
local espConns = {}

local function getPart(inst)
    if inst:IsA("BasePart") then return inst end
    if inst:IsA("Model") then return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart") end
    return nil
end

local function createTracer(inst, color)
    if tracers[inst] then return end
    local part = getPart(inst)
    if not part then return end
    
    local line = Drawing.new("Line")
    line.Thickness = 1.5; line.Transparency = 1; line.Color = color
    
    local label = Drawing.new("Text")
    label.Size = 14; label.Center = true; label.Outline = true; label.Color = color
    label.Text = inst.Name -- Tulisan otomatis ngikutin nama asli di game
    
    tracers[inst] = {line = line, label = label, part = part}
end

local function renderTracers()
    for inst, t in pairs(tracers) do
        if not espEnabled then t.line.Visible = false; t.label.Visible = false; continue end
        local part = t.part
        if not part or not part.Parent then
            local np = getPart(inst)
            if np then t.part = np; part = np else t.line.Visible = false; t.label.Visible = false; continue end
        end
        local cam = workspace.CurrentCamera
        local ok, screen = pcall(function() return cam:WorldToViewportPoint(part.Position) end)
        if not ok or screen.Z <= 0 then t.line.Visible = false; t.label.Visible = false; continue end
        local vp = cam.ViewportSize
        t.line.From = Vector2.new(vp.X / 2, vp.Y)
        t.line.To = Vector2.new(screen.X, screen.Y)
        t.line.Visible = true
        t.label.Position = Vector2.new(screen.X, screen.Y - 16)
        t.label.Visible = true
    end
end

local function scanESP()
    for _, d in ipairs(workspace:GetDescendants()) do
        local isKey, col = isKeyObject(d)
        if isKey then
            createTracer(d, col)
        end
    end
end

local function clearESP()
    for inst, t in pairs(tracers) do
        pcall(function() t.line:Remove() end)
        pcall(function() t.label:Remove() end)
    end
    tracers = {}
    for _, c in ipairs(espConns) do c:Disconnect() end
    espConns = {}
end

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP Kunci&Kode: " .. (espEnabled and "ON 🔥" or "OFF 🚀")
    if espEnabled then
        scanESP()
        table.insert(espConns, workspace.DescendantAdded:Connect(function(d)
            if not espEnabled then return end
            local isKey, col = isKeyObject(d)
            if isKey then createTracer(d, col) end
        end))
        table.insert(espConns, RunService.RenderStepped:Connect(renderTracers))
    else
        clearESP()
    end
end)

-- ====== KEBAL: NYAWA 999 ======
local invulnSelf = false
local invulnTeam = false
local protected = {}
local BIG_HP = 999

local function lockChar(char)
    if not char then return end
    protected[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = BIG_HP
        hum.Health = BIG_HP
        hum.HealthChanged:Connect(function(h)
            if protected[char] and h < BIG_HP then hum.Health = BIG_HP end
        end)
        hum.Died:Connect(function()
            if protected[char] and char.Parent then task.wait(0); hum.Health = BIG_HP end
        end)
    end
end

local function unlockChar(char)
    if not char then return end
    protected[char] = nil
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = 100
        if hum.Health > 100 then hum.Health = 100 end
    end
end

invulnSelfBtn.MouseButton1Click:Connect(function()
    invulnSelf = not invulnSelf
    invulnSelfBtn.Text = "Kebal Sendiri: " .. (invulnSelf and "ON 💥" or "OFF 🗿")
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if invulnSelf then lockChar(char) else unlockChar(char) end
end)

invulnTeamBtn.MouseButton1Click:Connect(function()
    invulnTeam = not invulnTeam
    invulnTeamBtn.Text = "Kebal Teman: " .. (invulnTeam and "ON 🔥" or "OFF 😈")
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if invulnTeam then lockChar(plr.Character) else unlockChar(plr.Character) end
        end
    end
end)

-- ====== AUTO EQUIP & TELEPORT ======
local autoEqEnabled = false

autoEqBtn.MouseButton1Click:Connect(function()
    autoEqEnabled = not autoEqEnabled
    autoEqBtn.Text = "Auto Equip & TP: " .. (autoEqEnabled and "ON ⚡" or "OFF")
end)

local function forceEquip()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not backpack then return end
    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if n:find("key") or n:find("kunci") or n:find("code") or n:find("kode") then
                pcall(function() item.Parent = char end)
            end
        end
    end
end

local function tpToNearest()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local nearest, dist = nil, math.huge
    for inst, t in pairs(tracers) do
        if t.part and t.part.Parent then
            local d = (hrp.Position - t.part.Position).Magnitude
            if d < dist then nearest = t.part; dist = d end
        end
    end
    
    -- Kalo jarak di bawah 5000 stud, teleport!
    if nearest and dist < 5000 then
        hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
    end
end

RunService.Heartbeat:Connect(function()
    if invulnSelf and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < BIG_HP then hum.Health = BIG_HP end
    end
    if invulnTeam then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health < BIG_HP then hum.Health = BIG_HP end
            end
        end
    end
    if autoEqEnabled then
        forceEquip()
        tpToNearest()
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    if invulnSelf then lockChar(char) end
end)

task.spawn(function() task.wait(2); scanESP() end)

print("[BitszExlusive v9] Loaded ✅")
