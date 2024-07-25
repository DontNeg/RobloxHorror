local runService = game:GetService("RunService")
local image = script.Parent
local enemy = workspace:WaitForChild("enemy")
local enemyRootPart = enemy:WaitForChild("HumanoidRootPart")
local player = game.Players.LocalPlayer
local playerRootPart = player.Character:WaitForChild("HumanoidRootPart")

runService.Heartbeat:Connect(function(deltaTime)
	image.ImageTransparency = math.clamp(0.87 + ((enemyRootPart.Position - playerRootPart.Position).Magnitude - 10) / 300, 0.80, 0.98)
end)
