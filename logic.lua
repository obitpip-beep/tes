local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("RobloxMainUI") then PlayerGui.RobloxMainUI:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxMainUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ==========================================
-- SMART ICON (FOTO PROF BITSZ)
-- ==========================================
local FloatingIcon = Instance.new("TextButton", ScreenGui)
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Size = UDim2.new(0, 60, 0, 60)
FloatingIcon.Position = UDim2.new(0.85, 0, 0.7, 0)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
FloatingIcon.Text = "⚙️" -- Emoji fallback
FloatingIcon.TextSize = 35
FloatingIcon.Font = Enum.Font.GothamBold
FloatingIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingIcon.ClipsDescendants = true
Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(1, 0)

local UIStrokeIcon = Instance.new("UIStroke", FloatingIcon)
UIStrokeIcon.Thickness = 3
UIStrokeIcon.Color = Color3.fromRGB(255, 255, 255)

-- Lazy Load Foto (Biar gak crash)
task.delay(1, function()
    pcall(function()
        local IconImage = Instance.new("ImageLabel", FloatingIcon)
        IconImage.Size = UDim2.new(1, 0, 1, 0)
        IconImage.BackgroundTransparency = 1
        IconImage.Image = "rbxassetid://91271428534324" -- ID FOTO PROF
        IconImage.ScaleType = Enum.ScaleType.Crop
        FloatingIcon.Text = "" -- Hapus emoji kalau foto berhasil
    end)
end)

-- MENU UTAMA
local MainGUI = Instance.new("Frame", ScreenGui)
MainGUI.Size = UDim2.new(0, 380, 0, 300)
MainGUI.Position = UDim2.new(0.5, -190, 0.5, -150)
MainGUI.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainGUI.Visible = false
MainGUI.Active = true
MainGUI.Draggable = true
Instance.new("UICorner", MainGUI).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("Frame", MainGUI)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PATRICK AI | MODULAR BYPASS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- TAB NAVIGASI
local TabFrame = Instance.new("Frame", MainGUI)
TabFrame.Size = UDim2.new(1, -20, 0, 30)
TabFrame.Position = UDim2.new(0, 10, 0, 45)
TabFrame.BackgroundTransparency = 1
local function CreateTab(text, xPos)
    local btn = Instance.new("TextButton", TabFrame)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end
local TabPlayer = CreateTab("Player", 0)
local TabVisual = CreateTab("Visual", 85)
local TabAuto = CreateTab("Auto", 170)
local TabMisc = CreateTab("Misc", 255)

-- CONTENT
local Content = Instance.new("ScrollingFrame", MainGUI)
Content.Size = UDim2.new(1, -20, 1, -85)
Content.Position = UDim2.new(0, 10, 0, 80)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 3
local PagePlayer = Instance.new("Frame", Content); PagePlayer.Size = UDim2.new(1, 0, 1, 0); PagePlayer.BackgroundTransparency = 1; PagePlayer.Visible = true
local PageVisual = Instance.new("Frame", Content); PageVisual.Size = UDim2.new(1, 0, 1, 0); PageVisual.BackgroundTransparency = 1; PageVisual.Visible = false
local PageAuto = Instance.new("Frame", Content); PageAuto.Size = UDim2.new(1, 0, 1, 0); PageAuto.BackgroundTransparency = 1; PageAuto.Visible = false
local PageMisc = Instance.new("Frame", Content); PageMisc.Size = UDim2.new(1, 0, 1, 0); PageMisc.BackgroundTransparency = 1; PageMisc.Visible = false

local function SwitchTab(tabBtn, page)
    TabPlayer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabVisual.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabAuto.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabMisc.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    PagePlayer.Visible = false; PageVisual.Visible = false; PageAuto.Visible = false; PageMisc.Visible = false
    page.Visible = true
end
TabPlayer.MouseButton1Click:Connect(function() SwitchTab(TabPlayer, PagePlayer) end)
TabVisual.MouseButton1Click:Connect(function() SwitchTab(TabVisual, PageVisual) end)
TabAuto.MouseButton1Click:Connect(function() SwitchTab(TabAuto, PageAuto) end)
TabMisc.MouseButton1Click:Connect(function() SwitchTab(TabMisc, PageMisc) end)
SwitchTab(TabPlayer, PagePlayer)

