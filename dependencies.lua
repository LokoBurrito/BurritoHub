local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService") 

local function createPlayerHighlight(player)
    if player:FindFirstChild("HighlightBillboardGui") then return end
    local playerHead = player.Character.Head 
    local highlightBillboardGui = Instance.new("BillboardGui")
    highlightBillboardGui.Name = "HighlightBillboardGui"
    highlightBillboardGui.Size = UDim2.new(1.5, 0, 1.5, 0)
    highlightBillboardGui.AlwaysOnTop = true
    highlightBillboardGui.Adornee = playerHead
    highlightBillboardGui.Parent = playerHead
    local highlightFrame = Instance.new("Frame")
    highlightFrame.Size = UDim2.new(1, 0, 1, 0)
    highlightFrame.BackgroundTransparency = 0.5 -- Semi-transparent
    highlightFrame.BackgroundColor3 = Color3.new(0.5, 0, 1) -- Purple
    highlightFrame.Parent = highlightBillboardGui
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Text = player.Name
    nameLabel.Parent = highlightBillboardGui
end

local function removePlayerHighlight(player)
    local highlightBillboardGui = player.Character.Head:FindFirstChild("HighlightBillboardGui")
    if highlightBillboardGui then
        highlightBillboardGui:Destroy()
    end
end

local function createOutlinesForAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        createPlayerHighlight(player)
    end
end

local function removeOutlinesForAllPlayers()
    for _, player in ipairs(game.Players:GetPlayers()) do
        removePlayerHighlight(player)
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.R then
        refreshHighlights() 
    end
end)

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
