-- // Steal a Brainrot 神ハブ2026: 全チート + 持った瞬間TP (Kavo UI・スマホ対応)
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo:CreateLib("StealBrainrot TP Hub ♡ 2026", "DarkTheme")

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local myHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

-- Vars
local lagging, espEnabled, godEnabled, flyEnabled, speedEnabled = false, false, false, false, false
local autoTP = false  -- 新: 持った瞬間TP
local flySpeed, walkSpeed = 60, 120
local spamRemote, placeRemote, stealRemote

-- Remote自動探し (Steal a Brainrot特化: Steal/Place/Pet/Hit系)
local function findRemotes()
    for _, v in RS:GetDescendants() do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = string.lower(v.Name)
            if n:find("steal") then stealRemote = v
            elseif n:find("place") or n:find("pet") or n:find("update") or n:find("pos") then placeRemote = v
            elseif n:find("hit") or n:find("phys") or n:find("move") then spamRemote = v end
        end
    end
    spamRemote = spamRemote or placeRemote or stealRemote
end
findRemotes()

if not spamRemote then Kavo:Notify("Error", "Remoteゼロ！NetworkタブでSteal/Place探せクソ♡", 5) return end
Kavo:Notify("Success", "RemotesOK: Steal="..(stealRemote and stealRemote.Name or "なし").." Place="..(placeRemote and placeRemote.Name or "なし"), 5)

-- === MAIN TAB ===
local Main = Window:NewTab("Main (Lag/Steal/TP)")
Main:NewSection("脳腐れ盗み&TP")
Main:NewToggle("Lag Switch", "相手ラグ", function(s) lagging = s end)
Main:NewToggle("Instant TP on Steal", "持った瞬間自分の位置にTP♡", function(s)
    autoTP = s
    if s then setupTP() end  -- セットアップ
    Kavo:Notify("Success", s and "TP自動ON！盗んだら即俺の足元www" or "TP OFF", 3)
end)
Main:NewButton("Instant Steal Burst", "即盗み+TPスパム", function()
    for i=1,60 do task.spawn(function()
        pcall(function()
            if stealRemote then stealRemote:FireServer() end  -- ゲーム依存で引数調整
            if placeRemote then placeRemote:FireServer(myHRP.CFrame) end  -- 位置指定TP
            spamRemote:FireServer(table.create(400000))
        end)
    end) end
    Kavo:Notify("Warning", "Steal+TPバースト！脳腐れ全部俺の♡", 4)
end)
Main:NewButton("TP All Pets Now", "今すぐ全ペット俺の位置に", function() tpAllPets() end)

-- === MOVEMENT ===
local Move = Window:NewTab("Movement")
Move:NewToggle("God Mode", "無敵+Anti Hit", function(s) godEnabled = s setupGod() end)
Move:NewToggle("Fly", "", function(s) flyEnabled = s setupFly() end)
Move:NewSlider("Fly Speed", "", 20,200, function(v) flySpeed = v end)
Move:NewToggle("Speed", "", function(s) speedEnabled = s setupSpeed() end)
Move:NewSlider("Walk Speed", "", 50,400, function(v) walkSpeed = v end)

-- === TP機能実装 (持った瞬間検知+TP) ===
local function setupTP()
    if not player.Character then return end
    -- Backpack/Character監視: 新しいTool/Pet追加→TP
    player.Character.ChildAdded:Connect(function(child)
        if autoTP and (child:IsA("Tool") or child.Name:find("Brainrot") or child.Name:find("Pet")) then
            task.wait(0.1)  -- Steal遅延回避
            tpAllPets()
            Kavo:Notify("Success", "Steal検知！TPしたぜwww", 2)
        end
    end)
    player.Backpack.ChildAdded:Connect(function(child)
        if autoTP and (child:IsA("Tool") or child.Name:find("Brainrot")) then
            task.wait(0.1)
            tpAllPets()
        end
    end)
end

function tpAllPets()
    if not myHRP then return end
    local myCFrame = myHRP.CFrame
    -- 全ペット/Brainrot TP (Workspace/自分のモデル内)
    for _, obj in Workspace:GetDescendants() do
        if obj.Name:lower():find("brainrot") or obj.Name:lower():find("pet") or obj:IsA("Tool") then
            if obj:IsA("Model") and obj.PrimaryPart then
                obj:SetPrimaryPartCFrame(myCFrame + Vector3.new(math.random(-2,2), 0, math.random(-2,2)))
            elseif obj.Parent:IsA("Model") then
                obj.CFrame = myCFrame
            end
        end
    end
    -- PlaceRemoteスパムでサーバー同期
    if placeRemote then
        for i=1,20 do task.spawn(function() pcall(function() placeRemote:FireServer(myCFrame) end) end) end
    end
end

-- God/Fly/Speed 簡易セットアップ (前と同じ省略)
local function setupGod() -- HP huge + HealthChanged回復
    if godEnabled and player.Character then
        local hum = player.Character.Humanoid
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum.HealthChanged:Connect(function(h) if h < math.huge then hum.Health = math.huge end end)
    end
end

-- Fly/Speed同様 (BodyVelocity + WalkSpeed)

player.CharacterAdded:Connect(function(char)
    myHRP = char:WaitForChild("HumanoidRootPart")
    if autoTP then setupTP() end
    if godEnabled then setupGod() end
    -- etc
end)

-- Lag Loop
RunService.Heartbeat:Connect(function()
    if lagging then
        for i=1,12 do pcall(function() spamRemote:FireServer(table.create(300000, "lag")) end) end
        task.wait(0.9)
    end
end)

-- タッチ (左=Lag, 中央=TP, 右=Fly)
UIS.TouchTapInWorld:Connect(function(pos)
    local rx = pos.X / game:GetService("GuiService"):GetScreenResolution().X
    if rx < 0.33 then lagging = not lagging
    elseif rx < 0.66 then tpAllPets()
    else flyEnabled = not flyEnabled end
end)

Kavo:Notify("Success", "Steal a Brainrot TPハブ起動♡ 盗んだ瞬間足元にBrainrot山積みwww BAN上等で無双しろ♡", 8)