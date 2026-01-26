-- Delta Mobile Steal a Brainrot ∞ v11.9 (名古屋 超本気仕様 2026) - 見やすさ強化版
-- 全画面メニュー・検知回避極限・壁貫通・☓奪取・🚀乗っ取り・Crush・ラグスイッチ・ALL TO BASE・解除

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

-- プレイヤーリスト更新
local playerListFrame
local function updatePlayerList()
    if not playerListFrame then return end
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local yPos = 10
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 60)          -- ボタン高さUP
            btn.Position = UDim2.new(0, 10, 0, yPos)
            btn.BackgroundColor3 = table.find(selectedPlayers, p) and Color3.fromRGB(0, 220, 80) or Color3.fromRGB(35, 35, 45)
            btn.Text = "  " .. p.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextSize = 24                             -- 文字サイズ大きく
            btn.Font = Enum.Font.SourceSansBold           -- 読みやすいフォント
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.BackgroundTransparency = 0.1
            btn.BorderSizePixel = 0
            btn.Parent = playerListFrame
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                if table.find(selectedPlayers, p) then
                    for i, v in pairs(selectedPlayers) do
                        if v == p then table.remove(selectedPlayers, i) break end
                    end
                    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                else
                    if #selectedPlayers < maxSelected then
                        table.insert(selectedPlayers, p)
                        btn.BackgroundColor3 = Color3.fromRGB(0, 220, 80)
                    end
                end
            end)
            yPos = yPos + 70  -- 間隔を広げる
        end
    end
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)
end

-- （他の関数は変更なしのため省略 → startXControlHijack, startPlayerTakeover, startCrush, startLagSwitch, startAllToBase, stopAllHijack, reloadMod などは元のまま使用）

-- GUI（見やすさ特化版）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FullMenuV111_Enhanced"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.92, 0, 0.90, 0)
mainFrame.Position = UDim2.new(0.04, 0, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BackgroundTransparency = 0.15          -- 背景を少し濃く
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 24)
UICorner.Parent = mainFrame

-- タイトル
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 80)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Δ Delta Brainrot Stealer v11.9"
Title.TextColor3 = Color3.fromRGB(0, 255, 180)
Title.TextSize = 42
Title.Font = Enum.Font.GothamBlack
Title.TextStrokeTransparency = 0.7
Title.TextStrokeColor3 = Color3.new(0,0,0)
Title.Parent = mainFrame

-- ON/OFF ボタン（大きく）
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.88, 0, 0, 90)
ToggleBtn.Position = UDim2.new(0.06, 0, 0.09, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextSize = 38
ToggleBtn.Font = Enum.Font.SourceSansProBold
ToggleBtn.Parent = mainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 18)
ToggleCorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    scriptEnabled = not scriptEnabled
    ToggleBtn.Text = scriptEnabled and "ON" or "OFF"
    ToggleBtn.BackgroundColor3 = scriptEnabled and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 60, 60)
    if not scriptEnabled then stopAllHijack() end
end)

-- プレイヤーリスト
playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0.88, 0, 0.38, 0)
playerListFrame.Position = UDim2.new(0.06, 0, 0.18, 0)
playerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
playerListFrame.BackgroundTransparency = 0.4
playerListFrame.BorderSizePixel = 0
playerListFrame.ScrollBarThickness = 10
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 255, 200)
playerListFrame.Parent = mainFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 16)
listCorner.Parent = playerListFrame

-- 機能ボタン（大きめ・読みやすく）
local function createBigButton(name, posY, color, textColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.42, 0, 0, 100)
    btn.Position = UDim2.new(0.06 + (posY % 2 == 0 and 0.5 or 0), 0, 0.58 + math.floor(posY/2)*0.17, 0)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = textColor or Color3.new(1,1,1)
    btn.TextSize = 32
    btn.Font = Enum.Font.SourceSansProBold
    btn.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = btn
    
    return btn
end

local XHijackBtn    = createBigButton("☓ コントロール奪取", 0, Color3.fromRGB(220, 60, 60), Color3.new(1,1,1))
local TakeoverBtn   = createBigButton("🚀 プレイヤー乗っ取り", 1, Color3.fromRGB(60, 220, 100), Color3.new(0,0,0))
local CrushBtn      = createBigButton("💀 Crush (回線落とし)", 2, Color3.fromRGB(180, 0, 255), Color3.new(1,1,1))
local LagSwitchBtn  = createBigButton("🌐 ラグスイッチ",     3, Color3.fromRGB(255, 180, 60), Color3.new(0,0,0))
local AllToBaseBtn  = createBigButton("🚀 ALL TO BASE (一気に盗む)", 4, Color3.fromRGB(255, 220, 60), Color3.new(0,0,0))
    AllToBaseBtn.Size = UDim2.new(0.88, 0, 0, 100)
    AllToBaseBtn.Position = UDim2.new(0.06, 0, 0.75, 0)

-- その他のボタン
local NoclipBtn = createBigButton("🌀 壁貫通 (OFF)", 5, Color3.fromRGB(60, 200, 255), Color3.new(1,1,1))
    NoclipBtn.Size = UDim2.new(0.42, 0, 0, 100)
    NoclipBtn.Position = UDim2.new(0.06, 0, 0.92, 0)

local ResetBtn = createBigButton("🛑 リセット", 6, Color3.fromRGB(100, 100, 110), Color3.new(1,1,1))
    ResetBtn.Size = UDim2.new(0.42, 0, 0, 100)
    ResetBtn.Position = UDim2.new(0.54, 0, 0.92, 0)

local UnhijackBtn = createBigButton("🔄 乗っ取り/コントロール解除", 7, Color3.fromRGB(60, 255, 220), Color3.new(0,0,0))
    UnhijackBtn.Size = UDim2.new(0.88, 0, 0, 90)
    UnhijackBtn.Position = UDim2.new(0.06, 0, 0.99, 0)

-- イベント接続（NoclipのON/OFF表示更新など）
NoclipBtn.MouseButton1Click:Connect(function()
    if scriptEnabled then
        noclipEnabled = not noclipEnabled
        -- ...（元のnoclip処理）
        NoclipBtn.Text = "🌀 壁貫通 (" .. (noclipEnabled and "ON" or "OFF") .. ")"
    end
end)

-- 自動更新
spawn(function()
    while wait(2.5) do
        updatePlayerList()
    end
end)

print("💎 v11.9 見やすさ強化版 Loaded! | 文字大きく・コントラストUP")
