local runService = game:GetService("RunService")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage").FlashLight
local remoteEventInput = replicatedStorage.FlashLightInput
local remoteEventCFrame = replicatedStorage.FlashLightCFrame
local remoteEventEquipped = replicatedStorage.FlashLightEquipped
local sound = replicatedStorage.flashLightSound
local ultraViolet = Color3.new(0.282353, 0, 0.65098)
local yellow = Color3.new(1, 0.941176, 0.286275)
ultraViolet = Color3.new(0.333333, 1, 0)
local active = false
local ultraVioletActive = false
local playing = false
local part = replicatedStorage.flashLightPart:Clone()
local spotLight = part.SpotLight
local equipped = false

function flashLightSound(player, play)
	remoteEventInput:FireClient(player, play)
	if play then
		playing = true
		wait(sound.TimeLength)
		playing = false
	else
		playing = false
	end
end

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		part.Name = "flashLightServer"
		part.Parent = character
		spotLight.Parent = part
	end)
end)

remoteEventEquipped.OnServerEvent:Connect(function(player)
	equipped = not equipped
	if not equipped and active then
		flashLightSound(player, false)
		flashLightSound(player, true)
		spotLight.Enabled = false
		active = false
	end
end)

remoteEventCFrame.OnServerEvent:Connect(function(player, mainCFrame)
	local character = player.Character or player.CharacterAdded:Wait()
	player.Character.flashLightServer.CFrame = mainCFrame
end)

remoteEventInput.OnServerEvent:Connect(function(player, input)
	if equipped then
		if not playing then
			if input[2] == Enum.UserInputType.MouseButton1 then
				active = not active
				flashLightSound(player, true)
				spotLight.Enabled = active
			elseif input[1] == Enum.KeyCode.E and active then
				ultraVioletActive = not ultraVioletActive
				flashLightSound(player, true)
				spotLight.Color = ultraVioletActive and ultraViolet or yellow
				spotLight.Brightness = ultraVioletActive and 6 or 3
			end
		end
	end
end)