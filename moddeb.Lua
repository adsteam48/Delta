-- mod名: ライバル v.4.43 (Rivals 武器速度変更 + 戦闘満載 - Mobile Delta 2026)
local Players=game:GetService("Players");local UIS=game:GetService("UserInputService");local RS=game:GetService("RunService");local Cam=workspace.CurrentCamera;local LP=Players.LocalPlayer
getgenv().Cfg={FOV=65,Pred=0.142,MaxD=380,Smooth=0.78,FlySpd=48,Speed=50,ESP=false,Fly=false,AutoAtk=false,Noclip=true,NoRecoil=true,InfAmmo=true,GunMods=false,FireRate=0.01,BulletSpd=400,NoSpread=true}
local Mouse=LP:GetMouse()
-- FOV Circle
local fovC=Drawing.new("Circle");fovC.Visible=true;fovC.Radius=135;fovC.Color=Color3.fromRGB(220,60,60);fovC.Thickness=2.2;fovC.Transparency=0.85
-- ESP (Box + HP)
local ESPs={};local function AddESP(p)local h=Instance.new("BoxHandleAdornment",p.Character);h.Size=Vector3.new(4,6,2);h.Color3=Color3.fromRGB(255,0,0);h.Transparency=0.5;h.AlwaysOnTop=true;h.ZIndex=10;ESPs[p]=h;local hb=Instance.new("BillboardGui",p.Character.Head);hb.Size=UDim2.new(0,100,0,50);local bar=Instance.new("Frame",hb);bar.Size=UDim2.new(1,0,1,0);bar.BgColor3=Color3.fromRGB(0,255,0);ESPs[p.."hb"]=bar end
local function UpdateESP()for p,_ in pairs(ESPs)do if p.Parent then local dist=(p.HumanoidRootPart.Position-LP.Character.HumanoidRootPart.Position).Magnitude;if dist<50 then ESPs[p].Color3=Color3.fromRGB(255,0,0)elseif dist<100 then ESPs[p].Color3=Color3.fromRGB(255,165,0)else ESPs[p].Color3=Color3.fromRGB(255,255,0)end;local hp=p.Humanoid.Health/p.Humanoid.MaxHealth;ESPs[p.."hb"].Size=UDim2.new(hp,0,1,0)end end end
-- GetClosest (Visible Raycast)
local function GetTarg()local targs={};for _,p in Players:GetPlayers()do if p~=LP and p.Character and p.Character:FindFirstChild("Head")and p.Character.Humanoid.Health>0 then local h=p.Character.Head;local d=(h.Position-Cam.CFrame.Position).Magnitude;if d<Cfg.MaxD then local sp,vis=Cam:WorldToViewportPoint(h.Position);local ang=math.deg(math.acos(math.clamp((h.Position-Cam.CFrame.Position).Unit:Dot(Cam.CFrame.LookVector),-1,1)));if vis and ang<Cfg.FOV/2 then local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Blacklist;rp.FilterDescendantsInstances={LP.Character};local ray=workspace:Raycast(Cam.CFrame.Position,(h.Position-Cam.CFrame.Position).Unit*d,rp);if ray and ray.Instance:IsDescendantOf(p.Character)then table.insert(targs,{p=p,pos=h.Position,scr=Vector2.new(sp.X,sp.Y),dist=d})end end end end end;table.sort(targs,function(a,b)return a.dist<b.dist end);return targs[1]end
-- Noclip
RS.Stepped:Connect(function()if Cfg.Noclip and LP.Character then for _,p in LP.Character:GetChildren()do if p:IsA("BasePart")then p.CanCollide=false end end end end)
-- NoRecoil/InfAmmo + GunMods (新: FireRate/BulletSpeed/NoSpread)
RS.RenderStepped:Connect(function()
    if Cfg.NoRecoil and LP.Character then local root=LP.Character:FindFirstChild("HumanoidRootPart");if root then root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)end end
    if Cfg.InfAmmo then for _,t in LP.Backpack:GetChildren()do if t:IsA("Tool")then if t:FindFirstChild("Ammo")then t.Ammo.Value=math.huge end end end end
    -- 新: Bullet Speed/NoSpread (Projectile Velocityハック)
    if Cfg.GunMods then
        for _,proj in workspace:GetChildren()do if proj:IsA("Part")and(proj.Name:find("Bullet")or proj.Name:find("Projectile"))and proj.Parent~=LP.Character then proj.AssemblyLinearVelocity=proj.AssemblyLinearVelocity.Unit*Cfg.BulletSpd;proj.Velocity=proj.Velocity.Unit*Cfg.BulletSpd end end
    end
