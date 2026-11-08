--[[
    OPah ICON — Delta Script v2
    - Kebal BYPASS (gak kena opah, nyawa aman)
    - Kebal Sendiri / Kebal Semua Teman
    - ESP Tracer ke Kunci (biru/merah/ungu/hijau/kuning) & Kode
    - Menu draggable, background hitam
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====== CONFIG WARNA KUNCI ======
local KEY_COLORS = {
    biru    = Color3.fromRGB(0, 150, 255),
    merah   = Color3.fromRGB(255, 60, 60),
    ungu    = Color3.fromRGB(170, 0, 255),
    hijau   = Color3.fromRGB(0, 255, 100),
    kuning  = Color3.fromRGB(255, 230, 0),
}
local CODE_KEYWORDS = {"kode", "code", "password"}

-- ====== UI ======
local gui = Instance.new("ScreenGui")
gui.Name = "OpahIconUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 200, 0, 160)
main.Position = UDim2.new(0, 20, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 24)
title.BackgroundTransparency = 1
title.Text = "OPAH ICON 🗿"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = main

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
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = b
    return b
end

local espBtn        = makeBtn("ESP Tracer: OFF 🚀", 30)
local invulnSelfBtn = makeBtn("Kebal Sendiri: OFF 🗿", 64)
local invulnTeamBtn = makeBtn("Kebal Teman: OFF 😈", 98)

-- ====== ESP TRACER ======
local espEnabled = false
local tracers = {}
local espConns = {}

local function getKeyColor(name)
    local lower = name:lower()
    for colorName, col in pairs(KEY_COLORS) do
        if lower:find(colorName) then return col end
    end
    return nil
end

local function isCode(name)
    local lower = name:lower()
    for _, kw in ipairs(CODE_KEYWORDS) do
        if lower:find(kw) then return true end
    end
    return false
end

local function getTargetPart(inst)
    if inst:IsA("BasePart") then return inst end
    if inst:IsA("Model") then
        return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end

local function createTracer(inst, color)
    if tracers[inst] then return end
    local part = getTargetPart(inst)
    if not part then return end

    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Transparency = 1
    line.Color = color
    line.Visible = false

    local label = Drawing.new("Text")
    label.Size = 14
    label.Center = true
    label.Outline = true
    label.Color = color
    label.Transparency = 1
    label.Text = inst.Name
    label.Visible = false

    tracers[inst] = {line = line, label = label, part = part}

    local conn = RunService.RenderStepped:Connect(function()
        if not espEnabled then
            line.Visible = false
            label.Visible = false
            return
        end
        local p = tracers[inst]
        if not p or not p.part or not p.part.Parent then
            line.Visible = false
            label.Visible = false
            return
        end
        local ok, screen = pcall(function()
            return workspace.CurrentCamera:WorldToViewportPoint(p.part.Position)
        end)
        if not ok or screen.Z <= 0 then
            line.Visible = false
            label.Visible = false
            return
        end
        local vp = workspace.CurrentCamera.ViewportSize
        line.From = Vector2.new(vp.X / 2, vp.Y)
        line.To = Vector2.new(screen.X, screen.Y)
        line.Visible = true
        label.Position = Vector2.new(screen.X, screen.Y - 16)
        label.Visible = true
    end)
    table.insert(espConns, conn)
end

local function scanESP()
    for _, d in ipairs(workspace:GetDescendants()) do
        local col = nil
        if d:IsA("BasePart") or d:IsA("Model") then
            col = getKeyColor(d.Name)
            if not col and isCode(d.Name) then
                col = Color3.fromRGB(255, 255, 255)
            end
            if col then createTracer(d, col) end
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
    espBtn.Text = "ESP Tracer: " .. (espEnabled and "ON 🔥" or "OFF 🚀")
    if espEnabled then
        scanESP()
        local c = workspace.DescendantAdded:Connect(function(d)
            if not espEnabled then return end
            if d:IsA("BasePart") or d:IsA("Model") then
                local col = getKeyColor(d.Name)
                if not col and isCode(d.Name) then col = Color3.fromRGB(255,255,255) end
                if col then createTracer(d, col) end
            end
        end)
        table.insert(espConns, c)
    else
        clearESP()
    end
end)

-- ====== MODE KEBAL BYPASS ======
local invulnSelf = false
local invulnTeam = false
local protected = {}

local function lockChar(char)
    if not char then return end
    protected[char] = true

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.HealthChanged:Connect(function()
            if protected[char] then
                hum.Health = math.huge
            end
        end)
        hum.Died:Connect(function()
            if protected[char] and char.Parent then
                hum.Health = math.huge
            end
        end)
    end

    -- ForceField permanen biar kill brick/opah gak ngaruh
    local ff = char:FindFirstChildOfClass("ForceField")
    if not ff then
        ff = Instance.new("ForceField")
        ff.Visible = false
        ff.Parent = char
    end
    ff.Visible = false

    -- Hapus ForceField baru yang bisa dateng (kadang game ngasih buat bypass)
    char.ChildAdded:Connect(function(c)
        if c:IsA("ForceField") and protected[char] then
            c.Visible = false
        end
    end)

    -- Hapus part kill / opah yang nempel
    char.DescendantAdded:Connect(function(d)
        if not protected[char] then return end
        if d:IsA("BasePart") and (d.Name:lower():find("kill") or d.Name:lower():find("opah") or d.Name:lower():find("damage")) then
            task.defer(function() if d and d.Parent then d:Destroy() end end)
        end
    end)
end

local function unlockChar(char)
    if not char then return end
    protected[char] = nil
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = 100
        hum.Health = math.min(hum.Health, 100)
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
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                if invulnTeam then lockChar(char) else unlockChar(char) end
            end
        end
    end
end)

-- Auto reapply on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    if invulnSelf then lockChar(char) end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        if invulnTeam then lockChar(char) end
    end)
end)

-- Loop jaga-jaga (opah kadang bypass HealthChanged)
RunService.Heartbeat:Connect(function()
    if invulnSelf and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end
    if invulnTeam then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
            end
        end
    end
end)

-- Init scan
task.spawn(function()
    task.wait(2)
    scanESP()
end)

print("[OpahIcon v2] Loaded ✅")
