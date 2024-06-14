local runService = game:GetService('RunService')
local pathfindingService = game:GetService('PathfindingService')
local humanoid = script.Parent.Humanoid
local rootPart = script.Parent.HumanoidRootPart
local Animator = humanoid.Animator

local function getDestination()
	local destination
	for _, v in pairs(workspace:GetChildren()) do
		if v.ClassName == "Part" then
			if destination ~= nil then
				if math.abs((v.Position - rootPart.Position).Magnitude) < math.abs((destination - rootPart.Position).Magnitude) then
					destination = v.Position
				end
			else
				destination = v.Position
			end
		end
	end
	return destination
end

local function pathFinding()
	local path = pathfindingService:CreatePath()
	path:ComputeAsync(rootPart.Position, getDestination())
	local waypoints = path:GetWaypoints()
	for _, v in pairs(waypoints) do
		local players = game.Players:GetPlayers()
		local MaxDistance = humanoid:GetAttribute("maxdistance")
		local target
		for _, v in pairs(players) do
			if (v.Character) then
				local targetInside = v.Character
				local distance = (rootPart.Position - targetInside.HumanoidRootPart.Position).Magnitude
				if (distance < MaxDistance) then
					target = targetInside
					MaxDistance = distance
				end
			end
		end
		if target then
			local distance = (rootPart.Position - target.HumanoidRootPart.Position).Magnitude
			humanoid:MoveTo(target.HumanoidRootPart.Position)
			break
		end
		humanoid:MoveTo(v.Position)
		humanoid.MoveToFinished:Wait()
	end
end

runService.PreAnimation:Connect(pathFinding)