UIPanelWindows["LootPlsFrame"] = { area = "left", pushable = 1, whileDead = 1 };
local LOOTPLSFRAME_PANELS = { };
local tabardLoaded = false;

function LootPlsFrame_OnLoad(self)
	debugstack();
	PanelTemplates_SetNumTabs(self, 2);
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

function LootPlsFrame_Toggle()
	if ( LootPlsFrame:IsShown() ) then
		HideUIPanel(LootPlsFrame);
	else
		ShowUIPanel(LootPlsFrame);
	end
end

function LootPlsFrame_TabClicked(self)
	print("LootPlsFrame_TabClicked() self = "..self:GetName());
	local tabIndex = self:GetID();
	PanelTemplates_SetTab(self:GetParent(), tabIndex);
	if(tabIndex == 1) then
		ButtonFrameTemplate_HideButtonBar(LootPlsFrame);
		LootPlsFrame_ShowPanel("LootPlsRosterFrame");
		LootPlsFrameInset:SetPoint("TOPLEFT", 4, -90);
		LootPlsFrameInset:SetPoint("BOTTOMRIGHT", -7, 26);
	else
		LootPlsFrame_ShowPanel("None");
	end
end

function LootPlsFrame_RegisterPanel(frame)
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