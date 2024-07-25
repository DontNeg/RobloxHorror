local runService = game:GetService("RunService")

runService.Heartbeat:Connect(function(deltaTime)
	local changeRate = deltaTime / 20
	if game.Lighting.ClockTime == 0 then
		game.Lighting.ClockTime = 24 - changeRate
	else
		game.Lighting.ClockTime = game.Lighting.ClockTime - changeRate
	end
end)