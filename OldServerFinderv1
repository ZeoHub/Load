if not game:IsLoaded() then game.Loaded:Wait() end

local function prompt(title, text)
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local UIGradient = Instance.new("UIGradient")
    local UICorner = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local Divider = Instance.new("Frame")
    local Message = Instance.new("TextLabel")
    local ButtonHolder = Instance.new("Frame")
    local YesButton = Instance.new("TextButton")
    local YesCorner = Instance.new("UICorner")
    local NoButton = Instance.new("TextButton")
    local NoCorner = Instance.new("UICorner")
    local Glow = Instance.new("ImageLabel")

    local parentGui = (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Parent = parentGui
    ScreenGui.Name = "BloodmoonPrompt"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    Frame.Parent = ScreenGui
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 350, 0, 220)
    Frame.ZIndex = 2

    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    UIGradient.Rotation = 90
    UIGradient.Parent = Frame

    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    Title.Name = "Title"
    Title.Parent = Frame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 15)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(220, 90, 90)
    Title.TextSize = 20
    Title.TextTransparency = 0.1

    Divider.Name = "Divider"
    Divider.Parent = Frame
    Divider.BackgroundColor3 = Color3.fromRGB(220, 90, 90)
    Divider.BorderSizePixel = 0
    Divider.Position = UDim2.new(0.1, 0, 0.2, 0)
    Divider.Size = UDim2.new(0.8, 0, 0, 1)
    Divider.ZIndex = 3

    Message.Name = "Message"
    Message.Parent = Frame
    Message.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Message.BackgroundTransparency = 1
    Message.Position = UDim2.new(0.1, 0, 0.25, 0)
    Message.Size = UDim2.new(0.8, 0, 0.4, 0)
    Message.Font = Enum.Font.Gotham
    Message.Text = text
    Message.TextColor3 = Color3.fromRGB(200, 200, 200)
    Message.TextSize = 14
    Message.TextWrapped = true
    Message.TextYAlignment = Enum.TextYAlignment.Top

    ButtonHolder.Name = "ButtonHolder"
    ButtonHolder.Parent = Frame
    ButtonHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonHolder.BackgroundTransparency = 1
    ButtonHolder.Position = UDim2.new(0.1, 0, 0.7, 0)
    ButtonHolder.Size = UDim2.new(0.8, 0, 0, 45)

    YesButton.Name = "YesButton"
    YesButton.Parent = ButtonHolder
    YesButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
    YesButton.Position = UDim2.new(0, 0, 0, 0)
    YesButton.Size = UDim2.new(0.45, 0, 1, 0)
    YesButton.Font = Enum.Font.GothamBold
    YesButton.Text = "YES"
    YesButton.TextColor3 = Color3.fromRGB(240, 240, 240)
    YesButton.TextSize = 14

    YesCorner.CornerRadius = UDim.new(0, 8)
    YesCorner.Parent = YesButton

    NoButton.Name = "NoButton"
    NoButton.Parent = ButtonHolder
    NoButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    NoButton.Position = UDim2.new(0.55, 0, 0, 0)
    NoButton.Size = UDim2.new(0.45, 0, 1, 0)
    NoButton.Font = Enum.Font.GothamBold
    NoButton.Text = "NO"
    NoButton.TextColor3 = Color3.fromRGB(240, 240, 240)
    NoButton.TextSize = 14

    NoCorner.CornerRadius = UDim.new(0, 8)
    NoCorner.Parent = NoButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Frame
    CloseButton.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
    CloseButton.Position = UDim2.new(0.85, 0, 0.02, 0)
    CloseButton.Size = UDim2.new(0.1, 0, 0, 25)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "❌"
    CloseButton.TextColor3 = Color3.fromRGB(220, 90, 90)
    CloseButton.TextSize = 16

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    local choice = false
    local done = false

    CloseButton.MouseButton1Click:Connect(function()
        choice = false
        done = true
        ScreenGui:Destroy()
    end)
    YesButton.MouseButton1Click:Connect(function()
        choice = true
        done = true
        ScreenGui:Destroy()
    end)
    NoButton.MouseButton1Click:Connect(function()
        choice = false
        done = true
        ScreenGui:Destroy()
    end)

    Glow.Name = "Glow"
    Glow.Parent = Frame
    Glow.BackgroundTransparency = 1
    Glow.BorderSizePixel = 0
    Glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
    Glow.Size = UDim2.new(1.2, 0, 1.2, 0)
    Glow.ZIndex = 1
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = Color3.fromRGB(220, 90, 90)
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(24, 24, 276, 276)
    Glow.SliceScale = 0.24
    Glow.ImageTransparency = 0.8

    repeat task.wait() until done or not ScreenGui.Parent
    return choice
