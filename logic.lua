local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local WS=game:GetService("Workspace")
local LG=game:GetService("Lighting")
local VU=game:GetService("VirtualUser")
local TS=game:GetService("TeleportService")
local LP=Players.LocalPlayer
local PG=LP:WaitForChild("PlayerGui")

if PG:FindFirstChild("CoreGuiHelper")then PG.CoreGuiHelper:Destroy()end
local SG=Instance.new("ScreenGui")
SG.Name="CoreGuiHelper"
SG.ResetOnSpawn=false
SG.Parent=PG

-- ICON
local FI=Instance.new("TextButton",SG)
FI.Size=UDim2.new(0,60,0,60)
FI.Position=UDim2.new(0.85,0,0.7,0)
FI.BackgroundColor3=Color3.fromRGB(0,150,255)
FI.Text="⚙️"
FI.TextSize=35
FI.Font=Enum.Font.GothamBold
FI.TextColor3=Color3.fromRGB(255,255,255)
Instance.new("UICorner",FI).CornerRadius=UDim.new(1,0)
local S1=Instance.new("UIStroke",FI)
S1.Thickness=3
S1.Color=Color3.fromRGB(255,255,255)

-- DRAG ICON
local dg=false
local ds,sp
FI.InputBegan:Connect(function(i)
if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
dg=true
ds=i.Position
sp=FI.Position
i.Changed:Connect(function()
if i.UserInputState==Enum.UserInputState.End then dg=false end
end)
end
end)
UIS.InputChanged:Connect(function(i)
if dg and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
local d=i.Position-ds
FI.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
end
end)

-- MAIN GUI
local MG=Instance.new("Frame",SG)
MG.Name="MainGUI"
MG.Size=UDim2.new(0,380,0,300)
MG.Position=UDim2.new(0.5,-190,0.5,-150)
MG.BackgroundColor3=Color3.fromRGB(15,15,20)
MG.Visible=false
MG.Active=true
MG.Draggable=true
Instance.new("UICorner",MG).CornerRadius=UDim.new(0,10)

-- HEADER
local MH=Instance.new("Frame",MG)
MH.Size=UDim2.new(1,0,0,40)
MH.BackgroundColor3=Color3.fromRGB(0,150,255)
Instance.new("UICorner",MH).CornerRadius=UDim.new(0,10)
local MT=Instance.new("TextLabel",MH)
MT.Size=UDim2.new(1,-20,1,0)
MT.Position=UDim2.new(0,15,0,0)
MT.BackgroundTransparency=1
MT.Text="PATRICK AI | TAB MENU"
MT.TextColor3=Color3.fromRGB(255,255,255)
MT.Font=Enum.Font.GothamBold
MT.TextSize=14
MT.TextXAlignment=Enum.TextXAlignment.Left
local MC=Instance.new("TextButton",MH)
MC.Size=UDim2.new(0,30,0,30)
MC.Position=UDim2.new(1,-35,0,5)
MC.BackgroundColor3=Color3.fromRGB(255,50,50)
MC.Text="X"
MC.TextColor3=Color3.fromRGB(255,255,255)
MC.Font=Enum.Font.GothamBold
Instance.new("UICorner",MC).CornerRadius=UDim.new(0,6)

-- TAB NAVIGASI
local TabFrame = Instance.new("Frame", MG)
TabFrame.Size = UDim2.new(1, -20, 0, 30)
TabFrame.Position = UDim2.new(0, 10, 0, 45)
TabFrame.BackgroundTransparency = 1

local function CreateTab(text, xPos)
    local btn = Instance.new("TextButton", TabFrame)
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local TabPlayer = CreateTab("Player", 0)
local TabVisual = CreateTab("Visual", 85)
local TabAuto = CreateTab("Auto", 170)
local TabMisc = CreateTab("Misc", 255)

-- CONTENT CONTAINER
local Content = Instance.new("ScrollingFrame",MG)
Content.Size=UDim2.new(1,-20,1,-85)
Content.Position=UDim2.new(0,10,0,80)
Content.BackgroundTransparency=1
Content.ScrollBarThickness=3

