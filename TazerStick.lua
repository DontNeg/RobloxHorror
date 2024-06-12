local InputService = game:GetService("UserInputService")
local tazerObject = script.Parent
local tazerSound = tazerObject:WaitForChild("Sound")
local active = false

InputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		active = not active
		if active then tazerSound:Play(); return end
		tazerSound:Stop()
	end
end)

