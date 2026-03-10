-- === REJOIN + GUI + TIMER + ANTI-AFK ===
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local REJOIN_TIME = 600 -- 10 minut
local timeLeft = REJOIN_TIME

-- ===== ANTI AFK =====
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "RejoinGui"
gui.ResetOnSpawn = false
pcall(function()
    gui.Parent = game.CoreGui -- zawsze działa, nawet jeśli PlayerGui zablokowane
end)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,250,0,120)
frame.Position = UDim2.new(0,20,0,20)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 1
frame.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255,255,255)
label.TextScaled = true
label.TextWrapped = true
label.Font = Enum.Font.SourceSansBold
label.Parent = frame

-- ===== TIMER + REJOIN =====
task.spawn(function()
    while true do
        label.Text =
            "Status: VALID\n"..
            "Time left: "..timeLeft.."s\n"..
            "Rejoin interval: "..REJOIN_TIME.."s"

        task.wait(1)
        timeLeft -= 1

        if timeLeft <= 0 then
            label.Text = "Rejoining..."
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, player)
        end
    end
end)
