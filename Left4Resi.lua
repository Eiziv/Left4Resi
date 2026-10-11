local MIN_RESILIENT_LEVEL = 12

-- Season bests are empty until the server has answered C_MythicPlus.RequestMapInfo.
local dataLoaded = false

local function Print(text)
	print("|cff33ff99Left4Resi|r: " .. text)
end

-- Highest key level timed this season in each dungeon of the current pool, 0 if never timed.
local function GetTimedLevels()
	local dungeons = {}
	for _, mapID in ipairs(C_ChallengeMode.GetMapTable()) do
		local inTimeInfo = C_MythicPlus.GetSeasonBestForMap(mapID)
		tinsert(dungeons, {
			name = C_ChallengeMode.GetMapUIInfo(mapID) or tostring(mapID),
			level = inTimeInfo and inTimeInfo.level or 0,
		})
	end
	table.sort(dungeons, function(a, b) return a.name < b.name end)
	return dungeons
end

local function GetNextResilientLevel(dungeons)
	local lowest = math.huge
	for _, dungeon in ipairs(dungeons) do
		lowest = math.min(lowest, dungeon.level)
	end
	return math.max(lowest + 1, MIN_RESILIENT_LEVEL)
end

-- A header line followed by one line per dungeon still missing at this level.
local function BuildReport(dungeons, level)
	local lines = {}
	for _, dungeon in ipairs(dungeons) do
		if dungeon.level < level then
			tinsert(lines, dungeon.level > 0 and ("%s (+%d)"):format(dungeon.name, dungeon.level) or dungeon.name)
		end
	end
	if #lines == 0 then
		return { ("Resilient %d: all %d dungeons timed."):format(level, #dungeons) }
	end
	tinsert(lines, 1, ("Left for Resilient %d (%d/%d):"):format(level, #lines, #dungeons))
	return lines
end

SLASH_LEFT4RESI1 = "/lr"
SLASH_LEFT4RESI2 = "/left4resi"
SlashCmdList.LEFT4RESI = function(msg)
	local level
	if msg ~= "" then
		level = tonumber(msg:match("^%s*(%d+)%s*$"))
		if not level then
			Print("/lr [level] - without a level it uses your next Resilient level.")
			return
		end
	end

	local dungeons = GetTimedLevels()
	if not dataLoaded or #dungeons == 0 then
		C_MythicPlus.RequestMapInfo()
		Print("Mythic+ data has not loaded yet, try again in a moment.")
		return
	end

	local toParty = IsInGroup()
	if toParty and C_ChatInfo.InChatMessagingLockdown() then
		Print("Addons cannot send chat messages right now, showing it only to you.")
		toParty = false
	end

	for _, line in ipairs(BuildReport(dungeons, level or GetNextResilientLevel(dungeons))) do
		if toParty then
			C_ChatInfo.SendChatMessage(line, "PARTY")
		else
			Print(line)
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("CHALLENGE_MODE_COMPLETED")
frame:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
frame:SetScript("OnEvent", function(_, event)
	if event == "CHALLENGE_MODE_MAPS_UPDATE" then
		dataLoaded = true
	else
		C_MythicPlus.RequestMapInfo()
	end
end)
