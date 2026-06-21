local h = gethui()
local s = Instance.new("ScreenGui", h)
local t = Instance.new("TextLabel", s)

t.Size = UDim2.new(0, 200, 0, 50)
t.Position = UDim2.new(0.5, -100, 0.5, -25)
t.BackgroundTransparency = 1
t.Text = "hi nubo"
t.TextColor3 = Color3.new(1, 1, 1)
t.TextSize = 30
t.Font = Enum.Font.SourceSansBold
