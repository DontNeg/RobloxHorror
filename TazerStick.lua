local pathFindingService = game:GetService("PathfindingService")
local runService = game:GetService("RunService")
local enemy = script.Parent
local humanoid = enemy:WaitForChild("Humanoid")
local humanoidRootPart = enemy:WaitForChild("HumanoidRootPart")
local rayParams = RaycastParams.new()
local waypoints = workspace.Waypoints:GetChildren()
local lastPos
local animPlaying = false
local RANGE = 60
local DAMAGE = 30
local AFTERSIGHT = 5
local ATTACKDISTANCE = 5

humanoidRootPart:SetNetworkOwner(nil)
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances = {enemy}

local function checkJump(waypoint)
	if waypoint.Action == Enum.PathWaypointAction.Jump then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end
local function moveTo(destination)
	humanoid:MoveTo(destination)
	humanoid.MoveToFinished:Wait()
end

local function pathFinding(destination)
	local path = pathFindingService:CreatePath({AgentHeight = 5,AgentRadius = 3,AgentCanJump = true})
	path:ComputeAsync(humanoidRootPart.Position, destination.Position)
	if path.Status == Enum.PathStatus.Success then
		for _, waypoint in pairs(path:GetWaypoints()) do
			checkJump(waypoint)
			path.Blocked:Connect(function()
				path:Destroy()
			end)
			if animPlaying == false then
				--walkAnim:Play()
				animPlaying = true
			end
			--attackAnim:Stop()
			local players = game.Players:GetPlayers()
			local maxDistance = RANGE
			local nearestTarget
			local lastTarget
			for _, player in pairs(players) do
				local target = player.Character
				if target then
					local distance = (humanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
					local canSee = false
					local direction = (target.HumanoidRootPart.Position - humanoidRootPart.Position).Unit
					local ray = workspace:Raycast(humanoidRootPart.Position, direction * RANGE, rayParams)
					if ray and ray.Instance then
						if ray.Instance:IsDescendantOf(target) then
							canSee = true
						end
					end
					if distance < maxDistance then
						lastTarget = target
						if canSee then
							nearestTarget = target
							maxDistance = distance
						end
					end
				end
			end
			if nearestTarget and nearestTarget.Humanoid.Health > 0 then
				lastPos = nearestTarget.HumanoidRootPart.Position
				local distance = (humanoidRootPart.Position - nearestTarget.HumanoidRootPart.Position).Magnitude
				local canAttack = true
				if distance > ATTACKDISTANCE then
					checkJump(waypoint)
					humanoid:MoveTo(nearestTarget.HumanoidRootPart.Position)
				else
					if canAttack then
						canAttack = not canAttack
						--npc.Head.AttackSound:Play()
						--attackAnim:Play()
						nearestTarget.Humanoid.Health -= DAMAGE
						task.wait(0.5)
						canAttack = not canAttack
					end
				end
				break
			else
				if lastPos then
					checkJump(waypoint)
					moveTo(lastPos)
					local pathInside = pathFindingService:CreatePath({AgentHeight = 5,AgentRadius = 3,AgentCanJump = true})
					local count = 0
					pathInside:ComputeAsync(humanoidRootPart.Position, lastTarget.HumanoidRootPart.Position)
					for _, waypointInside in pairs(pathInside:GetWaypoints()) do
						count = count + 1
						if count == AFTERSIGHT then
							break
						end
						checkJump(waypointInside)
						moveTo(waypointInside.Position)
					end
					lastPos = nil
					break
				else
					moveTo(waypoint.Position)
				end
			end
		end
	else
		return
	end
end

while task.wait(0.2) do
	pathFinding(waypoints[math.random(#waypoints)])
end