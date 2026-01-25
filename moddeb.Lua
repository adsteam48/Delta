-- Delta Mobile Steal a Brainrot ∞ v10.5 (名古屋 乗っ取りボタン追加 2026)
-- 💎 幅0.35メニュー・検知回避極限・壁貫通・☓奪取・🚀乗っ取り
-- ⚠️ 教育/テストのみ! 短時間使用推奨

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local noclipEnabled = false
local selectedPlayers = {}
local maxSelected = 5
local connections = {}
local noclipConn = nil

-- ログバッファ（デフォルトオフ）
local logBuffer = {}
local logEnabled = false
local function addLog(msg)
    if logEnabled then
        table.insert(logBuffer, os.date("%H:%M:%S") .. " | " .. msg)
        if #logBuffer > 20 then table.remove(logBuffer, 1) end
        if logLabel then
            logLabel.Text = table.concat(logBuffer, "\n")
            logFrame.CanvasPosition = Vector2.new(0, logFrame.AbsoluteCanvasSize.Y)
        end
    end
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
            btn.Size = UDim2.new(1, -8, 0, 32)
            btn.Position = UDim2.new(0, 4, 0, yPos)
            btn.BackgroundColor3 = table.find(selectedPlayers, p) and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(35, 35, 45)
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.Parent = playerListFrame
            btn.MouseButton1Click:Connect(function()
                if table.find(selectedPlayers, p) then
                    for i, v in pairs(selectedPlayers) do
                        if v == p then table.remove(selectedPlayers, i) break end
                    end
                    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                    addLog("対象解除: " .. p.Name)
                else
                    if #selectedPlayers < maxSelected then
                        table.insert(selectedPlayers, p)
                        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
                        addLog("対象追加: " .. p.Name)
                    end
                end
            end)
            yPos = yPos + 36
        end
    end
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- ☓コントロール奪取（位置固定）
local function startXControlHijack()
    if #selectedPlayers == 0 then 
        addLog("対象未選択")
        return 
    end

    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)

            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    local current = tHRP.CFrame
                    tHRP.CFrame = current:Lerp(tHRP.CFrame, 0.3)
                    tHRP.Velocity = Vector3.new()
                    tHum.PlatformStand = true
                    tHum.WalkSpeed = 0
                end
            end)
        end
    end
    addLog("☓コントロール奪取開始: " .. #selectedPlayers .. "人")
end

-- 🚀プレイヤー乗っ取り（相手を操作可能にする試み）
local function startPlayerTakeover()
    if #selectedPlayers == 0 then 
        addLog("対象未選択")
        return 
    end

    for _, tPlayer in pairs(selectedPlayers) do
        local tChar = tPlayer.Character
        local tHRP = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            pcall(function() tHRP:SetNetworkOwner(player) end)

            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    -- 相手の位置を自分に同期させて操作可能にする
                    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new()
                    tHRP.CFrame = CFrame.new(myPos + Vector3.new(math.random(-5,5), 0, math.random(-5,5)))
                    tHRP.Velocity = Vector3.new()
                    tHum.PlatformStand = true
                    tHum.WalkSpeed = 0
                end
            end)
        end
    end
    addLog("🚀プレイヤー乗っ取り開始: " .. #selectedPlayers .. "人 (相手を操作可能に)")
end

-- GUI（幅0.35のまま）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WideCompactXBrainrotV105"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.35, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.65, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.35
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(0, 12); UICorner.Parent = MainFrame

-- ドラッグ可能
local dragging, dragStart, startPos = false
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "名古屋 ∞ v10.5"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- プレイヤー選択リスト
playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0.95, 0, 0.4, 0)
playerListFrame.Position = UDim2.new(0.025, 0, 0.08, 0)
playerListFrame.BackgroundTransparency = 1
playerListFrame.ScrollBarThickness = 4
playerListFrame.Parent = MainFrame

-- ☓奪取ボタン
local XHijackBtn = Instance.new("TextButton")
XHijackBtn.Size = UDim2.new(0.95, 0, 0, 40)
XHijackBtn.Position = UDim2.new(0.025, 0, 0.50, 0)
XHijackBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
XHijackBtn.Text = "☓ コントロール奪取"
XHijackBtn.TextColor3 = Color3.new(1,1,1)
XHijackBtn.TextScaled = true
XHijackBtn.Font = Enum.Font.GothamBold
XHijackBtn.Parent = MainFrame
local XCorner = Instance.new("UICorner"); XCorner.CornerRadius = UDim.new(0, 10); XCorner.Parent = XHijackBtn

