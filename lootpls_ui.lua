UIPanelWindows["LootPlsFrame"] = { area = "left", pushable = 1, whileDead = 1 };
local LOOTPLSFRAME_PANELS = { };

function LootPlsFrame_OnLoad(self)
	LootPlsFrame_UpdateTabard();
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