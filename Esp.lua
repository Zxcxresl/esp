local success, errorMsg = pcall(function()
    local player = game.Players.LocalPlayer
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")

    local playerGui = player:WaitForChild("PlayerGui", 5)
    if not playerGui then
        error("PlayerGui no disponible")
    end

    -- Crear ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Clip_Menu"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    -- Crear Debug Label
    local debugLabel = Instance.new("TextLabel")
    debugLabel.Size = UDim2.new(1, 0, 0, 30)
    debugLabel.Position = UDim2.new(0, 0, 0, 0)
    debugLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    debugLabel.BackgroundTransparency = 0.3
    debugLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    debugLabel.Font = Enum.Font.SourceSansBold
    debugLabel.TextSize = 16
    debugLabel.Text = "Script cargado. Toca el botón ☰ para abrir el menú."
    debugLabel.ZIndex = 3
    debugLabel.Parent = screenGui

    -- Crear Botón Flotante para Togglear
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 50)
    toggleButton.Position = UDim2.new(1, -60, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 20
    toggleButton.Text = "☰"
    toggleButton.ZIndex = 4
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
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.Text = "🔍 Clip Menu by Zxcx"
    title.ZIndex = 2

    local closeButton = Instance.new("TextButton")
    closeButton.Parent = frame
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.SourceSansBold
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
    minimizeButton.Font = Enum.Font.SourceSansBold
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

    local tabs = {"ESP", "Up/Down", "Speed"}
    local tabButtons = {}
    local currentTab = nil

    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = tabFrame
        tabButton.Size = UDim2.new(0.33, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1)*0.33, 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Font = Enum.Font.SourceSans
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
        textLabel.Font = Enum.Font.SourceSansBold
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
            local teamName = plr.Team and plr.Team.Name or "Sin equipo"
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
                    local teamName = plr.Team and plr.Team.Name or "Sin equipo"
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
        debugLabel.Text = "ESP: " .. (espEnabled and "Activado" or "Desactivado")
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

    -- Up/Down Logic
    local function moveVertical(direction)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            rootPart.CFrame = rootPart.CFrame + Vector3.new(0, direction * 50, 0)
            debugLabel.Text = direction > 0 and "Subiendo" or "Bajando"
        else
            debugLabel.Text = "Personaje no disponible"
        end
    end

    -- Speed Logic
    local walkSpeed = 20
    local function updateSpeed(delta)
        walkSpeed = math.clamp(walkSpeed + delta, 20, 100)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeed
        end
        debugLabel.Text = "Velocidad: " .. walkSpeed
    end

    local function createTabContent(tabName)
        for _, child in ipairs(contentFrame:GetChildren()) do
            child:Destroy()
        end
        debugLabel.Text = "Pestaña " .. tabName .. " seleccionada"
        if tabName == "ESP" then
            local espToggleButton = Instance.new("TextButton")
            espToggleButton.Parent = contentFrame
            espToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
            espToggleButton.Position = UDim2.new(0.1, 0, 0, 0)
            espToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            espToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            espToggleButton.Font = Enum.Font.SourceSans
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
            boxToggleButton.Font = Enum.Font.SourceSans
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
            linesToggleButton.Font = Enum.Font.SourceSans
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
            outlineColorLabel.Font = Enum.Font.SourceSans
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
            fillToggleButton.Font = Enum.Font.SourceSans
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
            fillColorLabel.Font = Enum.Font.SourceSans
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
                    debugLabel.Text = "Color de borde seleccionado"
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
                    debugLabel.Text = "Color de relleno seleccionado"
                    fillColor = colors[i]
                    updateChams()
                end)
            end
        elseif tabName == "Up/Down" then
            local upButton = Instance.new("TextButton")
            upButton.Parent = contentFrame
            upButton.Size = UDim2.new(0.35, 0, 0, 40)
            upButton.Position = UDim2.new(0.1, 0, 0, 0)
            upButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            upButton.Font = Enum.Font.SourceSans
            upButton.TextSize = 16
            upButton.Text = "Subir"
            upButton.ZIndex = 3
            local upCorner = Instance.new("UICorner")
            upCorner.CornerRadius = UDim.new(0, 6)
            upCorner.Parent = upButton

            local downButton = Instance.new("TextButton")
            downButton.Parent = contentFrame
            downButton.Size = UDim2.new(0.35, 0, 0, 40)
            downButton.Position = UDim2.new(0.55, 0, 0, 0)
            downButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            downButton.Font = Enum.Font.SourceSans
            downButton.TextSize = 16
            downButton.Text = "Bajar"
            downButton.ZIndex = 3
            local downCorner = Instance.new("UICorner")
            downCorner.CornerRadius = UDim.new(0, 6)
            downCorner.Parent = downButton

            upButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Subir clickeado"
                moveVertical(1)
            end)
            downButton.MouseButton1Click:Connect(function()
                debugLabel.Text = "Botón Bajar clickeado"
                moveVertical(-1)
            end)
        elseif tabName == "Speed" then
            local speedLabel = Instance.new("TextLabel")
            speedLabel.Parent = contentFrame
            speedLabel.Size = UDim2.new(1, 0, 0, 20)
            speedLabel.Position = UDim2.new(0, 0, 0, 0)
            speedLabel.BackgroundTransparency = 1
            speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            speedLabel.Font = Enum.Font.SourceSans
            speedLabel.TextSize = 14
            speedLabel.Text = "Velocidad: " .. walkSpeed
            speedLabel.ZIndex = 2

            local increaseSpeedButton = Instance.new("TextButton")
            increaseSpeedButton.Parent = contentFrame
            increaseSpeedButton.Size = UDim2.new(0.35, 0, 0, 40)
            increaseSpeedButton.Position = UDim2.new(0.1, 0, 0.1, 0)
            increaseSpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            increaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            increaseSpeedButton.Font = Enum.Font.SourceSans
            increaseSpeedButton.TextSize = 16
            increaseSpeedButton.Text = "+"
            increaseSpeedButton.ZIndex = 3
            local increaseCorner = Instance.new("UICorner")
            increaseCorner.CornerRadius = UDim.new(0, 6)
            increaseCorner.Parent = increaseSpeedButton

            local decreaseSpeedButton = Instance.new("TextButton")
            decreaseSpeedButton.Parent = contentFrame
            decreaseSpeedButton.Size = UDim2.new(0.35, 0, 0, 40)
            decreaseSpeedButton.Position = UDim2.new(0.55, 0, 0.1, 0)
            decreaseSpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            decreaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            decreaseSpeedButton.Font = Enum.Font.SourceSans
            decreaseSpeedButton.TextSize = 16
            decreaseSpeedButton.Text = "-"
            decreaseSpeedButton.ZIndex = 3
            local decreaseCorner = Instance.new("UICorner")
            decreaseCorner.CornerRadius = UDim.new(0, 6)
            decreaseCorner.Parent = decreaseSpeedButton

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
        if espConnection then
            espConnection:Disconnect()
        end
        for _, data in pairs(espObjects) do
            for _, obj in pairs(data) do
                obj:Destroy()
            end
        end
        screenGui:Destroy()
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
        errorLabel.Font = Enum.Font.SourceSansBold
        errorLabel.TextSize = 20
        errorLabel.Text = "Error: " .. tostring(errorMsg)
        errorLabel.TextWrapped = true
        errorLabel.Parent = screenGui
    end
end