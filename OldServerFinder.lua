

if not game:IsLoaded() then game.Loaded:Wait() end

-- Remove duplicate GUI on respawn/rejoin
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("OldServerFinderGui") then
    playerGui.OldServerFinderGui:Destroy()
end


-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OldServerFinderGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Black color palette with white accent
local blackDark = Color3.fromRGB(15, 15, 15)
local blackMid = Color3.fromRGB(40, 40, 40)
local blackLight = Color3.fromRGB(80, 80, 80)
local accentWhite = Color3.fromRGB(235, 235, 235)
local accentGreen = Color3.fromRGB(60, 205, 100)
local accentRed = Color3.fromRGB(255, 82, 82)

-- Main Frame (with rounded corners)
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.45, 0)
mainFrame.Size = UDim2.new(0, 280, 0, 150)
mainFrame.BackgroundColor3 = blackDark
mainFrame.BorderSizePixel = 0

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 16)
uicorner.Parent = mainFrame

local uistroke = Instance.new("UIStroke")
uistroke.Color = blackMid
uistroke.Thickness = 2
uistroke.Parent = mainFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Size = UDim2.new(1, 0, 0, 36)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Old Server Finder"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = accentWhite
titleLabel.TextSize = 26
titleLabel.TextStrokeTransparency = 0.7

-- Button
local button = Instance.new("TextButton")
button.Parent = mainFrame
button.Position = UDim2.new(0.5, -90, 0.4, 0)
button.Size = UDim2.new(0, 180, 0, 40)
button.Text = "Run Menace Hub"
button.BackgroundColor3 = blackMid
button.TextColor3 = accentWhite
button.Font = Enum.Font.GothamSemibold
button.TextSize = 22
button.AutoButtonColor = true

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = button

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = blackMid
buttonStroke.Thickness = 1.2
buttonStroke.Parent = button

local function runMenaceHub()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZeoHub/Load/refs/heads/main/OldServerFinderv1", true))()
    end)
end

-- Button functionality
button.MouseButton1Click:Connect(runMenaceHub)

-- Make Frame Draggable
mainFrame.Active = true
mainFrame.Draggable = true

-- Shadow (faint white for effect)
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Parent = mainFrame
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.Size = UDim2.new(1, 28, 1, 28)
shadow.Position = UDim2.new(0, -14, 0, -14)
shadow.ImageTransparency = 0.85
shadow.ImageColor3 = accentWhite
shadow.ZIndex = 0

mainFrame.ZIndex = 1
titleLabel.ZIndex = 2
button.ZIndex = 2

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = mainFrame
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 4)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = accentRed
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.ZIndex = 3

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Auto Run Toggle
local autoRunValue = Instance.new("BoolValue")
autoRunValue.Name = "AutoRunMenaceHub"
autoRunValue.Value = false -- Default OFF

local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = mainFrame
toggleBtn.Position = UDim2.new(0.5, -70, 0.75, 0)
toggleBtn.Size = UDim2.new(0, 140, 0, 28)
toggleBtn.BackgroundColor3 = blackMid
toggleBtn.TextColor3 = accentWhite
toggleBtn.Font = Enum.Font.Gotham
toggleBtn.TextSize = 18
toggleBtn.AutoButtonColor = true
toggleBtn.ZIndex = 2

local toggleBtnCorner = Instance.new("UICorner")
toggleBtnCorner.CornerRadius = UDim.new(0, 10)
toggleBtnCorner.Parent = toggleBtn

local function updateToggleText()
    if autoRunValue.Value then
        toggleBtn.Text = "Auto Run: ON"
        toggleBtn.BackgroundColor3 = accentGreen
        toggleBtn.TextColor3 = blackDark
    else
        toggleBtn.Text = "Auto Run: OFF"
        toggleBtn.BackgroundColor3 = blackMid
        toggleBtn.TextColor3 = accentWhite
    end
end

updateToggleText()

toggleBtn.MouseButton1Click:Connect(function()
    autoRunValue.Value = not autoRunValue.Value
    updateToggleText()
    if autoRunValue.Value then
        runMenaceHub()
    end
end)

-- If auto run is enabled, run on load
if autoRunValue.Value then
    runMenaceHub()
end
