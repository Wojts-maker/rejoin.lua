--// SELF URL
local URL = "https://raw.githubusercontent.com/Wojts-maker/rejoin.lua/main/rejoin.lua"

--// WEBHOOK
local WEBHOOK = "https://discord.com/api/webhooks/1480872672970801255/_OnqO7-Z9uAThaf4MBh8pxN1LvnANeYsZlVFS7VpKIkbzMDrW2jiKEb6FAN4b0GIAq4O"

--// AUTO EXEC AFTER TELEPORT
if queue_on_teleport then
    queue_on_teleport('loadstring(game:HttpGet("'..URL..'?nocache='..math.random(1,9999)..'"))()')
end

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local REJOIN_TIME = 600
local timeLeft = REJOIN_TIME
local enabled = true
local joinTime = os.time()

--// WEBHOOK FUNCTION
local function send(msg)

    if WEBHOOK == "" then return end

    pcall(function()

        HttpService:PostAsync(
            WEBHOOK,
            HttpService:JSONEncode({content = msg}),
            Enum.HttpContentType.ApplicationJson
        )

    end)

end

send("Started "..player.Name)

--// ANTI AFK
player.Idled:Connect(function()

    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())

end)

--// GUI

local gui = Instance.new("ScreenGui")
gui.Name = "HubRejoin"
gui.ResetOnSpawn = false
pcall(function()
    gui.Parent = game.CoreGui
end)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,190)
frame.Position = UDim2.new(0,30,0,30)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0
frame.Parent = gui

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,32)
top.BackgroundColor3 = Color3.fromRGB(28,28,28)
top.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "Rejoin Hub"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = top

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1,-10,1,-80)
info.Position = UDim2.new(0,5,0,35)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1,1,1)
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextYAlignment = Enum.TextYAlignment.Top
info.Font = Enum.Font.Code
info.TextSize = 16
info.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1,-10,0,40)
toggle.Position = UDim2.new(0,5,1,-45)
toggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Text = "Enabled"
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 18
toggle.Parent = frame

--// DRAG

local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPos = frame.Position

    end

end)

top.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end

end)

UIS.InputChanged:Connect(function(input)

    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

    end

end)

--// TOGGLE

toggle.MouseButton1Click:Connect(function()

    enabled = not enabled

    toggle.Text = enabled and "Enabled" or "Disabled"

    send("Toggle "..tostring(enabled))

end)

--// LOOP

task.spawn(function()

    while true do

        local serverTime = os.time() - joinTime

        local status = enabled and "VALID" or "OFF"

        info.Text =
            "Status: "..status..
            "\nTime Left: "..timeLeft..
            "\nTime In Server: "..serverTime..
            "\nJobId: "..string.sub(game.JobId,1,10)

        task.wait(1)

        if enabled then
            timeLeft -= 1
        end

        if timeLeft <= 0 and enabled then

            info.Text = "Rejoining..."

            send(
                "Rejoin "..player.Name..
                "\nJobId "..game.JobId
            )

            task.wait(1)

            TeleportService:Teleport(game.PlaceId, player)

        end

    end

end)
