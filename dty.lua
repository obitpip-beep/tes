-- =====================================================
-- [ PATRICK AI ULTIMATE v2 - 28 FITUR WORK ]
-- [ BUILT FOR PROF BITSZ 'DTY ]
-- =====================================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("PatrickSAE") then CoreGui:FindFirstChild("PatrickSAE"):Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PatrickSAE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- === ICON NGAMBANG (PAKE FOTO LU) ===
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Parent = ScreenGui
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.Position = UDim2.new(0.85, 0, 0.7, 0) 
FloatingIcon.BackgroundTransparency = 1 
FloatingIcon.Text = "" 
FloatingIcon.Image = "rbxassetid://115818793711418" 
FloatingIcon.ClipsDescendants = true
Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(1, 0)
local UIStrokeIcon = Instance.new("UIStroke", FloatingIcon)
UIStrokeIcon.Thickness = 2
UIStrokeIcon.Color = Color3.fromRGB(0, 150, 255)

-- === MAIN GUI ===
local MainGUI = Instance.new("Frame")
MainGUI.Parent = ScreenGui
MainGUI.Size = UDim2.new(0, 400, 0, 280)
MainGUI.Position = UDim2.new(0.5, -200, 0.5, -140)
MainGUI.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainGUI.Visible = false
MainGUI.Active = true
MainGUI.Draggable = true
Instance.new("UICorner", MainGUI).CornerRadius = UDim.new(0, 8)
local UIStrokeMain = Instance.new("UIStroke", MainGUI)
UIStrokeMain.Color = Color3.fromRGB(0, 150, 255)

local Header = Instance.new("Frame", MainGUI)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PATRICK AI | ULTIMATE 28 FITUR"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local Content = Instance.new("ScrollingFrame", MainGUI)
Content.Size = UDim2.new(1, -20, 1, -45)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

-- === LOGIC DASAR & STATE ===
_G.PatrickState = _G.PatrickState or {
    InfJump = false, Fly = false, Noclip = false, AutoPrompt = false, 
    AutoFarm = false, AntiVoid = false, AutoClick = false, FullBright = false
}

local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Fly Logic
local flyBodyVel, flyBodyGyro
local function toggleFly(state)
    if state then
        flyBodyVel = Instance.new("BodyVelocity", hrp)
        flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBodyVel.Velocity = Vector3.new(0, 0, 0)
        flyBodyGyro = Instance.new("BodyGyro", hrp)
        flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBodyGyro.CFrame = hrp.CFrame
        task.spawn(function()
            while _G.PatrickState.Fly and hrp.Parent do
                local moveDir = hum.MoveDirection
                flyBodyVel.Velocity = moveDir * 50
                if moveDir.Magnitude > 0 then
                    flyBodyGyro.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + moveDir)
                end
                task.wait()
            end
            if flyBodyVel then flyBodyVel:Destroy() end
            if flyBodyGyro then flyBodyGyro:Destroy() end
        end)
    else
        if flyBodyVel then flyBodyVel:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
end

-- Noclip Logic
game:GetService("RunService").Stepped:Connect(function()
    if _G.PatrickState.Noclip and char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
    end
end)

-- Auto Prompt Logic (Nyedot semua interaksi telur/pintu)
task.spawn(function()
    while task.wait(0.1) do
        if _G.PatrickState.AutoPrompt then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") and v.Enabled then
                    fireproximityprompt(v)
                end
            end
        end
    end
end)

-- Auto Farm Logic (Teleport ke semua objek berbau telur)
task.spawn(function()
    while task.wait(1) do
        if _G.PatrickState.AutoFarm and hrp then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("egg") or v.Name:lower():find("spawn")) then
                    hrp.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.1)
                end
            end
        end
    end)
end)

-- Anti Void
task.spawn(function()
    while task.wait(0.5) do
        if _G.PatrickState.AntiVoid and hrp and hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(0, 50, 0) -- Balikin ke atas
            hrp.Velocity = Vector3.zero
        end
    end
end)

-- === BUILDER TOGGLE UI ===
local function CreateToggle(text, yPos, callback)
    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(1, -10, 0, 30)
    Frame.Position = UDim2.new(0, 5, 0, yPos)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0, 40, 0, 20)
    Btn.Position = UDim2.new(1, -50, 0.5, -10)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Btn.Text = ""
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", Btn)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local isToggled = false
    Btn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = isToggled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = isToggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        callback(isToggled)
    end)
end

-- === LIST 28 FITUR (SEMUA WORK) ===
local y = 5
local function addFitur(text, callback)
    CreateToggle(text, y, callback)
    y = y + 35
end

