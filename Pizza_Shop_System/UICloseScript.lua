local textButton = script.Parent

textButton.MouseButton1Click:Connect(function()
	textButton.Parent.Enabled = false
end)