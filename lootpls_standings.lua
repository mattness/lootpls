local LOOTPLS_STANDINGS_MAX_COLUMNS = 5;
local LOOTPLS_STANDINGS_MAX_STRINGS = 4;
local LOOTPLS_STANDINGS_BUTTON_OFFSET = 2;
local LOOTPLS_STANDINGS_BUTTON_HEIGHT = 20;

-- maybe someday we'll add more views with different columns to this frame, let's prepare for it now
local currentStandingsView = "standings";
local LOOTPLS_STANDINGS_COLUMNS = {
	standings = { "class", "name", "ep", "gp", "pr" },
};

-- global for localization changes
LOOTPLS_STANDINGS_COLUMN_DATA = {
	class = { width = 32, text = CLASS_ABBR, hasIcon = true },
	name = { width = 103, text = NAME, sortType = "name", stringJustify="LEFT" },
	ep = { width = 58, text = EP_TEXT, stringJustify="RIGHT" },
	gp = { width = 58, text = GP_TEXT, stringJustify="RIGHT" },
	pr = { width = 58, text = PR_TEXT, stringJustify="RIGHT" },
};

function LootPlsStandings_SortByColumn(column)
	if ( column.sortType ) then
		LootPlsStandings_SortRoster(column.sortType);
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
end

function LootPlsStandingsFrame_OnLoad(self)
	LootPlsFrame_RegisterPanel(self);
	LootPlsStandingsContainer.update = LootPlsStandings_Update;
	HybridScrollFrame_CreateButtons(LootPlsStandingsContainer, "LootPlsStandingsButtonTemplate", 0, 0, "TOPLEFT", "TOPLEFT", 0, -LOOTPLS_STANDINGS_BUTTON_OFFSET, "TOP", "BOTTOM");
	LootPlsStandingsContainerScrollBar.doNotHide = true;
	LootPlsStandingsFrame_SetView("standings");
end

function LootPlsStandingsFrame_OnShow(self)
	LootPlsStandings_Update();
end

function LootPlsStandings_Update()
	local scrollFrame = LootPlsStandingsContainer;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local button, index;
	local totalMembers = LootPlsStandings_GetMemberCount();
	
	-- numVisible
	local visibleMembers = totalMembers;
	
	for i = 1, numButtons do
		button = buttons[i];		
		index = offset + i;
		local name, classFileName, online, effortPoints, gearPoints, priority = LootPlsStandings_GetMemberInfo(index);
		if ( name and index <= visibleMembers ) then
			button.guildIndex = index;
			local displayedName = --[[ChatFrame_GetMobileEmbeddedTexture(119/255, 137/255, 119/255)..]]name;
			button.online = online;
			if ( currentStandingsView == "standings" ) then
      
				button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]));
				LootPlsStandingsButton_SetStringText(button.string1, displayedName, online, classFileName);
				LootPlsStandingsButton_SetStringText(button.string2, effortPoints, online);
				LootPlsStandingsButton_SetStringText(button.string3, gearPoints, online);
				LootPlsStandingsButton_SetStringText(button.string4, priority, online);
			end
			button:Show();
			if ( mod(index, 2) == 0 ) then
				button.stripe:SetTexCoord(0.36230469, 0.38183594, 0.95898438, 0.99804688);
			else
				button.stripe:SetTexCoord(0.51660156, 0.53613281, 0.88281250, 0.92187500);
			end
			button:UnlockHighlight();
		else
			button:Hide();
		end
	end
	local totalHeight = visibleMembers * (LOOTPLS_STANDINGS_BUTTON_HEIGHT + LOOTPLS_STANDINGS_BUTTON_OFFSET);
	local displayedHeight = numButtons * (LOOTPLS_STANDINGS_BUTTON_HEIGHT + LOOTPLS_STANDINGS_BUTTON_OFFSET);
	HybridScrollFrame_Update(scrollFrame, totalHeight, displayedHeight);
end

function LootPlsStandings_GetMemberCount()
	local totalMembers = GetNumGuildMembers();
  return totalMembers;
end

function LootPlsStandings_GetMemberInfo(index)
  local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName, achievementPoints, achievementRank, isMobile = GetGuildRosterInfo(index);
  return name, classFileName, online, 350, 100, 3.5;
end

function LootPlsStandingsFrame_SetView(view)
	if ( not view or not LOOTPLS_STANDINGS_COLUMNS[view] ) then
		view = "standings";
	end

	local numColumns = #LOOTPLS_STANDINGS_COLUMNS[view];
	local stringsInfo = { };
	local stringOffset = 0;
	local haveIcon;
	
	for columnIndex = 1, LOOTPLS_STANDINGS_MAX_COLUMNS do
		local columnButton = _G["LootPlsStandingsColumnButton"..columnIndex];
		local columnType = LOOTPLS_STANDINGS_COLUMNS[view][columnIndex];
		if ( columnType ) then
			local columnData = LOOTPLS_STANDINGS_COLUMN_DATA[columnType];
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
	local buttons = LootPlsStandingsContainer.buttons;
	local button, fontString;
	for buttonIndex = 1, #buttons do
		button = buttons[buttonIndex];
		for stringIndex = 1, LOOTPLS_STANDINGS_MAX_STRINGS do
			fontString = button["string"..stringIndex];
			local stringData = stringsInfo[stringIndex];
			if ( stringData ) then
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

function LootPlsStandings_SortRoster(sortType)
end

function LootPlsStandingsButton_SetStringText(buttonString, text, isOnline, class)
	buttonString:SetText(text);
	if ( isOnline ) then
		if ( class ) then
			local classColor = RAID_CLASS_COLORS[class];
			buttonString:SetTextColor(classColor.r, classColor.g, classColor.b);
		else
			buttonString:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		end
	else
		buttonString:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	end
end

function LootPlsStandingsButton_OnClick(self, button)
end