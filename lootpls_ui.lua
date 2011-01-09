UIPanelWindows["LootPlsFrame"] = { area = "left", pushable = 1, whileDead = 1 };
local LOOTPLSFRAME_PANELS = { };
local LOOTPLSFRAME_POPUPS = { };
local tabardLoaded = false;

SLASH_LOOTPLS1, SLASH_LOOTPLS2 = "/lootpls", "/lp";

function SlashCmdList.LOOTPLS(msg, editbox)
	if ( LootPlsFrame:IsShown() ) then
		HideUIPanel(LootPlsFrame);
	else
		ShowUIPanel(LootPlsFrame);
	end
end

function LootPlsFrame_OnLoad(self)
	PanelTemplates_SetNumTabs(self, 3);
end

function LootPlsFrame_OnShow(self)
	LootPlsFrame_UpdateTabard();
	PlaySound("igCharacterInfoOpen");
	if( not PanelTemplates_GetSelectedTab(self) ) then
		LootPlsFrame_TabClicked(LootPlsFrameTab1);
	end
end

function LootPlsFrame_OnHide(self)
	PlaySound("igCharacterInfoClose");
end

function LootPlsFrame_UpdateTabard()
	if(not tabardLoaded) then
		SetLargeGuildTabardTextures("player", LootPlsFrameTabardEmblem, LootPlsFrameTabardBackground, LootPlsFrameTabardBorder);
		tabardLoaded = true;
	end
end

function LootPlsFrame_TabClicked(self)
	if ( self == nil ) then return end
	local tabIndex = self:GetID();
	PanelTemplates_SetTab(self:GetParent(), tabIndex);
	if(tabIndex == 1) then
		ButtonFrameTemplate_HideButtonBar(LootPlsFrame);
		LootPlsFrame_ShowPanel("LootPlsStandingsFrame");
		LootPlsFrameInset:SetPoint("TOPLEFT", 4, -90);
		LootPlsFrameInset:SetPoint("BOTTOMRIGHT", -7, 26);
	else
		LootPlsFrame_ShowPanel("None");
	end
end

function LootPlsFrame_RegisterPanel(frame)
	if(frame:GetName() == "LootPlsRaid") then
		PanelTemplates_SetDisabledTabState(frame);
	end
	tinsert(LOOTPLSFRAME_PANELS, frame:GetName());
end

function LootPlsFrame_ShowPanel(frameName)
	local frame;
	for index, value in pairs(LOOTPLSFRAME_PANELS) do
		if ( value == frameName ) then
			frame = _G[value];
		else
			_G[value]:Hide();
		end	
	end
	if ( frame ) then
		frame:Show();
	end
end

function LootPlsFrame_RegisterPopup(frame)
	tinsert(LOOTPLSFRAME_POPUPS, frame:GetName());
end

function LootPlsFramePopup_Show(frame)
	local name = frame:GetName();
	for index, value in ipairs(LOOTPLSFRAME_POPUPS) do
		if ( name ~= value ) then
			_G[value]:Hide();
		end
	end
	frame:Show();
end
