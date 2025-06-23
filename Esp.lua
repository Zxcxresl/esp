local success, errorMsg = pcall(function()
    local player = game.Players.LocalPlayer
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")

    local playerGui = player:WaitForChild("PlayerGui", 5)
    if not playerGui then
        error("PlayerGui no encontrado")
    end

    -- Crear ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ESP_Toggle"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    -- Crear Debug Label
    local debugLabel = Instance.new("TextLabel")
    debugLabel.Size = UDim2.new(1, 0, 0, 30)
    debugLabel.Position = UDim2.new(0, 0, 0, 0)
    debugLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    debugLabel.BackgroundTransparency = 0.5
    debugLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    debugLabel.Font = Enum.Font.Gotham
    debugLabel.TextSize = 16
    debugLabel.Text = "Script cargado. Toca el botón ☰ para abrir el menú."
    debugLabel.ZIndex = 1000
    debugLabel.Parent = screenGui

    -- Crear Botón Flotante para Togglear Menú
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(1, -60, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 20
    toggleButton.Text = "☰"
    toggleButton.ZIndex = 1001
    toggleButton.Parent = screenGui
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleButton

    -- Crear Frame principal
    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0, 300, 0, 350)
    frame.Position = UDim2.new(0.5, -150, 0.5, -175)
    frame.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.ZIndex = 1
    frame.Visible = false
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    title.BackgroundTransparency = 0.5
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Text = "🔍 ESP Menu by Zxcx"
    title.ZIndex = 2

    local closeButton = Instance.new("TextButton")
    closeButton.Parent = frame
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.ZIndex = 3
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Parent = frame
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -80, 0, 5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.Text = "-"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 16
    minimizeButton.ZIndex = 3
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = minimizeButton

    local tabFrame = Instance.new("Frame")
    tabFrame.Parent = frame
    tabFrame.Size = UDim2.new(1, 0, 0, 40)
    tabFrame.Position = UDim2.new(0, 0, 0, 30)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ZIndex = 2

    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = frame
    contentFrame.Size = UDim2.new(1, 0, 0, 280)
    contentFrame.Position = UDim2.new(0, 0, 0, 70)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2

    local tabs = {"ESP", "Fly", "NoClip", "Speed", "Combat"}
    local tabButtons = {}
    local currentTab = nil

    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = tabFrame
        tabButton.Size = UDim2.new(0.2, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1)*0.2, 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.Text = tabName
        tabButton.ZIndex = 3
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tabButton
        tabButtons[tabName] = tabButton
    end

    -- ESP Logic
    local espEnabled = false
    local boxEnabled = false
    local linesEnabled = false
    local espObjects = {}
    local espConnection
    local outlineColor = Color3.fromRGB(255, 255, 255)
    local fillEnabled = false
    local fillColor = Color3.fromRGB(255, 255, 255)
    local fillTransparency = 0.5

    local colors = {
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0), Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(238, 130, 238)
    }

    local function applyESP(character)
        if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Head") then
            return
        end
        debugLabel.Text = "Aplicando ESP a: " .. character.Name
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillTransparency = fillEnabled and fillTransparency or 1
        highlight.FillColor = fillColor
        highlight.OutlineTransparency = boxEnabled and 0 or 1
        highlight.OutlineColor = outlineColor

        local billboard = Instance.new("BillboardGui")
        billboard.Parent = character
        billboard.Adornee = character:FindFirstChild("Head")
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboard
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 14
        textLabel.TextStrokeTransparency = 0.5

        local beam = Instance.new("Beam")
        beam.Parent = character
        beam.Enabled = linesEnabled
        beam.Color = ColorSequence.new(outlineColor)
        beam.Width0 = 0.2
        beam.Width1 = 0.2
        beam.ZOffset = 0
        local attachment0 = Instance.new("Attachment")
        attachment0.Parent = player.Character and player.Character:FindFirstChild("HumanoidRootPart") or nil
        local attachment1 = Instance.new("Attachment")
        attachment1.Parent = character:FindFirstChild("HumanoidRootPart")
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1

        local plr = game.Players:GetPlayerFromCharacter(character)
        if plr then
            local teamName = plr.Team and plr.Team.Name or "No Team"
            local humanoid = character:FindFirstChild("Humanoid")
            local health = humanoid and math.floor(humanoid.Health) or 0
            local maxHealth = humanoid and math.floor(humanoid.MaxHealth) or 100
            local distance = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
                            (character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude or 0
            textLabel.Text = string.format("%s | %.1fm | %d/%d HP | %s", teamName, distance, health, maxHealth, plr.Name)
        end

        espObjects[character] = {highlight, billboard, textLabel, beam}
    end

    local function updateESP()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local char = plr.Character
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChild("Humanoid")
                local espData = espObjects[char]
                if rootPart and humanoid and espData then
                    local distance = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    local teamName = plr.Team and plr.Team.Name or "No Team"
                    local health = math.floor(humanoid.Health)
                    local maxHealth = math.floor(humanoid.MaxHealth)
                    espData[3].Text = string.format("%s | %.1fm | %d/%d HP | %s", teamName, distance, health, maxHealth, plr.Name)
                    espData[1].Enabled = true
                    espData[2].Enabled = true
                    espData[4].Enabled = linesEnabled
                end
            end
        end
    end

    local function refreshESP()
        for _, data in pairs(espObjects) do
            for _, obj in pairs(data) do
                obj:Destroy()
            end
        end
        espObjects = {}
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                applyESP(plr.Character)
            end
        end
    end

    local function updateChams()
        for _, data in pairs(espObjects) do
            local highlight = data[1]
            local beam = data[4]
            highlight.OutlineColor = outlineColor
            highlight.FillColor = fillColor
            highlight.FillTransparency = fillEnabled and fillTransparency or 1
            highlight.OutlineTransparency = boxEnabled and 0 or 1
            beam.Color = ColorSequence.new(outlineColor)
            beam.Enabled = linesEnabled
        end
    end

    local function toggleESP()
        espEnabled = not espEnabled
        debugLabel.Text = "ESP toggled: " .. tostring(espEnabled)
        if espEnabled then
            refreshESP()
            espConnection = runService.Heartbeat:Connect(function()
                if espEnabled then
                    updateESP()
                end
            end)
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= player then
                    plr.CharacterAdded:Connect(function(character)
                        if espEnabled then
                            applyESP(character)
                        end
                    end)
                end
            end
        else
            if espConnection then
                espConnection:Disconnect()
            end
            for _, data in pairs(espObjects) do
                for _, obj in pairs(data) do
                    obj:Destroy()
                end
            end
            espObjects = {}
        end
    end

    -- Fly Logic
    local flyEnabled = false
    local flySpeed = 50
    local flyConnection
    local bodyVelocity
    local bodyGyro

    local function startFly()
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        local rootPart = player.Character.HumanoidRootPart
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Parent = rootPart
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Parent = rootPart
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame = rootPart.CFrame

        flyConnection = runService.RenderStepped:Connect(function()
            if not flyEnabled then return end
            local moveDirection = Vector3.new(0, 0, 0)
            if userInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + Vector3.new(0, 0, -1)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection + Vector3.new(0, 0, 1)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection + Vector3.new(-1, 0, 0)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + Vector3.new(1, 0, 0)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection + Vector3.new(0, -1, 0)
            end
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * flySpeed
            end
            bodyVelocity.Velocity = rootPart.CFrame:VectorToWorldSpace(moveDirection)
            bodyGyro.CFrame = game.Workspace.CurrentCamera.CFrame
        end)
        debugLabel.Text = "Fly iniciado"
    end

    local function stopFly()
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        debugLabel.Text = "Fly detenido"
    end

    local function toggleFly()
        flyEnabled = not flyEnabled
        debugLabel.Text = "Fly toggled: " .. tostring(flyEnabled)
        if flyEnabled then
            startFly()
        else
            stopFly()
        end
    end

    -- NoClip Logic
    local noClipEnabled = false
    local noClipConnection

    local function toggleNoClip()
        noClipEnabled = not noClipEnabled
        debugLabel.Text = "NoClip toggled: " .. tostring(noClipEnabled)
        if noClipEnabled then
            noClipConnection = runService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noClipConnection then
                noClipConnection:Disconnect()
                noClipConnection = nil
            end
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    -- Speed Logic
    local walkSpeed = 16
    local function updateSpeed(delta)
        walkSpeed = math.clamp(walkSpeed + delta, 16, 100)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeed
        end
        debugLabel.Text = "Velocidad actualizada: " .. walkSpeed
    end

    -- Combat Logic
    local killAuraEnabled = false
    local aimbotEnabled = false
    local killAuraRadius = 10
    local aimFOV = 100
    local aimPart = "Head"
    local killAuraConnection
    local aimbotConnection

    local function toggleKillAura()
        killAuraEnabled = not killAuraEnabled
        debugLabel.Text = "Kill Aura toggled: " .. tostring(killAuraEnabled)
        if killAuraEnabled then
            killAuraConnection = runService.Heartbeat:Connect(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                local weapon = player.Character:FindFirstChildOfClass("Tool")
                if not weapon then
                    debugLabel.Text = "No se encontró arma para Kill Aura"
                    return
                end
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= killAuraRadius then
                            weapon:Activate()
                        end
                    end
                end
            end)
        else
            if killAuraConnection then
                killAuraConnection:Disconnect()
                killAuraConnection = nil
            end
        end
    end

    local function toggleAimbot()
        aimbotEnabled = not aimbotEnabled
        debugLabel.Text = "Aimbot toggled: " .. tostring(aimbotEnabled)
        if aimbotEnabled then
            aimbotConnection = runService.RenderStepped:Connect(function()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                local camera = game.Workspace.CurrentCamera
                local closestPlayer = nil
                local closestDistance = aimFOV
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild(aimPart) then
                        local screenPoint, onScreen = camera:WorldToScreenPoint(plr.Character[aimPart].Position)
                        local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(game:GetService("UserInputService"):GetMouseLocation())).Magnitude
                        if onScreen and distance < closestDistance then
                            closestPlayer = plr
                            closestDistance = distance
                        end
                    end
                end
                if closestPlayer then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Character[aimPart].Position)
                end
            end)
        else
            if aimbotConnection then
                aimbotConnection:Disconnect()
                aimbotConnection = nil
            end
        end
    end

    local function createTabContent(tabName)
        clearContent()
        debugLabel.Text = "Pestaña " .. tabName .. " seleccionada"
        if tabName == "ESP" then
            local espToggleButton = Instance.new("TextButton")
            espToggleButton.Parent = contentFrame
            espToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
            espToggleButton.Position = UDim2.new(0.1, 0, 0, 0)
            espToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            espToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            espToggleButton.Font = Enum.Font.Gotham
            espToggleButton.TextSize = 16
            espToggleButton.Text = espEnabled and "Desactivar ESP" or "Activar ESP"
            espToggleButton.ZIndex = 3
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = espToggleButton

            local boxToggleButton = Instance.new("TextButton")
            boxToggleButton.Parent = contentFrame
            boxToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
            boxToggleButton.Position = UDim2.new(0.1, 0, 0.15, 0)
            boxToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            boxToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            boxToggleButton.Font = Enum.Font.Gotham
            boxToggleButton.TextSize = 16
            boxToggleButton.Text = boxEnabled and "Desactivar Box" or "Activar Box"
            boxToggleButton.ZIndex = 3
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = boxToggleButton

            local linesToggleButton = Instance.new("TextButton")
            linesToggleButton.Parent = contentFrame
            linesToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
            linesToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
            linesToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            linesToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            linesToggleButton.Font = Enum.Font.Gotham
            linesToggleButton.TextSize = 16
            linesToggleButton.Text = linesEnabled and "Desactivar Lines" or "Activar Lines"
            linesToggleButton.ZIndex = 3
            local linesCorner = Instance.new("UICorner")
            linesCorner.CornerRadius = UDim.new(0, 6)
            linesCorner.Parent = linesToggleButton

            local outlineColorLabel = Instance.new("TextLabel")
            outlineColorLabel.Parent = contentFrame
            outlineColorLabel.Size = UDim2.new(1, 0, 0, 20)
            outlineColorLabel.Position = UDim2.new(0, 0, 0.45, 0)
            outlineColorLabel.BackgroundTransparency = 1
            outlineColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            outlineColorLabel.Font = Enum.Font.Gotham
            outlineColorLabel.TextSize = 14
            outlineColorLabel.Text = "Color del Borde"
            outlineColorLabel.ZIndex = 2

            local outlineColorButtons = {}
            for i, color in ipairs(colors) do
                local button = Instance.new("TextButton")
                button.Parent = contentFrame
                button.Size = UDim2.new(0, 30, 0, 30)
                button.Position = UDim2.new(0.1 + (i-1) * 0.15, 0, 0.55, 0)
                button.BackgroundColor3 = color
                button.Text = ""
                button.ZIndex = 3
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = button
                outlineColorButtons[i] = button
            end

            local fillToggleButton = Instance.new("TextButton")
            fillToggleButton.Parent = contentFrame
            fillToggleButton.Size = UDim2.new(0.2, 0, 0, 30)
            fillToggleButton.Position = UDim2.new(0.7, 0, 0.7, 0)
            fillToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            fillToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            fillToggleButton.Font = Enum.Font.Gotham
            fillToggleButton.TextSize = 14
            fillToggleButton.Text = fillEnabled and "On" or "Off"
            fillToggleButton.ZIndex = 3
            local fillToggleCorner = Instance.new("UICorner")
            fillToggleCorner.CornerRadius = UDim.new(0, 6)
            fillToggleCorner.Parent = fillToggleButton

            local fillColorLabel = Instance.new("TextLabel")
            fillColorLabel.Parent = contentFrame
            fillColorLabel.Size = UDim2.new(1, 0, 0, 20)
            fillColorLabel.Position = UDim2.new(0, 0, 0.85, 0)
            fillColorLabel.BackgroundTransparency = 1
            fillColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            fillColorLabel.Font = Enum.Font.Gotham
            fillColorLabel.TextSize = 14
            fillColorLabel.Text = "Color del Relleno"
            fillColorLabel.ZIndex = 2

            local fillColorButtons = {}
            for i, color in ipairs(colors) do
                local button = Instance.new("TextButton")
                button.Parent = contentFrame
                button.Size = UDim2.new(0, 30, 0, 30)
                button.Position = UDim2.new(0.1 + (i-1) * 0.15, 0, 0.95, 0)
                button.BackgroundColor3 = color
                button.Text = ""
                button.ZIndex = 3
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = button
                fillColorButtons[i] = button
            end

            espToggleButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón ESP clickeado"
                toggleESP()
                espToggleButton.Text = espEnabled and "Desactivar ESP" or "Activar ESP"
            end)
            boxToggleButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Box clickeado"
                boxEnabled = not boxEnabled
                boxToggleButton.Text = boxEnabled and "Desactivar Box" or "Activar Box"
                updateChams()
            end)
            linesToggleButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Lines clickeado"
                linesEnabled = not linesEnabled
                linesToggleButton.Text = linesEnabled and "Desactivar Lines" or "Activar Lines"
                updateChams()
            end)
            for i, button in ipairs(outlineColorButtons) do
                button.MouseButton1Click:Connect(function()
                    debugLabel.Text = "Color de borde " .. i .. " seleccionado"
                    outlineColor = colors[i]
                    updateChams()
                end)
            end
            fillToggleButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón de relleno clickeado"
                fillEnabled = not fillEnabled
                fillToggleButton.Text = fillEnabled and "On" or "Off"
                updateChams()
            end)
            for i, button in ipairs(fillColorButtons) do
                button.MouseButton1Click:Connect(function()
                    debugLabel.Text = "Color de relleno " .. i .. " seleccionado"
                    fillColor = colors[i]
                    updateChams()
                end)
            end
        elseif tabName == "Fly" then
            local flyToggleButton = Instance.new("TextButton")
            flyToggleButton.Parent = contentFrame
            flyToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
            flyToggleButton.Position = UDim2.new(0.1, 0, 0, 0)
            flyToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            flyToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            flyToggleButton.Font = Enum.Font.Gotham
            flyToggleButton.TextSize = 16
            flyToggleButton.Text = flyEnabled and "Desactivar Fly" or "Activar Fly"
            flyToggleButton.ZIndex = 3
            local flyToggleCorner = Instance.new("UICorner")
            flyToggleCorner.CornerRadius = UDim.new(0, 6)
            flyToggleCorner.Parent = flyToggleButton

            local speedLabel = Instance.new("TextLabel")
            speedLabel.Parent = contentFrame
            speedLabel.Size = UDim2.new(1, 0, 0, 20)
            speedLabel.Position = UDim2.new(0, 0, 0.15, 0)
            speedLabel.BackgroundTransparency = 1
            speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            speedLabel.Font = Enum.Font.Gotham
            speedLabel.TextSize = 14
            speedLabel.Text = "Velocidad: " .. flySpeed
            speedLabel.ZIndex = 2

            local increaseSpeedButton = Instance.new("TextButton")
            increaseSpeedButton.Parent = contentFrame
            increaseSpeedButton.Size = UDim2.new(0.35, 0, 0, 30)
            increaseSpeedButton.Position = UDim2.new(0.1, 0, 0.25, 0)
            increaseSpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            increaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            increaseSpeedButton.Font = Enum.Font.Gotham
            increaseSpeedButton.TextSize = 14
            increaseSpeedButton.Text = "+"
            increaseSpeedButton.ZIndex = 3
            local increaseSpeedCorner = Instance.new("UICorner")
            increaseSpeedCorner.CornerRadius = UDim.new(0, 6)
            increaseSpeedCorner.Parent = increaseSpeedButton

            local decreaseSpeedButton = Instance.new("TextButton")
            decreaseSpeedButton.Parent = contentFrame
            decreaseSpeedButton.Size = UDim2.new(0.35, 0, 0, 30)
            decreaseSpeedButton.Position = UDim2.new(0.55, 0, 0.25, 0)
            decreaseSpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            decreaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            decreaseSpeedButton.Font = Enum.Font.Gotham
            decreaseSpeedButton.TextSize = 14
            decreaseSpeedButton.Text = "-"
            decreaseSpeedButton.ZIndex = 3
            local decreaseSpeedCorner = Instance.new("UICorner")
            decreaseSpeedCorner.CornerRadius = UDim.new(0, 6)
            decreaseSpeedCorner.Parent = decreaseSpeedButton

            local upButton = Instance.new("TextButton")
            upButton.Parent = contentFrame
            upButton.Size = UDim2.new(0.35, 0, 0, 30)
            upButton.Position = UDim2.new(0.1, 0, 0.4, 0)
            upButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            upButton.Font = Enum.Font.Gotham
            upButton.TextSize = 14
            upButton.Text = "Subir"
            upButton.ZIndex = 3
            local upButtonCorner = Instance.new("UICorner")
            upButtonCorner.CornerRadius = UDim.new(0, 6)
            upButtonCorner.Parent = upButton

            local downButton = Instance.new("TextButton")
            downButton.Parent = contentFrame
            downButton.Size = UDim2.new(0.35, 0, 0, 30)
            downButton.Position = UDim2.new(0.55, 0, 0.4, 0)
            downButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            downButton.Font = Enum.Font.Gotham
            downButton.TextSize = 14
            downButton.Text = "Bajar"
            downButton.ZIndex = 3
            local downButtonCorner = Instance.new("UICorner")
            downButtonCorner.CornerRadius = UDim.new(0, 6)
            downButtonCorner.Parent = downButton

            flyToggleButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Fly clickeado"
                toggleFly()
                flyToggleButton.Text = flyEnabled and "Desactivar Fly" or "Activar Fly"
            end)
            increaseSpeedButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Aumentar velocidad clickeado"
                flySpeed = math.clamp(flySpeed + 10, 10, 200)
                speedLabel.Text = "Velocidad: " .. flySpeed
            end)
            decreaseSpeedButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Disminuir velocidad clickeado"
                flySpeed = math.clamp(flySpeed - 10, 10, 200)
                speedLabel.Text = "Velocidad: " .. flySpeed
            end)
            upButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Subir clickeado"
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 10, 0)
                end
            end)
            downButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Bajar clickeado"
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, -10, 0)
                end
            end)
        elseif tabName == "NoClip" then
            local noClipToggleButton = Instance.new("TextButton")
            noClipToggleButton.Parent = contentFrame
            noClipToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
            noClipToggleButton.Position = UDim2.new(0.1, 0, 0, 0)
            noClipToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            noClipToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            noClipToggleButton.Font = Enum.Font.Gotham
            noClipToggleButton.TextSize = 16
            noClipToggleButton.Text = noClipEnabled and "Desactivar NoClip" or "Activar NoClip"
            noClipToggleButton.ZIndex = 3
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = noClipToggleButton

            noClipToggleButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón NoClip clickeado"
                toggleNoClip()
                noClipToggleButton.Text = noClipEnabled and "Desactivar NoClip" or "Activar NoClip"
            end)
        elseif tabName == "Speed" then
            local speedLabel = Instance.new("TextLabel")
            speedLabel.Parent = contentFrame
            speedLabel.Size = UDim2.new(1, 0, 0, 20)
            speedLabel.Position = UDim2.new(0, 0, 0, 0)
            speedLabel.BackgroundTransparency = 1
            speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            speedLabel.Font = Enum.Font.Gotham
            speedLabel.TextSize = 14
            speedLabel.Text = "Velocidad: " .. walkSpeed
            speedLabel.ZIndex = 2

            local increaseSpeedButton = Instance.new("TextButton")
            increaseSpeedButton.Parent = contentFrame
            increaseSpeedButton.Size = UDim2.new(0.35, 0, 0, 30)
            increaseSpeedButton.Position = UDim2.new(0.1, 0, 0.1, 0)
            increaseSpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            increaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            increaseSpeedButton.Font = Enum.Font.Gotham
            increaseSpeedButton.TextSize = 14
            increaseSpeedButton.Text = "+"
            increaseSpeedButton.ZIndex = 3
            local increaseSpeedCorner = Instance.new("UICorner")
            increaseSpeedCorner.CornerRadius = UDim.new(0, 6)
            increaseSpeedCorner.Parent = increaseSpeedButton

            local decreaseSpeedButton = Instance.new("TextButton")
            decreaseSpeedButton.Parent = contentFrame
            decreaseSpeedButton.Size = UDim2.new(0.35, 0, 0, 30)
            decreaseSpeedButton.Position = UDim2.new(0.55, 0, 0.1, 0)
            decreaseSpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            decreaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            decreaseSpeedButton.Font = Enum.Font.Gotham
            decreaseSpeedButton.TextSize = 14
            decreaseSpeedButton.Text = "-"
            decreaseSpeedButton.ZIndex = 3
            local decreaseSpeedCorner = Instance.new("UICorner")
            decreaseSpeedCorner.CornerRadius = UDim.new(0, 6)
            decreaseSpeedCorner.Parent = decreaseSpeedButton

            increaseSpeedButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Aumentar velocidad clickeado"
                updateSpeed(10)
                speedLabel.Text = "Velocidad: " .. walkSpeed
            end)
            decreaseSpeedButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Disminuir velocidad clickeado"
                updateSpeed(-10)
                speedLabel.Text = "Velocidad: " .. walkSpeed
            end)
        elseif tabName == "Combat" then
            local killAuraToggleButton = Instance.new("TextButton")
            killAuraToggleButton.Parent = contentFrame
            killAuraToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
            killAuraToggleButton.Position = UDim2.new(0.1, 0, 0, 0)
            killAuraToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            killAuraToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            killAuraToggleButton.Font = Enum.Font.Gotham
            killAuraToggleButton.TextSize = 16
            killAuraToggleButton.Text = killAuraEnabled and "Desactivar Kill Aura" or "Activar Kill Aura"
            killAuraToggleButton.ZIndex = 3
            local killAuraCorner = Instance.new("UICorner")
            killAuraCorner.CornerRadius = UDim.new(0, 6)
            killAuraCorner.Parent = killAuraToggleButton

            local aimbotToggleButton = Instance.new("TextButton")
            aimbotToggleButton.Parent = contentFrame
            aimbotToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
            aimbotToggleButton.Position = UDim2.new(0.1, 0, 0.15, 0)
            aimbotToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            aimbotToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            aimbotToggleButton.Font = Enum.Font.Gotham
            aimbotToggleButton.TextSize = 16
            aimbotToggleButton.Text = aimbotEnabled and "Desactivar Aimbot" or "Activar Aimbot"
            aimbotToggleButton.ZIndex = 3
            local aimbotCorner = Instance.new("UICorner")
            aimbotCorner.CornerRadius = UDim.new(0, 6)
            aimbotCorner.Parent = aimbotToggleButton

            local aimPartLabel = Instance.new("TextLabel")
            aimPartLabel.Parent = contentFrame
            aimPartLabel.Size = UDim2.new(1, 0, 0, 20)
            aimPartLabel.Position = UDim2.new(0, 0, 0.3, 0)
            aimPartLabel.BackgroundTransparency = 1
            aimPartLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            aimPartLabel.Font = Enum.Font.Gotham
            aimPartLabel.TextSize = 14
            aimPartLabel.Text = "Parte a Apuntar: " .. aimPart
            aimPartLabel.ZIndex = 2

            local headButton = Instance.new("TextButton")
            headButton.Parent = contentFrame
            headButton.Size = UDim2.new(0.35, 0, 0, 30)
            headButton.Position = UDim2.new(0.1, 0, 0.4, 0)
            headButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            headButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            headButton.Font = Enum.Font.Gotham
            headButton.TextSize = 14
            headButton.Text = "Cabeza"
            headButton.ZIndex = 3
            local headCorner = Instance.new("UICorner")
            headCorner.CornerRadius = UDim.new(0, 6)
            headCorner.Parent = headButton

            local torsoButton = Instance.new("TextButton")
            torsoButton.Parent = contentFrame
            torsoButton.Size = UDim2.new(0.35, 0, 0, 30)
            torsoButton.Position = UDim2.new(0.55, 0, 0.4, 0)
            torsoButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            torsoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            torsoButton.Font = Enum.Font.Gotham
            torsoButton.TextSize = 14
            torsoButton.Text = "Torso"
            torsoButton.ZIndex = 3
            local torsoCorner = Instance.new("UICorner")
            torsoCorner.CornerRadius = UDim.new(0, 6)
            torsoCorner.Parent = torsoButton

            local fovLabel = Instance.new("TextLabel")
            fovLabel.Parent = contentFrame
            fovLabel.Size = UDim2.new(1, 0, 0, 20)
            fovLabel.Position = UDim2.new(0, 0, 0.55, 0)
            fovLabel.BackgroundTransparency = 1
            fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            fovLabel.Font = Enum.Font.Gotham
            fovLabel.TextSize = 14
            fovLabel.Text = "FOV: " .. aimFOV
            fovLabel.ZIndex = 2

            local increaseFOVButton = Instance.new("TextButton")
            increaseFOVButton.Parent = contentFrame
            increaseFOVButton.Size = UDim2.new(0.35, 0, 0, 30)
            increaseFOVButton.Position = UDim2.new(0.1, 0, 0.65, 0)
            increaseFOVButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            increaseFOVButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            increaseFOVButton.Font = Enum.Font.Gotham
            increaseFOVButton.TextSize = 14
            increaseFOVButton.Text = "+"
            increaseFOVButton.ZIndex = 3
            local increaseFOVCorner = Instance.new("UICorner")
            increaseFOVCorner.CornerRadius = UDim.new(0, 6)
            increaseFOVCorner.Parent = increaseFOVButton

            local decreaseFOVButton = Instance.new("TextButton")
            decreaseFOVButton.Parent = contentFrame
            decreaseFOVButton.Size = UDim2.new(0.35, 0, 0, 30)
            decreaseFOVButton.Position = UDim2.new(0.55, 0, 0.65, 0)
            decreaseFOVButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            decreaseFOVButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            decreaseFOVButton.Font = Enum.Font.Gotham
            decreaseFOVButton.TextSize = 14
            decreaseFOVButton.Text = "-"
            decreaseFOVButton.ZIndex = 3
            local decreaseFOVCorner = Instance.new("UICorner")
            decreaseFOVCorner.CornerRadius = UDim.new(0, 6)
            decreaseFOVCorner.Parent = decreaseFOVButton

            killAuraToggleButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Kill Aura clickeado"
                toggleKillAura()
                killAuraToggleButton.Text = killAuraEnabled and "Desactivar Kill Aura" or "Activar Kill Aura"
            end)
            aimbotToggleButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Aimbot clickeado"
                toggleAimbot()
                aimbotToggleButton.Text = aimbotEnabled and "Desactivar Aimbot" or "Activar Aimbot"
            end)
            headButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Cabeza clickeado"
                aimPart = "Head"
                aimPartLabel.Text = "Parte a Apuntar: " .. aimPart
            end)
            torsoButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Torso clickeado"
                aimPart = "HumanoidRootPart"
                aimPartLabel.Text = "Parte a Apuntar: " .. aimPart
            end)
            increaseFOVButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Aumentar FOV clickeado"
                aimFOV = math.clamp(aimFOV + 10, 50, 200)
                fovLabel.Text = "FOV: " .. aimFOV
            end)
            decreaseFOVButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Disminuir FOV clickeado"
                aimFOV = math.clamp(aimFOV - 10, 50, 200)
                fovLabel.Text = "FOV: " .. aimFOV
            end)
        end
    end

    local function clearContent()
        for _, child in ipairs(contentFrame:GetChildren()) do
            child:Destroy()
        end
    end

    for tabName, button in pairs(tabButtons) do
        button.MouseButton1Click:Connect(function()
            debugLabel.Text = "Pestaña " .. tabName .. " clickeada"
            currentTab = tabName
            createTabContent(tabName)
            for _, btn in pairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            end
            button.BackgroundColor3 = Color3.fromRGB(65, 65, 75)
        end)
    end

    local isMinimized = false
    local function toggleMinimize()
        isMinimized = not isMinimized
        if isMinimized then
            frame.Size = UDim2.new(0, 300, 0, 40)
            tabFrame.Visible = false
            contentFrame.Visible = false
            minimizeButton.Text = "+"
            debugLabel.Text = "Menú minimizado"
        else
            frame.Size = UDim2.new(0, 300, 0, 350)
            tabFrame.Visible = true
            contentFrame.Visible = true
            minimizeButton.Text = "-"
            if currentTab then
                createTabContent(currentTab)
            end
            debugLabel.Text = "Menú restaurado"
        end
    end

    local function toggleMenu()
        frame.Visible = not frame.Visible
        debugLabel.Text = frame.Visible and "Menú abierto" or "Menú cerrado"
        if isMinimized and frame.Visible then
            toggleMinimize()
        end
    end

    closeButton.MouseButton1Click:Connect(function()
        debugLabel.Text = "Botón Cerrar clickeado"
        screenGui:Destroy()
        if espConnection then espConnection:Disconnect() end
        stopFly()
        toggleNoClip()
        toggleKillAura()
        toggleAimbot()
    end)

    minimizeButton.MouseButton1Click:Connect(function()
        debugLabel.Text = "Botón Minimizar clickeado"
        toggleMinimize()
    end)

    toggleButton.MouseButton1Click:Connect(function()
        debugLabel.Text = "Botón de toggle clickeado"
        toggleMenu()
    end)

    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.E then
            debugLabel.Text = "Tecla E presionada"
            toggleMenu()
        end
    end)

    game.Players.PlayerAdded:Connect(function(plr)
        if espEnabled and plr ~= player then
            plr.CharacterAdded:Connect(function(character)
                if espEnabled then
                    applyESP(character)
                end
            end)
        end
    end)

    game.Players.PlayerRemoving:Connect(function(plr)
        if espObjects[plr.Character] then
            for _, obj in pairs(espObjects[plr.Character]) do
                obj:Destroy()
            end
            espObjects[plr.Character] = nil
        end
    end)

    createTabContent("ESP")
    tabButtons["ESP"].BackgroundColor3 = Color3.fromRGB(65, 65, 75)
    currentTab = "ESP"
    debugLabel.Text = "Script cargado. Toca el botón ☰ para abrir el menú."
end)

if not success then
    local player = game.Players.LocalPlayer
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ErrorGui"
        screenGui.Parent = playerGui
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(1, 0, 0, 50)
        errorLabel.Position = UDim2.new(0, 0, 0, 0)
        errorLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        errorLabel.BackgroundTransparency = 0.5
        errorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        errorLabel.Font = Enum.Font.GothamBold
        errorLabel.TextSize = 20
        errorLabel.Text = "Error: " .. tostring(errorMsg)
        errorLabel.TextWrapped = true
        errorLabel.Parent = screenGui
    end
end