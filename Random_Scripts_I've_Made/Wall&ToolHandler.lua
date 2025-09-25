local pickaxe = script.Parent
local brickWall = workspace:WaitForChild("BrickWall")
local hpBar = brickWall.BillboardGui.HPbar
local toolHitbox = pickaxe:WaitForChild("Hitbox")
local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local s1 = Handle:WaitForChild("Smash1")
local s2 = Handle:WaitForChild("Smash2")
local whoosh = Handle:WaitForChild("Whoosh")

local broken = false
local wallHp = 100
local pickaxeDamage = 20
local cooldown = false

local function damageWall()
	if broken then return end

	wallHp -= pickaxeDamage
	hpBar.Size = UDim2.new(wallHp / 100, 0, 1, 0)
	print("Wall hit! HP:", wallHp)

	if wallHp <= 0 then
		print("Wall Destroyed!")
		broken = true
		brickWall.Transparency = 1
		brickWall.CanCollide = false
		brickWall.CanTouch = false

		task.delay(5, function()
			print("Wall regenerated!")
			wallHp = 100
			hpBar.Size = UDim2.new(1, 0, 1, 0)
			broken = false
			brickWall.Transparency = 0
			brickWall.CanCollide = true
			brickWall.CanTouch = true
		end)
	end
end

pickaxe.Activated:Connect(function()
	whoosh:Play()
	if cooldown or broken then return end
	cooldown = true

	local regionCFrame = toolHitbox.CFrame
	local regionSize = toolHitbox.Size
	local partsHit = workspace:GetPartBoundsInBox(regionCFrame, regionSize)

	for _, part in pairs(partsHit) do
		if part == brickWall then
			damageWall()
			if math.random(1,2) == 1 then s1:Play() else s2:Play() end
			break
		end
	end

	task.delay(0.3, function()
		cooldown = false
	end)
end)
