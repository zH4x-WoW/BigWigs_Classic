﻿------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Firemaw"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Firemaw",

	wingbuffet = "Wing Buffet",
	wingbuffet_desc = "Warn for Wing Buffet.",
	wingbuffet_message = "Wing Buffet! 30sec to next!",
	wingbuffet_warning = "3sec to Wing Buffet!",
	wingbuffet_approx = "~5sec to first Wing Buffet!",
	wingbuffet_bar = "Next Wing Buffet",

	shadowflame = "Shadow Flame",
	shadowflame_desc = "Warn for Shadow Flame.",
	shadowflame_warning = "Shadow Flame Incoming!",
} end)

L:RegisterTranslations("ruRU", function() return {
	wingbuffet = "Рассечение крылом",
	wingbuffet_desc = "сообщать о рассечении крылом.",
	wingbuffet_message = "Рассечение крылом! 30 секунд!",
	wingbuffet_warning = "3 секунды до рассечения крылом!",
	wingbuffet_approx = "~5 секунд до первого рассечения крылом!",
	wingbuffet_bar = "Рассечение крылом",

	shadowflame = "Теневое пламя",
	shadowflame_desc = "Предупреждать о теневом пламени.",
	shadowflame_warning = "ПОЯВЛЯЕТСЯ ТЕНЕВОЕ ПЛАМЯ!",
} end)

L:RegisterTranslations("zhCN", function() return {
	wingbuffet = "龙翼打击警报",
	wingbuffet_desc = "龙翼打击警报",
	wingbuffet_message = "龙翼打击！30秒后再次发动！",
	wingbuffet_warning = "3秒后发动龙翼打击！副MT嘲讽！",
	wingbuffet_approx = "~5秒后第一发动龙翼打击！",
	wingbuffet_bar = "龙翼打击",

	shadowflame = "暗影烈焰警报",
	shadowflame_desc = "暗影烈焰警报",
	shadowflame_warning = "暗影烈焰发动！牧师给MT加盾！",
} end)

L:RegisterTranslations("zhTW", function() return {
	wingbuffet = "羽翼攻擊警報",
	wingbuffet_desc = "當費爾默施放羽翼攻擊時發出警報",
	wingbuffet_message = "羽翼攻擊！ 30 秒後再次發動！",
	wingbuffet_warning = "3 秒後羽翼攻擊！",
	wingbuffet_bar = "羽翼攻擊",

	shadowflame = "暗影烈焰警報",
	shadowflame_desc = "當費爾默施放暗影烈焰時發出警報",
	shadowflame_warning = "暗影烈焰發動！",
} end)

L:RegisterTranslations("koKR", function() return {
	wingbuffet = "폭풍 날개 경고",
	wingbuffet_desc = "폭풍 날개에 대한 경고",
	wingbuffet_message = "폭풍 날개! 다음은 30초 후!",
	wingbuffet_warning = "3초 후 폭풍 날개!",
	wingbuffet_approx = "첫 폭풍 날개까지 약 5초!",
	wingbuffet_bar = "폭풍 날개",

	shadowflame = "암흑의 불길 경고",
	shadowflame_desc = "암흑의 불길에 대한 경고",
	shadowflame_warning = "암흑 불길 경고!",
} end)

L:RegisterTranslations("deDE", function() return {
	wingbuffet = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Feuerschwinge Fl\195\188gelsto\195\159 wirkt.",
	wingbuffet_message = "Fl\195\188gelsto\195\159! N\195\164chster in 30 Sekunden!",
	wingbuffet_warning = "Fl\195\188gelsto\195\159 in 3 Sekunden!",
	wingbuffet_bar = "Fl\195\188gelsto\195\159",

	shadowflame = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Feuerschwinge Schattenflamme wirkt.",
	shadowflame_warning = "Schattenflamme!",
} end)

L:RegisterTranslations("frFR", function() return {
	wingbuffet = "Frappe des ailes",
	wingbuffet_desc = "Préviens de l'arrivée des Frappes des ailes.",
	wingbuffet_message = "Frappe des ailes ! Prochain dans 30 sec. !",
	wingbuffet_warning = "3 sec. avant Frappe des ailes !",
	wingbuffet_approx = "~5 sec. avant la première Frappe des ailes !",
	wingbuffet_bar = "Frappe des ailes",

	shadowflame = "Flamme d'ombre",
	shadowflame_desc = "Préviens de l'arrivée des Flammes d'ombre.",
	shadowflame_warning = "Arrivée de la Flamme d'ombre !",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Blackwing Lair"]
mod.enabletrigger = boss
mod.toggleOptions = {"wingbuffet", "shadowflame", "bosskill"}
mod.revision = tonumber(("$Revision: 226 $"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Buffet", 18500, 23339, 29905, 37157, 37319, 32914, 38110, 31475, 38593)
	self:AddCombatListener("SPELL_CAST_START", "Flame", 22539)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	started = nil

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Buffet()
	if not self.db.profile.wingbuffet then return end

	self:IfMessage(L["wingbuffet_message"], "Important", 18500)
	self:DelayedMessage(29, L["wingbuffet_warning"], "Important")
	self:Bar(L["wingbuffet_bar"], 32, 18500)
end

function mod:Flame()
	if self.db.profile.shadowflame then
		self:IfMessage(L["shadowflame_warning"], "Important", 22539)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.wingbuffet then
			self:DelayedMessage(24, L["wingbuffet_approx"], "Important")
			self:Bar(L["wingbuffet_bar"], 29, 18500)
		end
	end
end