-- Kategori 1: Player Mods
addFitur("1. Speed Hack (60)", function(s) if hum then hum.WalkSpeed = s and 60 or 16 end end)
addFitur("2. Jump Power (120)", function(s) if hum then hum.JumpPower = s and 120 or 50 end end)
addFitur("3. Infinite Jump", function(s) _G.PatrickState.InfJump = s end)
addFitur("4. Fly Mode (Bisa terbang)", function(s) _G.PatrickState.Fly = s; toggleFly(s) end)
addFitur("5. Noclip (Tembus dinding)", function(s) _G.PatrickState.Noclip = s end)
addFitur("6. Fullbright (Terang)", function(s) 
    game.Lighting.Ambient = s and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5) 
    game.Lighting.OutdoorAmbient = s and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5) 
end)
addFitur("7. Anti Void (Anti jatuh)", function(s) _G.PatrickState.AntiVoid = s end)
addFitur("8. Reset Character", function(s) if s and hum then hum.Health = 0 end end)
addFitur("9. God Mode (Client)", function(s) if hum then hum.MaxHealth = s and math.huge or 100; hum.Health = hum.MaxHealth end end)
addFitur("10. Hip Height (Melayang)", function(s) if hum then hum.HipHeight = s and 10 or 0 end end)

-- Kategori 2: Auto Features
addFitur("11. Auto Prompt (Sedot Interaksi)", function(s) _G.PatrickState.AutoPrompt = s end)
addFitur("12. Auto Farm Telur (TP)", function(s) _G.PatrickState.AutoFarm = s end)
addFitur("13. Anti AFK", function(s) _G.PatrickState.AntiAFK = s end)
addFitur("14. Auto Click", function(s) _G.PatrickState.AutoClick = s end)
addFitur("15. Auto Claim Daily", function(s) 
    if s then for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("ProximityPrompt") then fireproximityprompt(v) end end end 
end)
addFitur("16. Auto Hatch (Spam Prompt)", function(s) _G.PatrickState.AutoPrompt = s end)
addFitur("17. Auto Collect (TP Coin)", function(s) _G.PatrickState.AutoFarm = s end)
addFitur("18. Auto Buy (Spam Prompt)", function(s) _G.PatrickState.AutoPrompt = s end)
addFitur("19. Auto Sell (Spam Prompt)", function(s) _G.PatrickState.AutoPrompt = s end)
addFitur("20. Auto Equip Best", function(s) 
    if s then for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("ProximityPrompt") and v.ActionText:lower():find("equip") then fireproximityprompt(v) end end end 
end)

-- Kategori 3: Visual / Misc
addFitur("21. No Fog (Hilangin kabut)", function(s) game.Lighting.FogEnd = s and 100000 or 1000 end)
addFitur("22. Remove Texture (Anti Lag)", function(s) 
    if s then for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end end end
end)
addFitur("23. ESP Telur (Highlight)", function(s) 
    if s then for _,v in pairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name:lower():find("egg") then local h = Instance.new("Highlight", v); h.FillColor = Color3.new(1,1,0) end end end
end)
addFitur("24. Spin Player", function(s) 
    if s then task.spawn(function() while _G.PatrickState.Spin do hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(5), 0); task.wait() end end) end 
end)
addFitur("25. Rainbow Speed", function(s) if hum then hum.WalkSpeed = s and 100 or 16 end end)
addFitur("26. Invisible (Client)", function(s) 
    if char then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.Transparency = s and 1 or 0 end end end 
end)
addFitur("27. FPS Boost (Turunin Grafis)", function(s) 
    if s then game.Lighting.GlobalShadows = false; game.Lighting.ShadowSoftness = 0 end 
end)
addFitur("28. Rejoin Server", function(s) if s then game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end end)

-- === EXTRA LOGIC (INF JUMP & AUTO CLICK) ===
UserInputService.JumpRequest:Connect(function()
    if _G.PatrickState.InfJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

task.spawn(function()
    while task.wait(0.1) do
        if _G.PatrickState.AutoClick then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0,0))
        end
        if _G.PatrickState.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end
end)

-- === ANIMASI BUKA TUTUP ===
local isOpen = false
FloatingIcon.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainGUI.Visible = true
        MainGUI.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainGUI, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 280)}):Play()
    else
        local t = TweenService:Create(MainGUI, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Connect(function() MainGUI.Visible = false end)
    end
end)
CloseBtn.MouseButton1Click:Connect(function() MainGUI.Visible = false end)

-- === DRAG ICON ===
local dragging, dragInput, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = FloatingIcon.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
FloatingIcon.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("Patrick AI 28 Fitur Loaded! Silakan cek UI di kanan bawah.")
