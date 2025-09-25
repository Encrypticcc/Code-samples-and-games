local TweenService = game:GetService("TweenService")

local FOV = game.ReplicatedStorage:WaitForChild("FOV")

local speedSound = game.SoundService:WaitForChild("SpeedSound")

FOV.OnClientEvent:Connect(function(speedTime, cameraEffects)
	local camera = game.Workspace.Camera
	
	if cameraEffects then
		local FOVIn = TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {FieldOfView = 120})
		FOVIn:Play()
	end
	
	speedSound:Play()
	task.wait(speedTime)
	
	if cameraEffects then
		local FOVOut = TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {FieldOfView = 70})
		FOVOut:Play()
	end
end)