-- STEAL GUI
local StealGUI = Instance.new("Frame", ScreenGui)
StealGUI.Size = UDim2.new(0, 350, 0, 280)
StealGUI.Position = UDim2.new(0.5, -175, 0.5, -140)
StealGUI.BackgroundColor3 = Color3.fromRGB(20, 10, 25)
StealGUI.Visible = false
StealGUI.Active = true
StealGUI.Draggable = true
Instance.new("UICorner", StealGUI).CornerRadius = UDim.new(0, 10)
local StealHeader = Instance.new("Frame", StealGUI)
StealHeader.Size = UDim2.new(1, 0, 0, 40)
StealHeader.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
Instance.new("UICorner", StealHeader).CornerRadius = UDim.new(0, 10)
local StealTitle = Instance.new("TextLabel", StealHeader)
StealTitle.Size = UDim2.new(1, -20, 1, 0)
StealTitle.Position = UDim2.new(0, 15, 0, 0)
StealTitle.BackgroundTransparency = 1
StealTitle.Text = "👑 STEAL PANEL"
StealTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
StealTitle.Font = Enum.Font.GothamBold
StealTitle.TextSize = 14
StealTitle.TextXAlignment = Enum.TextXAlignment.Left
local StealClose = Instance.new("TextButton", StealHeader)
StealClose.Size = UDim2.new(0, 30, 0, 30)
StealClose.Position = UDim2.new(1, -35, 0, 5)
StealClose.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
StealClose.Text = "X"
StealClose.TextColor3 = Color3.fromRGB(255, 255, 255)
StealClose.Font = Enum.Font.GothamBold
Instance.new("UICorner", StealClose).CornerRadius = UDim.new(0, 6)
local StealContent = Instance.new("ScrollingFrame", StealGUI)
StealContent.Size = UDim2.new(1, -20, 1, -50)
StealContent.Position = UDim2.new(0, 10, 0, 45)
StealContent.BackgroundTransparency = 1
StealContent.ScrollBarThickness = 3

FloatingIcon.MouseButton1Click:Connect(function() MainGUI.Visible = not MainGUI.Visible; StealGUI.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() MainGUI.Visible = false end)
StealClose.MouseButton1Click:Connect(function() StealGUI.Visible = false end)

-- LOGIC STATE
_G.State = {SpeedHack=false, JumpHack=false, Fly=false, Noclip=false, AutoSteal=false, AutoFarm=false, AutoPrompt=false, AutoClick=false, AntiVoid=false}
_G.SpeedVal = 65
_G.JumpVal = 130
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
end)

-- LOOP FITUR
task.spawn(function()
    while task.wait(0.1) do
        if hum then
            if _G.State.SpeedHack then pcall(function() hum.WalkSpeed = _G.SpeedVal end) end
            if _G.State.JumpHack then pcall(function() hum.JumpPower = _G.JumpVal end) end
        end
    end
end)

-- FLY
local flyVel, flyGyro
local function toggleFly(state)
    if state then
        pcall(function()
            flyVel = Instance.new("BodyVelocity", hrp); flyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9); flyVel.Velocity = Vector3.zero
            flyGyro = Instance.new("BodyGyro", hrp); flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9); flyGyro.CFrame = hrp.CFrame
            task.spawn(function()
                while _G.State.Fly and hrp.Parent do
                    flyVel.Velocity = hum.MoveDirection * 60
                    if hum.MoveDirection.Magnitude > 0 then flyGyro.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + hum.MoveDirection) end
                    task.wait()
                end
                if flyVel then flyVel:Destroy() end
                if flyGyro then flyGyro:Destroy() end
            end)
        end)
    else
        pcall(function()
            if flyVel then flyVel:Destroy() end
            if flyGyro then flyGyro:Destroy() end
        end)
    end
end

-- AUTO STEAL
task.spawn(function()
    while task.wait(0.3) do
        if _G.State.AutoSteal then
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled then
                        local txt = string.lower(v.Parent.Name .. " " .. v.ActionText)
                        if txt:find("divine") or txt:find("eternal") or txt:find("secret") or txt:find("egg") or txt:find("fruit") then
                            fireproximityprompt(v)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end
end)

-- AUTO LAINNYA
task.spawn(function() while task.wait(0.5) do if _G.State.AutoPrompt then pcall(function() for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("ProximityPrompt") and v.Enabled then fireproximityprompt(v) end end end) end end end)
task.spawn(function() while task.wait(1) do if _G.State.AutoFarm and hrp then pcall(function() for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and (v.Name:lower():find("egg") or v.Name:lower():find("spawn") or v.Name:lower():find("apple")) then hrp.CFrame = v.CFrame + Vector3.new(0,3,0); task.wait(0.2) end end end) end end end)
task.spawn(function() while task.wait(0.5) do if _G.State.AntiVoid and hrp and hrp.Position.Y < -50 then pcall(function() hrp.CFrame = CFrame.new(0, 50, 0); hrp.Velocity = Vector3.zero end) end end end)
task.spawn(function() while task.wait(0.2) do if _G.State.AutoClick then pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton1(Vector2.new(0,0)) end) end end end)
task.spawn(function() RunService.Stepped:Connect(function() if _G.State.Noclip and char then pcall(function() for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end end) end end) end)
UIS.JumpRequest:Connect(function() if _G.State.InfJump and hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end end)

