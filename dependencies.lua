local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService") 

-- Function to create a highlight for a player
local function createPlayerHighlight(player)
    -- Check if the highlight already exists for this player
    if player:FindFirstChild("HighlightBillboardGui") then return end

    local playerHead = player.Character.Head 

    -- Create BillboardGui to hold the highlight
    local highlightBillboardGui = Instance.new("BillboardGui")
    highlightBillboardGui.Name = "HighlightBillboardGui"
    highlightBillboardGui.Size = UDim2.new(1.5, 0, 1.5, 0) -- Adjust size as needed
    highlightBillboardGui.AlwaysOnTop = true
    highlightBillboardGui.Adornee = playerHead
    highlightBillboardGui.Parent = playerHead

    -- Create Frame for the highlight background
    local highlightFrame = Instance.new("Frame")
    highlightFrame.Size = UDim2.new(1, 0, 1, 0)
    highlightFrame.BackgroundTransparency = 0.5 -- Semi-transparent
    highlightFrame.BackgroundColor3 = Color3.new(0.5, 0, 1) -- Purple
    highlightFrame.Parent = highlightBillboardGui

    -- Create TextLabel to display the player's name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.2, 0) -- Adjust as needed
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1) -- White
    nameLabel.Text = player.Name
    nameLabel.Parent = highlightBillboardGui
end

-- Function to remove a player's highlight
local function removePlayerHighlight(player)
    local highlightBillboardGui = player.Character.Head:FindFirstChild("HighlightBillboardGui")
    if highlightBillboardGui then
        highlightBillboardGui:Destroy()
    end
end

-- Function to create highlights for all players
local function createOutlinesForAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        createPlayerHighlight(player)
    end
end

-- Function to remove highlights for all players
local function removeOutlinesForAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        removePlayerHighlight(player)
    end
end


local function findNearestPlayer()
    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character
    if not localCharacter then return end

    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local highlight = player.Character.Head:FindFirstChild("HighlightBillboardGui")
            if highlight then
                local distance = (localCharacter.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

local function teleportToNearest()
    nearestPlayer = findNearestPlayer()
    if nearestPlayer then
        local localPlayer = game.Players.LocalPlayer
        local localCharacter = localPlayer.Character
        if localCharacter then
            localCharacter.HumanoidRootPart.CFrame = nearestPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Nine then
        teleportToNearest()
    end
end)

-------------------------------------------------------------------------------
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("scripts (TESTING)", "DarkTheme")
local Tab = Window:NewTab("Visualizers")
local Section = Tab:NewSection("Toggles")
------------------------------------------------------------------------------
Section:NewToggle("Highlights", "Toggle to turn Highlights on/off", function(state)
    if state then
        createOutlinesForAllPlayers() 
        print("Creating Headboxes")
    else
        removeOutlinesForAllPlayers()
        print("Removing Headboxes")
    end
end)
------------------------------------------------------------------------------
local Tab = Window:NewTab("Extra Functions")
local a = Tab:NewSection("Toggles")

a:NewToggle("Teleport to Nearest", "Toggle teleportation on/off", function(state)
    if state then
        teleportEnabled = true
        print("teleport is on, press '9' to teleport.")
    else
        teleportEnabled = false
        print("teleport has been turned off")
    end
end)
