local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = PlayerGui:WaitForChild("PatrickUI")
local FloatingIcon = ScreenGui:WaitForChild("FloatingIcon")

local MainGUI = Instance.new("Frame", ScreenGui)
MainGUI.Name = "MainGUI"
MainGUI.Size = UDim2.new(0, 400, 0, 280)
MainGUI.Position = UDim2.new(0.5, -200, 0.5, -140)
MainGUI.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainGUI.Visible = false
MainGUI.Active = true
MainGUI.Draggable = true
Instance.new("UICorner", MainGUI).CornerRadius = UDim.new(0, 8)

local Header = Instance.new("Frame", MainGUI)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PATRICK AI | UI MODULE"
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
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -45)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 3

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

local yPos = 5
local function AddToggle(text, callback)
    local Frame = Instance.new("Frame", Content); Frame.Size = UDim2.new(1, -10, 0, 30); Frame.Position = UDim2.new(0, 5, 0, yPos); Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Label = Instance.new("TextLabel", Frame); Label.Size = UDim2.new(1, -50, 1, 0); Label.Position = UDim2.new(0, 10, 0, 0); Label.BackgroundTransparency = 1; Label.Text = text; Label.TextColor3 = Color3.fromRGB(255, 255, 255); Label.Font = Enum.Font.Gotham; Label.TextSize = 11; Label.TextXAlignment = Enum.TextXAlignment.Left
    local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(0, 40, 0, 20); Btn.Position = UDim2.new(1, -50, 0.5, -10); Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Btn.Text = ""; Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
    local Circle = Instance.new("Frame", Btn); Circle.Size = UDim2.new(0, 16, 0, 16); Circle.Position = UDim2.new(0, 2, 0.5, -8); Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    local isToggled = false
    Btn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = isToggled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = isToggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        pcall(function() callback(isToggled) end)
    end)
    yPos = yPos + 35
end

AddToggle("1. Speed Hack (65)", function(s) _G.PatrickToggle1 = s end)
AddToggle("2. Jump Power (130)", function(s) _G.PatrickToggle2 = s end)
AddToggle("3. Fly Mode", function(s) _G.PatrickToggle3 = s end)
AddToggle("4. Noclip", function(s) _G.PatrickToggle4 = s end)
AddToggle("5. Infinite Jump", function(s) _G.PatrickToggle5 = s end)
AddToggle("6. Fullbright", function(s) _G.PatrickToggle6 = s end)
AddToggle("7. Auto Prompt", function(s) _G.PatrickToggle7 = s end)
AddToggle("8. Auto Farm Egg", function(s) _G.PatrickToggle8 = s end)
AddToggle("9. God Mode", function(s) _G.PatrickToggle9 = s end)
AddToggle("10. Spin Player", function(s) _G.PatrickToggle10 = s end)
AddToggle("11. Anti AFK", function(s) _G.PatrickToggle11 = s end)
AddToggle("12. Auto Click", function(s) _G.PatrickToggle12 = s end)
AddToggle("13. ESP Telur", function(s) _G.PatrickToggle13 = s end)
AddToggle("14. Remove Texture", function(s) _G.PatrickToggle14 = s end)
AddToggle("15. No Fog", function(s) if s then game.Lighting.FogEnd = 1e6 else game.Lighting.FogEnd = 1000 end end)
AddToggle("16. Rejoin Server", function(s) if s then TeleportService:Teleport(game.PlaceId, Players.LocalPlayer) end end)

print("[Patrick AI] UI 2 (Menu) Loaded.")
