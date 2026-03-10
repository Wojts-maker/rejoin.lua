--// URL DO SAMEGO SIEBIE
local URL = "https://raw.githubusercontent.com/Wojts-maker/rejoin.lua/main/rejoin.lua"

--// WEBHOOK
local WEBHOOK = "https://discord.com/api/webhooks/1480872672970801255/_OnqO7-Z9uAThaf4MBh8pxN1LvnANeYsZlVFS7VpKIkbzMDrW2jiKEb6FAN4b0GIAq4O"

--// AUTOEXEC AFTER TELEPORT
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

--// webhook function
local function send(msg)

    if WEBHOOK == "" then return end

    pcall(function()

        HttpService:PostAsync(
            WEBHOOK,
            HttpService:JSONEncode({
                content = msg
            }),
            Enum.HttpContentType.ApplicationJson
        )

    end)

end

send("Script started: "..player.Name)

--// anti afk
player.Idled:Connect(function()

    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())

end)

--// GUI

local gui = Instance.new("ScreenGui")
gui.Name = "RejoinPro"
gui.ResetOnSpawn = false

pcall(function()
    gui.Parent = game.CoreGui
end)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,260,0,150)
frame.Position = UDim2.new(0,20,0,20)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,0.8,0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true
label.Font = Enum.Font.SourceSansBold
label.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1,0,0.2,0)
button.Position = UDim2.new(0,0,0.8,0)
button.Text = "ON"
button.BackgroundColor3 = Color3.fromRGB(30,30,30)
button.TextColor3 = Color3.new(1,1,1)
button.Parent = frame

--// DRAG

local dragging = false
local startPos
local startFramePos

frame.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        startPos = input.Position
        startFramePos = frame.Position

    end

end)

frame.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = false

    end

end)

UIS.InputChanged:Connect(function(input)

    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

        local delta = input.Position - startPos

        frame.Position = UDim2.new(
            startFramePos.X.Scale,
            startFramePos.X.Offset + delta.X,
            startFramePos.Y.Scale,
            startFramePos.Y.Offset + delta.Y
        )

    end

end)

--// toggle

button.MouseButton1Click:Connect(function()

    enabled = not enabled

    button.Text = enabled and "ON" or "OFF"

    send("Toggle: "..tostring(enabled))

end)

--// LOOP

task.spawn(function()

    while true do

        local serverTime = os.time() - joinTime

        label.Text =
            "Status: "..(enabled and "VALID" or "OFF")..
            "\nTime left: "..timeLeft..
            "\nTime in server: "..serverTime..
            "\nJobId: "..string.sub(game.JobId,1,8)

        task.wait(1)

        if enabled then
            timeLeft -= 1
        end

        if timeLeft <= 0 and enabled then

            label.Text = "REJOINING..."

            send(
                "Rejoin\nPlayer: "..player.Name..
                "\nJobId: "..game.JobId
            )

            task.wait(1)

            TeleportService:Teleport(game.PlaceId, player)

        end

    end

end)
