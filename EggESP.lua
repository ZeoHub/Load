-- Randomizer GUI Script Loader with Single-Instance Protection & Teleport Auto-Reload
-- Copilot version (PC/mobile adaptive, button feedback, min/max frame size, etc)
-- Replace SCRIPT_URL with your raw script URL if you want teleport reload! (see end of script)

if getgenv then
    getgenv().RandomizerLoaded = getgenv().RandomizerLoaded or false
    if getgenv().RandomizerLoaded then return end
    getgenv().RandomizerLoaded = true
end

local function MainRandomizer()
    -- === BEGIN RANDOMIZER SCRIPT BODY ===

    local players = game:GetService("Players")
    local collectionService = game:GetService("CollectionService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local localPlayer = players.LocalPlayer or players:GetPlayers()[1]

    local BROWN_BG = Color3.fromRGB(118, 61, 25)
    local BROWN_LIGHT = Color3.fromRGB(164, 97, 43)
    local BROWN_BORDER = Color3.fromRGB(51, 25, 0)
    local ACCENT_GREEN = Color3.fromRGB(110, 196, 99)
    local BUTTON_YELLOW = Color3.fromRGB(255, 214, 61)
    local BUTTON_RED = Color3.fromRGB(255, 62, 62)
    local BUTTON_GRAY = Color3.fromRGB(190, 190, 190)
    local BUTTON_BLUE = Color3.fromRGB(66, 150, 255)
    local BUTTON_BLUE_HOVER = Color3.fromRGB(85, 180, 255)
    local BUTTON_GREEN = Color3.fromRGB(85, 200, 85)
    local BUTTON_GREEN_HOVER = Color3.fromRGB(120, 230, 120)
    local BUTTON_RED_HOVER = Color3.fromRGB(255, 100, 100)
    local FONT = Enum.Font.FredokaOne
    local TILE_IMAGE = "rbxassetid://15910695828"

    local eggChances = {
        ["Common Egg"] = {["Dog"] = 33, ["Bunny"] = 33, ["Golden Lab"] = 33},
        ["Uncommon Egg"] = {["Black Bunny"] = 25, ["Chicken"] = 25, ["Cat"] = 25, ["Deer"] = 25},
        ["Rare Egg"] = {["Orange Tabby"] = 33.33, ["Spotted Deer"] = 25, ["Pig"] = 16.67, ["Rooster"] = 16.67, ["Monkey"] = 8.33},
        ["Legendary Egg"] = {["Cow"] = 42.55, ["Silver Monkey"] = 42.55, ["Sea Otter"] = 10.64, ["Turtle"] = 2.13, ["Polar Bear"] = 2.13},
        ["Mythic Egg"] = {["Grey Mouse"] = 37.5, ["Brown Mouse"] = 26.79, ["Squirrel"] = 26.79, ["Red Giant Ant"] = 8.93, ["Red Fox"] = 0},
        ["Bug Egg"] = {["Snail"] = 40, ["Giant Ant"] = 35, ["Caterpillar"] = 25, ["Praying Mantis"] = 0, ["Dragon Fly"] = 0},
        ["Night Egg"] = {["Hedgehog"] = 47, ["Mole"] = 23.5, ["Frog"] = 21.16, ["Echo Frog"] = 8.35, ["Night Owl"] = 0, ["Raccoon"] = 0},
        ["Bee Egg"] = {["Bee"] = 65, ["Honey Bee"] = 20, ["Bear Bee"] = 10, ["Petal Bee"] = 5, ["Queen Bee"] = 0},
        ["Anti Bee Egg"] = {["Wasp"] = 55, ["Tarantula Hawk"] = 31, ["Moth"] = 14, ["Butterfly"] = 0, ["Disco Bee"] = 0},
        ["Common Summer Egg"] = {["Starfish"] = 50, ["Seafull"] = 25, ["Crab"] = 25},
        ["Rare Summer Egg"] = {["Flamingo"] = 30, ["Toucan"] = 25, ["Sea Turtle"] = 20, ["Orangutan"] = 15, ["Seal"] = 10},
        ["Paradise Egg"] = {["Ostrich"] = 43, ["Peacock"] = 33, ["Capybara"] = 24, ["Scarlet Macaw"] = 3, ["Mimic Octopus"] = 1},
        ["Premium Night Egg"] = {["Hedgehog"] = 50, ["Mole"] = 26, ["Frog"] = 14, ["Echo Frog"] = 10}
    }

    local realESP = {
        ["Common Egg"] = true, ["Uncommon Egg"] = true, ["Rare Egg"] = true,
        ["Common Summer Egg"] = true, ["Rare Summer Egg"] = true
    }

    local displayedEggs = {}
    local autoStopOn = true

    local function weightedRandom(options)
        local valid = {}
        for pet, chance in pairs(options) do
            if chance > 0 then table.insert(valid, {pet = pet, chance = chance}) end
        end
        if #valid == 0 then return nil end
        local total = 0
        for _, v in ipairs(valid) do total += v.chance end
        local roll = math.random() * total
        local cumulative = 0
        for _, v in ipairs(valid) do
            cumulative += v.chance
            if roll <= cumulative then return v.pet end
        end
        return valid[1].pet
    end

    local function getNonRepeatingRandomPet(eggName, lastPet)
        local pool = eggChances[eggName]
        if not pool then return nil end
        local tries, selectedPet = 0, lastPet
        while tries < 5 do
            local pet = weightedRandom(pool)
            if not pet then return nil end
            if pet ~= lastPet or math.random() < 0.3 then
                selectedPet = pet
                break
            end
            tries += 1
        end
        return selectedPet
    end

    local function createEspGui(object, labelText)
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "FakePetESP"
        billboard.Adornee = object:FindFirstChildWhichIsA("BasePart") or object.PrimaryPart or object
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Text = labelText
        label.Parent = billboard

        billboard.Parent = object
        return billboard
    end

    local function addESP(egg)
        if egg:GetAttribute("OWNER") ~= localPlayer.Name then return end
        local eggName = egg:GetAttribute("EggName")
        local objectId = egg:GetAttribute("OBJECT_UUID")
        if not eggName or not objectId or displayedEggs[objectId] then return end

        local labelText, firstPet
        if realESP[eggName] then
            labelText = eggName
        else
            firstPet = getNonRepeatingRandomPet(eggName, nil)
            labelText = eggName .. " | " .. (firstPet or "?")
        end

        local espGui = createEspGui(egg, labelText)
        displayedEggs[objectId] = {
            egg = egg,
            gui = espGui,
            label = espGui:FindFirstChild("TextLabel"),
            eggName = eggName,
            lastPet = firstPet
        }
    end

    local function removeESP(egg)
        local objectId = egg:GetAttribute("OBJECT_UUID")
        if objectId and displayedEggs[objectId] then
            displayedEggs[objectId].gui:Destroy()
            displayedEggs[objectId] = nil
        end
    end

    for _, egg in collectionService:GetTagged("PetEggServer") do
        addESP(egg)
    end
    collectionService:GetInstanceAddedSignal("PetEggServer"):Connect(addESP)
    collectionService:GetInstanceRemovedSignal("PetEggServer"):Connect(removeESP)

    local gui = Instance.new("ScreenGui")
    gui.Name = "RandomizerStyledGUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = localPlayer:WaitForChild("PlayerGui")

    -- Responsive main frame for both mobile and desktop
    local function getMainFrameSizeAndPosition()
        local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1080, 720)
        local aspect = viewport.X / viewport.Y
        local widthScale, heightScale

        if aspect < 1.35 then
            widthScale = 0.93
            heightScale = 0.42
        else
            widthScale = 0.32
            heightScale = 0.34
        end

        local minW, minH, maxW, maxH = 300, 160, 480, 240
        local pxW, pxH = viewport.X * widthScale, viewport.Y * heightScale
        local size = UDim2.new(widthScale, 0, heightScale, 0)
        if pxW < minW or pxH < minH then
            size = UDim2.new(0, math.max(minW, pxW), 0, math.max(minH, pxH))
        elseif pxW > maxW or pxH > maxH then
            size = UDim2.new(0, math.min(maxW, pxW), 0, math.min(maxH, pxH))
        end
        local pos = UDim2.new(0.5, 0, 0.5, 0)
        return size, pos
    end

    local size, pos = getMainFrameSizeAndPosition()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = size
    mainFrame.Position = pos
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = BROWN_BG
    mainFrame.Parent = gui
    mainFrame.Active = true
    mainFrame.Draggable = true

    local frameCorner = Instance.new("UICorner", mainFrame)
    frameCorner.CornerRadius = UDim.new(0, 18)
    local frameStroke = Instance.new("UIStroke", mainFrame)
    frameStroke.Thickness = 4
    frameStroke.Color = BROWN_BORDER

    local brownTexture = Instance.new("ImageLabel")
    brownTexture.Name = "BrownTexture"
    brownTexture.Size = UDim2.new(1, 0, 1, 0)
    brownTexture.Position = UDim2.new(0, 0, 0, 0)
    brownTexture.BackgroundTransparency = 1
    brownTexture.Image = TILE_IMAGE
    brownTexture.ImageTransparency = 0
    brownTexture.ScaleType = Enum.ScaleType.Tile
    brownTexture.TileSize = UDim2.new(0, 96, 0, 96)
    brownTexture.ZIndex = 1
    brownTexture.Parent = mainFrame

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 50)
    topBar.BackgroundColor3 = ACCENT_GREEN
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    local topBarCorner = Instance.new("UICorner", topBar)
    topBarCorner.CornerRadius = UDim.new(0, 18)

    local greenTexture = Instance.new("ImageLabel")
    greenTexture.Name = "GreenTexture"
    greenTexture.Size = UDim2.new(1, 0, 1, 0)
    greenTexture.Position = UDim2.new(0, 0, 0, 0)
    greenTexture.BackgroundTransparency = 1
    greenTexture.Image = TILE_IMAGE
    greenTexture.ImageTransparency = 0
    greenTexture.ScaleType = Enum.ScaleType.Tile
    greenTexture.TileSize = UDim2.new(0, 96, 0, 96)
    greenTexture.ZIndex = 1
    greenTexture.Parent = topBar

    local topLabel = Instance.new("TextLabel")
    topLabel.Size = UDim2.new(1, -130, 1, 0)
    topLabel.Position = UDim2.new(0, 18, 0, 0)
    topLabel.BackgroundTransparency = 1
    topLabel.Text = "🐣 Randomizer"
    topLabel.Font = FONT
    topLabel.TextColor3 = Color3.new(1, 1, 1)
    topLabel.TextStrokeTransparency = 0
    topLabel.TextStrokeColor3 = Color3.fromRGB(45, 66, 0)
    topLabel.TextScaled = true
    topLabel.TextXAlignment = Enum.TextXAlignment.Left
    topLabel.ZIndex = 1
    topLabel.Parent = topBar

    local infoBtn = Instance.new("TextButton")
    infoBtn.Size = UDim2.new(0, 44, 0, 44)
    infoBtn.Position = UDim2.new(1, -104, 0.5, -22)
    infoBtn.BackgroundColor3 = BUTTON_GRAY
    infoBtn.Text = "?"
    infoBtn.Font = FONT
    infoBtn.TextColor3 = Color3.fromRGB(65, 65, 65)
    infoBtn.TextScaled = true
    infoBtn.TextStrokeTransparency = 0.1
    infoBtn.Parent = topBar
    infoBtn.ZIndex = 2
    local infoStroke = Instance.new("UIStroke", infoBtn)
    infoStroke.Color = Color3.fromRGB(120,120,120)
    infoStroke.Thickness = 2
    infoBtn.MouseEnter:Connect(function()
        infoBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    end)
    infoBtn.MouseLeave:Connect(function()
        infoBtn.BackgroundColor3 = BUTTON_GRAY
    end)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 44, 0, 44)
    closeBtn.Position = UDim2.new(1, -52, 0.5, -22)
    closeBtn.BackgroundColor3 = BUTTON_RED
    closeBtn.Text = "X"
    closeBtn.Font = FONT
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.TextScaled = true
    closeBtn.TextStrokeTransparency = 0.3
    closeBtn.Parent = topBar
    closeBtn.ZIndex = 2
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = Color3.fromRGB(107, 0, 0)
    closeStroke.Thickness = 2
    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 62, 62)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = BUTTON_RED
    end)
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -16, 1, -70)
    contentFrame.Position = UDim2.new(0, 8, 0, 62)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2
    contentFrame.Parent = mainFrame

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.Parent = contentFrame
    btnLayout.FillDirection = Enum.FillDirection.Vertical
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    btnLayout.Padding = UDim.new(0, 14)

    local function updateStopBtnColors(btn)
        if autoStopOn then
            btn.BackgroundColor3 = BUTTON_GREEN
            btn.Text = "[A] Auto Stop: ON"
            btn.TextColor3 = Color3.new(1,1,1)
        else
            btn.BackgroundColor3 = BUTTON_RED
            btn.Text = "[A] Auto Stop: OFF"
            btn.TextColor3 = Color3.new(1,1,1)
        end
    end

    local function makeStyledButton(text, color, hover, onHover, onUnhover)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.93, 0, 0, 52)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.Font = FONT
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextScaled = true
        btn.TextStrokeTransparency = 0.25
        btn.ZIndex = 2
        btn.AutoButtonColor = false
        btn.Parent = contentFrame
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 12)
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = BROWN_BORDER
        btnStroke.Thickness = 2

        btn.MouseEnter:Connect(function()
            if onHover then onHover(btn) else btn.BackgroundColor3 = hover end
        end)
        btn.MouseLeave:Connect(function()
            if onUnhover then onUnhover(btn) else btn.BackgroundColor3 = color end
        end)

        local pressColor = hover:Lerp(Color3.new(0,0,0), 0.15)
        btn.MouseButton1Down:Connect(function()
            btn.BackgroundColor3 = pressColor
        end)
        btn.MouseButton1Up:Connect(function()
            if onHover and btn:IsMouseOver() then
                onHover(btn)
            else
                btn.BackgroundColor3 = hover
            end
        end)
        btn.TouchTap:Connect(function()
            btn.BackgroundColor3 = pressColor
            task.wait(0.09)
            btn.BackgroundColor3 = hover
            task.wait(0.09)
            btn.BackgroundColor3 = color
        end)

        return btn
    end

    local stopBtn = makeStyledButton(
        "[A] Auto Stop: ON",
        BUTTON_GREEN,
        BUTTON_GREEN_HOVER,
        function(btn)
            if autoStopOn then
                btn.BackgroundColor3 = BUTTON_GREEN_HOVER
            else
                btn.BackgroundColor3 = BUTTON_RED_HOVER
            end
        end,
        function(btn)
            if autoStopOn then
                btn.BackgroundColor3 = BUTTON_GREEN
            else
                btn.BackgroundColor3 = BUTTON_RED
            end
        end
    )
    updateStopBtnColors(stopBtn)

    local rerollBtn = makeStyledButton(
        "[B] Reroll Pet Display",
        BUTTON_BLUE,
        BUTTON_BLUE_HOVER
    )

    stopBtn.MouseButton1Click:Connect(function()
        autoStopOn = not autoStopOn
        updateStopBtnColors(stopBtn)
    end)
    rerollBtn.MouseButton1Click:Connect(function()
        for objectId, data in pairs(displayedEggs) do
            local pet = getNonRepeatingRandomPet(data.eggName, data.lastPet)
            if pet and data.label then
                data.label.Text = data.eggName .. " | " .. pet
                data.lastPet = pet
            end
        end
    end)

    local camera = workspace.CurrentCamera
    local originalFOV
    local zoomFOV = 60
    local tweenTime = 0.4
    local currentTween

    infoBtn.MouseButton1Click:Connect(function()
        if gui:FindFirstChild("InfoModal") then return end

        local blur = Instance.new("BlurEffect")
        blur.Size = 16
        blur.Name = "ModalBlur"
        blur.Parent = game:GetService("Lighting")

        if camera then
            originalFOV = camera.FieldOfView
            if currentTween then currentTween:Cancel() end
            currentTween = TweenService:Create(camera, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                FieldOfView = zoomFOV
            })
            currentTween:Play()
        end

        local modal = Instance.new("Frame")
        modal.Name = "InfoModal"
        modal.Size = UDim2.new(0, 340, 0, 180)
        modal.Position = UDim2.new(0.5, 0, 0.5, 0)
        modal.AnchorPoint = Vector2.new(0.5,0.5)
        modal.BackgroundColor3 = BROWN_LIGHT
        modal.Active = true
        modal.ZIndex = 30
        modal.Parent = gui
        local modalCorner = Instance.new("UICorner", modal)
        modalCorner.CornerRadius = UDim.new(0, 14)
        local modalStroke = Instance.new("UIStroke", modal)
        modalStroke.Color = BROWN_BORDER
        modalStroke.Thickness = 3

        local modalTexture = Instance.new("ImageLabel")
        modalTexture.Name = "ModalBrownTexture"
        modalTexture.Size = UDim2.new(1, 0, 1, 0)
        modalTexture.Position = UDim2.new(0, 0, 0, 0)
        modalTexture.BackgroundTransparency = 1
        modalTexture.Image = TILE_IMAGE
        modalTexture.ImageTransparency = 0
        modalTexture.ScaleType = Enum.ScaleType.Tile
        modalTexture.TileSize = UDim2.new(0, 96, 0, 96)
        modalTexture.ZIndex = 30
        modalTexture.Parent = modal

        local textTile = Instance.new("Frame")
        textTile.Size = UDim2.new(1, 0, 0, 38)
        textTile.Position = UDim2.new(0, 0, 0, 0)
        textTile.BackgroundColor3 = ACCENT_GREEN
        textTile.ZIndex = 30
        textTile.Parent = modal
        local textTileCorner = Instance.new("UICorner", textTile)
        textTileCorner.CornerRadius = UDim.new(0, 14)

        local textTileLabel = Instance.new("TextLabel")
        textTileLabel.Size = UDim2.new(1, -40, 1, 0)
        textTileLabel.Position = UDim2.new(0, 20, 0, 0)
        textTileLabel.BackgroundTransparency = 1
        textTileLabel.Text = "Info"
        textTileLabel.TextColor3 = Color3.fromRGB(255,255,255)
        textTileLabel.Font = FONT
        textTileLabel.TextScaled = true
        textTileLabel.ZIndex = 31
        textTileLabel.TextStrokeTransparency = 0
        textTileLabel.Parent = textTile

        local closeBtn2 = Instance.new("TextButton")
        closeBtn2.Size = UDim2.new(0, 32, 0, 32)
        closeBtn2.Position = UDim2.new(1, -40, 0, 3)
        closeBtn2.BackgroundColor3 = BUTTON_RED
        closeBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn2.Text = "✖"
        closeBtn2.TextScaled = true
        closeBtn2.Font = FONT
        closeBtn2.ZIndex = 32
        closeBtn2.Parent = textTile
        local closeStroke2 = Instance.new("UIStroke", closeBtn2)
        closeStroke2.Color = Color3.fromRGB(107, 0, 0)
        closeStroke2.Thickness = 2
        closeBtn2.MouseEnter:Connect(function()
            closeBtn2.BackgroundColor3 = Color3.fromRGB(200, 62, 62)
        end)
        closeBtn2.MouseLeave:Connect(function()
            closeBtn2.BackgroundColor3 = BUTTON_RED
        end)
        closeBtn2.MouseButton1Click:Connect(function()
            if blur then blur:Destroy() end
            if modal then modal:Destroy() end
            if camera and originalFOV then
                if currentTween then currentTween:Cancel() end
                currentTween = TweenService:Create(camera, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    FieldOfView = originalFOV
                })
                currentTween:Play()
            end
        end)

        local infoBox = Instance.new("Frame")
        infoBox.Size = UDim2.new(1, -40, 1, -60)
        infoBox.Position = UDim2.new(0, 20, 0, 48)
        infoBox.BackgroundColor3 = Color3.fromRGB(196, 164, 132)
        infoBox.BackgroundTransparency = 0
        infoBox.ZIndex = 30
        infoBox.Parent = modal

        local infoBoxCorner = Instance.new("UICorner", infoBox)
        infoBoxCorner.CornerRadius = UDim.new(0, 10)

        local infoBoxGradient = Instance.new("UIGradient", infoBox)
        infoBoxGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(164, 97, 43)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 43, 18))
        }

        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, 0, 1, 0)
        infoLabel.Position = UDim2.new(0, 0, 0, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        infoLabel.Text = "Auto Stop when found:\nRaccoon, Dragonfly, Queen Bee, Red Fox, Disco Bee, Butterfly."
        infoLabel.TextWrapped = true
        infoLabel.Font = FONT
        infoLabel.TextScaled = true
        infoLabel.ZIndex = 31
        infoLabel.TextStrokeTransparency = 0.5
        infoLabel.Parent = infoBox
    end)

    local function updateMainFrame()
        local size, pos = getMainFrameSizeAndPosition()
        mainFrame.Size = size
        mainFrame.Position = pos
    end
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateMainFrame)

    local dragging, dragInput, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    -- === END RANDOMIZER SCRIPT BODY ===
end

MainRandomizer()

-- Teleport auto-reload (requires HTTP hosting for best compatibility)
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
lp.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.InQueue then
        local scriptUrl = "https://pastebin.com/raw/YOUR_SCRIPT_ID_HERE" -- TODO: Replace with your raw script URL
        if syn and syn.queue_on_teleport then
            syn.queue_on_teleport(('loadstring(game:HttpGet("%s"))()'):format(scriptUrl))
        elseif queue_on_teleport then
            queue_on_teleport(('loadstring(game:HttpGet("%s"))()'):format(scriptUrl))
        end
    end
end)
