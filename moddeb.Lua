-- Delta Mobile Steal a Brainrot ∞ v11.9 (名古屋 超本気仕様 2026)
-- 💎 全画面メニュー・検知回避極限・壁貫通・☓奪取・🚀乗っ取り・Crush・ラグスイッチ・ALL TO BASE・解除・mod更新
-- ⚠️ 本気使用・野良/プライベート10秒以内使用厳守

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
local mainFrame = nil
local showBtn = nil

-- ログオフ
local logEnabled = false
local function addLog(msg) end

-- Brainrot検知
local function findBrainrots(char)
    local brainrots = {}
    for _, obj in pairs(char:GetChildren()) do
        if obj:IsA("Model") and (obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain")) then
            table.insert(brainrots, obj)
        end
    end
    return brainrots
end

-- プレイヤーリスト更新
local playerListFrame
local function updatePlayerList()
    if not playerListFrame then return end
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local yPos = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 50)
            btn.Position = UDim2.new(0, 10, 0, yPos)
            btn.BackgroundColor3 = table.find(selectedPlayers, p) and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(40, 40, 50)
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextScaled = true
            btn.Font = Enum.Font.GothamBold
            btn.Parent = playerListFrame
            btn.MouseButton1Click:Connect(function()
                if table.find(selectedPlayers, p) then
                    for i, v in pairs(selectedPlayers) do
                        if v == p then table.remove(selectedPlayers, i) break end
                    end
                    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                else
                    if #selectedPlayers < maxSelected then
                        table.insert(selectedPlayers, p)
                        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
                    end
                end
            end)
            yPos = yPos + 55
        end
    end
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- ☓コントロール奪取
local function startXControlHijack()
    if #selectedPlayers == 0 then return end
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
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
        local tHRP = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)
            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new()
                    tHRP.CFrame = CFrame.new(myPos + Vector3.new(math.random(-4,4), 0, math.random(-4,4)))
                    tHRP.Velocity = Vector3.new()
                    tHum.PlatformStand = true
                    tHum.WalkSpeed = 0
                end
            end)
        end
    end
end

-- 💀 Crush（回線落とし本気）
local function startCrush()
    if #selectedPlayers == 0 then return end
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)
            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    local current = tHRP.CFrame
                    tHRP.CFrame = current:Lerp(current * CFrame.new(0, -300, 0), 0.18)
                    tHRP.Velocity = Vector3.new(0, -800, 0)
                    tHRP.AssemblyLinearVelocity = Vector3.new(0, -800, 0)
                    tHum.Health = 0
                end
            end)
        end
    end
end

-- 🌐 ラグスイッチ（めっちゃ重く本気）
local function startLagSwitch()
    if #selectedPlayers == 0 then return end
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)
            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    tHRP.Velocity = Vector3.new()
                    tHRP.AssemblyLinearVelocity = Vector3.new()
                    tHRP.AssemblyAngularVelocity = Vector3.new()
                    tHum.WalkSpeed = 0
                    tHum.JumpPower = 0
                    tHum.PlatformStand = true
                    local current = tHRP.CFrame
                    tHRP.CFrame = current:Lerp(current, 0.03)
                end
            end)
        end
    end
end

-- 🚀 ALL TO BASE（相手のブレインロットを一気に自分のベースにテレポート盗み）
local function startAllToBase()
    if #selectedPlayers == 0 then return end
    local myBasePos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new()
    
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local brainrots = findBrainrots(tChar)
        for _, br in pairs(brainrots) do
            if br and br.Parent then
                br.Parent = player.Character
                if br:FindFirstChild("HumanoidRootPart") then
                    -- 自分のベースに一気にテレポート
                    br.HumanoidRootPart.CFrame = CFrame.new(myBasePos + Vector3.new(math.random(-8,8), 0, math.random(-8,8)))
                end
            end
        end
    end
end

-- 🔄 解除
local function stopAllHijack()
    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
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

