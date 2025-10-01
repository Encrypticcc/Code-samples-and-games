local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local npcModel = workspace:WaitForChild("NPC")
local torso = npcModel:WaitForChild("Torso")
local proximityPrompt = torso:WaitForChild("ProximityPrompt")

local player = game.Players.LocalPlayer
local dialogueGui = player:WaitForChild("PlayerGui"):WaitForChild("DialogueGui")
local container = dialogueGui:WaitForChild("Container")
local chatBoxFrame = container:WaitForChild("ChatBox")
local playerResponsesFrame = container:WaitForChild("PlayerResponses")
local gridLayout = playerResponsesFrame:WaitForChild("UIGridLayout")
local closeButton = chatBoxFrame:WaitForChild("CloseButton")
local nameText = chatBoxFrame:WaitForChild("NameText")
local NPCResponsesText = chatBoxFrame:WaitForChild("NPCResponses")
local placeholder = dialogueGui:WaitForChild("Placeholder")

local UIOpenSound = game.SoundService:WaitForChild("UIOpen")
local UICloseSound = game.SoundService:WaitForChild("UIClose")
local UIClickSound = game.SoundService:WaitForChild("UIClick")

nameText.Text = "NPC"

local NPCResponses = {
	"Hello!",
	"How are you doing?",
	"Hi!",
	"Well hello there, " .. player.Name .. "!",
	"Nice to see you.",
	"Welcome!",
	"Hey there!",
	"Good to meet you.",
	"How’s your day going?",
	"Greetings!",
	"Been busy lately?",
	"Glad you stopped by.",
	"Need any help?",
	"Lovely weather today, isn’t it?",
	"You look ready for an adventure!",
	"Take care out there.",
	"Be careful around here.",
	"It’s been quiet… too quiet.",
	"Always good to have company.",
	"Don’t wander too far.",
	"Safe travels!"
}

local playerResponses = {
	"What do I do?",
	"Bye!"
}

local startPos = UDim2.new(0, 0, 1.5, 0)
local endPos = UDim2.new(0, 0, 0, 0)

container.Position = startPos

local tweenInfo = TweenInfo.new(
	0.5,
	Enum.EasingStyle.Back,
	Enum.EasingDirection.Out
)

local tweenIn = TweenService:Create(container, tweenInfo, {Position = endPos})
local tweenOut = TweenService:Create(container, tweenInfo, {Position = startPos})

local dialogueRange = 15 -- studs
local checkingConnection

local function endDialogue()
	tweenOut:Play()
	UICloseSound:Play()
	proximityPrompt.Enabled = true
	if checkingConnection then
		checkingConnection:Disconnect()
		checkingConnection = nil
	end
end

local function responseHandler(response)
	print("NPC: " .. response)
	UIClickSound:Play()
	if response == "What do I do?" then
		NPCResponsesText.Text = "You can playtest my scripts, all of them are fully functional."
	elseif response == "Bye!" then
		NPCResponsesText.Text = "Bye, " .. player.Name .. "."
		task.delay(1, function()
			endDialogue()
		end)
	end
end

local function updateGrid(responses)
	-- Clear old clones (but keep the original placeholder template)
	for _, child in ipairs(playerResponsesFrame:GetChildren()) do
		if child:IsA("GuiObject") and child ~= placeholder then
			child:Destroy()
		end
	end

	local responsesCount = #responses

	if responsesCount <= 0 then 
		gridLayout.CellSize = UDim2.new(1, 0, 1, 0)
		return
	end

	gridLayout.CellSize = UDim2.new(1 / responsesCount, 0, 1, 0)

	-- Clone for each response
	for i, response in ipairs(responses) do
		local newButton = placeholder:Clone()
		newButton.Parent = playerResponsesFrame
		newButton.Visible = true
		newButton.TextButton.Text = response
		newButton.Name = "Response_" .. i

		newButton.TextButton.Activated:Connect(function()
			print("Player chose:", response)
			responseHandler(response)
		end)
	end
end

proximityPrompt.Triggered:Connect(function()
	proximityPrompt.Enabled = false
	UIOpenSound:Play()
	tweenIn:Play()
	updateGrid(playerResponses)
	local randomIndex = math.random(1, #NPCResponses)
	NPCResponsesText.Text = NPCResponses[randomIndex]
	
	if checkingConnection then
		checkingConnection:Disconnect()
	end

	checkingConnection = RunService.Heartbeat:Connect(function()
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local distance = (torso.Position - char.HumanoidRootPart.Position).Magnitude
			if distance > dialogueRange then
				endDialogue()
			end
		else
			endDialogue()
		end
	end)
end)

closeButton.Activated:Connect(function()
	endDialogue()
end)
