local camera = workspace.CurrentCamera
local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage").FlashLight
local runService = game:GetService("RunService")
local remoteEventInput = replicatedStorage.FlashLightInput
local remoteEventCFrame = replicatedStorage.FlashLightCFrame
local remoteEventEquipped = replicatedStorage.FlashLightEquipped
local InputService = game:GetService("UserInputService")
local clickSound = replicatedStorage.flashLightSound
local equipped = false

script.Parent.Unequipped:Connect(function()
	remoteEventEquipped:FireServer()
	equipped = false
end)

script.Parent.Equipped:Connect(function()
	remoteEventEquipped:FireServer()
	equipped = true
end)

runService.Heartbeat:Connect(function()
	local character = player.Character or player.CharacterAdded:Wait()
	if character.Humanoid.Health > 0 and equipped then
		remoteEventCFrame:FireServer(camera.viewModelFlashLight.Flashlight.MeshPart.CFrame)
	end
end)

InputService.InputBegan:Connect(function(input)
	if equipped then
		remoteEventInput:FireServer({input.KeyCode,input.UserInputType})
	end
end)

remoteEventInput.OnClientEvent:Connect(function(play)
	if play then
		clickSound:Play()
	else
		clickSound:Stop()
	end
end)