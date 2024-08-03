local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService") 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local bindableEvent = Instance.new("BindableEvent")

local function createPlayerHighlight(player)
    
    if player:FindFirstChild("HighlightBillboardGui") then return end

    local playerHead = player.Character.Head 

    local highlightBillboardGui = Instance.new("BillboardGui")
    highlightBillboardGui.Name = "HighlightBillboardGui"
    highlightBillboardGui.Size = UDim2.new(1.5, 0, 1.5, 0) -- Adjust size as needed
    highlightBillboardGui.AlwaysOnTop = true
    highlightBillboardGui.Adornee = playerHead
    highlightBillboardGui.Parent = playerHead

    local highlightFrame = Instance.new("Frame")
    highlightFrame.Size = UDim2.new(1, 0, 1, 0)
    highlightFrame.BackgroundTransparency = 0.5 -- Semi-transparent
    highlightFrame.BackgroundColor3 = Color3.new(0.5, 0, 1) -- Purple
    highlightFrame.Parent = highlightBillboardGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.2, 0) -- Adjust as needed
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1) -- White
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

local partSize = Vector3.new(1, 1, 1)  
local hoverHeight = 3
local hoverSpeed = 5

local function createPetRock(player)
    local part = Instance.new("Part")
    part.Name = player.Name .. "'s pet rock"
    part.Size = partSize
    part.BrickColor = BrickColor.new("Medium stone grey") 
    part.Anchored = true

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = part
    billboardGui.Size = UDim2.new(2, 0, 2, 0)  
    billboardGui.Parent = part

    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            part.CFrame = humanoidRootPart.CFrame * CFrame.new(0, hoverHeight, 0)
            part.Parent = workspace 
        end
    end

    local angle = 0
    RunService.Heartbeat:Connect(function(dt)
        if part and character and character:FindFirstChild("HumanoidRootPart") then
            angle = angle + dt * hoverSpeed
            local offset = Vector3.new(math.sin(angle), hoverHeight, math.cos(angle))
            part.CFrame = character.HumanoidRootPart.CFrame * CFrame.new(offset)
        end
    end)
end

local function destroyPetRock(player)
    local petRockName = player.Name .. "'s pet rock"
    local petRock = workspace:FindFirstChild(petRockName)
    if petRock then
        petRock:Destroy()
    end
end

bindableEvent.Name = "TogglePetRock"
bindableEvent.Parent = ReplicatedStorage

bindableEvent.Event:Connect(function(player, state)
    if state then
        createPetRock(player)
    else
        destroyPetRock(player)
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message:lower() == "/petrock" then 
            if workspace:FindFirstChild(player.Name .. "'s pet rock") then
                destroyPetRock(player) -- Destroy if already exists
            else
                createPetRock(player) 
            end
        end
    end)
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

a:NewToggle("rock", "makes a rock hover around you", function(state)
    local player = game.Players.LocalPlayer -- Get the local player
    if state then
        createPetRock(player)  -- Toggle pet rock on
    else
        destroyPetRock(player) -- Toggle pet rock off
    end
end)