local PagePlayer = Instance.new("Frame", Content)
PagePlayer.Size = UDim2.new(1, 0, 1, 0)
PagePlayer.BackgroundTransparency = 1
PagePlayer.Visible = true

local PageVisual = Instance.new("Frame", Content)
PageVisual.Size = UDim2.new(1, 0, 1, 0)
PageVisual.BackgroundTransparency = 1
PageVisual.Visible = false

local PageAuto = Instance.new("Frame", Content)
PageAuto.Size = UDim2.new(1, 0, 1, 0)
PageAuto.BackgroundTransparency = 1
PageAuto.Visible = false

local PageMisc = Instance.new("Frame", Content)
PageMisc.Size = UDim2.new(1, 0, 1, 0)
PageMisc.BackgroundTransparency = 1
PageMisc.Visible = false

-- FUNGSI PINDAH TAB
local function SwitchTab(tabBtn, page)
    TabPlayer.BackgroundColor3 = Color3.fromRGB(30,30,35)
    TabVisual.BackgroundColor3 = Color3.fromRGB(30,30,35)
    TabAuto.BackgroundColor3 = Color3.fromRGB(30,30,35)
    TabMisc.BackgroundColor3 = Color3.fromRGB(30,30,35)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0,150,255)
    PagePlayer.Visible = false; PageVisual.Visible = false; PageAuto.Visible = false; PageMisc.Visible = false
    page.Visible = true
end

TabPlayer.MouseButton1Click:Connect(function() SwitchTab(TabPlayer, PagePlayer) end)
TabVisual.MouseButton1Click:Connect(function() SwitchTab(TabVisual, PageVisual) end)
TabAuto.MouseButton1Click:Connect(function() SwitchTab(TabAuto, PageAuto) end)
TabMisc.MouseButton1Click:Connect(function() SwitchTab(TabMisc, PageMisc) end)
SwitchTab(TabPlayer, PagePlayer)

-- STEAL GUI
local TG=Instance.new("Frame",SG)
TG.Name="StealGUI"
TG.Size=UDim2.new(0,350,0,280)
TG.Position=UDim2.new(0.5,-175,0.5,-140)
TG.BackgroundColor3=Color3.fromRGB(20,10,25)
TG.Visible=false
TG.Active=true
TG.Draggable=true
Instance.new("UICorner",TG).CornerRadius=UDim.new(0,10)
local TH=Instance.new("Frame",TG)
TH.Size=UDim2.new(1,0,0,40)
TH.BackgroundColor3=Color3.fromRGB(150,0,200)
Instance.new("UICorner",TH).CornerRadius=UDim.new(0,10)
local TT=Instance.new("TextLabel",TH)
TT.Size=UDim2.new(1,-20,1,0)
TT.Position=UDim2.new(0,15,0,0)
TT.BackgroundTransparency=1
TT.Text="👑 STEAL PANEL"
TT.TextColor3=Color3.fromRGB(255,255,255)
TT.Font=Enum.Font.GothamBold
TT.TextSize=14
TT.TextXAlignment=Enum.TextXAlignment.Left
local TC=Instance.new("TextButton",TH)
TC.Size=UDim2.new(0,30,0,30)
TC.Position=UDim2.new(1,-35,0,5)
TC.BackgroundColor3=Color3.fromRGB(255,50,50)
TC.Text="X"
TC.TextColor3=Color3.fromRGB(255,255,255)
TC.Font=Enum.Font.GothamBold
Instance.new("UICorner",TC).CornerRadius=UDim.new(0,6)
local TCF=Instance.new("ScrollingFrame",TG)
TCF.Size=UDim2.new(1,-20,1,-50)
TCF.Position=UDim2.new(0,10,0,45)
TCF.BackgroundTransparency=1
TCF.ScrollBarThickness=3
TCF.ScrollBarImageColor3=Color3.fromRGB(150,0,200)

FI.MouseButton1Click:Connect(function()MG.Visible=not MG.Visible TG.Visible=false end)
MC.MouseButton1Click:Connect(function()MG.Visible=false end)
TC.MouseButton1Click:Connect(function()TG.Visible=false end)

