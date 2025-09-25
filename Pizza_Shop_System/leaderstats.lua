game.Players.PlayerAdded:Connect(function(player)

	local leaderstats = Instance.new("Folder") 
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local pizzaValue = Instance.new("IntValue")
	pizzaValue.Name = "Pizza"
	pizzaValue.Value = 0
	pizzaValue.Parent = leaderstats
end)