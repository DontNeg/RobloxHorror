local tool = script.Parent
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.Camera
local replicatedStorage = game.ReplicatedStorage
local runService = game:GetService("RunService")
local inputService = game:GetService("UserInputService")
local equipped = false
local viewModel
local modelName = "viewModelFlashLight"

tool.Equipped:Connect(function()
	equipped = true
	replicatedStorage:WaitForChild(modelName):Clone().Parent = camera
end)
tool.Unequipped:Connect(function()
	equipped = false
	viewModel = camera:WaitForChild(modelName)
	destroyLight()
	viewModel:Destroy()
end)
local camSway = CFrame.new()

function flashLightFunctionality(deltaTime)
	if humanoid.Health <= 0 then
		if not (camera:FindFirstChild(modelName)==nil) then
			destroyLight()
			camera:WaitForChild(modelName):Destroy()
		end
	end
	if equipped then
		if not (camera:FindFirstChild(modelName)==nil) then
			local mouseDelta = inputService:GetMouseDelta()/50
			local camSwayX = math.clamp(mouseDelta.X, -0.2, 0.2)
			local camSwayY = math.clamp(mouseDelta.Y, -0.2, 0.2)
			camera:WaitForChild(modelName):SetPrimaryPartCFrame(camera.CFrame)
			for i, v in pairs(camera:WaitForChild(modelName):GetChildren()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
			camSway = camSway:Lerp(CFrame.new(camSwayX, camSwayY, 0), deltaTime * 5)
			camera:WaitForChild(modelName):SetPrimaryPartCFrame(camera.CFrame * camSway)
		end
	end
end

function destroyLight()
	local meshPart = camera:WaitForChild(modelName):WaitForChild("Flashlight"):WaitForChild("MeshPart")
	if meshPart:FindFirstChild("SurfaceLight") then
		meshPart:WaitForChild("SurfaceLight").Parent = nil
	end
end

runService.RenderStepped:Connect(flashLightFunctionality)