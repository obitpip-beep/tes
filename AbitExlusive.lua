--[[
    OPah ICON — Delta Script v4
    - ESP HANYA kunci (biru/merah/ungu/hijau/kuning) + kode
    - Kebal nyawa lock (max 2, gak turun)
    - Kebal Sendiri / Teman
    - Menu draggable hitam
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====== WARNA KUNCI (cuma ini yang di-ESP) ======
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
main.Size = UDim2.new(0, 210, 0, 165)
main.Position = UDim2.new(0, 20, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 6)

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
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local espBtn        = makeBtn("ESP Kunci&Kode: OFF 🚀", 30)
local invulnSelfBtn = makeBtn("Kebal Sendiri: OFF 🗿", 64)
local invulnTeamBtn = makeBtn("Kebal Teman: OFF 😈", 98)

-- ====== FILTER ESP (STRICT) ======
local function matchKeyColor(name)
    local lower = name:lower()
    for colorName, col in pairs(KEY_COLORS) do
        if lower:find(colorName, 1, true) then return col end
    end
    return nil
end

local function matchCode(name)
    local lower = name:lower()
    for _, kw in ipairs(CODE_KEYWORDS) do
        if lower:find(kw, 1, true) then return true end
    end
    return false
end

-- Cuma 2 kondisi ini yang lolos
local function shouldESP(name)
    if matchKeyColor(name) then return true end
    if matchCode(name) then return true end
    return false
end

local function colorFor(name)
    local c = matchKeyColor(name)
    if c then return c end
    if matchCode(name) then return Color3.fromRGB(255, 255, 255) end
    return nil
end

-- ====== ESP MULTI TRACER ======
local espEnabled = false
local tracers = {}
local espConns = {}

local function getPart(inst)
    if inst:IsA("BasePart") then return inst end
    if inst:IsA("Model") then
        return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart")
    end
    if inst:IsA("Tool") then
        return inst:FindFirstChildWhichIsA("BasePart") or inst:FindFirstChildWhichIsA("Handle")
    end
    return nil
end

local function createTracer(inst, color)
    if tracers[inst] then return end
    local part = getPart(inst)
    if not part then return end

    local line = Drawing.new("Line")
    line.Thickness = 1.5
    line.Transparency = 1
    line.Color = color

    local label = Drawing.new("Text")
    label.Size = 14
    label.Center = true
    label.Outline = true
    label.Color = color
    label.Text = inst.Name

    tracers[inst] = {line = line, label = label, part = part}
end

local function renderTracers()
    for inst, t in pairs(tracers) do
        if not espEnabled then
            t.line.Visible = false; t.label.Visible = false; continue
        end
        local part = t.part
        if not part or not part.Parent then
            local np = getPart(inst)
            if np then t.part = np; part = np
            else t.line.Visible = false; t.label.Visible = false; continue end
        end
        local cam = workspace.CurrentCamera
        local ok, screen = pcall(function() return cam:WorldToViewportPoint(part.Position) end)
        if not ok or screen.Z <= 0 then
            t.line.Visible = false; t.label.Visible = false; continue
        end
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
        if (d:IsA("BasePart") or d:IsA("Model") or d:IsA("Tool")) and shouldESP(d.Name) then
            createTracer(d, colorFor(d.Name))
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
            if (d:IsA("BasePart") or d:IsA("Model") or d:IsA("Tool")) and shouldESP(d.Name) then
                createTracer(d, colorFor(d.Name))
            end
        end))
        table.insert(espConns, RunService.RenderStepped:Connect(renderTracers))
    else
        clearESP()
    end
end)

-- ====== KEBAL BYPASS ======
local invulnSelf = false
local invulnTeam = false
local protected = {}
local originalHealth = {}

local function lockChar(char)
    if not char then return end
    protected[char] = true
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if not originalHealth[char] then originalHealth[char] = hum.MaxHealth end
        local baseHP = originalHealth[char]
        hum.MaxHealth = baseHP
        hum.Health = baseHP
        hum.HealthChanged:Connect(function(h)
            if protected[char] and h < baseHP then hum.Health = baseHP end
        end)
        hum.Died:Connect(function()
            if protected[char] and char.Parent then task.wait(0); hum.Health = baseHP end
        end)
    end
    local function ensureFF()
        local ff = char:FindFirstChildOfClass("ForceField")
        if not ff then ff = Instance.new("ForceField"); ff.Visible = false; ff.Parent = char
        else ff.Visible = false end
    end
    ensureFF()
    char.ChildAdded:Connect(function(c)
        if c:IsA("ForceField") and protected[char] then c.Visible = false end
        if c:IsA("Tool") and protected[char] then
            local n = c.Name:lower()
            if n:find("opah") or n:find("kill") or n:find("damage") then
                task.defer(function() pcall(function() c:Destroy() end) end)
            end
        end
    end)
    char.DescendantAdded:Connect(function(d)
        if not protected[char] then return end
        if d:IsA("BasePart") then
            local n = d.Name:lower()
            if n:find("kill") or n:find("opah") or n:find("damage") or n:find("hurt") then
                task.defer(function() if d and d.Parent then d:Destroy() end end)
            end
        end
    end)
end

local function unlockChar(char)
    if not char then return end
    protected[char] = nil
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local base = originalHealth[char] or 2
        hum.MaxHealth = base
        hum.Health = math.min(hum.Health, base)
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

RunService.Heartbeat:Connect(function()
    if invulnSelf and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local base = originalHealth[LocalPlayer.Character] or 2
        if hum and hum.Health < base then hum.Health = base end
    end
    if invulnTeam then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                local base = originalHealth[plr.Character] or 2
                if hum and hum.Health < base then hum.Health = base end
            end
        end
    end
end)

task.spawn(function() task.wait(2); scanESP() end)

print("[OpahIcon v4] Loaded ✅")
