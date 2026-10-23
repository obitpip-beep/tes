local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local WS=game:GetService("Workspace")
local LG=game:GetService("Lighting")
local VU=game:GetService("VirtualUser")
local TS=game:GetService("TeleportService")
local LP=Players.LocalPlayer
local PG=LP:WaitForChild("PlayerGui")

-- 1. TRIK BYPASS: Nama UI disamarkan agar tidak dicurigai AC game
if PG:FindFirstChild("CoreGuiHelper")then PG.CoreGuiHelper:Destroy()end
local SG=Instance.new("ScreenGui")
SG.Name="CoreGuiHelper" -- Nama samaran
SG.ResetOnSpawn=false
SG.Parent=PG

-- 2. IKON DISAMARKAN
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

-- 3. MENU UTAMA DISAMARKAN
local MG=Instance.new("Frame",SG)
MG.Name="MainGUI"
MG.Size=UDim2.new(0,350,0,280)
MG.Position=UDim2.new(0.5,-175,0.5,-140)
MG.BackgroundColor3=Color3.fromRGB(15,15,20)
MG.Visible=false
MG.Active=true
MG.Draggable=true
Instance.new("UICorner",MG).CornerRadius=UDim.new(0,10)
local MH=Instance.new("Frame",MG)
MH.Size=UDim2.new(1,0,0,40)
MH.BackgroundColor3=Color3.fromRGB(0,150,255)
Instance.new("UICorner",MH).CornerRadius=UDim.new(0,10)
local MT=Instance.new("TextLabel",MH)
MT.Size=UDim2.new(1,-20,1,0)
MT.Position=UDim2.new(0,15,0,0)
MT.BackgroundTransparency=1
MT.Text="PATRICK AI | MAIN MENU"
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
local MCF=Instance.new("ScrollingFrame",MG)
MCF.Size=UDim2.new(1,-20,1,-50)
MCF.Position=UDim2.new(0,10,0,45)
MCF.BackgroundTransparency=1
MCF.ScrollBarThickness=3

-- 4. STEAL PANEL
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
TT.Text="👑 STEAL PANEL (100%)"
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

-- 5. TRIK BYPASS: Auto Steal dibuat lebih lambat (0.3 detik) & disamarkan
task.spawn(function()
while task.wait(0.3)do 
if _G.PatrickState.AutoSteal then 
pcall(function()
for _,v in pairs(WS:GetDescendants())do 
if v:IsA("ProximityPrompt")and v.Enabled then 
local t=string.lower(v.Parent.Name.." "..v.ActionText) 
if t:find("divine")or t:find("eternal")or t:find("secret")or t:find("egg")or t:find("fruit")then 
fireproximityprompt(v) 
task.wait(0.1) -- Jeda tambahan biar gak spam
end 
end 
end 
end)
end 
end 
end)

task.spawn(function()while task.wait(0.5)do if _G.PatrickState.AutoPrompt then pcall(function()for _,v in pairs(WS:GetDescendants())do if v:IsA("ProximityPrompt")and v.Enabled then fireproximityprompt(v)end end end)end end end)
task.spawn(function()while task.wait(1)do if _G.PatrickState.AutoFarm and hp then pcall(function()for _,v in pairs(WS:GetDescendants())do if v:IsA("BasePart")and(v.Name:lower():find("egg")or v.Name:lower():find("spawn")or v.Name:lower():find("apple"))then hp.CFrame=v.CFrame+Vector3.new(0,3,0) task.wait(0.2)end end end)end end end)
task.spawn(function()while task.wait(0.5)do if _G.PatrickState.AntiVoid and hp and hp.Position.Y<-50 then hp.CFrame=CFrame.new(0,50,0) hp.Velocity=Vector3.zero end end end)
task.spawn(function()while task.wait(0.1)do if _G.PatrickState.Spin and hp then hp.CFrame=hp.CFrame*CFrame.Angles(0,math.rad(5),0)end end end)
task.spawn(function()while task.wait(0.2)do if _G.PatrickState.AutoClick then VU:CaptureController() VU:ClickButton1(Vector2.new(0,0))end end end)
task.spawn(function()RS.Stepped:Connect(function()if _G.PatrickState.Noclip and ch then for _,v in pairs(ch:GetDescendants())do if v:IsA("BasePart")and v.CanCollide then v.CanCollide=false end end end end)end)
UIS.JumpRequest:Connect(function()if _G.PatrickState.InfJump and hm then hm:ChangeState(Enum.HumanoidStateType.Jumping)end end)

