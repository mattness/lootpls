function LootPlsRaidFrame_OnLoad(self)
	LootPlsFrame_RegisterPanel(self);
	LootPlsRaidContainer.update = LootPlsRaid_Update;
	HybridScrollFrame_CreateButtons(LootPlsRaidContainer, "LootPlsStandingsButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -LOOTPLS_STANDINGS_BUTTON_OFFSET, "TOP", "BOTTOM");
	LootPlsRaidContainerScrollBar.doNotHide = true;
end

function LootPlsRaidFrame_OnShow(self)
	LootPlsRaid_Update();
end

function LootPlsRaid_Update()
	local scrollFrame = LootPlsStandingsContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local button, index;
	local totalMembers = 0;
end