_G.PatrickState={InfJump=false,Fly=false,Noclip=false,AutoSteal=false,AutoFarm=false,AutoPrompt=false,AutoClick=false,AntiVoid=false,Spin=false}
_G.SpeedValue = 65 -- Nilai default
_G.JumpValue = 130 -- Nilai default

local ch=LP.Character or LP.CharacterAdded:Wait()
local hp=ch:WaitForChild("HumanoidRootPart")
local hm=ch:WaitForChild("Humanoid")

local fv,fg
local function tf(s)
if s then
fv=Instance.new("BodyVelocity",hp);fv.MaxForce=Vector3.new(1e9,1e9,1e9);fv.Velocity=Vector3.zero
fg=Instance.new("BodyGyro",hp);fg.MaxTorque=Vector3.new(1e9,1e9,1e9);fg.CFrame=hp.CFrame
task.spawn(function()while _G.PatrickState.Fly and hp.Parent do fv.Velocity=hm.MoveDirection*60;if hm.MoveDirection.Magnitude>0 then fg.CFrame=CFrame.lookAt(hp.Position,hp.Position+hm.MoveDirection)end task.wait()end;if fv then fv:Destroy()end;if fg then fg:Destroy()end end)
else if fv then fv:Destroy()end;if fg then fg:Destroy()end end
end
LP.CharacterAdded:Connect(function(newChar)ch=newChar hp=ch:WaitForChild("HumanoidRootPart") hm=ch:WaitForChild("Humanoid") if _G.PatrickState.Fly then tf(true)end end)

-- LOOP UNTUK MENGECEK NILAI SLIDER SPEED & JUMP
task.spawn(function()
    while task.wait(0.1) do
        if hm then
            if _G.PatrickState.SpeedHack then hm.WalkSpeed = _G.SpeedValue end
            if _G.PatrickState.JumpHack then hm.JumpPower = _G.JumpValue end
        end
    end
end)

task.spawn(function()while task.wait(0.3)do if _G.PatrickState.AutoSteal then pcall(function()for _,v in pairs(WS:GetDescendants())do if v:IsA("ProximityPrompt")and v.Enabled then local t=string.lower(v.Parent.Name.." "..v.ActionText) if t:find("divine")or t:find("eternal")or t:find("secret")or t:find("egg")or t:find("fruit")then fireproximityprompt(v) task.wait(0.1)end end end end)end end end)
task.spawn(function()while task.wait(0.5)do if _G.PatrickState.AutoPrompt then pcall(function()for _,v in pairs(WS:GetDescendants())do if v:IsA("ProximityPrompt")and v.Enabled then fireproximityprompt(v)end end end)end end end)
task.spawn(function()while task.wait(1)do if _G.PatrickState.AutoFarm and hp then pcall(function()for _,v in pairs(WS:GetDescendants())do if v:IsA("BasePart")and(v.Name:lower():find("egg")or v.Name:lower():find("spawn")or v.Name:lower():find("apple"))then hp.CFrame=v.CFrame+Vector3.new(0,3,0) task.wait(0.2)end end end)end end end)
task.spawn(function()while task.wait(0.5)do if _G.PatrickState.AntiVoid and hp and hp.Position.Y<-50 then hp.CFrame=CFrame.new(0,50,0) hp.Velocity=Vector3.zero end end end)
task.spawn(function()while task.wait(0.1)do if _G.PatrickState.Spin and hp then hp.CFrame=hp.CFrame*CFrame.Angles(0,math.rad(5),0)end end end)
task.spawn(function()while task.wait(0.2)do if _G.PatrickState.AutoClick then VU:CaptureController() VU:ClickButton1(Vector2.new(0,0))end end end)
task.spawn(function()RS.Stepped:Connect(function()if _G.PatrickState.Noclip and ch then for _,v in pairs(ch:GetDescendants())do if v:IsA("BasePart")and v.CanCollide then v.CanCollide=false end end end end)end)
UIS.JumpRequest:Connect(function()if _G.PatrickState.InfJump and hm then hm:ChangeState(Enum.HumanoidStateType.Jumping)end end)

