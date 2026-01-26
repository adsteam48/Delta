-- Delta Mobile Steal a Brainrot ∞ v11.9 FULL DISPLAY + SUPER LAG SWITCH (名古屋 超本気仕様 2026)
-- 全機能一目で見える・サーバー超重ラグスイッチ強化版

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local scriptEnabled = false
local noclipEnabled = false
local selectedPlayers = {}
local maxSelected = 10
local connections = {}
local noclipConn = nil

-- プレイヤーリスト更新（デカ文字・見やすい）
local playerListFrame
local function updatePlayerList()
    if not playerListFrame then return end
    playerListFrame:ClearAllChildren()
    local y = 10
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 80)
            btn.Position = UDim2.new(0, 10, 0, y)
            btn.BackgroundColor3 = table.find(selectedPlayers, p) and Color3.fromRGB(0, 230, 120) or Color3.fromRGB(45, 45, 60)
            btn.Text = "  " .. p.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextSize = 36
            btn.Font = Enum.Font.SourceSansProBold
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.BackgroundTransparency = 0.1
            btn.Parent = playerListFrame
            
            local corner = Instance.new("UICorner", btn)
            corner.CornerRadius = UDim.new(0, 16)
            
            btn.MouseButton1Click:Connect(function()
                if table.find(selectedPlayers, p) then
                    table.remove(selectedPlayers, table.find(selectedPlayers, p))
                    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                elseif #selectedPlayers < maxSelected then
                    table.insert(selectedPlayers, p)
                    btn.BackgroundColor3 = Color3.fromRGB(0, 230, 120)
                end
            end)
            y = y + 90
        end
    end
    playerListFrame.CanvasSize = UDim2.new(0,0,0,y+30)
end

-- ☓コントロール奪取
local function startXControlHijack()
    if #selectedPlayers == 0 then return end
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)
            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    local current = tHRP.CFrame
                    tHRP.CFrame = current:Lerp(current, 0.08)
                    tHRP.Velocity = Vector3.new()
                    tHum.PlatformStand = true
                    tHum.WalkSpeed = 0
                end
            end)
        end
    end
end

-- 🚀プレイヤー乗っ取り
local function startPlayerTakeover()
    if #selectedPlayers == 0 then return end
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)
            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new()
                    tHRP.CFrame = CFrame.new(myPos + Vector3.new(math.random(-5,5), 0, math.random(-5,5)))
                    tHRP.Velocity = Vector3.new()
                    tHum.PlatformStand = true
                    tHum.WalkSpeed = 0
                end
            end)
        end
    end
end

-- 💀 Crush（回線落とし）
local function startCrush()
    if #selectedPlayers == 0 then return end
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)
            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    local current = tHRP.CFrame
                    tHRP.CFrame = current:Lerp(current * CFrame.new(0, -500, 0), 0.2)
                    tHRP.Velocity = Vector3.new(0, -1200, 0)
                    tHRP.AssemblyLinearVelocity = Vector3.new(0, -1200, 0)
                    tHum.Health = 0
                end
            end)
        end
    end
end

-- 🌐 サーバー超重ラグスイッチ（本気でサーバー詰まらせる強化版）
local function startLagSwitch()
    if #selectedPlayers == 0 then return end
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)
            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    -- 物理演算を極限まで重くする
                    tHRP.Velocity = Vector3.new()
                    tHRP.AssemblyLinearVelocity = Vector3.new()
                    tHRP.AssemblyAngularVelocity = Vector3.new(0,0,0)
                    tHum.WalkSpeed = 0
                    tHum.JumpPower = 0
                    tHum.PlatformStand = true
                    
                    -- 毎フレーム微妙に位置を揺らしてサーバー負荷爆上げ
                    local current = tHRP.CFrame
                    tHRP.CFrame = current * CFrame.Angles(0, math.rad(math.random(-2,2)), 0) + Vector3.new(0, math.sin(tick()*30)*0.05, 0)
                    
                    -- ネットワークスパム気味に所有権を繰り返し主張（サーバー重くする）
                    pcall(function() tHRP:SetNetworkOwner(player) end)
                end
            end)
        end
    end
end

-- 🚀 ALL TO BASE
local function startAllToBase()
    if #selectedPlayers == 0 then return end
    local myBasePos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new()
    
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local brainrots = {}
        for _, obj in pairs(tChar:GetChildren()) do
            if obj:IsA("Model") and (obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain")) then
                table.insert(brainrots, obj)
            end
        end
        for _, br in pairs(brainrots) do
            if br and br.Parent then
                br.Parent = player.Character
                if br:FindFirstChild("HumanoidRootPart") then
                    br.HumanoidRootPart.CFrame = CFrame.new(myBasePos + Vector3.new(math.random(-10,10), 0, math.random(-10,10)))
                end
            end
        end
    end
end

-- 全部解除
local function stopAllHijack()
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function()
                tHRP:SetNetworkOwner(tPlayer)
                tHum.PlatformStand = false
                tHum.WalkSpeed = 16
                tHum.JumpPower = 50
                tHRP.Velocity = Vector3.new()
                tHRP.AssemblyLinearVelocity = Vector3.new()
                tHRP.AssemblyAngularVelocity = Vector3.new()
            end)
        end
    end
    for _, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
    connections = {}
    selectedPlayers = {}
    updatePlayerList()
