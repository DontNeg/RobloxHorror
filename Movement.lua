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
local fovs = {60, 70, 80}
local movementKeys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
local moving = false
local jumping = false

function resetTimer()
	if stamina > 0 then
		timer = 0
	end
end

InputService.InputBegan:Connect(function(key)
	if stamina > 0 then
		if table.find(movementKeys, key.KeyCode) then  
			if _G.moveMode == "semiSprinting" then
				setWalkMode("sprinting")
			elseif _G.moveMode == "semiCrouching" then
				setWalkMode("crouching")
			end
		elseif key.KeyCode == Enum.KeyCode.LeftShift then
			if moving then
				setWalkMode("sprinting")
			else
				setWalkMode("semiSprinting")
			end
		elseif key.KeyCode == Enum.KeyCode.LeftControl then
			if moving then
				setWalkMode("crouching")
			else
				setWalkMode("semiCrouching")
			end
		end
	end
	if key.KeyCode == Enum.KeyCode.Space and stamina>=5 then
		stamina-=5
		timer = 0
	end
end)

InputService.InputEnded:Connect(function(key)
	if key.KeyCode == Enum.KeyCode.LeftShift or key.KeyCode == Enum.KeyCode.LeftControl then
		setWalkMode("walking")
	end
end)

RunService.PreAnimation:Connect(function(deltaTime)
	local changeValue = 10 * deltaTime * 5
	if _G.moveMode == "sprinting" then
		stamina = math.max(0, stamina - 1 * deltaTime)
		cam.FieldOfView = math.min(fovs[3], cam.FieldOfView + changeValue)
	elseif _G.moveMode == "crouching" then
		stamina = math.max(0, stamina - 0.5 * deltaTime)
		cam.FieldOfView = math.max(fovs[1], cam.FieldOfView - changeValue)
	elseif _G.moveMode == "walking" or string.find(_G.moveMode, "semi") ~= nil then
		if timer >= 3 then
			stamina = math.min(maxStamina, stamina + 2 * (deltaTime))
		end
		if cam.FieldOfView > fovs[2] then
			cam.FieldOfView = math.max(fovs[2], cam.FieldOfView - changeValue)
		else
			cam.FieldOfView = math.min(fovs[2], cam.FieldOfView + changeValue)
		end
	end
end)

RunService.Heartbeat:Connect(function(deltaTime)
	moving = (player.RootPart.Velocity * Vector3.new(1,0,1)).Magnitude >= 1
	jumping = (player.RootPart.Velocity * Vector3.new(0,1,0)).Magnitude >= 1
	if jumping then
		setWalkMode("jumping")
	elseif not jumping and _G.moveMode == "jumping" then
		setWalkMode("walking")
	end
	if stamina < 5 then
		player:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	else
		player:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	end
	if _G.moveMode == "sprinting" and not moving then
		setWalkMode("semiSprinting")
	elseif _G.moveMode == "crouching" and not moving then
		setWalkMode("semiCrouching")
	end
	if stamina <= 0 then
		setWalkMode("walking")
	end
	if _G.moveMode == "walking" or string.find(_G.moveMode, "semi") ~= nil then
		if stamina<maxStamina and timer<3 then
			timer = timer + (1*deltaTime)
		end
	end
	if stamina == maxStamina then
		timer = 0
	end
end)

function setWalkMode(value)
	if value == "sprinting" then
		resetTimer()
		player.WalkSpeed = moveSpeeds[3]
	elseif value == "walking" then
		player.WalkSpeed = moveSpeeds[2]
	elseif value == "crouching" then
		resetTimer()
		player.WalkSpeed = moveSpeeds[1]
	end
	_G.moveMode = value
end