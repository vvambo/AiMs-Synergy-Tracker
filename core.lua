----------------------
-- AST namespace and settings related variables
----------------------
AST                 = {}
AST.name            = "AiMs-Synergy-Tracker"
AST.author          = "AiMPlAyEr [EU]"
AST.version         = "4.0"
AST.website         = "http://www.esoui.com/downloads/info2084-AiMsSynergyTracker.html"
AST.menuname        = "AiMs Synergy Tracker"

----------------------
-- saved variables
----------------------
AST.varVersion      = 7
AST.default         = nil
AST.varName         = "ASTSaved"

----------------------
-- Managing Events and Stuff
----------------------
local em            = EVENT_MANAGER
local LibUnit       = LibStub:GetLibrary("LibUnits")

----------------------
-- other variables
----------------------
local combat        = IsUnitInCombat("player")
local wrapper       = nil
local fragment      = nil
AST.tanks           = {}

----------------------
-- default savedvariables table
----------------------

AST.default = {
    ["orb"]         = true,
    ["liq"]         = true,
    ["pur"]         = true,
    ["hea"]         = true,
    ["bon"]         = false,
    ["blo"]         = false,
    ["tra"]         = false,
    ["rad"]         = false,
    ["cha"]         = false,
    ["sha"]         = false,
    ["imp"]         = false,
    ["gra"]         = false,
    ["hir"]         = false,
    ["sol"]         = false,
    ["rob"]         = false,
    ["ago"]         = false,
    ["windowstate"] = true,
    ["windowscale"] = 1,
    ["left"]        = 500,
    ["top"]         = 500,
    ["orientation"] = "horizontal",
    ["alpha"]       = 0.8,
    ["lockwindow"]  = false,
    ["trackerui"]   = true,
    ["healerui"]    = true,
    ["interval"]    = 50,
    ["textures"]    = false,
    ["healer"]      = {
        ["tanksonly"] = true,
        ["firstsynergy"] = nil,
        ["secondsynergy"] = nil,
    }
}

----------------------
-- AddOn Initialize
----------------------
function AST:Initialize()
    em:RegisterForEvent(AST.name.."Combat", EVENT_PLAYER_COMBAT_STATE, AST.combatState)

    for k, v in pairs(AST.Data.SynergyData) do
        em:RegisterForEvent(AST.name.."Synergy"..k, EVENT_COMBAT_EVENT , AST.synergyCheck)
        em:AddFilterForEvent(AST.name.."Synergy"..k, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, k)
    end

    AST.SV = ZO_SavedVars:New(AST.varName, AST.varVersion, nil, AST.default)

    if AST.SV.healerui then
        AST.UpdateGroup()
    end

    AST.UI.TrackerUI(AST.SV.trackerui)
    AST.UI.HealerUI(AST.SV.healerui)

    AST.RestorePosition()
    AST.LoadSettings()
    AST.LoadAlpha(AST.SV.alpha)
    AST.LockWindow(AST.SV.lockwindow)

    wrapper = ASTGrid
    fragment = ZO_SimpleSceneFragment:New(wrapper)
    AST.combatState()
end

----------------------
-- Main Functions
----------------------