-- mod更新
local function reloadMod()
    stopAllHijack()
    if noclipConn then noclipConn:Disconnect() end
    noclipEnabled = false
    scriptEnabled = false
    ToggleBtn.Text = "OFF"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    mainFrame.Visible = false
    showBtn.Visible = true
    wait(0.5)
    mainFrame.Visible = true
    showBtn.Visible = false
    updatePlayerList()
end

-- GUI（全部表示モード・幅広げ）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FullMenuV111"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.95, 0, 0.95, 0)
mainFrame.Position = UDim2.new(0.025, 0, 0.025, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = ScreenGui
local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(0, 20); UICorner.Parent = mainFrame

-- ドラッグ可能
local dragging, dragStart, startPos = false
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- 全体ON/OFF
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 70)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.02, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = mainFrame
local ToggleCorner = Instance.new("UICorner"); ToggleCorner.CornerRadius = UDim.new(0, 15); ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    ToggleBtn.Text = scriptEnabled and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = scriptEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    if not scriptEnabled then stopAllHijack() end
end)

-- mod更新
local ReloadBtn = Instance.new("TextButton")
ReloadBtn.Size = UDim2.new(0, 60, 0, 60)
ReloadBtn.Position = UDim2.new(0.95, -70, 0.02, 0)
ReloadBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
ReloadBtn.Text = "🔄 mod更新"
ReloadBtn.TextColor3 = Color3.new(0,0,0)
ReloadBtn.TextScaled = true
ReloadBtn.Font = Enum.Font.GothamBold
ReloadBtn.Parent = mainFrame
local ReloadCorner = Instance.new("UICorner"); ReloadCorner.CornerRadius = UDim.new(0, 15); ReloadCorner.Parent = ReloadBtn

ReloadBtn.MouseButton1Click:Connect(function()
    reloadMod()
end)

-- 閉じる
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 60, 0, 60)
CloseBtn.Position = UDim2.new(0.95, -135, 0.02, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = mainFrame
local CloseCorner = Instance.new("UICorner"); CloseCorner.CornerRadius = UDim.new(0, 15); CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    showBtn.Visible = true
end)

-- 再表示（丸）
showBtn = Instance.new("TextButton")
showBtn.Size = UDim2.new(0, 90, 0, 90)
showBtn.Position = UDim2.new(0.02, 0, 0.88, 0)
showBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
showBtn.Text = "メニュー"
showBtn.TextColor3 = Color3.new(1,1,1)
showBtn.TextScaled = true
showBtn.Font = Enum.Font.GothamBold
showBtn.Visible = false
showBtn.Parent = ScreenGui
local ShowCorner = Instance.new("UICorner"); ShowCorner.CornerRadius = UDim.new(0.5, 0); ShowCorner.Parent = showBtn

showBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    showBtn.Visible = false
end)

-- プレイヤーリスト
playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0.9, 0, 0.45, 0)
playerListFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
playerListFrame.BackgroundTransparency = 1
playerListFrame.ScrollBarThickness = 8
playerListFrame.Parent = mainFrame

-- ボタン類
local XHijackBtn = Instance.new("TextButton")
XHijackBtn.Size = UDim2.new(0.45, 0, 0, 80)
XHijackBtn.Position = UDim2.new(0.025, 0, 0.60, 0)
XHijackBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
XHijackBtn.Text = "☓ コントロール奪取"
XHijackBtn.TextColor3 = Color3.new(1,1,1)
XHijackBtn.TextScaled = true
XHijackBtn.Font = Enum.Font.GothamBold
XHijackBtn.Parent = mainFrame

local TakeoverBtn = Instance.new("TextButton")
TakeoverBtn.Size = UDim2.new(0.45, 0, 0, 80)
TakeoverBtn.Position = UDim2.new(0.525, 0, 0.60, 0)
TakeoverBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
TakeoverBtn.Text = "🚀 プレイヤー乗っ取り"
TakeoverBtn.TextColor3 = Color3.new(0,0,0)
TakeoverBtn.TextScaled = true
TakeoverBtn.Font = Enum.Font.GothamBold
TakeoverBtn.Parent = mainFrame

