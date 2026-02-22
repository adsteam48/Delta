-- // 津波から逃げろ + 全災害無効 + ラグスイッチ HELL SCRIPT v4.RAGSWITCH // 
-- // メニューON/OFF！ ラグで皆予測不能♡ 触れねぇ+ラグで神www BAN即死確定♡♡♡

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- トグル変数 ♡ ラグスイッチ追加！
local godMode = false
local speedHack = false
local flyMode = false
local tsunamiIgnore = false
local allDisable = false
local lagSwitch = false  -- 🔥 新！ラグスイッチ (NetworkOwner nilでサーバーラグ神)
local flySpeed = 100

-- メニュー作成（さらにデカく♡）
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TsunamiRagHellMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 600)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- 角丸 + 赤黒炎 ♡
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 25)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200, 0, 0)
stroke.Thickness = 5
stroke.Parent = mainFrame

-- タイトル（ラグ煽り♡）
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 80)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌪️ RAG HELL MODE 🌪️\nラグ+全災害無効♡ 皆死ねぇwww"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- 閉じるボタン（デカく♡）
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 60, 0, 60)
closeBtn.Position = UDim2.new(1, -70, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeBtn

-- トグル作成関数（改良）
local function createToggle(name, posY, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -60, 0, 60)
    frame.Position = UDim2.new(0, 30, 0, posY)
    frame.BackgroundTransparency = 1
    frame.Parent = mainFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.75, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 80, 0, 45)
    toggleBtn.Position = UDim2.new(1, -90, 0.5, -22.5)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 12)
    tCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        local isOn = toggleBtn.Text == "ON"
        callback(not isOn)
        toggleBtn.Text = isOn and "OFF" or "ON"
        toggleBtn.BackgroundColor3 = toggleBtn.Text == "ON" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(70, 70, 70)
    end)
    
    return toggleBtn
end

-- トグル一覧（ラグ追加♡）
createToggle("🛡️ 神モード (無敵)", 100, function(on) godMode = on end)
createToggle("⚡ 超スピード (80)", 170, function(on) 
    speedHack = on
    if character and humanoid then humanoid.WalkSpeed = on and 80 or 16 end
end)
createToggle("✈️ フライ (WASD+Sp+Ctrl)", 240, function(on) flyMode = on end)
createToggle("🌊 津波専用無視", 310, function(on) tsunamiIgnore = on end)
createToggle("💥 全災害無効化", 380, function(on) allDisable = on end)

-- 🔥 新！ラグスイッチトグル（これでラグ地獄♡）
local ragBtn = createToggle("🌐 ラグスイッチ (予測不能神)", 450, function(on)
    lagSwitch = on
    print(on and "🌐 ラグスイッチON!! 皆の弾当たらねぇwww サーバー泣かせ♡" or "ラグオフ…凡人モード")
end)

-- Fly Speedスライダー
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -60, 0, 40)
speedLabel.Position = UDim2.new(0, 30, 0, 520)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "🚀 Fly Speed: 100"
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, -60, 0, 30)
sliderFrame.Position = UDim2.new(0, 30, 0, 560)
sliderFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
sliderFrame.Parent = mainFrame
local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 15)
sCorner.Parent = sliderFrame

local sliderBtn = Instance.new("TextButton")
sliderBtn.Size = UDim2.new(0, 30, 1, 0)
sliderBtn.Position = UDim2.new(0.5, -15, 0, 0)
sliderBtn.BackgroundColor3 = Color3.fromRGB(255,255,0)
sliderBtn.Text = ""
sliderBtn.Parent = sliderFrame
local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 15)
sbCorner.Parent = sliderBtn

-- スライダー（同じ）
local dragging = false
sliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end)
sliderBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = sliderBtn.AbsolutePosition.X - sliderFrame.AbsolutePosition.X
        local perc = math.clamp(pos / sliderFrame.AbsoluteSize.X, 0, 1)
        flySpeed = math.floor(perc * 200 + 50)
        speedLabel.Text = "🚀 Fly Speed: " .. flySpeed
        sliderBtn.Position = UDim2.new(perc, -15, 0, 0)
    end
end)

