local InputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local tazerStick = script.Parent
local tazerSound = tazerStick:WaitForChild("Sound")
local camera = workspace.Camera
local tazerMeshPart = camera:WaitForChild("viewModelTazerStick"):WaitForChild("TazerStick"):WaitForChild("MeshPart")
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

tazerMeshPart.Touched:Connect(function(part)
	if CollectionService:HasTag(part,"Enemy") and part.Name ~= "HumanoidRootPart" or CollectionService:HasTag(part,"Enemy") and part.Name ~= "Humanoid" then
		part:Destroy()
	end
end)

