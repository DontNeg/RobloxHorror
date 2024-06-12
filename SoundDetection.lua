local main = script.parent
local Detection=game.Workspace.Detection
local player = script.Parent
local body = player:WaitForChild("Humanoid")
local character = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local obj = Instance.new("Part")
local objSize = Vector3.new(25,25,25)
local jumpModified = false

obj.Name = "Detection"
obj.CanCollide = false
obj.Anchored = true
obj.Shape = "Ball"
obj.Material = "SmoothPlastic"
obj:AddTag("SoundTrigger")
obj.Parent = player

function setPos()
	local pos = character.Character.HumanoidRootPart.Position
	local jumping = (body.RootPart.Velocity * Vector3.new(0,1,0)).Magnitude > 1
	local moving = (body.RootPart.Velocity * Vector3.new(1,0,1)).Magnitude >= 1
	obj.Position = Vector3.new(pos.X,pos.Y+30,pos.Z) 
	if _G.moveMode == "sprinting" then
		if jumping then
			obj.Size = objSize * 2.25
			return
		end
		obj.Size = objSize * 1.5
	elseif _G.moveMode == "walking" or _G.moveMode == "semiCrouching" or _G.moveMode == "semiSprinting" then
		if jumping then
			obj.Size = objSize * 1.5
			return
		end
		obj.Size = objSize
	elseif _G.moveMode == "crouching" then
		if jumping then
			obj.Size = objSize
			return
		end
		obj.Size = objSize / 1.5
	end
end

runService.Heartbeat:Connect(setPos) 