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

local function GetOption(option)
	return addon.db.global.Options[option]
end

local function GetGuildKey(guild, realm)
	if( guild == nil ) then guild = GetGuildInfo("player"); end
	if( realm == nil ) then realm = GetRealmName(); end
	return format("Default.%s.%s", realm, guild);
end

function addon:OnInitialize()
	addon.db = LibStub("AceDB-3.0"):New(addonName .. "DB", AddonDB_Defaults);
	setmetatable(LootPls, { __index = addon });
end

function addon:SortData(guildKey, sortType)
	print(format("Sorting data for '%s' by '%s'", guildKey, sortType));
end

function addon:GetMemberInfo(index, guild, realm)
	local guildKey = GetGuildKey(guild, realm);
	
	local roster = DataStore:GetGuildDKPRoster(guildKey);
	if( roster == nil ) then return nil; end
	
	local name = roster[index];
	if( name == nil ) then return nil; end

	local ep, gp = DataStore:GetGuildMemberDKP(guildKey, name);
	return name, "PALADIN", false, ep, gp, ep/gp;
end

function addon:GetMemberCount(realm, guild)
	local guildKey = GetGuildKey(guild, realm);
	local roster = DataStore:GetGuildDKPRoster(guildKey)
	if( roster == nil ) then return 0; end
	
	return #roster;
end

-- This is a throw-away function just to generate some static data for developing and testing the sorting story.
function addon:SetupDummyData(guild, realm)
	local guildKey = GetGuildKey(guild, realm);
	local recordCount = GetNumGuildMembers();
	
	for i = 1, recordCount do
		local name, _, _, _, _, _, _, _, online, _, classFileName = GetGuildRosterInfo(i);
		local ep = math.random(1000, 10000);
		local gp = math.random(100, 1000);
		local characterKey = format("%s.%s", GetRealmName(), name);

		DataStore:SetGuildMemberDKP(guildKey, name, ep, gp);
	end
end