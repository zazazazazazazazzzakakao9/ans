-- Create GUI
local player = game:GetService("Players").LocalPlayer
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local textBox = Instance.new("TextBox")
local button = Instance.new("TextButton")
local scrollingFrame = Instance.new("ScrollingFrame")
local uiListLayout = Instance.new("UIListLayout")

-- Parent GUI to PlayerGui
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame (Main Container)
frame.Parent = screenGui
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true -- Required for dragging
frame.Draggable = true -- Enables dragging

-- TextBox (Path Input)
textBox.Parent = frame
textBox.Size = UDim2.new(0.9, 0, 0, 30)
textBox.Position = UDim2.new(0.05, 0, 0.05, 0)
textBox.PlaceholderText = "Enter Object Path"
textBox.Text = ""
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Button (Fetch Children)
button.Parent = frame
button.Size = UDim2.new(0.9, 0, 0, 30)
button.Position = UDim2.new(0.05, 0, 0.2, 0)
button.Text = "List Children"
button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Scrolling Frame (Results)
scrollingFrame.Parent = frame
scrollingFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
scrollingFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 1, 0)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scrollingFrame.BorderSizePixel = 2
scrollingFrame.ScrollBarThickness = 8

-- UIListLayout (Auto Positioning)
uiListLayout.Parent = scrollingFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Function to list children
local function listChildren(path)
    -- Clear previous results
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local success, object = pcall(function()
        return path
    end)

    if success and object then
        for _, child in ipairs(object:GetChildren()) do
            local label = Instance.new("TextLabel")
            label.Parent = scrollingFrame
            label.Size = UDim2.new(1, 0, 0, 25)
            label.Text = child.Name
            label.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    else
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Parent = scrollingFrame
        errorLabel.Size = UDim2.new(1, 0, 0, 25)
        errorLabel.Text = "Invalid path!"
        errorLabel.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        errorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Button Click Event
button.MouseButton1Click:Connect(function()
    local pathString = textBox.Text
    local success, path = pcall(function()
        return loadstring("return " .. pathString)() -- Convert string to object
    end)

    if success and path then
        listChildren(path)
    else
        warn("Invalid path: " .. pathString)
    end
end)
