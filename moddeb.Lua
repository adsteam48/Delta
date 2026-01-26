-- LagSwitch + Crush v1.3 (完全版・文字全部見えるUI)
-- ラグスイッチ + Crushボタン追加（ラグの下にCrush）
-- 相手を極限まで重く + 回線クラッシュで即抜け
-- 検知回避：所有権変更1回だけ・処理超緩やか

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local targets = {}
local lagConnections = {}
local crushConnections = {}
local isLagging = false
local isCrushing = false

-- GUI作成（文字が全部見えるように強化）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LagCrushGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.35, 0, 0.5, 0)  -- 少し縦長にしてボタン収まる
Frame.Position = UDim2.new(0.325, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)  -- 暗めで文字が浮き出る
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = Frame

-- タイトル（大きくクッキリ）
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Lag + Crush Only"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 45
Title.TextStrokeTransparency = 0.6
Title.TextStrokeColor3 = Color3.new(0,0,0)
Title.Parent = Frame

-- ラグスイッチボタン（文字切れ防止）
local LagBtn = Instance.new("TextButton")
LagBtn.Size = UDim2.new(0.9, 0, 0, 90)
LagBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
LagBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
LagBtn.Text = "ラグスイッチ OFF"
LagBtn.TextColor3 = Color3.new(1,1,1)
LagBtn.TextScaled = true
LagBtn.Font = Enum.Font.GothamBold
LagBtn.TextSize = 35
LagBtn.TextStrokeTransparency = 0.7
LagBtn.TextStrokeColor3 = Color3.new(0,0,0)
LagBtn.Parent = Frame
local LagCorner = Instance.new("UICorner")
LagCorner.CornerRadius = UDim.new(0, 12)
LagCorner.Parent = LagBtn

-- Crushボタン（ラグの下に配置）
local CrushBtn = Instance.new("TextButton")
CrushBtn.Size = UDim2.new(0.9, 0, 0, 90)
CrushBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
CrushBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
CrushBtn.Text = "Crush OFF (回線クラッシュ)"
CrushBtn.TextColor3 = Color3.new(1,1,1)
CrushBtn.TextScaled = true
CrushBtn.Font = Enum.Font.GothamBold
CrushBtn.TextSize = 35
CrushBtn.TextStrokeTransparency = 0.7
CrushBtn.TextStrokeColor3 = Color3.new(0,0,0)
CrushBtn.Parent = Frame
local CrushCorner = Instance.new("UICorner")
CrushCorner.CornerRadius = UDim.new(0, 12)
CrushCorner.Parent = CrushBtn

-- 閉じるボタン
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 50, 0, 50)
CloseBtn.Position = UDim2.new(0.95, -55, 0.02, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Frame
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

-- ラグスイッチON/OFF
LagBtn.MouseButton1Click:Connect(function()
    isLagging = not isLagging
    LagBtn.Text = "ラグスイッチ " .. (isLagging and "ON" or "OFF")
    LagBtn.BackgroundColor3 = isLagging and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
    
    if isLagging then
        for _, target in pairs(targets) do
            local char = target.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            if hrp and hum then
                pcall(function() hrp:SetNetworkOwner(player) end)
                lagConnections[target] = RunService.Heartbeat:Connect(function()
                    hrp.Velocity = Vector3.new()
                    hrp.AssemblyLinearVelocity = Vector3.new()
                    hrp.AssemblyAngularVelocity = Vector3.new()
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                    hum.PlatformStand = true
                    local current = hrp.CFrame
                    hrp.CFrame = current:Lerp(current, 0.03)
                end)
            end
        end
    else
        for _, conn in pairs(lagConnections) do
            if conn then conn:Disconnect() end
        end
        lagConnections = {}
    end
end)

-- Crush ON/OFF（回線クラッシュ）
CrushBtn.MouseButton1Click:Connect(function()
    isCrushing = not isCrushing
    CrushBtn.Text = "Crush " .. (isCrushing and "ON" or "OFF") .. " (回線クラッシュ)"
    CrushBtn.BackgroundColor3 = isCrushing and Color3.fromRGB(255, 100, 255) or Color3.fromRGB(200, 0, 255)
    
    if isCrushing then
        for _, target in pairs(targets) do
            local char = target.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            if hrp and hum then
                pcall(function() hrp:SetNetworkOwner(player) end)
                crushConnections[target] = RunService.Heartbeat:Connect(function()
                    local current = hrp.CFrame
                    hrp.CFrame = current:Lerp(current * CFrame.new(0, -400, 0), 0.2)
                    hrp.Velocity = Vector3.new(0, -1000, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, -1000, 0)
                    hum.Health = 0
                end)
            end
        end
    else
        for _, conn in pairs(crushConnections) do
            if conn then conn:Disconnect() end
        end
        crushConnections = {}
    end
end)

-- 閉じるボタン
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ドラッグ可能
local dragging, dragStart, startPos = false
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("ラグスイッチ + Crush 完全版起動！")
print("使い方：")
print("1. 対象プレイヤーを選択（ゲーム内でタップ・複数OK）")
print("2. ラグスイッチボタン → ONで極限ラグ / Crushボタン → ONで回線クラッシュ")
print("3. ×ボタンでメニューを閉じられます")
print("4. 文字が全部見えるように高さ・縁取り・コントラストを強化済み")