-- メニュー開閉（Insert + アニメ強化）
local menuVisible = false
uis.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        menuVisible = not menuVisible
        if menuVisible then
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 600)
            mainFrame:TweenSize(UDim2.new(0, 480, 0, 600), "Out", "Quad", 0.5)
        else
            mainFrame:TweenSize(UDim2.new(0, 0, 0, 600), "In", "Quad", 0.5)
            game:GetService("Debris"):AddItem(mainFrame, 0.5)  -- 待って非表示
            wait(0.5)
            mainFrame.Visible = false
            mainFrame.Size = UDim2.new(0, 480, 0, 600)  -- リセット
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    menuVisible = false
    mainFrame:TweenSize(UDim2.new(0, 0, 0, 600), "In", "Quad", 0.5)
    game:GetService("Debris"):AddItem(mainFrame, 0.5)
    wait(0.5)
    mainFrame.Visible = false
    mainFrame.Size = UDim2.new(0, 480, 0, 600)
end)

-- 🔥🔥 メインループ：全チート + ラグスイッチ ♡
rs.Heartbeat:Connect(function()
    if not character or not humanoid or not root then return end
    
    -- 神モード
    if godMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
    
    -- スピード
    if speedHack then humanoid.WalkSpeed = 80 end
    
    -- 津波専用
    if tsunamiIgnore then
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("water") or part.Name:lower():find("tsunami") or part.Name:lower():find("wave")) then
                part.CanCollide = false
                part.CanTouch = false
                part.Transparency = 0.95
                if part:FindFirstChildOfClass("TouchTransmitter") then part:FindFirstChildOfClass("TouchTransmitter"):Destroy() end
            end
        end
    end
    
    -- 全災害無効化
    if allDisable then
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Parent ~= character then
                local isDisaster = part.Name:lower():match("lava|fire|rock|debris|tornado|meteor|earthquake|quake|disaster|damage|fall|kill")
                if isDisaster or part.Size.Magnitude > 5 then  -- 大きいヤツも♡
                    part.CanTouch = false
                    part.CanCollide = false
                    part.Transparency = math.min(part.Transparency + 0.005, 0.98)
                    if part:FindFirstChildOfClass("TouchTransmitter") then part:FindFirstChildOfClass("TouchTransmitter"):Destroy() end
                end
            end
        end
    end
    
    -- 🌐 新！ラグスイッチ（全パーツNetworkOwner = nil でサーバー同期ラグ♡ 弾当たらねぇ！）
    if lagSwitch then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part ~= root then
                pcall(function() part:SetNetworkOwner(nil) end)  -- サーバー所有でラグ爆発www
            end
        end
        -- 追加ラグ効果：微妙にポジションずらし（予測不能）
        root.CFrame = root.CFrame + Vector3.new(math.random(-2,2)/10, 0, math.random(-2,2)/10)
    end
    
    -- フライ
    if flyMode then
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0,0,0)
        if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir + Vector3.new(0,-1,0) end
        if moveDir.Magnitude > 0 then
            root.Velocity = moveDir.Unit * flySpeed
            root.AssemblyLinearVelocity = moveDir.Unit * flySpeed  -- 追加で強化
        else
            root.Velocity = Vector3.new(0,0,0)
            root.AssemblyLinearVelocity = Vector3.new(0,0,0)
        end
    end
end)

-- リスポーン
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    root = character:WaitForChild("HumanoidRootPart")
    if speedHack then humanoid.WalkSpeed = 80 end
    if lagSwitch then
        wait(1)  -- 少し待ってからラグON
    end
end)

-- 究極煽りGUI♡
local tauntGui = Instance.new("ScreenGui")
tauntGui.Parent = playerGui
local tauntLabel = Instance.new("TextLabel")
tauntLabel.Size = UDim2.new(1,0,0.15,0)
tauntLabel.Position = UDim2.new(0,0,0.425,0)
tauntLabel.BackgroundTransparency = 1
tauntLabel.TextColor3 = Color3.fromRGB(255,0,255)
tauntLabel.TextStrokeTransparency = 0
tauntLabel.TextStrokeColor3 = Color3.new(0,0,0)
tauntLabel.TextScaled = true
tauntLabel.Font = Enum.Font.GothamBlack
tauntLabel.Text = "🌐 ラグスイッチON♡ 全災害無効+ラグで不死身www 皆BAN待ちなクズども！！"
tauntLabel.Parent = tauntGui

print("🌐 RAG HELL SCRIPT LOADED!! Insertでメニュー！ ラグスイッチONで皆の攻撃全部スカ！！ サーバー崩壊待ったなし♡ BAN？ 俺のラグで届かねぇよボケェェェ！！！ 🔥🔥🔥")
