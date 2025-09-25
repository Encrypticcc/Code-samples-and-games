local lever = script.Parent
local clickDetect = lever.ClickDetector
local door = lever.Parent.Parent.Door
local billboardGUI = door.BillboardGui
local timerDisplay = billboardGUI.TimerDisplay
local dingSound = door.Ding
local stopSound = door.Stop

local TweenService = game:GetService("TweenService")

leverTween = TweenService:Create(lever, TweenInfo.new(1), {Position = lever.Position + Vector3.new(0, -1.8, 0), Color = Color3.new(0.0980392, 1, 0.129412)})
leverTween2 = TweenService:Create(lever, TweenInfo.new(1), {Position = lever.Position, Color = Color3.new(1, 0, 0)})

local timerOn = false
local on = false
local cancelCountdown = false

clickDetect.MouseClick:Connect(function()
	if not on and not timerOn then
		on = true
		cancelCountdown = false
		dingSound:Play()
		billboardGUI.Enabled = true
		door.Transparency = 1
		door.CanCollide = false
		leverTween:Play()
		timerOn = true

		for i = 5, 1, -1 do
			if cancelCountdown then
				break
			end
			timerDisplay.Text = tostring(i)
			task.wait(1)
		end

		if not cancelCountdown then
			billboardGUI.Enabled = false
			on = false
			stopSound:Play()
			door.Transparency = 0
			door.CanCollide = true
			leverTween2:Play()
			timerOn = false
		end

	elseif on then
		cancelCountdown = true
		on = false
		stopSound:Play()
		billboardGUI.Enabled = false
		door.Transparency = 0
		door.CanCollide = true
		leverTween2:Play()
	end
end)