local function BT(p,t,y,cb)
local f=Instance.new("Frame",p);f.Size=UDim2.new(1,-10,0,30);f.Position=UDim2.new(0,5,0,y);f.BackgroundColor3=Color3.fromRGB(30,30,35);Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
local l=Instance.new("TextLabel",f);l.Size=UDim2.new(1,-60,1,0);l.Position=UDim2.new(0,10,0,0);l.BackgroundTransparency=1;l.Text=t;l.TextColor3=Color3.fromRGB(255,255,255);l.Font=Enum.Font.Gotham;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left
local b=Instance.new("TextButton",f);b.Size=UDim2.new(0,40,0,20);b.Position=UDim2.new(1,-50,0.5,-10);b.BackgroundColor3=Color3.fromRGB(60,60,60);b.Text="";Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
local c=Instance.new("Frame",b);c.Size=UDim2.new(0,16,0,16);c.Position=UDim2.new(0,2,0.5,-8);c.BackgroundColor3=Color3.fromRGB(255,255,255);Instance.new("UICorner",c).CornerRadius=UDim.new(1,0)
local it=false
b.MouseButton1Click:Connect(function()it=not it;b.BackgroundColor3=it and Color3.fromRGB(0,200,100)or Color3.fromRGB(60,60,60);c.Position=it and UDim2.new(1,-18,0.5,-8)or UDim2.new(0,2,0.5,-8);pcall(function()cb(it)end)end)
end

local ym=5
local function AM(t,cb)BT(MCF,t,ym,cb) ym=ym+35 end
local s1=Instance.new("TextButton",MCF);s1.Size=UDim2.new(1,-10,0,35);s1.Position=UDim2.new(0,5,0,ym);s1.BackgroundColor3=Color3.fromRGB(150,0,200);s1.Text="BUKA STEAL PANEL 👑";s1.TextColor3=Color3.fromRGB(255,255,255);s1.Font=Enum.Font.GothamBold;Instance.new("UICorner",s1).CornerRadius=UDim.new(0,6)
s1.MouseButton1Click:Connect(function()MG.Visible=false TG.Visible=true end)
ym=ym+40

AM("1. Speed Hack (65)",function(s)if hm then hm.WalkSpeed=s and 65 or 16 end end)
AM("2. Jump Power (130)",function(s)if hm then hm.JumpPower=s and 130 or 50 end end)
AM("3. Infinite Jump",function(s)_G.PatrickState.InfJump=s end)
AM("4. Fly Mode",function(s)_G.PatrickState.Fly=s;tf(s)end)
AM("5. Noclip (Tembus)",function(s)_G.PatrickState.Noclip=s end)
AM("6. Fullbright",function(s)LG.Ambient=s and Color3.new(1,1,1)or Color3.fromRGB(128,128,128)end)
AM("7. God Mode (Client)",function(s)if hm then hm.MaxHealth=s and math.huge or 100;hm.Health=hm.MaxHealth end end)
AM("8. Anti Void",function(s)_G.PatrickState.AntiVoid=s end)
AM("9. Auto Prompt",function(s)_G.PatrickState.AutoPrompt=s end)
AM("10. Anti AFK",function(s)if s then LP.Idled:Connect(function()VU:CaptureController() VU:ClickButton2(Vector2.new())end)end end)
AM("11. Auto Click",function(s)_G.PatrickState.AutoClick=s end)
AM("12. No Fog",function(s)LG.FogEnd=s and 100000 or 1000 end)
AM("13. Invisible",function(s)if ch then for _,v in pairs(ch:GetDescendants())do if v:IsA("BasePart")then v.Transparency=s and 1 or 0 end end end end)
AM("14. FPS Boost",function(s)if s then LG.GlobalShadows=false LG.ShadowSoftness=0 end end)
AM("15. Auto Farm Telur/Buah",function(s)_G.PatrickState.AutoFarm=s end)
AM("16. Spin Player",function(s)_G.PatrickState.Spin=s end)
AM("17. Rainbow Speed",function(s)if hm then hm.WalkSpeed=s and 100 or 16 end end)
AM("18. Remove Texture",function(s)if s then pcall(function()for _,v in pairs(WS:GetDescendants())do if v:IsA("Decal")or v:IsA("Texture")then v.Transparency=1 end end end)end end)
AM("19. ESP Telur/Buah",function(s)if s then pcall(function()for _,v in pairs(WS:GetDescendants())do if v:IsA("BasePart")and(v.Name:lower():find("egg")or v.Name:lower():find("apple"))then local h=Instance.new("Highlight",v) h.FillColor=Color3.new(1,1,0)end end end)end end)
AM("20. Rejoin Server",function(s)if s then TS:Teleport(game.PlaceId,LP)end end)

local ys=5
local function AS(t,cb)BT(TCF,t,ys,cb) ys=ys+35 end
local s2=Instance.new("TextButton",TCF);s2.Size=UDim2.new(1,-10,0,35);s2.Position=UDim2.new(0,5,0,ys);s2.BackgroundColor3=Color3.fromRGB(0,150,255);s2.Text="BALIK KE MAIN MENU 🔙";s2.TextColor3=Color3.fromRGB(255,255,255);s2.Font=Enum.Font.GothamBold;Instance.new("UICorner",s2).CornerRadius=UDim.new(0,6)
s2.MouseButton1Click:Connect(function()TG.Visible=false MG.Visible=true end)
ys=ys+40

AS("⚡ AUTO STEAL 100% (Stealth)",function(s)_G.PatrickState.AutoSteal=s end)
AS("👑 Auto Divine",function(s)_G.PatrickState.AutoSteal=s end)
AS("🔥 Auto Eternal",function(s)_G.PatrickState.AutoSteal=s end)
AS("💎 Auto Secret",function(s)_G.PatrickState.AutoSteal=s end)
print("[Patrick AI] Stealth Bypass Mode Loaded! 🔥")
