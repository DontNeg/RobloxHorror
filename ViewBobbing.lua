local runService = game:GetService("RunService")
local player = script.Parent:WaitForChild("Humanoid")

local function lerpCamera(pos, alpha)
	player.CameraOffset = player.CameraOffset:lerp(pos,alpha)
end

local function updateBobblesEffect()
	local bModifier = player.WalkSpeed / 2
	if (player.RootPart.Velocity * Vector3.new(1,0,1)).Magnitude >= 1 then
		local camX = 0.5 * math.cos(tick() * bModifier)
		local camY = 0.5 * math.abs(math.sin(tick() * bModifier)) 
		lerpCamera(Vector3.new(camX,camY,0),0.05)
	else
		lerpCamera(Vector3.new(0,0,0),0.05)
	end
end

runService.Heartbeat:Connect(updateBobblesEffect)
