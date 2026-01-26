-- Delta Mobile Steal a Brainrot ∞ v11.9 FULL DISPLAY + SUPER LAG + EXTRA BUTTONS (名古屋 超本気仕様 2026)
-- 全機能一目で見える・新ボタン追加・サーバー超重ラグスイッチ極限

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local scriptEnabled = false
local noclipEnabled = false
local autoUpdateEnabled = true
local selectedPlayers = {}
local maxSelected = 10
local connections = {}
local noclipConn = nil
local updateLoop = nil

-- プレイヤーリスト更新
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

-- 自動更新ループ
local function startAutoUpdate()
    if updateLoop then updateLoop:Disconnect() end
    if autoUpdateEnabled then
        updateLoop = RunService.Heartbeat:Connect(function()
            if tick() % 1.5 < 0.1 then
                updatePlayerList()
            end
        end)
    end
end

-- （他の関数：startXControlHijack, startPlayerTakeover, startCrush, startLagSwitch, startAllToBase, stopAllHijack は前回と同じ）

-- 🔥 超高速Crush（強化版）
local function startUltraCrush()
    if #selectedPlayers == 0 then return end
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)
            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    tHRP.CFrame = tHRP.CFrame * CFrame.new(0, -1000, 0)
                    tHRP.AssemblyLinearVelocity = Vector3.new(0, -2000, 0)
                    tHRP.AssemblyAngularVelocity = Vector3.new(100,100,100)
                    tHum.Health = 0
                end
            end)
        end
    end
end

-- ⚡ ラグスイッチ極限（サーバー超重強化）
local function startExtremeLagSwitch()
    if #selectedPlayers == 0 then return end
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)
            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    tHRP.Velocity = Vector3.new()
                    tHRP.AssemblyLinearVelocity = Vector3.new()
                    tHRP.AssemblyAngularVelocity = Vector3.new(math.random(-50,50),math.random(-50,50),math.random(-50,50))
                    tHum.WalkSpeed = 0
                    tHum.JumpPower = 0
                    tHum.PlatformStand = true
                    
                    -- 位置を高速で揺らしてサーバー負荷MAX
                    local current = tHRP.CFrame
                    tHRP.CFrame = current * CFrame.Angles(math.rad(math.random(-5,5)), math.rad(math.random(-5,5)), math.rad(math.random(-5,5))) + Vector3.new(math.sin(tick()*50)*0.1, math.cos(tick()*50)*0.1, 0)
                    
                    -- 所有権を毎フレーム連打
                    pcall(function() tHRP:SetNetworkOwner(player) end)
                    wait(0.001) -- 微妙なディレイでスパム感UP
                end
            end)
        end
    end
end

-- GUI（新ボタン追加・全表示）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaFullExtraButtonsV119"
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
Title.Text = "Δ BRAINROT STEALER v11.9 EXTRA BTNS"
Title.TextColor3 = Color3.fromRGB(255, 80, 200)
Title.TextSize = 54
Title.Font = Enum.Font.GothamBlack
Title.TextStrokeTransparency = 0.5
Title.TextStrokeColor3 = Color3.new(0,0,0)
Title.Parent = mainFrame

-- ON/OFF
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

-- プレイヤーリスト
playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0.92, 0, 0.22, 0)
playerListFrame.Position = UDim2.new(0.04, 0, 0.02, 320)
playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
playerListFrame.BackgroundTransparency = 0.25
playerListFrame.ScrollBarThickness = 14
playerListFrame.Parent = mainFrame

local listCorner = Instance.new("UICorner", playerListFrame)
listCorner.CornerRadius = UDim.new(0, 20)

-- 機能ボタン（グリッド拡張・新ボタン追加）
local function createFuncBtn(name, row, col, color, textColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.44, 0, 0, 170)
    btn.Position = UDim2.new(0.04 + col*0.48, 0, 0.28 + row*0.205, 0)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = textColor or Color3.new(1,1,1)
    btn.TextSize = 40
    btn.Font = Enum.Font.SourceSansProBold
    btn.TextWrapped = true
    btn.Parent = mainFrame
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 24)
    
    return btn
end

