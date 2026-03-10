repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local REJOIN_TIME = 600

local timeLeft = REJOIN_TIME
local running = true

-- anti afk
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RejoinGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,200,0,100)
frame.Position = UDim2.new(0,10,0,10)
frame.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.TextScaled = true
label.Parent = frame

-- timer loop
task.spawn(function()
    while running do
        label.Text =
            "Status: VALID\n" ..
            "Time left: "..timeLeft.."s\n" ..
            "Rejoin: "..REJOIN_TIME.."s"

        task.wait(1)
        timeLeft -= 1

        if timeLeft <= 0 then
            label.Text = "Rejoining..."
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, player)
        end
    end
end)
