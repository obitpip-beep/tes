local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("PatrickUI") then PlayerGui.PatrickUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PatrickUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local FloatingIcon = Instance.new("TextButton", ScreenGui)
FloatingIcon.Name = "FloatingIcon"
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

print("[Patrick AI] UI 1 (Icon) Loaded.")
