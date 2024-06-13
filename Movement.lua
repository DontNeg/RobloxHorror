_G.moveMode = "walking"
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ActionService = game:GetService("ContextActionService")
local player = script.Parent:WaitForChild("Humanoid")
local cam = workspace.CurrentCamera
local maxStamina = 30
local stamina = maxStamina
local timer = 0
local timerGoal = 3
local moveSpeeds = {8 ,12, 18}
local fovs = {70, 80}


function resetTimer()
	if stamina > 0 then
		timer = 0
	end
end

InputService.InputBegan:Connect(function(key)
	local movementKey = 
			key.KeyCode == Enum.KeyCode.W 
		or 	key.KeyCode == Enum.KeyCode.A 
		or 	key.KeyCode == Enum.KeyCode.S 
		or 	key.KeyCode == Enum.KeyCode.D
	local moving = (player.RootPart.Velocity * Vector3.new(1,0,1)).Magnitude >= 1
	if movementKey then
		if _G.moveMode == "semiSprinting" then
			resetTimer()
			setWalkMode("sprinting")
		elseif _G.moveMode == "semiCrouching" then
			resetTimer()
			setWalkMode("crouching")
		end
	elseif key.KeyCode == Enum.KeyCode.LeftShift then
		if moving then
			resetTimer()
			setWalkMode("sprinting")
		else
			setWalkMode("semiSprinting")
		end
	elseif key.KeyCode == Enum.KeyCode.LeftControl then
		if moving then
			resetTimer()
			setWalkMode("crouching")
		else
			setWalkMode("semiCrouching")
		end
	elseif key.KeyCode == Enum.KeyCode.Space and stamina>=5 then
		stamina-=5
		timer = 0
	end
end)

InputService.InputEnded:Connect(function(key)
	local movementKey = 
			key.KeyCode == Enum.KeyCode.W 
		or 	key.KeyCode == Enum.KeyCode.A 
		or 	key.KeyCode == Enum.KeyCode.S 
		or 	key.KeyCode == Enum.KeyCode.D
	if key.KeyCode == Enum.KeyCode.LeftShift or key.KeyCode == Enum.KeyCode.LeftControl then
		setWalkMode("walking")
	end
end)

RunService.Heartbeat:Connect(function(deltaTime)
	if (player.RootPart.Velocity * Vector3.new(0,1,0)).Magnitude >= 1 then
		setWalkMode("jumping")
	elseif (player.RootPart.Velocity * Vector3.new(0,1,0)).Magnitude < 1 and not (_G.moveMode == "crouching") and not (_G.moveMode == "semiCrouching") and not (_G.moveMode == "sprinting") and not (_G.moveMode == "semiSprinting")  then
		setWalkMode("walking")
	end
	if stamina < 5 then
		player:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	else
		player:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	end
	local moving = (player.RootPart.Velocity * Vector3.new(1,0,1)).Magnitude >= 1
	if _G.moveMode == "sprinting" and not moving then
		setWalkMode("semiSprinting")
	elseif _G.moveMode == "crouching" and not moving then
		setWalkMode("semiCrouching")
	end
	if stamina <= 0 then
		setWalkMode("walking")
	end
	local velocity = player.RootPart.Velocity
	local changeValue = 10 * deltaTime * 5
	if (_G.moveMode == "sprinting") or (_G.moveMode == "crouching") then
		stamina = math.max(0, stamina - 1 * deltaTime)
		if cam.FieldOfView<fovs[2] then
			cam.FieldOfView = cam.FieldOfView + changeValue
		end
	elseif (not (_G.moveMode == "sprinting") and not (_G.moveMode == "crouching")) and not (_G.moveMode == "jumpingw") or stamina<=0 then
		if cam.FieldOfView>fovs[1] then
			cam.FieldOfView = cam.FieldOfView - changeValue
		end
		if stamina<maxStamina and timer<3 then
			timer = timer + (1*deltaTime)
		end
		if timer >= timerGoal then
			stamina = math.min(maxStamina, stamina + 2 * (deltaTime))
			if stamina == maxStamina then
				timer = 0
			end
		end
	end
end)

function setWalkMode(value)
 	if value == "sprinting" then
		player.WalkSpeed = moveSpeeds[3]
	elseif value == "walking" then
		player.WalkSpeed = moveSpeeds[2]
	elseif value == "crouching" then
		player.WalkSpeed = moveSpeeds[1]
	end
	_G.moveMode = value
end