-- BUILDER TOGGLE
local yPositions = {Player=5, Visual=5, Auto=5, Misc=5}
local function BT(parent, t, y, cb)
local f=Instance.new("Frame",parent);f.Size=UDim2.new(1,-10,0,30);f.Position=UDim2.new(0,5,0,y);f.BackgroundColor3=Color3.fromRGB(30,30,35);Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
local l=Instance.new("TextLabel",f);l.Size=UDim2.new(1,-60,1,0);l.Position=UDim2.new(0,10,0,0);l.BackgroundTransparency=1;l.Text=t;l.TextColor3=Color3.fromRGB(255,255,255);l.Font=Enum.Font.Gotham;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left
local b=Instance.new("TextButton",f);b.Size=UDim2.new(0,40,0,20);b.Position=UDim2.new(1,-50,0.5,-10);b.BackgroundColor3=Color3.fromRGB(60,60,60);b.Text="";Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
local c=Instance.new("Frame",b);c.Size=UDim2.new(0,16,0,16);c.Position=UDim2.new(0,2,0.5,-8);c.BackgroundColor3=Color3.fromRGB(255,255,255);Instance.new("UICorner",c).CornerRadius=UDim.new(1,0)
local it=false
b.MouseButton1Click:Connect(function()it=not it;b.BackgroundColor3=it and Color3.fromRGB(0,200,100)or Color3.fromRGB(60,60,60);c.Position=it and UDim2.new(1,-18,0.5,-8)or UDim2.new(0,2,0.5,-8);pcall(function()cb(it)end)end)
end

-- BUILDER SLIDER
local function Slider(parent, text, minVal, maxVal, defaultVal, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -10, 0, 50)
    f.Position = UDim2.new(0, 5, 0, 0) -- Nanti diatur otomatis
    f.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -10, 0, 20)
    l.Position = UDim2.new(0, 10, 0, 5)
    l.BackgroundTransparency = 1
    l.Text = text .. ": " .. defaultVal
    l.TextColor3 = Color3.fromRGB(255,255,255)
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1, -20, 0, 10)
    bar.Position = UDim2.new(0, 10, 0, 30)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton", bar)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        l.Text = text .. ": " .. val
        pcall(function() callback(val) end)
    end
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(input)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            Update(input)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return f
end

local function AddPlayer(t, cb) BT(PagePlayer, t, yPositions.Player, cb) yPositions.Player = yPositions.Player + 35 end
local function AddVisual(t, cb) BT(PageVisual, t, yPositions.Visual, cb) yPositions.Visual = yPositions.Visual + 35 end
local function AddAuto(t, cb) BT(PageAuto, t, yPositions.Auto, cb) yPositions.Auto = yPositions.Auto + 35 end
local function AddMisc(t, cb) BT(PageMisc, t, yPositions.Misc, cb) yPositions.Misc = yPositions.Misc + 35 end

-- ISI TAB PLAYER (Slider Dulu, Baru Toggle)
local SliderSpeed = Slider(PagePlayer, "Speed Hack (1-1000)", 1, 1000, 65, function(val) _G.SpeedValue = val end)
SliderSpeed.Position = UDim2.new(0, 5, 0, yPositions.Player)
yPositions.Player = yPositions.Player + 55
_G.PatrickState.SpeedHack = false
local speedToggleFrame = Instance.new("Frame", PagePlayer) -- Dummy frame buat naro toggle nyala/mati
speedToggleFrame.Size = UDim2.new(0, 0, 0, 0) -- Gak keliatan, cuma penanda
-- Toggle buat ngaktifin slider speed
BT(PagePlayer, "Aktifkan Speed Hack", yPositions.Player, function(s) _G.PatrickState.SpeedHack = s end)
yPositions.Player = yPositions.Player + 35

local SliderJump = Slider(PagePlayer, "Jump Power (1-1000)", 1, 1000, 130, function(val) _G.JumpValue = val end)
SliderJump.Position = UDim2.new(0, 5, 0, yPositions.Player)
yPositions.Player = yPositions.Player + 55
_G.PatrickState.JumpHack = false
BT(PagePlayer, "Aktifkan Jump Power", yPositions.Player, function(s) _G.PatrickState.JumpHack = s end)
yPositions.Player = yPositions.Player + 35

