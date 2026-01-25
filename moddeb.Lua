-- Delta Mobile Steal a Brainrot ∞ v9.3 (名古屋 壁貫通追加 2026 全マップ)
-- 💎 スマホ最適: 巨大ボタン・縦GUI・ログ・壁貫通 | F:Freeze G:Crush I:AutoSteal J:WallPenetrate H:OFF
-- ⚠️ 教育/テストのみ! Crushで回線即落ち + 壁貫通でBase完全侵入

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local currentMode = "off"
local enabled = false
local noclipEnabled = false
local targets = {}
local maxTargets = 5
local connections = {}
local spamRemotes = {}
local originalProps = {}
local espConnections = {}
local autoStealConn = nil
local noclipConn = nil
local stealthDelay = 0.001 + math.random(5)/1000

-- ログバッファ
local logBuffer = {}
local function addLog(msg)
    table.insert(logBuffer, os.date("%H:%M:%S") .. " | " .. msg)
    if #logBuffer > 100 then table.remove(logBuffer, 1) end
    if logFrame and logLabel then
        logLabel.Text = table.concat(logBuffer, "\n")
        logFrame.CanvasPosition = Vector2.new(0, logFrame.AbsoluteCanvasSize.Y)
    end
end

-- Brainrot検知
local function findBrainrots(char)
    local count = 0
    for _, obj in pairs(char:GetChildren()) do
        if obj.Name:lower():find("brainrot") or obj.Name:lower():find("brain") then
            count = count + 1
        end
    end
    return count
end

-- ESP簡易
local function updateESP(tPlayer)
    local char = tPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local count = findBrainrots(char)
    local hrp = char.HumanoidRootPart
    if not espConnections[tPlayer] then
        local esp = Instance.new("BillboardGui")
        esp.Adornee = hrp
        esp.Size = UDim2.new(0, 150, 0, 40)
        esp.StudsOffset = Vector3.new(0, 3, 0)
        esp.Parent = hrp
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1,0,0)
        label.TextScaled = true
        label.Parent = esp
        espConnections[tPlayer] = {gui=esp, label=label}
    end
    espConnections[tPlayer].label.Text = tPlayer.Name .. "\nBR: " .. count
end

