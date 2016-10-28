--FrameWork

--Autorepair
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("MERCHANT_SHOW")

--Autoreply
local whisperFrame = CreateFrame("Frame")
whisperFrame:RegisterEvent("CHAT_MSG_WHISPER")

--ScriptSet (Automatic Repair)
EventFrame:SetScript("OnEvent", function(self, event, ...)

    ChatFrame1:AddMessage('Did you want to repair '.. UnitName("Player")..'?')

    if(CanMerchantRepair()) then
      local cost = GetRepairAllCost()
      if (cost > 0) then
        local money = GetMoney()

        if (IsInGuild()) then
          local guildMoney = GetGuildBankWithdrawMoney()

          if (guildMoney > GetGuildBankMoney()) then
            guildMoney = GetGuildBankMoney()
          end

          if (guildMoney > cost and CanGuildBankRepair()) then
            RepairAllItems(1)
            print(format("|cfff07100Repair cost covered by G-Bank: %.1fg|r", cost * 0.0001))
            return
          end

        end

        if (money > cost) then
          RepairAllItems()
          print(format("|cffead000Repair cost: %.1fg|r", cost * 0.0001))
        else
          print("You're broke. You cannot repair.")
        end
      end
    end

end)

--ScriptSet (Automatic Reply)
local toggle = true

local function slashHandler(msg, editbox)
	if (msg == 'on') then -- Player turns autoreply ON
		toggle = true;
		ChatFrame1:AddMessage('Autoreply enabled.')
	elseif (msg == 'off') then -- Player turns autoreply OFF
		toggle = false;
		ChatFrame1:AddMessage('Autoreply disabled.')
	else
		message = msg -- Player SETS autoreply message
		list = nil;
		ChatFrame1:AddMessage('New message set.')
	end
end

SLASH_TRAVTILITIES1 = '/trav'

SlashCmdList["TRAVTILITIES"] = slashHandler; 

local function eventHandler(self, event, ...)
  local arg1, arg2 = ...;
  local OtherPlayer = arg2;
  local player, realm = strsplit("-", OtherPlayer, 2)
  local count = 1;
  list = list or {};
  found = false;
  
  print("Travtilities - You've recevied a whisper.")
  --Check recent players that have recevied an autoreply message.
  if toggle == true then
	for i = 1, 100 do
		if list[i] ~= nil then
			if list[i] == player then
				found = true
				break
			end
			count = i;
		end
	end

	if found == false then
		if message ~= nil then
			SendChatMessage(message, "WHISPER", "Common", player)
			list[count+1] = player;
			found = true;
		else
			ChatFrame1:AddMessage('You have not set auto reply.')
		end
	end
 end
end

whisperFrame:SetScript("OnEvent", eventHandler)