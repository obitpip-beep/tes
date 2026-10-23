local baseURL = "https://raw.githubusercontent.com/obitpip-beep/tes/refs/heads/main/"

local function loadUI(fileName)
    local ok, source = pcall(game.HttpGet, game, baseURL .. fileName)
    if ok and type(source) == "string" then
        local chunk = loadstring(source)
        if chunk then pcall(chunk) end
    end
    task.wait(0.3)
end

-- 1. Load UI Dulu (Biar muncul duluan)
loadUI("ui1.lua")
loadUI("ui2.lua")

-- 2. LOGIC PLAYER & GAME (Langsung di file ini)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Fitur Fly
local flyVel, flyGyro
local function toggleFly(state)
    if state then
        flyVel = Instance.new("BodyVelocity", hrp)
        flyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyVel.Velocity = Vector3.zero
        flyGyro = Instance.new("BodyGyro", hrp)
        flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyGyro.CFrame = hrp.CFrame
        
        task.spawn(function()
            while _G.PatrickToggle3 and hrp.Parent do
                flyVel.Velocity = hum.MoveDirection * 55
                if hum.MoveDirection.Magnitude > 0 then
                    flyGyro.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + hum.MoveDirection)
                end
                task.wait()
            end
            if flyVel then flyVel:Destroy() end
            if flyGyro then flyGyro:Destroy() end
        end)
    else
        if flyVel then flyVel:Destroy() end
        if flyGyro then flyGyro:Destroy() end
    end
end

-- Loop Player
task.spawn(function()
    while task.wait(0.1) do
        if hum and hrp then
            hum.WalkSpeed = _G.PatrickToggle1 and 65 or 16
            hum.JumpPower = _G.PatrickToggle2 and 130 or 50
            if _G.PatrickToggle3 then if not flyVel then toggleFly(true) end else if flyVel then toggleFly(false) end end
            if _G.PatrickToggle4 then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
            Lighting.Ambient = _G.PatrickToggle6 and Color3.new(1,1,1) or Color3.new(0.5,0.5,0.5)
            if _G.PatrickToggle9 then
                if hrp.Position.Y < -50 then hrp.CFrame = CFrame.new(0, 50, 0); hrp.Velocity = Vector3.zero end
                hum.MaxHealth = math.huge
                hum.Health = math.huge
            else
                hum.MaxHealth = 100
            end
            if _G.PatrickToggle10 then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(5), 0) end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.PatrickToggle5 and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Loop Auto
task.spawn(function()
    while task.wait(0.2) do
        if _G.PatrickToggle7 then
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled then fireproximityprompt(v) end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if _G.PatrickToggle8 and hrp then
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:lower():find("egg") or v.Name:lower():find("spawn")) then
                        hrp.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1)
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(5) do
        if _G.PatrickToggle11 then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if _G.PatrickToggle12 then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if _G.PatrickToggle13 then
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:lower():find("egg") and not v:FindFirstChild("PatrickESP") then
                        local h = Instance.new("Highlight", v)
                        h.Name = "PatrickESP"
                        h.FillColor = Color3.new(1, 1, 0)
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(3) do
        if _G.PatrickToggle14 then
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
                end
            end)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
end)

print("[Patrick AI] Loader + Logic Gabungan Berhasil Jalan! 🔥")