-- AIターゲット
local function getAITargets()
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return {} end
    local myPos = myChar.HumanoidRootPart.Position
    local candidates = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
            local brainrots = findBrainrots(p.Character)
            local threat = (1/dist) * (brainrots * 3 + 1)
            table.insert(candidates, {player = p, threat = threat, brainrots = brainrots})
        end
    end
    table.sort(candidates, function(a,b) return a.threat > b.threat end)
    local top = {}
    for i=1, math.min(maxTargets, #candidates) do table.insert(top, candidates[i].player) end
    return top
end

-- Remote収集
local function collectRemotes()
    spamRemotes = {}
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(spamRemotes, obj)
        end
    end
    addLog("Remote収集: " .. #spamRemotes .. "個")
end

-- 壁貫通 (Noclip)
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if noclipEnabled then
        addLog("壁貫通 ON")
        noclipConn = RunService.Stepped:Connect(function()
            if char and hrp then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        -- 高速移動用BodyPosition
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bp.P = 10000
        bp.Parent = hrp
        spawn(function()
            while noclipEnabled and hrp do
                local moveDir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0,0,-1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0,0,1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-1,0,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1,0,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir + Vector3.new(0,-1,0) end
                if moveDir.Magnitude > 0 then
                    bp.Position = hrp.Position + (moveDir.Unit * 50) -- 速度調整
                end
                wait(0.01)
            end
        end)
    else
        addLog("壁貫通 OFF")
        if noclipConn then noclipConn:Disconnect() end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotMobileV93"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.95, 0, 0.98, 0)
MainFrame.Position = UDim2.new(0.025, 0, 0.01, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(0, 20); UICorner.Parent = MainFrame
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(150,0,200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,200,255))}
UIGradient.Rotation = 45; UIGradient.Parent = MainFrame

-- ログエリア
local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(0.9, 0, 0.25, 0)
logFrame.Position = UDim2.new(0.05, 0, 0.70, 0)
logFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
logFrame.BorderSizePixel = 0
logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
logFrame.ScrollBarThickness = 8
logFrame.Parent = MainFrame
local logUICorner = Instance.new("UICorner"); logUICorner.CornerRadius = UDim.new(0, 10); logUICorner.Parent = logFrame

local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(1, -10, 0, 0)
logLabel.Position = UDim2.new(0, 5, 0, 0)
logLabel.BackgroundTransparency = 1
logLabel.TextColor3 = Color3.new(0.8, 0.8, 1)
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.TextYAlignment = Enum.TextYAlignment.Top
logLabel.TextWrapped = true
logLabel.TextScaled = false
logLabel.Font = Enum.Font.SourceSans
logLabel.TextSize = 14
logLabel.Parent = logFrame

-- ボタン（壁貫通追加）
local FreezeBtn = Instance.new("TextButton")
FreezeBtn.Size = UDim2.new(0.9, 0, 0, 80)
FreezeBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
FreezeBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
FreezeBtn.Text = "🧊 FREEZE"
FreezeBtn.TextColor3 = Color3.new(0,0,0)
FreezeBtn.TextScaled = true
FreezeBtn.Font = Enum.Font.GothamBold
FreezeBtn.Parent = MainFrame
local FCorner = Instance.new("UICorner"); FCorner.CornerRadius = UDim.new(0, 22); FCorner.Parent = FreezeBtn

local CrushBtn = Instance.new("TextButton")
CrushBtn.Size = UDim2.new(0.9, 0, 0, 80)
CrushBtn.Position = UDim2.new(0.05, 0, 0.24, 0)
CrushBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
CrushBtn.Text = "💀 CRUSH 回線落とし"
CrushBtn.TextColor3 = Color3.new(1,1,1)
CrushBtn.TextScaled = true
CrushBtn.Font = Enum.Font.GothamBold
CrushBtn.Parent = MainFrame
local CCorner = Instance.new("UICorner"); CCorner.CornerRadius = UDim.new(0, 22); CCorner.Parent = CrushBtn

local AutoStealBtn = Instance.new("TextButton")
AutoStealBtn.Size = UDim2.new(0.9, 0, 0, 80)
AutoStealBtn.Position = UDim2.new(0.05, 0, 0.36, 0)
AutoStealBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
AutoStealBtn.Text = "🚀 AUTO STEAL"
AutoStealBtn.TextColor3 = Color3.new(0,0,0)
AutoStealBtn.TextScaled = true
AutoStealBtn.Font = Enum.Font.GothamBold
AutoStealBtn.Parent = MainFrame
local SCorner = Instance.new("UICorner"); SCorner.CornerRadius = UDim.new(0, 22); SCorner.Parent = AutoStealBtn

local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(0.9, 0, 0, 80)
NoclipBtn.Position = UDim2.new(0.05, 0, 0.48, 0)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
NoclipBtn.Text = "🌀 壁貫通 (OFF)"
NoclipBtn.TextColor3 = Color3.new(1,1,1)
NoclipBtn.TextScaled = true
NoclipBtn.Font = Enum.Font.GothamBold
NoclipBtn.Parent = MainFrame
local NCorner = Instance.new("UICorner"); NCorner.CornerRadius = UDim.new(0, 22); NCorner.Parent = NoclipBtn

local OffBtn = Instance.new("TextButton")
OffBtn.Size = UDim2.new(0.9, 0, 0, 70)
OffBtn.Position = UDim2.new(0.05, 0, 0.60, 0)
OffBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
OffBtn.Text = "🛑 OFF"
OffBtn.TextColor3 = Color3.new(1,1,1)
OffBtn.TextScaled = true
OffBtn.Font = Enum.Font.GothamBold
OffBtn.Parent = MainFrame
local OffCorner = Instance.new("UICorner"); OffCorner.CornerRadius = UDim.new(0, 22); OffCorner.Parent = OffBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 50)
StatusLabel.Position = UDim2.new(0, 0, 0, 70)
StatusLabel.Text = "モード: OFF | ターゲット: 0/5"
StatusLabel.TextColor3 = Color3.fromRGB(255,215,0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Parent = MainFrame

-- モードセット
local function setMode(newMode)
    enabled = false
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    connections = {}
    if autoStealConn then autoStealConn:Disconnect() end
    for tPlayer, _ in pairs(originalProps) do
        if tPlayer.Character and tPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function() tPlayer.Character.HumanoidRootPart:SetNetworkOwner(tPlayer) end)
        end
    end
    originalProps = {}

    currentMode = newMode
    addLog("モード変更: " .. newMode:upper())

    if newMode == "off" then
        StatusLabel.Text = "モード: OFF | ターゲット: 0/5"
        return
    end

    targets = getAITargets()
    addLog("ターゲット検出: " .. #targets .. "人")

    if #targets == 0 then return end

    for _, tPlayer in pairs(targets) do
        local tChar = tPlayer.Character
        local tHRP = tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar:FindFirstChild("Humanoid")
        if tHRP and tHum then
            originalProps[tPlayer] = {CFrame = tHRP.CFrame}
            pcall(function() tHRP:SetNetworkOwner(player) end)

            connections[tPlayer] = RunService.Heartbeat:Connect(function()
                if tPlayer.Parent and tHRP then
                    updateESP(tPlayer)
                    if newMode == "freeze" then
                        tHRP.CFrame = originalProps[tPlayer].CFrame
                        tHum.PlatformStand = true
                        tHum.WalkSpeed = 0
                    elseif newMode == "crush" then
                        tHRP.CFrame = originalProps[tPlayer].CFrame * CFrame.new(0, -300, 0)
                        tHRP.Velocity = Vector3.new(math.random(-2000,2000), -2000, math.random(-2000,2000))
                        tHum.Health = 0
                    end
                end
            end)
        end
    end

    if newMode == "autosteal" then
        autoStealConn = RunService.Heartbeat:Connect(function()
            for _, tPlayer in pairs(targets) do
                local brainrots = tPlayer.Character:GetChildren()
                for _, br in pairs(brainrots) do
                    if br.Name:lower():find("brainrot") then
                        br.CFrame = player.Character.HumanoidRootPart.CFrame
                    end
                end
            end
        end)
        addLog("AUTO STEAL 開始")
    end

    -- Crush回線落とし
    spawn(function()
        while currentMode ~= "off" do
            for _, remote in pairs(spamRemotes) do
                for _, t in pairs(targets) do
                    pcall(function()
                        remote:FireServer(t, {math.random(1e10)}, "crash", workspace)
                    end)
                end
            end
            addLog("[CRUSH] Spam送信")
            wait(stealthDelay)
        end
    end)

    enabled = true
    StatusLabel.Text = "モード: " .. string.upper(newMode) .. " ∞ | ターゲット: " .. #targets .. "/5"
end

-- 壁貫通トグル
NoclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
    NoclipBtn.Text = "🌀 壁貫通 (" .. (noclipEnabled and "ON" or "OFF") .. ")"
end)

-- ボタンイベント
FreezeBtn.MouseButton1Click:Connect(function() setMode("freeze") end)
CrushBtn.MouseButton1Click:Connect(function() setMode("crush") end)
AutoStealBtn.MouseButton1Click:Connect(function() setMode("autosteal") end)
OffBtn.MouseButton1Click:Connect(function() setMode("off") end)

-- キー
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then setMode("freeze") end
    if input.KeyCode == Enum.KeyCode.G then setMode("crush") end
    if input.KeyCode == Enum.KeyCode.I then setMode("autosteal") end
    if input.KeyCode == Enum.KeyCode.J then toggleNoclip(); NoclipBtn.Text = "🌀 壁貫通 (" .. (noclipEnabled and "ON" or "OFF") .. ")" end
    if input.KeyCode == Enum.KeyCode.H then setMode("off") end
end)

-- 自動更新
spawn(function()
    while wait(1.2) do
        targets = getAITargets()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then updateESP(p) end
        end
        if enabled then
            addLog("更新: ターゲット " .. #targets .. "人")
        end
    end
end)

collectRemotes()
addLog("スクリプト起動完了 | Delta Mobile v9.3 | 壁貫通(Jキー or 青ボタン)")
print("💎 名古屋 Brainrot v9.3 Loaded! | 壁貫通追加 | Crush(G)で回線落とし + 壁越し侵入")
