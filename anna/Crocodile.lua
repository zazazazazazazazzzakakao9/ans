local Players = game:GetService("Players")
local LogService = game:GetService("LogService")

local player = Players.LocalPlayer

-- Create GUI Elements
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true -- Make GUI draggable

-- Tab Buttons
local tabButtons = {}
local categories = { "Output", "Information", "Warning", "Error" }
local currentCategory = "Output"

for i, category in ipairs(categories) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.25, 0, 0, 30)
    button.Position = UDim2.new((i - 1) * 0.25, 0, 0, 0)
    button.Text = category
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        currentCategory = category
        updateLogs()
    end)

    tabButtons[category] = button
end

-- Scrolling Frame for Logs
local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(1, -10, 0.85, -30)
logFrame.Position = UDim2.new(0, 5, 0.15, 0)
logFrame.CanvasSize = UDim2.new(0, 0, 1, 0)
logFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
logFrame.BorderSizePixel = 2
logFrame.ScrollBarThickness = 8
logFrame.Parent = frame

-- Layout for Logs
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = logFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Table to store logs
local logs = {
    Output = {},
    Information = {},
    Warning = {},
    Error = {}
}

-- Function to Update Logs in GUI
local function updateLogs()
    -- Clear previous logs
    for _, child in pairs(logFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    -- Display only logs from the selected category
    for _, log in ipairs(logs[currentCategory]) do
        local logLabel = Instance.new("TextLabel")
        logLabel.Parent = logFrame
        logLabel.Size = UDim2.new(1, 0, 0, 25)
        logLabel.Text = log
        logLabel.TextWrapped = true
        logLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        logLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end

-- Function to Capture Logs
local function captureLog(message, messageType)
    local category = "Output" -- Default category

    if messageType == Enum.MessageType.MessageOutput then
        category = "Output"
    elseif messageType == Enum.MessageType.MessageInfo then
        category = "Information"
    elseif messageType == Enum.MessageType.MessageWarning then
        category = "Warning"
    elseif messageType == Enum.MessageType.MessageError then
        category = "Error"
    end

    table.insert(logs[category], message)
    updateLogs()
end

-- Listen for Log Messages
LogService.MessageOut:Connect(captureLog)

-- Initialize UI
updateLogs()
