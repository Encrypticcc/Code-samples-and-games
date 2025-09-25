local jumpPad = script.Parent
local cam = game.Workspace.Camera
local FOV = game.ReplicatedStorage:WaitForChild("FOV")
local players = game:GetService("Players")

local debounce = false

------Settings------
local setJump = 75 --Controls how fast the players speed is after they stand on the speed pad.
local speedTime = 5 --Controls how long the speed will last for, Set to -1 to never revoke the speed.
local cameraEffects = true --Set to true to enable the effects.

jumpPad.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	
	if humanoid and debounce == false then
		local player = players:GetPlayerFromCharacter(humanoid.Parent)
		debounce = true
		humanoid.UseJumpPower = true
		humanoid.JumpPower = setJump
		jumpPad.Color = Color3.new(0.0196078, 0.32549, 0.490196)
		FOV:FireClient(player, speedTime, cameraEffects)
		print("JumpPower given!")
		if speedTime < 0 then
			return
		else
			task.wait(speedTime)
			humanoid.JumpPower = 50
			debounce = false
			jumpPad.Color = Color3.new(0.0352941, 0.537255, 0.811765)
			print("JumpPower revoked!")
		end
	end
end)