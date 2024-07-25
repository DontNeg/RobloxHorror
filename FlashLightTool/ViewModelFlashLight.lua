local tool = script.Parent
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera
local replicatedStorage = game.ReplicatedStorage.FlashLight
local runService = game:GetService("RunService")
local inputService = game:GetService("UserInputService")
local sound = replicatedStorage.flashLightSound
local equipped = false
local viewModel
local ultraViolet = Color3.new(0.282353, 0, 0.65098)
local yellow = Color3.new(1, 0.941176, 0.286275)
local active = false
local ultraVioletActive = false
local modelName = "viewModelFlashLight"

tool.Equipped:Connect(function()
	player.Character.flashLightServer.SpotLight.Enabled = false
	equipped = true
	replicatedStorage:WaitForChild(modelName):Clone().Parent = camera
end)
tool.Unequipped:Connect(function()
	equipped = false
	viewModel = camera:WaitForChild(modelName)
	active = false
	viewModel:Destroy()
end)

inputService.InputBegan:Connect(function(input)
	if camera:FindFirstChild(modelName) then
		local meshPart = camera:WaitForChild(modelName):WaitForChild("Flashlight"):WaitForChild("MeshPart")
		local spotLight = meshPart.SpotLight
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			wait(sound.TimeLength)
			active = not active
			spotLight.Enabled = active
		elseif input.KeyCode == Enum.KeyCode.E and active then
			wait(sound.TimeLength)
			ultraVioletActive = not ultraVioletActive
			if ultraVioletActive then
				spotLight.Color = ultraViolet
				spotLight.Brightness = 6
			else
				spotLight.Color = yellow
				spotLight.Brightness = 3
			end
		end
	end
end)

function flashLightFunctionality(deltaTime)
	local camSway = CFrame.new()
	if equipped then
		if camera:FindFirstChild(modelName) then
			local mouseDelta = inputService:GetMouseDelta()/50
			local camSwayX = math.clamp(mouseDelta.X, -0.2, 0.2)
			local camSwayY = math.clamp(mouseDelta.Y, -0.2, 0.2)
			camSway = camSway:Lerp(CFrame.new(camSwayX, camSwayY, 0), deltaTime * 5)
			camera:WaitForChild(modelName):SetPrimaryPartCFrame(camera.CFrame * camSway)
		end
	end
end

runService.RenderStepped:Connect(function(deltaTime)
	flashLightFunctionality(deltaTime)
	--if character:FindFirstChild("flashLightServer") then
	--	character.flashLightServer.SpotLight.Enabled = false
	--end
end)