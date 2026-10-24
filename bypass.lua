local Players = game:GetService("Players")
local LP = Players.LocalPlayer

pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or (method == "FireServer" and (self.Name == "AC_Remote" or self.Name == "AntiCheat" or self.Name:lower():find("detect"))) then
            return nil 
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

pcall(function()
    LP.Kick = function() end
    LP.Idled = function() end
end)

pcall(function()
    local RS = game:GetService("RunService")
    RS.Stepped:Connect(function()
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.01, 0.01, 0.01, 0.01)
        end
    end)
end)
