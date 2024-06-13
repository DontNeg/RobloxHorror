local flashLight = script.Parent
local camera = workspace:WaitForChild("Camera")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local handle = flashLight:WaitForChild("Handle")
local lightObject = handle:WaitForChild("SurfaceLight")
local clickSound = flashLight:WaitForChild("Sound")
local ultraViolet = Color3.new(0.282353, 0, 0.65098)
local yellow = Color3.new(1, 0.941176, 0.286275)
local playing = false
local active = false
local ultraVioletActive = false
local equipped = false

lightObject.Parent = nil
flashLight.Equipped:Connect(function()
	equipped = true
	lightObject.Brightness = 5
end)
flashLight.Unequipped:Connect(function()
	equipped = false
	active = false
	lightObject.Brightness = 0
end)

InputService.InputBegan:Connect(function(input)
	if equipped then
		if input.UserInputType == Enum.UserInputType.MouseButton1 and not playing then
			active = not active
			playing = true
			clickSound:Play()
			wait(clickSound.TimeLength)
			clickSound:Stop()
			playing = false
			lightObject.Parent = active and camera:WaitForChild("viewModelFlashLight"):WaitForChild("Flashlight"):WaitForChild("MeshPart") or nil
		elseif input.KeyCode == Enum.KeyCode.E and active and not playing then
			playing = true
			clickSound:Play()
			wait(clickSound.TimeLength)
			clickSound:Stop()
			playing = false
			ultraVioletActive = not ultraVioletActive
			lightObject.Color = ultraVioletActive and ultraViolet or yellow
		end
	end
end)