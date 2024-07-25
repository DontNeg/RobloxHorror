local image = script.Parent
image.Image = "rbxassetid://18212891493"
game:GetService("RunService").Heartbeat:Connect(function()
	image.TileSize = UDim2.new(math.random(800, 1000) / 1000, 0, math.random(800, 1000) / 1000, 0)
end)