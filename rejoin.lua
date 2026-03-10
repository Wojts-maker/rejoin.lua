repeat task.wait() until game:IsLoaded()

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local REJOIN_TIME = 600

player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

while true do
    task.wait(REJOIN_TIME)
    TeleportService:Teleport(game.PlaceId, player)
end
