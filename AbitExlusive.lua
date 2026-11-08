--[[
    OPah ICON — Delta Script
    Features:
    - ESP Kunci & Kode (highlight object)
    - Mode Kebal Sendiri
    - Mode Kebal Semua Teman 1 Server
    UI: tanpa background, cuma tombol
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ====== CONFIG ======
local KEY_KEYWORDS = {"kunci", "key"}
local CODE_KEYWORDS = {"kode", "code", "password"}

-- ====== UI (NO BACKGROUND) ======
local gui = Instance.new("ScreenGui")
gui.Name = "OpahIconUI"
gui.ResetOnSpawn = false
gui.Parent = (pcall(function() return CoreGui end) and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

local function makeButton(text, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 30)
    btn.Position = pos
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextStrokeTransparency = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = gui
    return btn
end

local espBtn = makeButton("ESP: OFF 🚀", UDim2.new(0, 10, 0, 10))
local invulnSelfBtn = makeButton("Kebal Sendiri: OFF 🗿", UDim2.new(0, 10, 0, 45))
local invulnTeamBtn = makeButton("Kebal Teman: OFF 😈", UDim2.new(0, 10, 0, 80))

-- ====== ESP KUNCI & KODE ======
local espEnabled = false
local espObjects = {}

local function isTarget(inst)
    local name = inst.Name:lower()
    for _, kw in ipairs(KEY_KEYWORDS) do
        if name:find(kw) then return true end
    end
    for _, kw in ipairs(CODE_KEYWORDS) do
        if name:find(kw) then return true end
    end
    return false
end

local function addESP(inst)
    if not inst:IsA("BasePart") then return end
    if espObjects[inst] then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0, 255, 100)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = inst
    hl.Parent = gui
    espObjects[inst] = hl
end

local function clearESP()
    for inst, hl in pairs(espObjects) do
        if hl then hl:Destroy() end
    end
    espObjects = {}
end

local function scanMap()
    for _, d in ipairs(workspace:GetDescendants()) do
        if isTarget(d) then addESP(d) end
    end
end

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: " .. (espEnabled and "ON 🔥" or "OFF 🚀")
    if espEnabled then
        scanMap()
        workspace.DescendantAdded:Connect(function(d)
            if espEnabled and isTarget(d) then addESP(d) end
        end)
    else
        clearESP()
    end
end)

-- ====== MODE KEBAL ======
local invulnSelf = false
local invulnTeam = false
local protectedCache = {}

local function protectChar(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = hum.MaxHealth
        protectedCache[char] = true
        char.ChildAdded:Connect(function(c)
            if c:IsA("ForceField") then c:Destroy() end
        end)
    end
end

local function unprotect(char)
    protectedCache[char] = nil
end

-- Self
invulnSelfBtn.MouseButton1Click:Connect(function()
    invulnSelf = not invulnSelf
    invulnSelfBtn.Text = "Kebal Sendiri: " .. (invulnSelf and "ON 💥" or "OFF 🗿")
    if invulnSelf then
        protectChar(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
    else
        if LocalPlayer.Character then unprotect(LocalPlayer.Character) end
    end
end)

-- Team
invulnTeamBtn.MouseButton1Click:Connect(function()
    invulnTeam = not invulnTeam
    invulnTeamBtn.Text = "Kebal Teman: " .. (invulnTeam and "ON 🔥" or "OFF 😈")
    if invulnTeam then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                protectChar(plr.Character)
            end
        end
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then unprotect(plr.Character) end
        end
    end
end)

-- Auto re-protect on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    if invulnSelf then protectChar(char) end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if invulnTeam then protectChar(char) end
    end)
end)

-- Loop jaga health
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

-- Scan awal
task.spawn(function()
    task.wait(2)
    scanMap()
end)

print("[OpahIcon] Loaded ✅")
