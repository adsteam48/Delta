-- Delta Mobile Steal a Brainrot ∞ v11.1 (名古屋 メニュー全部表示モード 2026)
-- 💎 全画面メニュー・検知回避極限・壁貫通・☓奪取・🚀乗っ取り・閉じる/再表示
-- ⚠️ 教育/テストのみ! 野良サーバー短時間使用厳守

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local scriptEnabled = false
local noclipEnabled = false
local selectedPlayers = {}
local maxSelected = 5
local connections = {}
local noclipConn = nil
local mainFrame = nil
local showBtn = nil

-- ログ（デフォルトオフ）
local logEnabled = false
local function addLog(msg) end

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
            btn.Size = UDim2.new(1, -10, 0, 45)
            btn.Position = UDim2.new(0, 5, 0, yPos)
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
            yPos = yPos + 50
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

-- GUI（全部表示モード・全画面に近いサイズ）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FullMenuV108"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.9, 0, 0.9, 0)  -- 全部表示モードで大きく
mainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = ScreenGui
local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(0, 16); UICorner.Parent = mainFrame

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
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.02, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = mainFrame
local ToggleCorner = Instance.new("UICorner"); ToggleCorner.CornerRadius = UDim.new(0, 12); ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    ToggleBtn.Text = scriptEnabled and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = scriptEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
    if not scriptEnabled then
        selectedPlayers = {}
        for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
        connections = {}
        if noclipConn then noclipConn:Disconnect() end
        noclipEnabled = false
        NoclipBtn.Text = "🌀 壁貫通 (OFF)"
        updatePlayerList()
    end
end)

-- 閉じるボタン (右上×)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(0.95, -45, 0.02, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = mainFrame
local CloseCorner = Instance.new("UICorner"); CloseCorner.CornerRadius = UDim.new(0, 10); CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    showBtn.Visible = true
end)

-- 再表示ボタン（左下丸）
showBtn = Instance.new("TextButton")
showBtn.Size = UDim2.new(0, 70, 0, 70)
showBtn.Position = UDim2.new(0.02, 0, 0.88, 0)
showBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
showBtn.Text = "メニュー"
showBtn.TextColor3 = Color3.new(1,1,1)
showBtn.TextScaled = true
showBtn.Font = Enum.Font.GothamBold
showBtn.Visible = false
showBtn.Parent = ScreenGui
local ShowCorner = Instance.new("UICorner"); ShowCorner.CornerRadius = UDim.new(0.5, 0); ShowCorner.Parent = showBtn

-- 再表示ボタンドラッグ
local showDragging, showDragStart, showStartPos = false
showBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        showDragging = true
        showDragStart = input.Position
        showStartPos = showBtn.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then showDragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if showDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - showDragStart
        showBtn.Position = UDim2.new(showStartPos.X.Scale, showStartPos.X.Offset + delta.X, showStartPos.Y.Scale, showStartPos.Y.Offset + delta.Y)
    end
end)

showBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    showBtn.Visible = false
end)

-- プレイヤーリスト・ボタン類（全部表示モードで大きく）
playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
playerListFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
playerListFrame.BackgroundTransparency = 1
playerListFrame.ScrollBarThickness = 6
playerListFrame.Parent = mainFrame

-- ☓奪取ボタン
local XHijackBtn = Instance.new("TextButton")
XHijackBtn.Size = UDim2.new(0.45, 0, 0, 60)
XHijackBtn.Position = UDim2.new(0.025, 0, 0.65, 0)
XHijackBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
XHijackBtn.Text = "☓ コントロール奪取"
XHijackBtn.TextColor3 = Color3.new(1,1,1)
XHijackBtn.TextScaled = true
XHijackBtn.Font = Enum.Font.GothamBold
XHijackBtn.Parent = mainFrame
local XCorner = Instance.new("UICorner"); XCorner.CornerRadius = UDim.new(0, 12); XCorner.Parent = XHijackBtn

-- 🚀乗っ取りボタン
local TakeoverBtn = Instance.new("TextButton")
TakeoverBtn.Size = UDim2.new(0.45, 0, 0, 60)
TakeoverBtn.Position = UDim2.new(0.525, 0, 0.65, 0)
TakeoverBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
TakeoverBtn.Text = "🚀 プレイヤー乗っ取り"
TakeoverBtn.TextColor3 = Color3.new(0,0,0)
TakeoverBtn.TextScaled = true
TakeoverBtn.Font = Enum.Font.GothamBold
TakeoverBtn.Parent = mainFrame
local TCorner = Instance.new("UICorner"); TCorner.CornerRadius = UDim.new(0, 12); TCorner.Parent = TakeoverBtn

-- 壁貫通ボタン
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0.45, 0, 0, 60)
NoclipBtn.Position = UDim2.new(0.025, 0, 0.78, 0)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
NoclipBtn.Text = "🌀 壁貫通 (OFF)"
NoclipBtn.TextColor3 = Color3.new(1,1,1)
NoclipBtn.TextScaled = true
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.Parent = mainFrame
local NCorner = Instance.new("UICorner"); NCorner.CornerRadius = UDim.new(0, 12); NCorner.Parent = NoclipBtn

-- リセットボタン
local OffBtn = Instance.new("TextButton")
OffBtn.Size = UDim2.new(0.45, 0, 0, 60)
OffBtn.Position = UDim2.new(0.525, 0, 0.78, 0)
OffBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
OffBtn.Text = "🛑 リセット"
OffBtn.TextColor3 = Color3.new(1,1,1)
OffBtn.TextScaled = true
OffBtn.Font = Enum.Font.GothamBold
OffBtn.Parent = mainFrame
local OffCorner = Instance.new("UICorner"); OffCorner.CornerRadius = UDim.new(0, 12); OffCorner.Parent = OffBtn

-- ログON/OFF
local LogToggleBtn = Instance.new("TextButton")
LogToggleBtn.Size = UDim2.new(0.95, 0, 0, 30)
LogToggleBtn.Position = UDim2.new(0.025, 0, 0.92, 0)
LogToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
LogToggleBtn.Text = "ログ: OFF"
LogToggleBtn.TextColor3 = Color3.new(1,1,1)
LogToggleBtn.TextScaled = true
LogToggleBtn.Font = Enum.Font.Gotham
LogToggleBtn.Parent = mainFrame
local LogCorner = Instance.new("UICorner"); LogCorner.CornerRadius = UDim.new(0, 10); LogCorner.Parent = LogToggleBtn

LogToggleBtn.MouseButton1Click:Connect(function()
    logEnabled = not logEnabled
    LogToggleBtn.Text = "ログ: " .. (logEnabled and "ON" or "OFF")
end)

-- イベント
XHijackBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then startXControlHijack() end
end)

TakeoverBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then startPlayerTakeover() end
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

OffBtn.MouseButton1Click:Connect(function()
    selectedPlayers = {}
    updatePlayerList()
end)

-- 自動更新
spawn(function()
    while wait(3 + math.random(15)/10) do
        updatePlayerList()
    end
end)

print("💎 v11.1 Loaded! | メニュー全部表示モード | 左下丸ボタンで再表示")