local CrushBtn = Instance.new("TextButton")
CrushBtn.Size = UDim2.new(0.45, 0, 0, 80)
CrushBtn.Position = UDim2.new(0.025, 0, 0.75, 0)
CrushBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
CrushBtn.Text = "💀 Crush (回線落とし)"
CrushBtn.TextColor3 = Color3.new(1,1,1)
CrushBtn.TextScaled = true
CrushBtn.Font = Enum.Font.GothamBold
CrushBtn.Parent = mainFrame

local LagSwitchBtn = Instance.new("TextButton")
LagSwitchBtn.Size = UDim2.new(0.45, 0, 0, 80)
LagSwitchBtn.Position = UDim2.new(0.525, 0, 0.75, 0)
LagSwitchBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
LagSwitchBtn.Text = "🌐 ラグスイッチ (めっちゃ重く)"
LagSwitchBtn.TextColor3 = Color3.new(0,0,0)
LagSwitchBtn.TextScaled = true
LagSwitchBtn.Font = Enum.Font.GothamBold
LagSwitchBtn.Parent = mainFrame

local AllToBaseBtn = Instance.new("TextButton")
AllToBaseBtn.Size = UDim2.new(0.9, 0, 0, 80)
AllToBaseBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
AllToBaseBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
AllToBaseBtn.Text = "🚀 ALL TO BASE (一気に自分のベースに盗む)"
AllToBaseBtn.TextColor3 = Color3.new(0,0,0)
AllToBaseBtn.TextScaled = true
AllToBaseBtn.Font = Enum.Font.GothamBold
AllToBaseBtn.Parent = mainFrame
local AllToBaseCorner = Instance.new("UICorner"); AllToBaseCorner.CornerRadius = UDim.new(0, 15); AllToBaseCorner.Parent = AllToBaseBtn

local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0.45, 0, 0, 80)
NoclipBtn.Position = UDim2.new(0.025, 0, 0.92, 0)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
NoclipBtn.Text = "🌀 壁貫通 (OFF)"
NoclipBtn.TextColor3 = Color3.new(1,1,1)
NoclipBtn.TextScaled = true
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.Parent = mainFrame

local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0.45, 0, 0, 80)
ResetBtn.Position = UDim2.new(0.525, 0, 0.92, 0)
ResetBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
ResetBtn.Text = "🛑 リセット"
ResetBtn.TextColor3 = Color3.new(1,1,1)
ResetBtn.TextScaled = true
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.Parent = mainFrame

local UnhijackBtn = Instance.new("TextButton")
UnhijackBtn.Size = UDim2.new(0.9, 0, 0, 70)
UnhijackBtn.Position = UDim2.new(0.05, 0, 0.97, 0)
UnhijackBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
UnhijackBtn.Text = "🔄 乗っ取り/コントロール解除"
UnhijackBtn.TextColor3 = Color3.new(0,0,0)
UnhijackBtn.TextScaled = true
UnhijackBtn.Font = Enum.Font.GothamBold
UnhijackBtn.Parent = mainFrame
local UnhijackCorner = Instance.new("UICorner"); UnhijackCorner.CornerRadius = UDim.new(0, 15); UnhijackCorner.Parent = UnhijackBtn

-- イベント
XHijackBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then startXControlHijack() end
end)

TakeoverBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then startPlayerTakeover() end
end)

CrushBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then startCrush() end
end)

LagSwitchBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then startLagSwitch() end
end)

AllToBaseBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then startAllToBase() end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then
        noclipEnabled = not noclipEnabled
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        if noclipEnabled then
            noclipConn = RunService.Stepped:Connect(function()
                if char and hrp then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
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
end)

ResetBtn.MouseButton1Click:Connect(function()
    selectedPlayers = {}
    updatePlayerList()
end)

UnhijackBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then
        stopAllHijack()
    end
end)

-- 自動更新
spawn(function()
    while wait(3 + math.random(15)/10) do
        updatePlayerList()
    end
end)

print("💎 v11.9 Loaded! | ALL TO BASE追加 | 相手のブレインロットを一気に自分のベースにテレポート盗む")