end)
-- Skin Changer (Rainbow)
for _,p in Players:GetPlayers()do p.CharacterAdded:Connect(function()wait(1);local h=Instance.new("Highlight",p.Character);h.FillColor=Color3.fromRGB(255,0,255);h.OutlineColor=Color3.fromRGB(255,255,0);h.FillTransparency=0.5;game:GetService("TweenService"):Create(h,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,2),{FillColor=Color3.fromRGB(0,255,255)}):Play()end)end
-- Fly
local flyConn,BV,BG;local function ToggleFly()Cfg.Fly=not Cfg.Fly;if Cfg.Fly and LP.Character then local root=LP.Character.HumanoidRootPart;BV=Instance.new("BodyVelocity",root);BV.MaxForce=Vector3.new(1e7,1e7,1e7);BG=Instance.new("BodyGyro",root);BG.MaxTorque=Vector3.new(1e7,1e7,1e7);BG.P=20000;flyConn=RS.RenderStepped:Connect(function()if not Cfg.Fly then flyConn:Disconnect()return end;local mv=Vector3.new(0,0,0);local hm=LP.Character.Humanoid;if hm then local cm=require(LP.PlayerScripts.PlayerModule:GetChildren()[1].ControlModule);local vec=cm:GetMoveVector();mv=Vector3.new(vec.X,0,-vec.Z).Unit;if hm.Jump then mv=mv+Vector3.new(0,1,0)end end;BV.Velocity=Cam.CFrame:VectorToWorldSpace(mv*Cfg.FlySpd);BG.CFrame=Cam.CFrame end)end;if BV then BV:Destroy()end;if BG then BG:Destroy()end end
-- Speed/InfJump
local function ToggleSpeed()local hm=LP.Character.Humanoid;if hm then hm.WalkSpeed=Cfg.Speed;hm.JumpPower=100 end end;ToggleSpeed();LP.CharacterAdded:Connect(ToggleSpeed)
-- AutoAtk (FireRate統合: GunMods ONで超連射)
local atkConn;local function ToggleAtk()Cfg.AutoAtk=not Cfg.AutoAtk;if Cfg.AutoAtk then atkConn=RS.Heartbeat:Connect(function()local t=GetTarg();if t then local pred=t.pos+(t.p.Character.HumanoidRootPart.Velocity*Cfg.Pred);local dx=(t.scr.X-Cam.ViewportSize.X/2)*Cfg.Smooth;local dy=(t.scr.Y-Cam.ViewportSize.Y/2)*Cfg.Smooth;mousemoverel(dx,dy);Mouse.Hit=CFrame.new(pred);mouse1click();if Cfg.GunMods then wait(Cfg.FireRate)else wait(0.05)end end end)else if atkConn then atkConn:Disconnect()end end end
-- GUI (新GunMods橙ボタン)
local sg=Instance.new("ScreenGui",LP.PlayerGui);sg.Name="Rivals443"
local flyB=Instance.new("TextButton",sg);flyB.Size=UDim2.new(0,140,0,60);flyB.Position=UDim2.new(1,-155,0,10);flyB.BgColor3=Color3.fromRGB(30,200,255);flyB.Text="Fly OFF";flyB.TextScaled=true;flyB.MouseButton1Click:Connect(function()ToggleFly();flyB.Text="Fly "..(Cfg.Fly and "ON"or"OFF");flyB.BgColor3=Cfg.Fly and Color3.fromRGB(0,255,100)or Color3.fromRGB(30,200,255)end)
local atkB=Instance.new("TextButton",sg);atkB.Size=UDim2.new(0,140,0,60);atkB.Position=UDim2.new(1,-155,0.3,0);atkB.BgColor3=Color3.fromRGB(255,80,80);atkB.Text="Attack OFF";atkB.TextScaled=true;atkB.MouseButton1Click:Connect(function()ToggleAtk();atkB.Text="Attack "..(Cfg.AutoAtk and "ON"or"OFF");atkB.BgColor3=Cfg.AutoAtk and Color3.fromRGB(255,0,0)or Color3.fromRGB(255,80,80)end)
local espB=Instance.new("TextButton",sg);espB.Size=UDim2.new(0,140,0,60);espB.Position=UDim2.new(1,-155,0.6,0);espB.BgColor3=Color3.fromRGB(80,255,80);espB.Text="ESP OFF";espB.TextScaled=true;espB.MouseButton1Click:Connect(function()Cfg.ESP=not Cfg.ESP;espB.Text="ESP "..(Cfg.ESP and "ON"or"OFF");espB.BgColor3=Cfg.ESP and Color3.fromRGB(0,255,0)or Color3.fromRGB(80,255,80);if Cfg.ESP then for _,p in Players:GetPlayers()do if p~=LP then AddESP(p)end end else for _,h in pairs(ESPs)do h:Destroy()end;ESPs={}end end)
local gunB=Instance.new("TextButton",sg);gunB.Size=UDim2.new(0,140,0,60);gunB.Position=UDim2.new(1,-155,1,-75);gunB.BgColor3=Color3.fromRGB(255,165,0);gunB.Text="GunMods OFF";gunB.TextScaled=true;gunB.MouseButton1Click:Connect(function()Cfg.GunMods=not Cfg.GunMods;gunB.Text="GunMods "..(Cfg.GunMods and "ON"or"OFF");gunB.BgColor3=Cfg.GunMods and Color3.fromRGB(255,140,0)or Color3.fromRGB(255,165,0);if Cfg.GunMods then Cfg.FireRate=0.01;Cfg.BulletSpd=400;Cfg.NoSpread=true else Cfg.FireRate=0.05;Cfg.BulletSpd=200 end end)
-- 更新
RS.RenderStepped:Connect(function()fovC.Position=Vector2.new(Cam.ViewportSize.X/2,Cam.ViewportSize.Y/2);if Cfg.ESP then UpdateESP()end end);Players.PlayerAdded:Connect(function(p)p.CharacterAdded:Connect(function()if Cfg.ESP then AddESP(p)end end)end)
print("【ライバル v.4.43】武器速度変更追加！ GunModsタップでFireRate/BulletSpeed爆速🔥")
