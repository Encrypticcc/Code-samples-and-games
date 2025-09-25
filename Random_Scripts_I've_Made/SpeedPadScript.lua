local speedPad = script.Parent
local cam = game.Workspace.Camera
local FOV = game.ReplicatedStorage:WaitForChild("FOV")
local players = game:GetService("Players")

local debounce = false

------Settings------
local setSpeed = 50 --Controls how fast the players speed is after they stand on the speed pad.
local speedTime = 5 --Controls how long the speed will last for, Set to -1 to never revoke the speed.
local cameraEffects = true --Set to true to enable the effects.

speedPad.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	
	if humanoid and debounce == false then
		local player = players:GetPlayerFromCharacter(humanoid.Parent)
		debounce = true
		humanoid.WalkSpeed = setSpeed
		speedPad.Color = Color3.new(0.4, 0.141176, 0.141176)
		FOV:FireClient(player, speedTime, cameraEffects)
		print("WalkSpeed given!")
		if speedTime < 0 then
			return
		else
			task.wait(speedTime)
			humanoid.WalkSpeed = 16
			debounce = false
			speedPad.Color = Color3.new(1, 0.34902, 0.34902)
			print("WalkSpeed revoked!")
		end
	end
end)