local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local plate = script.Parent
local activateSignalRemote = game.ReplicatedStorage.ActivateSignalRemote

local debounce = false

------Settings------
local Single_Tick = false --Controls wether the plate will be triggered once or continous until the plate is relased.
local Active_Time = -1 --Controls how long the plate will be activated for, Set to -1 to never revoke the activated status or set to -1 when not using the timed plate. 
local Tween_Time = 0.5 --Controls the tween time in between state transitions.
local Timed_Plate = false -- Controls if the plate will only be active for a set amount of time or by when the player releases the plate.

local starterPlatePos = plate.Position
local starterPlateColor = plate.Color

local tweenedPositon = starterPlatePos + Vector3.new(0, -1, 0)

local plateTweenDown = TweenService:Create(plate, TweenInfo.new(Tween_Time, Enum.EasingStyle.Back), {Position = tweenedPositon})
local plateTweenUp = TweenService:Create(plate, TweenInfo.new(Tween_Time, Enum.EasingStyle.Back), {Position = starterPlatePos})

local lastTick = 0
local touchingParts = {}

plate.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	
	if humanoid and debounce == false then
		local player = Players:GetPlayerFromCharacter(humanoid.Parent)
		if not player then return end

		local ancGui = player:WaitForChild("PlayerGui"):WaitForChild("AnnouncementGui")
		local ancText = ancGui:WaitForChild("Frame"):WaitForChild("TextLabel")
		ancText.Text = "Activated!"
		ancGui.Enabled = true

		debounce = true
		plate.Color = Color3.new(0.65, 0.65, 0)
		plateTweenDown:Play()
		lastTick = tick()

		activateSignalRemote:FireClient(player, Single_Tick, Active_Time)
		print("Plate activated!")
		if not Timed_Plate then
			local timer = task.delay(3, function()
				ancGui.Enabled = false
			end)
		end
		
		if Active_Time < 0 then
			-- no auto-reset
		elseif Timed_Plate == true then
			task.delay(Active_Time, function()
				debounce = false
				plate.Color = starterPlateColor
				plateTweenUp:Play()
				ancGui.Enabled = false
				print("Plate deactivated!")
			end)
		end
	end

	touchingParts[hit] = true
end)

plate.TouchEnded:Connect(function(hit)
	touchingParts[hit] = nil
end)

-- Fallback check every frame
RunService.Heartbeat:Connect(function(dt, humanoid)
	if debounce and Active_Time < 0 and next(touchingParts) == nil then
		if tick() - lastTick >= 0.1 then
			debounce = false
			plate.Color = starterPlateColor
			plateTweenUp:Play()
			print("Plate deactivated! (fallback)")
		end
	end
end)
