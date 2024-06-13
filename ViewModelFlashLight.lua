local tool = script.Parent
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.Camera
local runService = game:GetService("RunService")
local inputService = game:GetService("UserInputService")
local equipped = false
local viewModel

tool.Equipped:Connect(function()
	equipped = true
		game.ReplicatedStorage:WaitForChild("viewModelFlashLight"):Clone().Parent = camera
end)
tool.Unequipped:Connect(function()
	equipped = false
	viewModel = camera:WaitForChild("viewModelFlashLight")
	destroyLight()
	viewModel:Destroy()
end)
local camSway = CFrame.new()
runService.RenderStepped:Connect(function(deltaTime)
	if humanoid.Health <= 0 then
		if not (camera:FindFirstChild("viewModelFlashLight")==nil) then
			destroyLight()
			camera:WaitForChild("viewModelFlashLight"):Destroy()
		end
	end
	if equipped then
		if not (camera:FindFirstChild("viewModelFlashLight")==nil) then
			local mouseDelta = inputService:GetMouseDelta()/50
			local camSwayX = math.clamp(mouseDelta.X, -0.2, 0.2)
			local camSwayY = math.clamp(mouseDelta.Y, -0.2, 0.2)
			camera:WaitForChild("viewModelFlashLight"):SetPrimaryPartCFrame(camera.CFrame)
			for i, v in pairs(camera:WaitForChild("viewModelFlashLight"):GetChildren()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
			camSway = camSway:Lerp(CFrame.new(camSwayX, camSwayY, 0), deltaTime * 5)
			camera:WaitForChild("viewModelFlashLight"):SetPrimaryPartCFrame(camera.CFrame * camSway)
		end
	end
end)

function destroyLight()
	if camera:WaitForChild("viewModelFlashLight"):WaitForChild("Flashlight"):WaitForChild("MeshPart"):FindFirstChild("SurfaceLight") then
		camera:WaitForChild("viewModelFlashLight"):WaitForChild("Flashlight"):WaitForChild("MeshPart"):WaitForChild("SurfaceLight").Parent = nil
	end
end