print("Script iniciado: " .. os.date())
local success, errorMsg = pcall(function()
    local player = game.Players.LocalPlayer
    print("Jugador local: ", player)
    local userInputService = game:GetService("UserInputService")
    local teams = game:GetService("Teams")
    local runService = game:GetService("RunService")

    local playerGui = player:WaitForChild("PlayerGui", 5)
    if not playerGui then
        warn("Error: PlayerGui no encontrado")
        return
    end
    print("PlayerGui encontrado")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui
    screenGui.Name = "ESP_Toggle"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    print("ScreenGui creado")

    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0, 220, 0, 250)
    frame.Position = UDim2.new(0.5, -110, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.ZIndex = 1
    print("Frame creado")

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Parent = frame
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Text = "🔍 ESP Menu by Zxcx"
    title.TextStrokeTransparency = 0.8
    title.ZIndex = 2
    print("Título creado")

    local espButton = Instance.new("TextButton")
    espButton.Parent = frame
    espButton.Size = UDim2.new(0.8, 0, 0, 40)
    espButton.Position = UDim2.new(0.1, 0, 0.15, 0)
    espButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.Font = Enum.Font.Gotham
    espButton.TextSize = 16
    espButton.Text = "Activar ESP"
    espButton.ZIndex = 3
    print("Botón ESP creado")

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = espButton

    local customizeButton = Instance.new("TextButton")
    customizeButton.Parent = frame
    customizeButton.Size = UDim2.new(0.8, 0, 0, 40)
    customizeButton.Position = UDim2.new(0.1, 0, 0.35, 0)
    customizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    customizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    customizeButton.Font = Enum.Font.Gotham
    customizeButton.TextSize = 16
    customizeButton.Text = "Personalizar Chams"
    customizeButton.ZIndex = 3
    print("Botón Personalizar creado")

    local customizeButtonCorner = Instance.new("UICorner")
    customizeButtonCorner.CornerRadius = UDim.new(0, 6)
    customizeButtonCorner.Parent = customizeButton

    local flyButton = Instance.new("TextButton")
    flyButton.Parent = frame
    flyButton.Size = UDim2.new(0.8, 0, 0, 40)
    flyButton.Position = UDim2.new(0.1, 0, 0.55, 0)
    flyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.Font = Enum.Font.Gotham
    flyButton.TextSize = 16
    flyButton.Text = "Fly Control"
    flyButton.ZIndex = 3
    print("Botón Fly creado")

    local flyButtonCorner = Instance.new("UICorner")
    flyButtonCorner.CornerRadius = UDim.new(0, 6)
    flyButtonCorner.Parent = flyButton

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
    print("Botón Cerrar creado")

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton

    local footerLabel = Instance.new("TextLabel")
    footerLabel.Parent = frame
    footerLabel.Size = UDim2.new(1, 0, 0, 20)
    footerLabel.Position = UDim2.new(0, 0, 0.9, 0)
    footerLabel.BackgroundTransparency = 1
    footerLabel.Font = Enum.Font.GothamBold
    footerLabel.TextSize = 14
    footerLabel.TextStrokeTransparency = 0.5
    footerLabel.Text = "Made by Zxcx ot"
    footerLabel.TextXAlignment = Enum.TextXAlignment.Center
    footerLabel.ZIndex = 2
    print("Footer creado")

    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 127, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(238, 130, 238)
    }

    local currentIndex = 1
    runService.RenderStepped:Connect(function()
        footerLabel.TextColor3 = colors[currentIndex]
        currentIndex = currentIndex + 1
        if currentIndex > #colors then
            currentIndex = 1
        end
    end)
    print("Animación del footer iniciada")

    -- Customization Menu
    local customizeFrame = Instance.new("Frame")
    customizeFrame.Parent = screenGui
    customizeFrame.Size = UDim2.new(0, 220, 0, 200)
    customizeFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
    customizeFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    customizeFrame.BorderSizePixel = 0
    customizeFrame.Visible = false
    customizeFrame.ZIndex = 1
    print("CustomizeFrame creado")

    local customizeFrameCorner = Instance.new("UICorner")
    customizeFrameCorner.CornerRadius = UDim.new(0, 10)
    customizeFrameCorner.Parent = customizeFrame

    local customizeTitle = Instance.new("TextLabel")
    customizeTitle.Parent = customizeFrame
    customizeTitle.Size = UDim2.new(1, 0, 0, 30)
    customizeTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    customizeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    customizeTitle.Font = Enum.Font.GothamBold
    customizeTitle.TextSize = 16
    customizeTitle.Text = "Personalizar Chams"
    customizeTitle.ZIndex = 2
    print("Título de personalización creado")

    local outlineColorLabel = Instance.new("TextLabel")
    outlineColorLabel.Parent = customizeFrame
    outlineColorLabel.Size = UDim2.new(1, 0, 0, 20)
    outlineColorLabel.Position = UDim2.new(0, 0, 0.15, 0)
    outlineColorLabel.BackgroundTransparency = 1
    outlineColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    outlineColorLabel.Font = Enum.Font.Gotham
    outlineColorLabel.TextSize = 14
    outlineColorLabel.Text = "Color del Borde"
    outlineColorLabel.ZIndex = 2
    print("Label de color del borde creado")

    local outlineColorButtons = {}
    for i, color in ipairs(colors) do
        local button = Instance.new("TextButton")
        button.Parent = customizeFrame
        button.Size = UDim2.new(0, 30, 0, 30)
        button.Position = UDim2.new(0.1 + (i-1) * 0.15, 0, 0.25, 0)
        button.BackgroundColor3 = color
        button.Text = ""
        button.ZIndex = 3
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        outlineColorButtons[i] = button
    end
    print("Botones de color del borde creados")

    local fillToggleLabel = Instance.new("TextLabel")
    fillToggleLabel.Parent = customizeFrame
    fillToggleLabel.Size = UDim2.new(1, 0, 0, 20)
    fillToggleLabel.Position = UDim2.new(0, 0, 0.45, 0)
    fillToggleLabel.BackgroundTransparency = 1
    fillToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fillToggleLabel.Font = Enum.Font.Gotham
    fillToggleLabel.TextSize = 14
    fillToggleLabel.Text = "Relleno Activado"
    fillToggleLabel.ZIndex = 2
    print("Label de relleno creado")

    local fillToggleButton = Instance.new("TextButton")
    fillToggleButton.Parent = customizeFrame
    fillToggleButton.Size = UDim2.new(0.2, 0, 0, 30)
    fillToggleButton.Position = UDim2.new(0.7, 0, 0.45, 0)
    fillToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    fillToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fillToggleButton.Font = Enum.Font.Gotham
    fillToggleButton.TextSize = 14
    fillToggleButton.Text = "Off"
    fillToggleButton.ZIndex = 3
    local fillToggleCorner = Instance.new("UICorner")
    fillToggleCorner.CornerRadius = UDim.new(0, 6)
    fillToggleCorner.Parent = fillToggleButton
    print("Botón de relleno creado")

    local fillColorLabel = Instance.new("TextLabel")
    fillColorLabel.Parent = customizeFrame
    fillColorLabel.Size = UDim2.new(1, 0, 0, 20)
    fillColorLabel.Position = UDim2.new(0, 0, 0.65, 0)
    fillColorLabel.BackgroundTransparency = 1
    fillColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fillColorLabel.Font = Enum.Font.Gotham
    fillColorLabel.TextSize = 14
    fillColorLabel.Text = "Color del Relleno"
    fillColorLabel.ZIndex = 2
    print("Label de color de relleno creado")

    local fillColorButtons = {}
    for i, color in ipairs(colors) do
        local button = Instance.new("TextButton")
        button.Parent = customizeFrame
        button.Size = UDim2.new(0, 30, 0, 30)
        button.Position = UDim2.new(0.1 + (i-1) * 0.15, 0, 0.75, 0)
        button.BackgroundColor3 = color
        button.Text = ""
        button.ZIndex = 3
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        fillColorButtons[i] = button
    end
    print("Botones de color de relleno creados")

    -- Fly Menu
    local flyFrame = Instance.new("Frame")
    flyFrame.Parent = screenGui
    flyFrame.Size = UDim2.new(0, 220, 0, 200)
    flyFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
    flyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    flyFrame.BorderSizePixel = 0
    flyFrame.Visible = false
    flyFrame.ZIndex = 1
    print("FlyFrame creado")

    local flyFrameCorner = Instance.new("UICorner")
    flyFrameCorner.CornerRadius = UDim.new(0, 10)
    flyFrameCorner.Parent = flyFrame

    local flyTitle = Instance.new("TextLabel")
    flyTitle.Parent = flyFrame
    flyTitle.Size = UDim2.new(1, 0, 0, 30)
    flyTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    flyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyTitle.Font = Enum.Font.GothamBold
    flyTitle.TextSize = 16
    flyTitle.Text = "Fly Control"
    flyTitle.ZIndex = 2
    print("Título de fly creado")

    local flyToggleButton = Instance.new("TextButton")
    flyToggleButton.Parent = flyFrame
    flyToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
    flyToggleButton.Position = UDim2.new(0.1, 0, 0.15, 0)
    flyToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    flyToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyToggleButton.Font = Enum.Font.Gotham
    flyToggleButton.TextSize = 16
    flyToggleButton.Text = "Activar Fly"
    flyToggleButton.ZIndex = 3
    local flyToggleCorner = Instance.new("UICorner")
    flyToggleCorner.CornerRadius = UDim.new(0, 6)
    flyToggleCorner.Parent = flyToggleButton
    print("Botón de fly creado")

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = flyFrame
    speedLabel.Size = UDim2.new(1, 0, 0, 20)
    speedLabel.Position = UDim2.new(0, 0, 0.35, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 14
    speedLabel.Text = "Velocidad: 50"
    speedLabel.ZIndex = 2
    print("Label de velocidad creado")

    local increaseSpeedButton = Instance.new("TextButton")
    increaseSpeedButton.Parent = flyFrame
    increaseSpeedButton.Size = UDim2.new(0.35, 0, 0, 30)
    increaseSpeedButton.Position = UDim2.new(0.1, 0, 0.45, 0)
    increaseSpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    increaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    increaseSpeedButton.Font = Enum.Font.Gotham
    increaseSpeedButton.TextSize = 14
    increaseSpeedButton.Text = "+"
    increaseSpeedButton.ZIndex = 3
    local increaseSpeedCorner = Instance.new("UICorner")
    increaseSpeedCorner.CornerRadius = UDim.new(0, 6)
    increaseSpeedCorner.Parent = increaseSpeedButton
    print("Botón de aumentar velocidad creado")

    local decreaseSpeedButton = Instance.new("TextButton")
    decreaseSpeedButton.Parent = flyFrame
    decreaseSpeedButton.Size = UDim2.new(0.35, 0, 0, 30)
    decreaseSpeedButton.Position = UDim2.new(0.55, 0, 0.45, 0)
    decreaseSpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    decreaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    decreaseSpeedButton.Font = Enum.Font.Gotham
    decreaseSpeedButton.TextSize = 14
    decreaseSpeedButton.Text = "-"
    decreaseSpeedButton.ZIndex = 3
    local decreaseSpeedCorner = Instance.new("UICorner")
    decreaseSpeedCorner.CornerRadius = UDim.new(0, 6)
    decreaseSpeedCorner.Parent = decreaseSpeedButton
    print("Botón de disminuir velocidad creado")

    local upButton = Instance.new("TextButton")
    upButton.Parent = flyFrame
    upButton.Size = UDim2.new(0.35, 0, 0, 30)
    upButton.Position = UDim2.new(0.1, 0, 0.65, 0)
    upButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.Font = Enum.Font.Gotham
    upButton.TextSize = 14
    upButton.Text = "Subir"
    upButton.ZIndex = 3
    local upButtonCorner = Instance.new("UICorner")
    upButtonCorner.CornerRadius = UDim.new(0, 6)
    upButtonCorner.Parent = upButton
    print("Botón de subir creado")

    local downButton = Instance.new("TextButton")
    downButton.Parent = flyFrame
    downButton.Size = UDim2.new(0, 30, 0, 0)
    downButton.Position = UDim2.new(0.55, 0, 0.65, 0)
    downButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.Font = Enum.Font.Gotham
    downButton.TextSize = 14
    downButton.Text = "Bajar"
    downButton.ZIndex = 3
    local downButtonCorner = Instance.new("UICorner")
    downButtonCorner.CornerRadius = UDim.new(0, 6)
    downButtonCorner.Parent = downButton
    print("Botón de bajar creado")

    -- ESP Logic
    local espEnabled = false
    local espObjects = {}
    local espConnection
    local maxDistance = 1000
    local outlineColor = Color3.fromRGB(255, 255, 255)
    local fillEnabled = false
    local fillColor = Color3.fromRGB(255, 255,255)
    local fillTransparency = 0.5

    local function applyESP(character)
        if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Head") then
            return
        end
        print("Aplicando ESP a: ", character)
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillTransparency = fillEnabled and fillTransparency or 1
        highlight.FillColor = fillColor
        highlight.OutlineTransparency = 0
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

        espObjects[character] = {highlight, billboard, textLabel}
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
                    if distance <= maxDistance then
                        local teamName = plr.Team and plr.Team.Name or "No Team"
                        local health = math.floor(humanoid.Health)
                        local maxHealth = math.floor(humanoid.MaxHealth)
                        espData[3].Text = string.format("%s | %.1fm | %d/%d HP | %s", teamName, distance, health, 
maxHealth, plr.Name)
                        espData[1].Enabled = true
                        espData[2].Enabled = true
                    else
                        espData[1].Enabled = false
                        espData[2].Enabled = false
                    end
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
            highlight.OutlineColor = outlineColor
            highlight.FillColor = fillColor
            highlight.FillTransparency = fillEnabled and fillTransparency or 1
        end
    end

    local function toggleESP()
        espEnabled = not espEnabled
        espButton.Text = espEnabled and "Disable ESP" or "Enable ESP"
        print("ESP toggled: ", espEnabled)
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
            if userInputService:IsKeyDown(Enum.KeyCode.S) then
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
        print("Fly iniciado")
    end

    local function stopFly()
        if bodyVelocity then
            bodyVelocity.Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro.Destroy()
            bodyGyro = nil
        end
        if flyConnection then
            flyConnection.Disconnect()
            flyConnection = nil
        end
        print("Fly detenido")
    end

    local function toggleFly()
        flyEnabled = not flyEnabled
        flyToggleButton.Text = flyEnabled and "Desactivar Fly" or "Activar Fly"
        print("Fly toggled: ", flyEnabled)
        if flyEnabled then
            startFly()
        else
            stopFly()
        end
    end

    local function updateFlySpeed(delta)
        flySpeed = math.clamp(flySpeed + delta, 10, 200)
        speedLabel.Text = string.format("Velocidad: %d", flySpeed)
        print("Velocidad de fly actualizada: ", flySpeed)
    end

    local function teleportUpDown(direction)
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        local rootPart = player.Character.HumanoidRootPart
        local offset = direction == "up" and Vector3.new(0, 10, 0) or Vector3.new(0, -10, 0)
        rootPart.CFrame = rootPart.CFrame + offset
        print("Teletransportado ", direction)
    end

    -- Event Handlers with Debugging
    espButton.MouseButton1Click:Connect(function()
        print("Botón ESP clickeado")
        toggleESP()
    end)
    print("Evento de Botón ESP conectado")

    customizeButton.MouseButton1Click:Connect(function()
        print("Botón Personalizar clickeado")
        frame.Visible = false
        customizeFrame.Visible = true
        flyFrame.Visible = false
    end)
    print("Evento de Botón Personalizar conectado")

    flyButton.MouseButton1Click:Connect(function()
        print("Botón Fly clickeado")
        frame.Visible = false
        customizeFrame.Visible = false
        flyFrame.Visible = true
    end)
    print("Evento de Botón Fly conectado")

    closeButton.MouseButton1Click:Connect(function()
        print("Botón Cerrar clickeado")
        screenGui:Destroy()
        if espConnection then
            espConnection:Disconnect()
        end
        stopFly()
    end)
    print("Evento de Botón Cerrar conectado")

    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.E then
            print("Tecla E presionada")
            frame.Visible = not frame.Visible
            customizeFrame.Visible = false
            flyFrame.Visible = false
        end
    end)
    print("Evento de Tecla E conectado")

    game.Players.PlayerAdded:Connect(function(plr)
        if espEnabled and plr ~= player then
            plr.CharacterAdded:Connect(function(character)
                if espEnabled then
                    applyESP(character)
                end
            end)
        end
    end)
    print("Evento de PlayerAdded conectado")

    game.Players.PlayerRemoving:Connect(function(plr)
        if espObjects[plr.Character] then
            for _, obj in pairs(espObjects[plr.Character]) do
                obj:Destroy()
            end
            espObjects[plr.Character] = nil
        end
    end)
    print("Evento de PlayerRemoving conectado")

    for i, button in ipairs(outlineColorButtons) do
        button.MouseButton1Click:Connect(function()
            print("Botón de color de borde ", i, " clickeado")
            outlineColor = colors[i]
            updateChams()
        end)
    end
    print("Eventos de botones de color de borde conectados")

    fillToggleButton.MouseButton1Click:Connect(function()
        print("Botón de relleno clickeado")
        fillEnabled = not fillEnabled
        fillToggleButton.Text = fillEnabled and "On" or "Off"
        updateChams()
    end)
    print("Evento de Botón de relleno conectado")

    for i, button in ipairs(fillColorButtons) do
        button.MouseButton1Click:Connect(function()
            print("Botón de color de relleno ", i, " clickeado")
            fillColor = colors[i]
            updateChams()
        end)
    end
    print("Eventos de botones de color de relleno conectados")

    flyToggleButton.MouseButton1Click:Connect(function()
        print("Botón de toggle fly clickeado")
        toggleFly()
    end)
    print("Evento de Botón de toggle fly conectado")

    increaseSpeedButton.MouseButton1Click:Connect(function()
        print("Botón de aumentar velocidad clickeado")
        updateFlySpeed(10)
    end)
    print("Evento de Botón de aumentar velocidad conectado")

    decreaseSpeedButton.MouseButton1Click:Connect(function()
        print("Botón de disminuir velocidad clickeado")
        updateFlySpeed(-10)
    end)
    print("Evento de Botón de disminuir velocidad conectado")

    upButton.MouseButton1Click:Connect(function()
        print("Botón de subir clickeado")
        teleportUpDown("up")
    end)
    print("Evento de Botón de subir conectado")

    downButton.MouseButton1Click:Connect(function()
        print("Botón de bajar clickeado")
        teleportUpDown("down")
    end)
    print("Evento de Botón de bajar conectado")
end)

if not success then
    warn("Error al ejecutar el script: ", tostring(errorMsg))
else
    print("Script ejecutado correctamente")
end