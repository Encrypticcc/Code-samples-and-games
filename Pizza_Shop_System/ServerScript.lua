local givePizza = game.ReplicatedStorage:WaitForChild("GivePizza")
local pizza = game.ReplicatedStorage.Pizza

givePizza.OnServerEvent:Connect(function(player, buyCount, buyError)
	if not buyError then
		local leaderstats = player:WaitForChild("leaderstats")
		local pizzaValue = leaderstats:FindFirstChild("Pizza")

		local playerPizza = pizza:Clone()
		playerPizza.Parent = player.Backpack
		pizzaValue.Value = buyCount
		print(player.Name .. " succesfully bought a pizza!")
	else
		warn(player.Name .. " has not enough money!")
	end
end)