function AST.synergyCheck(eventCode, result, _, abilityName, _, _, _, sourceType, _, targetType, _, _, _, _, sourceUnitId, targetUnitId, abilityId)
    local start = GetFrameTimeSeconds()

    if sourceType == COMBAT_UNIT_TYPE_PLAYER and AST.SV.trackerui then

        if AST.Data.SynergyData[abilityId].group == 1 then

            if result == 2240 then
                AST.Data.TrackerTimer[1] = start + AST.Data.SynergyData[abilityId].cooldown
            end
        else
            AST.Data.TrackerTimer[AST.Data.SynergyData[abilityId].group] = start + AST.Data.SynergyData[abilityId].cooldown
        end
    end

    if result == ACTION_RESULT_EFFECT_GAINED and AST.SV.healerui then
        local usedBy = AST.GetUnitName(targetUnitId)
        local role = GetGroupMemberAssignedRole(usedBy)

        if AST.SV.healer.tanksonly then
            if role ~= LFG_GROUP_TANK then return; end
        end

        --d("Synergy activated! ID: "..abilityId.." From: "..usedBy)

        for k, v in ipairs(AST.Data.HealerTimer) do
            if v.name == usedBy then
                if AST.Data.SynergyData[abilityId].group == AST.SV.healer.firstsynergy then
                    AST.Data.Healertimer[k].firstsynergy = start + AST.Data.SynergyData[abilityId].cooldown
                elseif AST.Data.SynergyData[abilityId].group == AST.SV.healer.secondsynergy then
                    AST.Data.Healertimer[k].secondsynergy = start + AST.Data.SynergyData[abilityId].cooldown
                end
            end
        end
    end

    em:RegisterForUpdate(AST.name.."Update", AST.SV.interval, AST.countDown)
end

function AST.countDown()
    if AST.SV.trackerui then
        local counter   = 0
        local countAll  = 0

        for k, v in ipairs(AST.Data.TrackerTimer) do
            local element   = ASTGrid:GetNamedChild("SynergyTimer"..k)
            local icon      = ASTGrid:GetNamedChild("SynergyIcon"..k)

            if AST.time(v, 1) <= 0.1 then
                element:SetText("0.0")
                element:SetColor(255, 255, 255, 1)
                icon:SetColor(1, 1, 1, 1)

                counter = counter + 1
            else
                --element:SetText(string.format("%.1f", AST.time(AST.Data.TrackerTimer[k])))
                element:SetText(AST.time(AST.Data.TrackerTimer[k], 1))
                element:SetColor(255, 0, 0, 1)
                icon:SetColor(0.5, 0.5, 0.5, 1)

            end

            countAll = countAll + 1
        end

        if counter == countAll then
            em:UnregisterForUpdate(AST.name.."Update")
        end
    end

    if AST.SV.healerui then
        local count = 0
        local counttotal = 0
        for k, v in ipairs(AST.Data.HealerTimer) do
            if AST.time(v.firstsynergy, 1) <= 0.1 then
                local element = ASTHealerUI:GetNamedChild("HealerTimer"..(k * 2 - 1))
                element:SetText("0.0")
                element:SetColor(255, 255, 255, 1)

                count = count + 1
            else
                local element = ASTHealerUI:GetNamedChild("HealerTimer"..(k * 2 - 1))
                element:SetText(AST.time(AST.Data.TrackerTimer[k], 0))
                --element:SetText(string.format("%.0f", AST.time(AST.Data.TrackerTimer[k])))
                element:SetColor(255, 0, 0, 1)
            end

            if AST.time(v.secondsynergy, 1) <= 0.1 then
                local element = ASTHealerUI:GetNamedChild("HealerTimer"..(k * 2))
                element:SetText("0.0")
                element:SetColor(255, 255, 255, 1)

                count = count + 1
            else
                local element = ASTHealerUI:GetNamedChild("HealerTimer"..(k * 2))
                element:SetText(AST.time(AST.Data.TrackerTimer[k], 0))
                --element:SetText(string.format("%.0f", AST.time(AST.Data.TrackerTimer[k])))
                element:SetColor(255, 0, 0, 1)
            end

            counttotal = counttotal + 1

            if count == counttotal then
                em:UnregisterForUpdate(AST.name.."Update")
            end
        end
    end
end

