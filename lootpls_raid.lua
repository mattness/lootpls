local LOOTPLS_RAID_COLUMNS = { "class", "name", "ep", "gp", "pr" };

function LootPlsRaidFrame_OnLoad(self)
	LootPlsFrame_RegisterPanel(self);
	LootPlsRaidFrameScrollContainer.update = LootPlsRaidFrame_Update;
	HybridScrollFrame_CreateButtons(LootPlsRaidFrameScrollContainer, "LootPlsStandingsButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -LOOTPLS_STANDINGS_TEMPL_BUTTON_OFFSET, "TOP", "BOTTOM");
	LootPlsRaidFrameScrollContainerScrollBar.doNotHide = true;
	LootPlsRaidFrame_SetView();
end

function LootPlsRaidFrame_OnShow(self)
	LootPlsRaidFrame_Update();
end

function LootPlsRaidFrame_Update()
	local scrollFrame = LootPlsRaidFrameScrollContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local button, index;
	local visibleMembers = GetNumRaidMembers();
	
	for i = 1, numButtons do
		button = buttons[i];
		index = offset + i;
		local name, classFileName, online, effortPoints, gearPoints, priority = LootPls:GetRaidMemberInfo(UnitName("raid"..index));
		if( name and index <= visibleMembers ) then
			-- do some stuff
		else
			button:Hide();
		end
	end

	local totalHeight = visibleMembers * (LOOTPLS_STANDINGS_TEMPL_BUTTON_HEIGHT + LOOTPLS_STANDINGS_TEMPL_BUTTON_OFFSET);
	local displayedHeight = numButtons * (LOOTPLS_STANDINGS_TEMPL_BUTTON_HEIGHT + LOOTPLS_STANDINGS_TEMPL_BUTTON_OFFSET);
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

function LootPlsRaidFrame_SetView()
	local numColumns = #LOOTPLS_STANDINGS_TEMPL_COLUMNS;
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon;

	for columnIndex = 1, LOOTPLS_STANDINGS_TEMPL_MAX_COLUMNS do
		local columnButton = _G["LootPlsRaidFrameColumnButton"..columnIndex];
		local columnType = LOOTPLS_STANDINGS_TEMPL_COLUMNS[columnIndex];
		if ( columnType ) then
			local columnData = LOOTPLS_STANDINGS_TEMPL_COLUMN_DATA[columnType];
			columnButton:SetText(columnData.text);
			WhoFrameColumn_SetWidth(columnButton, columnData.width);
			columnButton:Show();
			-- by default the sort type should be the same as the column type
			if ( columnData.sortType ) then
				columnButton.sortType = columnData.sortType;
			else
				columnButton.sortType = columnType;
			end
			if ( columnData.hasIcon ) then
				haveIcon = true;
			else	
				-- store string data for processing
				columnData["stringOffset"] = stringOffset;
				table.insert(stringsInfo, columnData);
			end
			stringOffset = stringOffset + columnData.width - 2;
		else
			columnButton:Hide();
		end
	end

	-- process the button strings
	local buttons = LootPlsRaidFrameScrollContainer.buttons;
	local button, fontString;
	for buttonIndex = 1, #buttons do
		button = buttons[buttonIndex];
		for stringIndex = 1, LOOTPLS_STANDINGS_TEMPL_MAX_STRINGS do
			fontString = button["string"..stringIndex];
			local stringData = stringsInfo[stringIndex];
			if (stringData ) then
				-- want strings a little inside the columns, 6 pixels from the left and 8 from the right
				fontString:SetPoint("LEFT", stringData.stringOffset + 6, 0);
				fontString:SetWidth(stringData.width - 14);
				fontString:SetJustifyH(stringData.stringJustify);
				fontString:Show();
			else
				fontString:Hide();
			end
		end
		if ( haveIcon ) then
			button.icon:Show();
		else
			button.icon:Hide();
		end
	end
end