end

local o = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZeoHub/Load/refs/heads/main/Gui.lua"))()
function nt(n, c)
    if o and o.MakeNotification then
        o:MakeNotification({
            Name = n,
            Content = c,
            Image = "rbxassetid://4483345998",
            Time = 6
        })
    else
        warn("[Notification]", n, c)
    end
end

_G.patched = _G.patched or false
if _G.patched then
    nt("PATCHED","Dupe Sheckles has been patched and it won't work now.")
    nt("NOTICE","We'll come back soon once a new bug or script has been found!")
    return
end

local gagid = 126884695634066
if game.PlaceId ~= gagid then
    nt("Wrong Game", "This script is for Grow a Garden only!")
    return
end

local queueTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport) or function() end
local oldVersionMax = 1279 -- servers with this place version or lower are considered old
local currentVersion = game.PlaceVersion

local shf = ([[
    if not _G.exeonce then
        _G.exeonce = true
        repeat task.wait() until game:IsLoaded()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZeoHub/Load/refs/heads/main/OldServerFinderv1", true))()
    end
]]):format(oldVersionMax)
queueTeleport(shf)

local function checkBloodMoon()
    local shrine = workspace:FindFirstChild("Interaction") and workspace.Interaction:FindFirstChild("UpdateItems") and workspace.Interaction.UpdateItems:FindFirstChild("BloodMoonShrine")
    if shrine and shrine:IsA("Model") then
        local part = shrine.PrimaryPart or shrine:FindFirstChildWhichIsA("BasePart")
        if part then
            return (part.Position - Vector3.new(-83.157, 0.3, -11.295)).Magnitude < 0.1
        end
    end
    return false
end

local lastHopAttempt = 0
local function sh()
    if os.time() - lastHopAttempt < 5 then
        nt("Please Wait", "Server hop cooldown...")
        return false
    end
    lastHopAttempt = os.time()

    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if typeof(req) ~= "function" then 
        nt("Error", "No HTTP request function available")
        return false
    end
    task.wait(math.random(1, 3))

    local hs = game:GetService("HttpService")
    local tp = game:GetService("TeleportService")
    local res = req({
        Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
        Method = "GET"
    })

    if not res then
        nt("Error", "HTTP request failed")
        return false
    end

    if res.StatusCode == 429 then
        nt("Rate Limited", "Please wait a few minutes before trying again")
        return false
    elseif res.StatusCode ~= 200 then 
        nt("Error", "Server request failed (Code: "..res.StatusCode..")")
        return false 
    end

    local success, data = pcall(function() return hs:JSONDecode(res.Body) end)
    if not success or not data or not data.data then 
        nt("Error", "Failed to read server data")
        return false
    end

    local list = {}
    for _, v in ipairs(data.data) do
        if type(v) == "table" and v.id ~= game.JobId then
            local playing = tonumber(v.playing) or 0
            local max = tonumber(v.maxPlayers) or 100
            local placeVersion = tonumber(v.placeVersion) or 0
            if playing < max and placeVersion <= oldVersionMax then
                table.insert(list, v.id)
            end
        end
    end

    if #list > 0 then
        nt("Server Hop", "Found "..#list.." servers with version ≤ "..oldVersionMax)
        task.wait(1)
        nt("Teleporting", "Joining server with old version...")
        task.wait(0.5)
        tp:TeleportToPlaceInstance(game.PlaceId, list[math.random(#list)])
        return true
    else
        nt("No Servers", "No available servers with version ≤ "..oldVersionMax.." found")
        return false
    end
end

if currentVersion <= oldVersionMax then
    nt("Perfect Server!", "This server supports the Infinite Sheckles Script!")
else
    nt("New Server Detected!", "Version: " .. currentVersion)
    task.wait(0.5)
    nt("Searching...", "Looking for a server with version ≤ "..oldVersionMax.."...")
    local success = sh()
    if not success then
        task.wait(5)
        sh()
    end
end
