local textButton = script.Parent
local textStroke = textButton:WaitForChild("UIStroke")
local player = game.Players.LocalPlayer
local buySound = game.SoundService:WaitForChild("BuySound")
local errorSound = game.SoundService:WaitForChild("ErrorSound")
local GivePizza = game.ReplicatedStorage:WaitForChild("GivePizza")

local moneyGui = player.PlayerGui:WaitForChild("MoneyGui")
local moneyAmountDisplay = moneyGui:WaitForChild("Frame"):WaitForChild("MoneyAmount")

local buyCount = 0
local MAX_COUNT = 100
local PLAYER_MONEY = 0
local PIZZA_COST = 10
local PIZZAS_BOUGHT = 0

moneyAmountDisplay.Text = PLAYER_MONEY
textButton.Text = "$" .. PIZZA_COST

task.spawn(function()
	while task.wait(0.5) do
		PLAYER_MONEY += 1
		moneyAmountDisplay.Text = PLAYER_MONEY
	end
end)

textButton.MouseButton1Click:Connect(function()
	if buyCount ~= MAX_COUNT and PLAYER_MONEY >= PIZZA_COST then
		buySound:Play()
		buyCount += 1
		
		GivePizza:FireServer(buyCount)
		
		PLAYER_MONEY -= PIZZA_COST
		
		PIZZA_COST += math.random(-5, 10)
		
		textButton.Text = "$" .. PIZZA_COST
		
		if buyCount == MAX_COUNT then
			textButton.Text = "Sold Out!"
			textButton.TextColor3 = Color3.fromRGB(218, 0, 0)
			textStroke.Color = Color3.fromRGB(88, 0, 0)
		end
		moneyAmountDisplay.Text = PLAYER_MONEY
	else
		local buyError = true
		errorSound:Play()
		GivePizza:FireServer(buyCount, buyError)
		
		textButton.TextColor3 = Color3.fromRGB(255, 0, 4)
		textStroke.Color = Color3.fromRGB(88, 0, 0)
		task.delay(0.25, function()
			textButton.TextColor3 = Color3.fromRGB(4, 236, 0)
			textStroke.Color = Color3.fromRGB(16, 102, 1)
		end)
	end
end)