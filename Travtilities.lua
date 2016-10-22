--FrameWork
local EventFrame = CreateFrame("Frame")
local whisperFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("MERCHANT_SHOW")
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
				SendChatMessage(UnitName("Player").." just repaired. It cost "..cost * 0.0001 .."g because you failed. Current balance remaining: "..(money-cost) * 0.0001 .."g.", "SAY", "Common", "1")
            else
                print("You're broke. You cannot repair.")
            end
        end 
    end   
	
end)

--ScriptSet (Automatic Reply)

local function eventHandler(self, event, ...)
	local arg1, arg2 = ...;
	local OtherPlayer = arg2;
	local message = "Coin cost is 3k, Grump cost is 60k. Can negotiate"
	local contacts = list
	
	SendChatMessage("This is a test", "WHISPER", "Common", OtherPlayer)
end
whisperFrame:SetScript("OnEvent", eventHandler)


	