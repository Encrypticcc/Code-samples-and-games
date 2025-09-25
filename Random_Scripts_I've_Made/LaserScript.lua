local laser = script.Parent
local pointA = laser.Parent.PointA
local pointB = laser.Parent.PointB
local laserHitSound = laser.LaserHit

local TweenService = game:GetService("TweenService")

local laserDamage = 100
local laserSpeed = 20

local laserSpeedTime = laserSpeed / 10
local tweenInfo = TweenInfo.new(laserSpeedTime, Enum.EasingStyle.Quad)

local goal = {
	Position = pointA.Position
}

local P1Tween = TweenService:Create(laser, tweenInfo, goal)



local tweenInfo2 = TweenInfo.new(laserSpeedTime, Enum.EasingStyle.Quad)

local goal2 = {
	Position = pointB.Position
}

local P2Tween = TweenService:Create(laser, tweenInfo2, goal2)

P1Tween:Play()

P1Tween.Completed:Connect(function()
	P2Tween:Play()
end)

P2Tween.Completed:Connect(function()
	P1Tween:Play()
end)

laser.Touched:Connect(function(otherPart)
	local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
	if humanoid then
		print(humanoid.Parent.Name .. " has touched laser")
		laser.CanTouch = false
		
		laserHitSound:Play()
		humanoid.Health = humanoid.Health - laserDamage
		laser.Transparency = 0.8
		laser.CanCollide = false
		task.wait(2)
		laser.Transparency = 0
		laser.CanCollide = true
		laser.CanTouch = true
	end
end)