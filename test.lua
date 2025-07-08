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
    local myRoot = Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        print("HumanoidRootPart not found in your character!")
        return
    end
    local targetRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        print("Target's HumanoidRootPart not found!")
        return
    end
    local prompt = targetRoot:FindFirstChildOfClass("ProximityPrompt")
    print("Prompt found:", prompt)
    if not prompt then
        print("No ProximityPrompt found on target!")
        return
    end

    for _, ctool in ipairs(Character:GetChildren()) do
        if ctool:IsA("Tool") then 
            ctool.Parent = Backpack 
        end
    end

    myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 2)
    tool.Parent = Character

    if prompt.Enabled then
        -- Only call fireproximityprompt if available in environment
        if typeof(fireproximityprompt) == "function" then
            pcall(fireproximityprompt, prompt)
        end
        pcall(function()
            if prompt.InputHoldBegin then
                prompt:InputHoldBegin()
                task.wait(prompt.HoldDuration or 0.15)
                prompt:InputHoldEnd()
            end
        end)
    end

    tool.Parent = Backpack
end

print("Starting fast gifting loop...")

while true do
    local items = getEligibleItems()
    if #items == 0 then
        break
    end

    local recipient = getRecipient()
    if not recipient then
        break
    end

    local idx = math.random(1, #items)
    local tool = items[idx]

    fastGift(tool, recipient)
    task.wait(0.01)
end

print("Script finished")
