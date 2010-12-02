UIPanelWindows["LootPlsFrame"] = { area = "left", pushable = 1, whileDead = 1 };
local LOOTPLSFRAME_PANELS = { };

function LootPlsFrame_OnLoad(self)
	PanelTemplates_SetNumTabs(self, 2);
	LootPlsFrame_UpdateTabard();
end

function LootPlsFrame_OnShow(self)
	PlaySound("igCharacterInfoOpen");
	if( not PanelTemplates_GetSelectedTab(self) ) then
		LootPlsFrame_TabClicked(LootPlsFrameTab1);
	end
end

function LootPlsFrame_OnHide(self)
	PlaySound("igCharacterInfoClose");
end

function LootPlsFrame_UpdateTabard()
	SetLargeGuildTabardTextures("player", LootPlsFrameTabardEmblem, LootPlsFrameTabardBackground, LootPlsFrameTabardBorder);
end

function LootPlsFrame_Toggle()
	if ( LootPlsFrame:IsShown() ) then
		HideUIPanel(LootPlsFrame);
	else
		ShowUIPanel(LootPlsFrame);
	end
end

function LootPlsFrame_TabClicked(self)
	local tabIndex = self:GetID();
	PanelTemplates_SetTab(self:GetParent(), tabIndex);
end