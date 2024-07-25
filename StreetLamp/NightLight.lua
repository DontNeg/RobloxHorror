local glass = script.Parent
local lightObject = glass:WaitForChild("PointLight")
local runService = game:GetService("RunService")
local onColor = Color3.new(0.705882, 0.654902, 0.0705882)
local offColor = Color3.new(1, 1, 1)

glass.Color = onColor
runService.Heartbeat:Connect(function()
	if (game.Lighting.ClockTime>=18 or game.Lighting.ClockTime<=6) then
		lightObject.Enabled = true
		glass.Color = onColor
		glass.Transparency = 0.75
	else
		lightObject.Enabled = false
		glass.Color = offColor
		glass.Transparency = 0.90
	end
end)