end

-- GUI 全表示 + 超見やすい
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaFullSuperLagV119"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
mainFrame.BackgroundTransparency = 0.08
mainFrame.Parent = ScreenGui

-- タイトル
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 140)
Title.BackgroundTransparency = 1
Title.Text = "Δ BRAINROT STEALER v11.9 SUPER LAG"
Title.TextColor3 = Color3.fromRGB(255, 80, 200)
Title.TextSize = 54
Title.Font = Enum.Font.GothamBlack
Title.TextStrokeTransparency = 0.5
Title.TextStrokeColor3 = Color3.new(0,0,0)
Title.Parent = mainFrame

-- ON/OFF 超巨大
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.92, 0, 0, 160)
ToggleBtn.Position = UDim2.new(0.04, 0, 0.02, 140)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextSize = 60
ToggleBtn.Font = Enum.Font.SourceSansProBold
ToggleBtn.Parent = mainFrame

local togCorner = Instance.new("UICorner", ToggleBtn)
togCorner.CornerRadius = UDim.new(0, 28)

ToggleBtn.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    ToggleBtn.Text = scriptEnabled and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = scriptEnabled and Color3.fromRGB(0, 255, 160) or Color3.fromRGB(255, 80, 80)
    if not scriptEnabled then stopAllHijack() end
end)

-- プレイヤーリスト（上部）
playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0.92, 0, 0.25, 0)
playerListFrame.Position = UDim2.new(0.04, 0, 0.02, 320)
playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
playerListFrame.BackgroundTransparency = 0.25
playerListFrame.ScrollBarThickness = 14
playerListFrame.Parent = mainFrame

local listCorner = Instance.new("UICorner", playerListFrame)
listCorner.CornerRadius = UDim.new(0, 20)

-- 機能ボタン（全部デカくグリッド）
local function createFuncBtn(name, row, col, color, textColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.44, 0, 0, 180)
    btn.Position = UDim2.new(0.04 + col*0.48, 0, 0.30 + row*0.22, 0)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = textColor or Color3.new(1,1,1)
    btn.TextSize = 42
    btn.Font = Enum.Font.SourceSansProBold
    btn.TextWrapped = true
    btn.Parent = mainFrame
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 24)
    
    return btn
end

-- 左列
local XHijackBtn    = createFuncBtn("☓ コントロール奪取", 0, 0, Color3.fromRGB(220, 60, 60), Color3.new(1,1,1))
local TakeoverBtn   = createFuncBtn("🚀 プレイヤー乗っ取り", 1, 0, Color3.fromRGB(60, 220, 100), Color3.new(0,0,0))
local CrushBtn      = createFuncBtn("💀 Crush 回線落とし", 2, 0, Color3.fromRGB(180, 0, 255), Color3.new(1,1,1))

-- 右列（ラグスイッチを目立たせ）
local LagSwitchBtn  = createFuncBtn("🌐 サーバー超重ラグスイッチ", 0, 1, Color3.fromRGB(200, 0, 150), Color3.new(1,1,1))
local AllToBaseBtn  = createFuncBtn("🚀 ALL TO BASE 一気に盗む", 1, 1, Color3.fromRGB(255, 220, 60), Color3.new(0,0,0))
local NoclipBtn     = createFuncBtn("🌀 壁貫通 (OFF)",         2, 1, Color3.fromRGB(60, 200, 255), Color3.new(1,1,1))

-- 下部ボタン
local ResetBtn      = createFuncBtn("🛑 選択リセット",         3, 0, Color3.fromRGB(100, 100, 120), Color3.new(1,1,1))
local UnhijackBtn   = createFuncBtn("🔄 全部解除",             3, 1, Color3.fromRGB(60, 255, 220), Color3.new(0,0,0))

-- イベント
XHijackBtn.MouseButton1Click:Connect(function() if scriptEnabled then startXControlHijack() end end)
TakeoverBtn.MouseButton1Click:Connect(function() if scriptEnabled then startPlayerTakeover() end end)
CrushBtn.MouseButton1Click:Connect(function() if scriptEnabled then startCrush() end end)
LagSwitchBtn.MouseButton1Click:Connect(function() if scriptEnabled then startLagSwitch() end end)
AllToBaseBtn.MouseButton1Click:Connect(function() if scriptEnabled then startAllToBase() end end)

NoclipBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then
        noclipEnabled = not noclipEnabled
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            if noclipEnabled then
                noclipConn = RunService.Stepped:Connect(function()
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end)
            else
                if noclipConn then noclipConn:Disconnect() end
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
            NoclipBtn.Text = "🌀 壁貫通 (" .. (noclipEnabled and "ON" or "OFF") .. ")"
        end
    end
end)

ResetBtn.MouseButton1Click:Connect(function()
    selectedPlayers = {}
    updatePlayerList()
end)

UnhijackBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then stopAllHijack() end
end)

-- 自動更新
spawn(function()
    while wait(1.8) do
        updatePlayerList()
    end
end)

print("💎 v11.9 SUPER LAG FULL DISPLAY Loaded! | サーバー超重ラグスイッチ搭載")
