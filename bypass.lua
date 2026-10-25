-- =====================================================
-- [ PATRICK AI - MODULAR BYPASS SYSTEM ]
-- =====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- BYPASS UTAMA (Ngejaga Pondasi)
pcall(function()
    LP.Kick = function() end
    LP.Idled = function() end
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then return nil end
        if method == "FireServer" and (self.Name:lower():find("anti") or self.Name:lower():find("detect") or self.Name:lower():find("ac_")) then return nil end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

-- BYPASS SPEED, JUMP, FLY
pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, key)
        if key == "WalkSpeed" then return 16 end
        if key == "JumpPower" or key == "UseJumpPower" then return 50 end
        if key == "HipHeight" then return 2 end
        if key == "Position" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" then return Vector3.new(0, 0, 0) end
        return oldIndex(self, key)
    end)
    setreadonly(mt, true)
end)

-- BYPASS AUTO STEAL & TELEPORT
pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "GetDistance" or method == "Magnitude" or method == "FindPartOnRay" then
            return 0
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

-- AUTO HEAL
pcall(function()
    RunService.Stepped:Connect(function()
        if LP.Character then
            local hum = LP.Character:FindFirstChild("Humanoid")
            if hum then hum.Health = hum.MaxHealth end
        end
    end)
end)