function AST.windowState()
    if AST.SV.windowstate then
        AST.SV.windowstate = false
        ASTGrid:SetHidden(true)
        HUD_SCENE:RemoveFragment(fragment)
        HUD_UI_SCENE:RemoveFragment(fragment)
        d(zo_strformat("|cfd6a02[AiMs Synergy Tracker]|r |cffffffTracker is now <<1>> outside of combat|r", "|cdc143chidden|r"))
    else
        AST.SV.windowstate = true
        ASTGrid:SetHidden(false)
        HUD_SCENE:AddFragment(fragment)
        HUD_UI_SCENE:AddFragment(fragment)
        d(zo_strformat("|cfd6a02[AiMs Synergy Tracker]|r |cffffffTracker is now <<1>> outside of combat|r", "|c32cd32visible|r"))
    end
end

function AST.combatState(event, inCombat)
    if AST.SV.windowstate then
        HUD_SCENE:AddFragment(fragment)
        HUD_UI_SCENE:AddFragment(fragment)
    else
        if inCombat ~= combat then
            combat = inCombat
            if inCombat then
                ASTGrid:SetHidden(false)
            else
                ASTGrid:SetHidden(true)
            end
        end
        HUD_SCENE:RemoveFragment(fragment)
        HUD_UI_SCENE:RemoveFragment(fragment)
    end

    --AST.UpdateGroup()
end

function AST.LoadAlpha(value)
    ASTGridbdBackDrop:SetAlpha(value)

    if AST.SV.textures then
        for k, v in ipairs(AST.Data.TrackerTimer) do
            local icon = ASTGrid:GetNamedChild("SynergyIcon"..k)
            icon:SetAlpha(value)
        end
    else
        for k, v in ipairs(AST.Data.TrackerTimer) do
            local icon = ASTGrid:GetNamedChild("SynergyIcon"..k)
            icon:SetAlpha(1.0)
        end
    end
end

function AST.LockWindow(value)
    if not value then
        ASTGrid:SetMovable(true)
    else
        ASTGrid:SetMovable(false)
    end
end

function AST.UpdateGroup()
    local gSize = GetGroupSize()

    if gSize > 0 then

        for i = 1, gSize do
            local accName = string.lower(GetUnitDisplayName("group" .. i))
            local role = GetGroupMemberAssignedRole("group" .. i)

            if role ~= 4 then --healers will always be ignored
                if not AST.SV.healer.tanksonly then --add tanks and dds
                    AST.Data.HealerTimer[i] = {}
                    AST.Data.HealerTimer[i].name = accName
                    AST.Data.HealerTimer[i].firstsynergy = "0"
                    AST.Data.HealerTimer[i].secondsynergy = "0"
                elseif AST.SV.healer.tanksonly and role == LFG_GROUP_TANK then --add only tanks
                    AST.Data.HealerTimer[i] = {}
                    AST.Data.HealerTimer[i].name = accName
                    AST.Data.HealerTimer[i].firstsynergy = "0"
                    AST.Data.HealerTimer[i].secondsynergy = "0"
                end
            end
        end
    end
end

function AST.GetUnitName(unitId)
    local unit = LibUnit:GetNameForUnitId(unitId)

    if unit ~= "" or unit ~= nil then
        return zo_strformat("<<1>>", unit)
    else
        return ""
    end
end

----------------------
-- Supporting Functions
----------------------
function AST.time(nd, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
	return math.floor((nd - GetGameTimeMilliseconds()/1000) * mult + 0.5)/mult
end

function AST.RestorePosition()
    local left = AST.SV.left
    local top = AST.SV.top
    ASTGrid:ClearAnchors()
    ASTGrid:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

----------------------
-- Slash Commands
----------------------
SLASH_COMMANDS["/asttoggle"]   = AST.windowState

----------------------
-- AddOn Loaded
----------------------
function AST.OnAddOnLoaded(event, addonName)
    if addonName ~= AST.name then return end
    em:UnregisterForEvent(AST.name, EVENT_ADD_ON_LOADED)
    AST:Initialize()
end

----------------------
-- OnAddOnLoaded Event
----------------------
em:RegisterForEvent(AST.name, EVENT_ADD_ON_LOADED, AST.OnAddOnLoaded)