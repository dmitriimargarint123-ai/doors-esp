local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "LocalMusicPlayer"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local sound = Instance.new("Sound")
sound.Name = "MyLocalMusic"
sound.SoundId = "rbxassetid://96414211708215"
sound.Volume = 1
sound.Looped = true
sound.Parent = SoundService

local function makeButton(parent, text, pos, size, color)
    local b = Instance.new("TextButton")
    b.Parent = parent
    b.Text = text
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 205)
frame.Position = UDim2.new(0.5, -150, 0.5, -102)
frame.BackgroundColor3 = Color3.fromRGB(22, 24, 40)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = makeButton(
    frame, "Мой музыкальный плеер",
    UDim2.fromOffset(8, 5), UDim2.new(1, -48, 0, 32),
    Color3.fromRGB(45, 43, 75)
)
title.Active = true

local close = makeButton(
    frame, "X", UDim2.new(1, -36, 0, 5),
    UDim2.fromOffset(28, 32), Color3.fromRGB(180, 45, 65)
)

local idBox = Instance.new("TextBox", frame)
idBox.Position = UDim2.fromOffset(12, 45)
idBox.Size = UDim2.new(1, -24, 0, 34)
idBox.Text = "96414211708215"
idBox.PlaceholderText = "ID музыки"
idBox.TextScaled = true
idBox.ClearTextOnFocus = false
idBox.BackgroundColor3 = Color3.fromRGB(38, 42, 62)
idBox.TextColor3 = Color3.new(1,1,1)

local play = makeButton(
    frame, "▶ ИГРАТЬ", UDim2.fromOffset(12, 88),
    UDim2.new(1, -24, 0, 38), Color3.fromRGB(20, 160, 90)
)

local stop = makeButton(
    frame, "■ ОСТАНОВИТЬ", UDim2.fromOffset(12, 133),
    UDim2.new(1, -24, 0, 38), Color3.fromRGB(190, 40, 60)
)

local open = makeButton(
    gui, "♫ ОТКРЫТЬ ПЛЕЕР",
    UDim2.fromOffset(20, 150),
    UDim2.fromOffset(180, 42),
    Color3.fromRGB(85, 55, 180)
)
open.Visible = false

play.MouseButton1Click:Connect(function()
    local id = idBox.Text:match("%d+")
    if not id then return end
    sound:Stop()
    sound.SoundId = "rbxassetid://" .. id
    sound:Play()
end)

stop.MouseButton1Click:Connect(function()
    sound:Stop()
end)

close.MouseButton1Click:Connect(function()
    frame.Visible = false
    open.Visible = true
end)

open.MouseButton1Click:Connect(function()
    frame.Visible = true
    open.Visible = false
end)

local function draggable(obj)
    local dragging = false
    local dragStart, startPos

    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

draggable(frame)
draggable(title)
draggable(open)
