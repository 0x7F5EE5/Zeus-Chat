local Players = game:GetService("Players")
local player = Players.LocalPlayer
local debug = true
function log(message) if debug then print(message) end end

game.ReplicatedStorage.is_sudoer:FireServer()

game.ReplicatedStorage.is_sudoer.OnClientEvent:Connect(function(sudoer)
	if sudoer == "yes" then
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "zc has been initilized, you are admin. enjoy your stay.";
			Color = Color3.fromRGB(255, 28, 236);
			Font = Enum.Font.SourceSansBold;
			FontSize = Enum.FontSize.Size18;
		})
	end
	if sudoer == "new sudoer" then
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "your status has been temporarily updated to admin";
			Color = Color3.fromRGB(255, 28, 236);
			Font = Enum.Font.SourceSansBold;
			FontSize = Enum.FontSize.Size18;
		})
	end
	if sudoer == "get fucked" then
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "your temporary status as admin has been revoked";
			Color = Color3.fromRGB(255, 28, 236);
			Font = Enum.Font.SourceSansBold;
			FontSize = Enum.FontSize.Size18;
		})
	end
end)


local function onMessageReceived(message)
	game.ReplicatedStorage.recive_on_server:FireServer(message)
end

local playerGui = player:WaitForChild("PlayerGui")
local chat = playerGui:WaitForChild("Chat")

chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local chatBar = chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar
		local message = chatBar.Text
		onMessageReceived(message)
		chatBar.Text = ""
	end
end)

game.ReplicatedStorage.transmit_to_clients.OnClientEvent:Connect(function(playernm, msg, r, g, b)
	local tag = ""
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local function sendWelcomeMessage()
		local message = "<font color='rgb(" .. r .. ", " .. g ..", " .. b .. ")'>[" .. playernm .. "]" .. tag .. ":</font> " .. msg
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = message;
			Color = Color3.fromRGB(255, 255, 255);
			Font = Enum.Font.SourceSansBold;
			FontSize = Enum.FontSize.Size18;
		})
	end

	sendWelcomeMessage()
end)
