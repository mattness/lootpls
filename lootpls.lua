local addonName = "LootPls";
LootPls = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0");
_G[addonName] = LootPls;
local addon = LootPls;

local AddonDB_Defaults = {
	global = {
		Options = {
		},
	},
};

local dummyData = {
	Guilds = {
		['*'] = {
			Raiders = {
				['*'] = {
					class = nil,
					data1 = nil,
					data2 = nil,
				},
			},
		},
	},
	Characters = {
		['*'] = {
			class = nil,
			Guilds = {
				['*'] = {
					data1 = nil,
					data2 = nil,
				},
			},
		},
	},
};

local function GetOption(option)
	return addon.db.global.Options[option]
end

function addon:SetupLdb()
	local LDB = LibStub("LibDataBroker-1.1");
	if not LDB then return end
	if addon.ldb then return end
	
	addon.ldb = LDB:NewDataObject("lootpls",
		{
			type = "launcher",
			label = "LootPls",
			icon = "Interface\\Icons\\Spell_Nature_StormReach",
			OnClick = function(clickedFrame, button)
				if button == "LeftButton" then
					if ( LootPlsFrame:IsShown() ) then
						HideUIPanel(LootPlsFrame);
					else
						ShowUIPanel(LootPlsFrame);
					end
				end
			end,
			OnTooltipShow = function(tooltip)
				tooltip:AddLine("LootPls");
				tooltip:AddLine("");
				tooltip:AddLine("Left click to toggle the LootPls standings", 0, 1, 0);
			end,
		});
end

function addon:OnInitialize()
	addon.db = LibStub("AceDB-3.0"):New(addonName .. "DB", AddonDB_Defaults);
	SetupDummyData();
	setmetatable(LootPls, { __index = addon });
	addon:SetupLdb()
end

function addon:SortData(guildKey, sortType)
	print(format("Sorting data for '%s' by '%s'", guildKey, sortType));
end

function addon:GetMemberInfo(guildKey, index)
	-- This is a hack to get the member name from the index.  It needs to be reworked.
	local name = GetGuildRosterInfo(index);
	if( name == nil ) then return nil end

	local member = dummyData.Guilds[guildKey].Raiders[name];
	return name, member.class, false, member.data1, member.data2, member.data1/member.data2;
end

local guildKey = format("%s.%s", GetRealmName(), GetGuildInfo("player"));
function addon:GetMemberCount(realm, guild)
	local guildTable = dummyData.Guilds[guildKey];
	if ( guildTable == nil ) then return 0 end

	local count = 0
	for _, _ in pairs(guildTable.Raiders) do
		count = count + 1
	end

	return count;
end

-- This is a throw-away function just to generate some static data for developing and testing the sorting story.
function SetupDummyData()
	local recordCount = GetNumGuildMembers();
	dummyData.Guilds[guildKey] = { Raiders = { } };
	local guildTable = dummyData.Guilds[guildKey];
	local charactersTable = dummyData.Characters;
	
	for i = 1, recordCount do
		local name, _, _, _, _, _, _, _, online, _, classFileName = GetGuildRosterInfo(i);
		local ep = math.random(1000, 10000);
		local gp = math.random(100, 1000);
		local characterKey = format("%s.%s", GetRealmName(), name);
		
		charactersTable[characterKey] = {
			class = classFileName,
			Guilds = {
				[guildKey] = { data1 = ep, data2 = gp },
			}
		};

		guildTable.Raiders[name] = { class = classFileName, data1 = ep, data2 = gp };
	end
end