-- BUILDER
local yPos = 5
local function AddToggle(parent, text, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -10, 0, 30)
    f.Position = UDim2.new(0, 5, 0, yPos)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 40, 0, 20)
    b.Position = UDim2.new(1, -50, 0.5, -10)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local c = Instance.new("Frame", b)
    c.Size = UDim2.new(0, 16, 0, 16)
    c.Position = UDim2.new(0, 2, 0.5, -8)
    c.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)
    local it = false
    b.MouseButton1Click:Connect(function()
        it = not it
        b.BackgroundColor3 = it and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
        c.Position = it and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        pcall(function() callback(it) end)
    end)
    yPos = yPos + 35
end

local function AddSlider(parent, text, minV, maxV, defV, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -10, 0, 50)
    f.Position = UDim2.new(0, 5, 0, yPos)
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -10, 0, 20)
    l.Position = UDim2.new(0, 10, 0, 5)
    l.BackgroundTransparency = 1
    l.Text = text .. ": " .. defV
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1, -20, 0, 10)
    bar.Position = UDim2.new(0, 10, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((defV - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local btn = Instance.new("TextButton", bar)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    local drag = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(minV + (maxV - minV) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        l.Text = text .. ": " .. val
        pcall(function() callback(val) end)
    end
    btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = true; update(input) end end)
    UIS.InputChanged:Connect(function(input) if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
    UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end end)
    yPos = yPos + 55
end

-- TAB PLAYER
yPos = 5
AddSlider(PagePlayer, "Speed (1-1000)", 1, 1000, 65, function(v) _G.SpeedVal = v end)
AddToggle(PagePlayer, "Aktifkan Speed Hack", function(s) _G.State.SpeedHack = s end)
AddSlider(PagePlayer, "Jump (1-1000)", 1, 1000, 130, function(v) _G.JumpVal = v end)
AddToggle(PagePlayer, "Aktifkan Jump Power", function(s) _G.State.JumpHack = s end)
AddToggle(PagePlayer, "Infinite Jump", function(s) _G.State.InfJump = s end)
AddToggle(PagePlayer, "Fly Mode", function(s) _G.State.Fly = s; toggleFly(s) end)
AddToggle(PagePlayer, "Noclip", function(s) _G.State.Noclip = s end)

-- TAB VISUAL
yPos = 5
AddToggle(PageVisual, "Fullbright", function(s) Lighting.Ambient = s and Color3.new(1,1,1) or Color3.fromRGB(128,128,128) end)
AddToggle(PageVisual, "Anti Void", function(s) _G.State.AntiVoid = s end)
AddToggle(PageVisual, "Invisible", function(s) if char then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = s and 1 or 0 end end end end)
AddToggle(PageVisual, "No Fog", function(s) Lighting.FogEnd = s and 100000 or 1000 end)

-- TAB AUTO
yPos = 5
AddToggle(PageAuto, "Auto Prompt", function(s) _G.State.AutoPrompt = s end)
AddToggle(PageAuto, "Auto Farm", function(s) _G.State.AutoFarm = s end)
AddToggle(PageAuto, "Anti AFK", function(s) if s then LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end end)
AddToggle(PageAuto, "Auto Click", function(s) _G.State.AutoClick = s end)

-- TAB MISC
yPos = 5
AddToggle(PageMisc, "Spin Player", function(s) _G.State.Spin = s end)
AddToggle(PageMisc, "Remove Texture", function(s) if s then pcall(function() for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end end end) end end)

local btnSteal = Instance.new("TextButton", PageMisc)
btnSteal.Size = UDim2.new(1, -10, 0, 35)
btnSteal.Position = UDim2.new(0, 5, 0, yPos)
btnSteal.BackgroundColor3 = Color3.fromRGB(150, 0, 200)
btnSteal.Text = "BUKA STEAL PANEL 👑"
btnSteal.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSteal.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnSteal).CornerRadius = UDim.new(0, 6)
btnSteal.MouseButton1Click:Connect(function() MainGUI.Visible = false; StealGUI.Visible = true end)

-- STEAL PANEL
yPos = 5
local backBtn = Instance.new("TextButton", StealContent)
backBtn.Size = UDim2.new(1, -10, 0, 35)
backBtn.Position = UDim2.new(0, 5, 0, yPos)
backBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
backBtn.Text = "BALIK KE MAIN MENU 🔙"
backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
backBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", backBtn).CornerRadius = UDim.new(0, 6)
backBtn.MouseButton1Click:Connect(function() StealGUI.Visible = false; MainGUI.Visible = true end)
yPos = yPos + 45

AddToggle(StealContent, "⚡ AUTO STEAL 100%", function(s) _G.State.AutoSteal = s end)
AddToggle(StealContent, "👑 Auto Divine", function(s) _G.State.AutoSteal = s end)
AddToggle(StealContent, "🔥 Auto Eternal", function(s) _G.State.AutoSteal = s end)
AddToggle(StealContent, "💎 Auto Secret", function(s) _G.State.AutoSteal = s end)

print("[Patrick AI] Smart Icon & Modular Loaded!")