-- 左列
local XHijackBtn     = createFuncBtn("☓ コントロール奪取", 0, 0, Color3.fromRGB(220, 60, 60), Color3.new(1,1,1))
local TakeoverBtn    = createFuncBtn("🚀 プレイヤー乗っ取り", 1, 0, Color3.fromRGB(60, 220, 100), Color3.new(0,0,0))
local CrushBtn       = createFuncBtn("💀 Crush 回線落とし", 2, 0, Color3.fromRGB(180, 0, 255), Color3.new(1,1,1))
local UltraCrushBtn  = createFuncBtn("🔥 超高速Crush", 3, 0, Color3.fromRGB(255, 100, 100), Color3.new(1,1,1))

-- 右列
local LagSwitchBtn   = createFuncBtn("🌐 サーバー超重ラグ", 0, 1, Color3.fromRGB(200, 0, 150), Color3.new(1,1,1))
local ExtremeLagBtn  = createFuncBtn("⚡ ラグスイッチ極限", 1, 1, Color3.fromRGB(180, 0, 120), Color3.new(1,1,1))
local AllToBaseBtn   = createFuncBtn("🚀 ALL TO BASE", 2, 1, Color3.fromRGB(255, 220, 60), Color3.new(0,0,0))
local NoclipBtn      = createFuncBtn("🌀 壁貫通 (OFF)", 3, 1, Color3.fromRGB(60, 200, 255), Color3.new(1,1,1))

-- 下部ボタン
local ResetBtn       = createFuncBtn("🛑 選択リセット", 4, 0, Color3.fromRGB(100, 100, 120), Color3.new(1,1,1))
local ClearAllBtn    = createFuncBtn("📋 選択全解除",   4, 1, Color3.fromRGB(80, 80, 100), Color3.new(1,1,1))
local AutoUpdateBtn  = createFuncBtn("🛡️ 自動更新 (ON)", 5, 0, Color3.fromRGB(0, 180, 255), Color3.new(1,1,1))
local UnhijackBtn    = createFuncBtn("🔄 全部解除",     5, 1, Color3.fromRGB(60, 255, 220), Color3.new(0,0,0))

-- イベント接続（新ボタン分追加）
XHijackBtn.MouseButton1Click:Connect(function() if scriptEnabled then startXControlHijack() end end)
TakeoverBtn.MouseButton1Click:Connect(function() if scriptEnabled then startPlayerTakeover() end end)
CrushBtn.MouseButton1Click:Connect(function() if scriptEnabled then startCrush() end end)
UltraCrushBtn.MouseButton1Click:Connect(function() if scriptEnabled then startUltraCrush() end end)
LagSwitchBtn.MouseButton1Click:Connect(function() if scriptEnabled then startLagSwitch() end end)
ExtremeLagBtn.MouseButton1Click:Connect(function() if scriptEnabled then startExtremeLagSwitch() end end)
AllToBaseBtn.MouseButton1Click:Connect(function() if scriptEnabled then startAllToBase() end end)

NoclipBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then
        noclipEnabled = not noclipEnabled
        -- （noclip処理は前回と同じ）
        NoclipBtn.Text = "🌀 壁貫通 (" .. (noclipEnabled and "ON" or "OFF") .. ")"
    end
end)

ResetBtn.MouseButton1Click:Connect(function()
    selectedPlayers = {}
    updatePlayerList()
end)

ClearAllBtn.MouseButton1Click:Connect(function()
    selectedPlayers = {}
    updatePlayerList()
end)

AutoUpdateBtn.MouseButton1Click:Connect(function()
    autoUpdateEnabled = not autoUpdateEnabled
    AutoUpdateBtn.Text = "🛡️ 自動更新 (" .. (autoUpdateEnabled and "ON" or "OFF") .. ")"
    startAutoUpdate()
end)

UnhijackBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then stopAllHijack() end
end)

-- 初期化
startAutoUpdate()
spawn(function()
    while wait(0.1) do
        if autoUpdateEnabled then updatePlayerList() end
    end
end)

print("💎 v11.9 EXTRA BUTTONS Loaded! | 新ボタン追加・極限ラグ搭載")
