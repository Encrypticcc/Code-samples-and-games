local player = game.Players.LocalPlayer
local ShopGUI = player.PlayerGui:WaitForChild("ShopGui")
local proximityPrompt = game.Workspace:WaitForChild("NPC"):WaitForChild("Torso"):WaitForChild("ProximityPrompt")

proximityPrompt.Triggered:Connect(function(plr)
	ShopGUI.Enabled = true
	print("Enabled")
end)