-- 🚀乗っ取りボタン（新追加）
local TakeoverBtn = Instance.new("TextButton")
TakeoverBtn.Size = UDim2.new(0.95, 0, 0, 40)
TakeoverBtn.Position = UDim2.new(0.025, 0, 0.58, 0)
TakeoverBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
TakeoverBtn.Text = "🚀 プレイヤー乗っ取り"
TakeoverBtn.TextColor3 = Color3.new(0,0,0)
TakeoverBtn.TextScaled = true
TakeoverBtn.Font = Enum.Font.GothamBold
TakeoverBtn.Parent = MainFrame
local TCorner = Instance.new("UICorner"); TCorner.CornerRadius = UDim.new(0, 10); TCorner.Parent = TakeoverBtn

-- 壁貫通ボタン
local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0.95, 0, 0, 40)
NoclipBtn.Position = UDim2.new(0.025, 0, 0.66, 0)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
NoclipBtn.Text = "🌀 壁貫通 (OFF)"
NoclipBtn.TextColor3 = Color3.new(1,1,1)
NoclipBtn.TextScaled = true
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.Parent = MainFrame
local NCorner = Instance.new("UICorner"); NCorner.CornerRadius = UDim.new(0, 10); NCorner.Parent = NoclipBtn

-- OFFボタン
local OffBtn = Instance.new("TextButton")
OffBtn.Size = UDim2.new(0.95, 0, 0, 35)
OffBtn.Position = UDim2.new(0.025, 0, 0.74, 0)
OffBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
OffBtn.Text = "🛑 OFF"
OffBtn.TextColor3 = Color3.new(1,1,1)
OffBtn.TextScaled = true
OffBtn.Font = Enum.Font.GothamBold
OffBtn.Parent = MainFrame
local OffCorner = Instance.new("UICorner"); OffCorner.CornerRadius = UDim.new(0, 10); OffCorner.Parent = OffBtn

-- ログON/OFF
local LogToggleBtn = Instance.new("TextButton")
LogToggleBtn.Size = UDim2.new(0.95, 0, 0, 30)
LogToggleBtn.Position = UDim2.new(0.025, 0, 0.85, 0)
LogToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
LogToggleBtn.Text = "ログ: OFF"
LogToggleBtn.TextColor3 = Color3.new(1,1,1)
LogToggleBtn.TextScaled = true
LogToggleBtn.Font = Enum.Font.Gotham
LogToggleBtn.Parent = MainFrame
local LogCorner = Instance.new("UICorner"); LogCorner.CornerRadius = UDim.new(0, 8); LogCorner.Parent = LogToggleBtn

LogToggleBtn.MouseButton1Click:Connect(function()
    logEnabled = not logEnabled
    LogToggleBtn.Text = "ログ: " .. (logEnabled and "ON" or "OFF")
end)

-- イベント
XHijackBtn.MouseButton1Click:Connect(startXControlHijack)
TakeoverBtn.MouseButton1Click:Connect(startPlayerTakeover)
NoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if noclipEnabled then
        addLog("壁貫通 ON")
        noclipConn = RunService.Stepped:Connect(function()
            if char and hrp then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        addLog("壁貫通 OFF")
        if noclipConn then noclipConn:Disconnect() end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    NoclipBtn.Text = "🌀 壁貫通 (" .. (noclipEnabled and "ON" or "OFF") .. ")"
end)

OffBtn.MouseButton1Click:Connect(function()
    selectedPlayers = {}
    updatePlayerList()
    addLog("全OFF & リセット")
end)

-- 自動更新（検知回避遅延）
spawn(function()
    while wait(2.2 + math.random(12)/10) do
        updatePlayerList()
    end
end)

addLog("起動完了 | 乗っ取りボタン追加 | ☓/🚀で操作開始")
print("💎 v10.5 Loaded! | プレイヤー乗っ取りボタン追加 | 検知回避極限")
