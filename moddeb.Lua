-- LagSwitch Only v1.1 (シンプル・本気ラグスイッチ専用)
-- 相手を極限まで重くしてマジで何もできない状態にする
-- 対象プレイヤーを選択 → ボタンでON/OFF
-- 検知回避：所有権変更1回だけ・処理超緩やか

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local targets = {}
local lagConnections = {}
local isLagging = false

-- GUI作成（文字が全部見えるように調整）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LagSwitchGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.35, 0, 0.45, 0)  -- コンパクトで文字が見やすいサイズ
Frame.Position = UDim2.new(0.325, 0, 0.275, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BackgroundTransparency = 0.25
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = Frame

-- タイトル（大きくクッキリ）
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "LagSwitch Only"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 40
Title.TextStrokeTransparency = 0.7
Title.TextStrokeColor3 = Color3.new(0,0,0)
Title.Parent = Frame

-- ラグスイッチトグルボタン（文字が切れないように高さ増やし）
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 100)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
ToggleBtn.Text = "ラグスイッチ OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 35
ToggleBtn.TextStrokeTransparency = 0.8
ToggleBtn.TextStrokeColor3 = Color3.new(0,0,0)
ToggleBtn.Parent = Frame
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 12)
BtnCorner.Parent = ToggleBtn

-- ラグスイッチON/OFF機能
ToggleBtn.MouseButton1Click:Connect(function()
    isLagging = not isLagging
    ToggleBtn.Text = "ラグスイッチ " .. (isLagging and "ON" or "OFF")
    ToggleBtn.BackgroundColor3 = isLagging and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
    
    if isLagging then
        -- 対象プレイヤー全員にラグスイッチ適用
        for _, target in pairs(targets) do
            local char = target.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            if hrp and hum then
                pcall(function() hrp:SetNetworkOwner(player) end)  -- 所有権1回変更
                lagConnections[target] = RunService.Heartbeat:Connect(function()
                    hrp.Velocity = Vector3.new()
                    hrp.AssemblyLinearVelocity = Vector3.new()
                    hrp.AssemblyAngularVelocity = Vector3.new()
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                    hum.PlatformStand = true
                    -- 位置を超緩やかに固定（検知回避）
                    local current = hrp.CFrame
                    hrp.CFrame = current:Lerp(current, 0.03)
                end)
            end
        end
    else
        -- 解除
        for _, conn in pairs(lagConnections) do
            if conn then conn:Disconnect() end
        end
        lagConnections = {}
    end
end)

-- ドラッグ可能にする
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

-- 閉じるボタン
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(0.95, -45, 0.02, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Frame
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("ラグスイッチ専用スクリプト起動！")
print("使い方：")
print("1. 対象プレイヤーを選択（ゲーム内でタップ）")
print("2. 画面に表示されるボタンを押してON/OFF")
print("3. ONにすると選択したプレイヤーが極端に重くなり操作不能になります")
print("4. ×ボタンでメニューを閉じられます")
