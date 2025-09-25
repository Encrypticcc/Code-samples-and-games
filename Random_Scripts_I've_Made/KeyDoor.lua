local key = script.Parent
local keyH = key:WaitForChild("Handle")
local door = key.Parent:WaitForChild("Door")
local ding = door:WaitForChild("Ding")
local touchInterest = keyH:WaitForChild("TouchInterest")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local reLock = true
local doorOpenTime = 5

local notifTime = 1

touchInterest.Changed:Connect(function()
	print("Key has been picked up")
	
	local char = key.Parent
	local player = Players:GetPlayerFromCharacter(char)
	local ancGui = player.PlayerGui:WaitForChild("AnnouncementGui")
	local ancFrame = ancGui:WaitForChild("Frame")
	
	local ancFrameStartPos = UDim2.new(0.5, 0 ,0, 0)
	local ancFrameStartSize = UDim2.new(0.051, 0 ,0.017, 0)
	
	local ancFrameEndPos = UDim2.new(0.5, 0, 0.05, 0)
	local ancFrameEndSize = UDim2.new(0.424, 0, 0.104, 0)
	
	ancFrame.Position = ancFrameStartPos
	ancFrame.Size = ancFrameStartSize
	
	ancGui.Enabled = true
	
	local GuiMoveTweenIn = TweenService:Create(ancFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = ancFrameEndPos, Size = ancFrameEndSize})
	local GuiMoveTweenOut = TweenService:Create(ancFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = ancFrameStartPos, Size = ancFrameStartSize})

	GuiMoveTweenIn:Play()
	
	local success, result = pcall(function()
		task.delay(notifTime, function()
			GuiMoveTweenOut:Play()

			GuiMoveTweenOut.Completed:Connect(function()
				ancGui.Enabled = false
			end)
		end)
	end)
end)

door.Touched:Connect(function(hit)
	if keyH == hit and key.Equipped then
		ding:Play()
		
		door.Transparency = 0.75
		door.CanCollide = false
		
		key:Destroy()
		
		if reLock then
			task.delay(doorOpenTime, function()
				door.Transparency = 0
				door.CanCollide = true
			end)
		end
	end
end)