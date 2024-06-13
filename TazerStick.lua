local InputService = game:GetService("UserInputService")
local tazerStick = script.Parent
local tazerSound = tazerStick:WaitForChild("Sound")
local active = false
local equipped = false

tazerStick.Equipped:Connect(function()
	equipped = true
end)
tazerStick.Unequipped:Connect(function()
	equipped = false
	active = false
	tazerSound:Stop()
end)

InputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and equipped then
		active = not active
		if active then tazerSound:Play(); return end
		tazerSound:Stop()
	end
end)

