local flashLight = script.Parent
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local flashLightModel = flashLight:WaitForChild("Flashlight")
local meshPart = flashLightModel:WaitForChild("MeshPart")
local lightObject = meshPart:WaitForChild("SurfaceLight")
local clickSound = flashLight:WaitForChild("Sound")
local originalParent = lightObject.Parent
local ultraViolet = Color3.new(0.282353, 0, 0.65098)
local yellow = Color3.new(1, 0.941176, 0.286275)
local playing = false
local active = false
local ultraVioletActive = false

lightObject.Parent = nil
InputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not playing then
		active = not active
		playing = true
		clickSound:Play()
		wait(clickSound.TimeLength)
		clickSound:Stop()
		playing = false
		lightObject.Parent = active and originalParent or nil
	elseif input.KeyCode == Enum.KeyCode.E and active then
		playing = true
		clickSound:Play()
		wait(clickSound.TimeLength)
		clickSound:Stop()
		playing = false
		ultraVioletActive = not ultraVioletActive
		lightObject.Color = ultraVioletActive and ultraViolet or yellow
	end
end)