AddPlayer("Infinite Jump",function(s)_G.PatrickState.InfJump=s end)
AddPlayer("Fly Mode",function(s)_G.PatrickState.Fly=s;tf(s)end)
AddPlayer("Noclip",function(s)_G.PatrickState.Noclip=s end)

-- ISI TAB VISUAL
AddVisual("Fullbright",function(s)LG.Ambient=s and Color3.new(1,1,1)or Color3.fromRGB(128,128,128)end)
AddVisual("No Fog",function(s)LG.FogEnd=s and 100000 or 1000 end)
AddVisual("FPS Boost",function(s)if s then LG.GlobalShadows=false LG.ShadowSoftness=0 end end)
AddVisual("Invisible",function(s)if ch then for _,v in pairs(ch:GetDescendants())do if v:IsA("BasePart")then v.Transparency=s and 1 or 0 end end end end)
AddVisual("ESP Telur/Buah",function(s)if s then pcall(function()for _,v in pairs(WS:GetDescendants())do if v:IsA("BasePart")and(v.Name:lower():find("egg")or v.Name:lower():find("apple"))then local h=Instance.new("Highlight",v) h.FillColor=Color3.new(1,1,0)end end end)end end)

-- ISI TAB AUTO
AddAuto("Auto Prompt",function(s)_G.PatrickState.AutoPrompt=s end)
AddAuto("Auto Farm Telur/Buah",function(s)_G.PatrickState.AutoFarm=s end)
AddAuto("Anti AFK",function(s)if s then LP.Idled:Connect(function()VU:CaptureController() VU:ClickButton2(Vector2.new())end)end end)
AddAuto("Auto Click",function(s)_G.PatrickState.AutoClick=s end)

-- ISI TAB MISC
AddMisc("Anti Void",function(s)_G.PatrickState.AntiVoid=s end)
AddMisc("Spin Player",function(s)_G.PatrickState.Spin=s end)
AddMisc("Remove Texture",function(s)if s then pcall(function()for _,v in pairs(WS:GetDescendants())do if v:IsA("Decal")or v:IsA("Texture")then v.Transparency=1 end end end)end end)

-- Tombol Buka Steal Panel di Tab Misc
local btnSteal = Instance.new("TextButton", PageMisc)
btnSteal.Size=UDim2.new(1,-10,0,35)
btnSteal.Position=UDim2.new(0,5,0,yPositions.Misc+10)
btnSteal.BackgroundColor3=Color3.fromRGB(150,0,200)
btnSteal.Text="BUKA STEAL PANEL 👑"
btnSteal.TextColor3=Color3.fromRGB(255,255,255)
btnSteal.Font=Enum.Font.GothamBold
Instance.new("UICorner",btnSteal).CornerRadius=UDim.new(0,6)
btnSteal.MouseButton1Click:Connect(function()MG.Visible=false TG.Visible=true end)

-- ISI STEAL PANEL
local ys=5
local function AS(t,cb)BT(TCF,t,ys,cb) ys=ys+35 end
local s2=Instance.new("TextButton",TCF);s2.Size=UDim2.new(1,-10,0,35);s2.Position=UDim2.new(0,5,0,ys);s2.BackgroundColor3=Color3.fromRGB(0,150,255);s2.Text="BALIK KE MAIN MENU 🔙";s2.TextColor3=Color3.fromRGB(255,255,255);s2.Font=Enum.Font.GothamBold;Instance.new("UICorner",s2).CornerRadius=UDim.new(0,6)
s2.MouseButton1Click:Connect(function()TG.Visible=false MG.Visible=true end)
ys=ys+40
AS("⚡ AUTO STEAL 100%",function(s)_G.PatrickState.AutoSteal=s end)
AS("👑 Auto Divine",function(s)_G.PatrickState.AutoSteal=s end)
AS("🔥 Auto Eternal",function(s)_G.PatrickState.AutoSteal=s end)
AS("💎 Auto Secret",function(s)_G.PatrickState.AutoSteal=s end)

print("[Patrick AI] Slider Update Loaded! 🔥")
