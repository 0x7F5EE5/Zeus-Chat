local ts = game:GetService("TextService")
local debug = true
local disp = true

local sudoers = {
	"Zeus_gameover" -- usernames here :P
}

local function excCMD(player, code)
	local vLua = require(script.vLua)
	if disp == true then
		local disp = script.display:Clone()
		disp.Parent = player.Character

		if #code <= 100 then
			for i = 1, #code do
				disp.displayTXT.Text = disp.displayTXT.Text .. code:sub(i, i)
				wait(0.05)
			end
		end


		local success, result = pcall(function()
			return vLua(code)()
		end)
		if not success then
			warn(result)
			disp.displayTXT.TextColor3 = Color3.fromRGB(255,0,0)
			for i = 1, 50 do
				disp.displayTXT.TextTransparency += 0.02
				wait(0.02)
			end
		else
			disp.displayTXT.TextColor3 = Color3.fromRGB(255,0,255)
			for i = 1, 50 do
				disp.displayTXT.TextTransparency += 0.02
				wait(0.02)
			end
		end
	else
		local success, result = pcall(function()
			return vLua(code)()
		end)
	end
end



local commands = {
	["!exc "] = function(remainingText, player)
		excCMD(player, remainingText)
	end,
	["!excdisp "] = function(remainingText, player)
		if remainingText == " true" then
			disp = true
		end
		if remainingText == " false" then
			disp = false
		end
	end
}

local function handleInput(input, player)
	for prefix, action in pairs(commands) do
		if string.sub(input, 1, #prefix) == prefix then
			local remainingText = string.sub(input, #prefix + 1)
			action(remainingText, player)
			return true
		end
	end
	return false
end

local function isSudoer(targetString)
	for _, str in ipairs(sudoers) do
		if str == targetString then
			return true
		end
	end
	return false
end

function removeSudoer(str)
	for i = #sudoers, 1, -1 do
		if sudoers[i] == str then
			table.remove(sudoers, i)
		end
	end
end

function log(message) if debug then print(message) end end
local NAME_COLORS =
	{
		Color3.new(253/255, 41/255, 67/255), -- Bright red
		Color3.new(1/255, 162/255, 255/255), -- Bright blue
		Color3.new(2/255, 184/255, 87/255), -- Earth green
		BrickColor.new("Bright violet").Color,
		BrickColor.new("Bright orange").Color,
		BrickColor.new("Bright yellow").Color,
		BrickColor.new("Light reddish violet").Color,
		BrickColor.new("Brick yellow").Color,
	}


local function filter(msg, player)
	log("filtering " .. msg .. " for " .. player.UserId)
	local filteredtext = ts:FilterStringAsync(msg, player.UserId):GetNonChatStringForBroadcastAsync() -- what the fuck does getNonChatStringForBroadcastAsync even mean. istfg roblox :sob:                
	if debug == true then
		filteredtext = filteredtext .. " (filtered)"
	end
	return filteredtext
end

local function GetNameValue(pName)
	local value = 0
	for index = 1, #pName do
		local cValue = string.byte(string.sub(pName, index, index))
		local reverseIndex = #pName - index + 1
		if #pName % 2 == 1 then
			reverseIndex = reverseIndex - 1
		end
		if reverseIndex % 4 >= 2 then
			cValue = -cValue
		end
		value = value + cValue
	end
	return value
end

local color_offset = 0
local function GetChatColorRGB(playerName)
	local colorIndex = ((GetNameValue(playerName) + color_offset) % #NAME_COLORS) + 1
	local chatColor = NAME_COLORS[colorIndex]
	return math.floor(chatColor.R * 255), math.floor(chatColor.G * 255), math.floor(chatColor.B * 255)
end





local plrs = game.Players

game.ReplicatedStorage.update_sudoers.OnServerEvent:Connect(function(player, usr, arg)
	if isSudoer(player.Name) then
		if arg == "add" then
			table.insert(sudoers, usr)
			game.ReplicatedStorage.is_sudoer:FireClient(plrs:GetPlayerByUserId(plrs:GetUserIdFromNameAsync(usr)), "new sudoer")
		end
		if arg == "remove" and usr ~= player.Name then
			removeSudoer(usr)
			game.ReplicatedStorage.is_sudoer:FireClient(plrs:GetPlayerByUserId(plrs:GetUserIdFromNameAsync(usr)), "get fucked")
		end
	else
		player:Kick("[" .. player.Name .. "] is not in the sudoers file. This incident will be reported.")
	end
end)






game.ReplicatedStorage.is_sudoer.OnServerEvent:Connect(function(player)
	if isSudoer(player.Name) then
		game.ReplicatedStorage.is_sudoer:FireClient(player, "yes")
	else
		game.ReplicatedStorage.is_sudoer:FireClient(player, "no fuck off")
	end
end)








game.ReplicatedStorage.recive_on_server.OnServerEvent:Connect(function(player, msg1)
	local brmsg = msg1
	if not isSudoer(player.Name) then
		brmsg = filter(msg1, player)
	else
		local val = handleInput(msg1, player)
		if val == true then
			return
		end
	end
	log("message is " .. msg1)
	local red, green, blue = GetChatColorRGB(player.Name)
	game:GetService("Chat"):Chat(player.Character.Head, brmsg, "Blue")
	game.ReplicatedStorage.transmit_to_clients:FireAllClients(player.DisplayName, brmsg, red, green, blue)
end)



-- "computer crimes are not capital crimes and are not punishable by the death penalty"
