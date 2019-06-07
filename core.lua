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
local fragment2     = nil
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
        ["left"]            = 500,
        ["top"]             = 500,
        ["tanksonly"]       = true,
        ["ddsonly"]         = false,
        ["onesynergy"]      = false,
        ["firstsynergy"]    = 1,
        ["secondsynergy"]   = 2,
    }
}

----------------------
-- AddOn Initialize
----------------------
function AST:Initialize()
    em:RegisterForEvent(AST.name.."Combat", EVENT_PLAYER_COMBAT_STATE, AST.combatState)

    for k, v in pairs(AST.Data.SynergyData) do
        em:RegisterForEvent(AST.name.."Synergy"..k,EVENT_COMBAT_EVENT , AST.synergyCheck)
        em:AddFilterForEvent(AST.name.."Synergy"..k,EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, k)
    end

    AST.SV = ZO_SavedVars:New(AST.varName, AST.varVersion, nil, AST.default)

    AST.UI.TrackerUI(AST.SV.trackerui)
    AST.UI.HealerUI(AST.SV.healerui)

    AST.RestorePosition()
    AST.LoadSettings()
    AST.LoadAlpha(AST.SV.alpha)
    AST.LockWindow(AST.SV.lockwindow)

    wrapper = ASTGrid
    fragment = ZO_SimpleSceneFragment:New(wrapper)

    if AST.SV.healerui then
        wrapper2 = ASTHealerUI
        fragment2 = ZO_SimpleSceneFragment:New(wrapper2)
    end
    AST.combatState()
end

----------------------
-- Main Functions
----------------------

function AST.synergyCheck(eventCode, result, _, abilityName, _, _, _, sourceType, _, targetType, _, _, _, _, sourceUnitId, targetUnitId, abilityId)
    local start = GetFrameTimeSeconds()

    if (sourceType == COMBAT_UNIT_TYPE_PLAYER or sourceType == COMBAT_UNIT_TYPE_GROUP) and AST.SV.trackerui then

        if AST.Data.SynergyData[abilityId].group == 1 then

            if result == 2240 then
                AST.Data.TrackerTimer[1] = start + AST.Data.SynergyData[abilityId].cooldown
            end
        else
            AST.Data.TrackerTimer[AST.Data.SynergyData[abilityId].group] = start + AST.Data.SynergyData[abilityId].cooldown
        end
    end

    if result == ACTION_RESULT_EFFECT_GAINED and AST.SV.healerui then

        if AST.SV.healer.tanksonly then
            if role ~= LFG_GROUP_TANK then return; end
        end

        if AST.SV.healer.ddsonly then
            if role ~= LFG_GROUP_DD then return; end
        end

        local usedBy = AST.GetUnitName(targetUnitId)
        local role = GetGroupMemberAssignedRole(usedBy)

        for k, v in ipairs(AST.Data.HealerTimer) do
            if v.name == usedBy then
                if AST.Data.SynergyData[abilityId].group == AST.SV.healer.firstsynergy then
                    AST.Data.HealerTimer[k].firstsynergy = start + AST.Data.SynergyData[abilityId].cooldown
                elseif AST.Data.SynergyData[abilityId].group == AST.SV.healer.secondsynergy and not AST.SV.healer.onesynergy then
                    AST.Data.HealerTimer[k].secondsynergy = start + AST.Data.SynergyData[abilityId].cooldown
                end
            end
        end

        --d("Synergy activated! ID: "..abilityId.." From: "..usedBy.." Result: "..result.." Source: "..sourceType)
    end

    em:RegisterForUpdate(AST.name.."Update", AST.SV.interval, AST.countDown)
end

function AST.countDown()
    local count, counttotal, counter, countAll = 0, 0, 0, 0

    if AST.SV.trackerui then
        for k, v in ipairs(AST.Data.TrackerTimer) do
            local element   = ASTGrid:GetNamedChild("SynergyTimer"..k)
            local icon      = ASTGrid:GetNamedChild("SynergyIcon"..k)

            if AST.time(v, 1) <= 0.1 then
                element:SetText("0.0")
                element:SetColor(255, 255, 255, 1)
                icon:SetColor(1, 1, 1, 1)
                if AST.SV.textures then
                    icon:SetAlpha(AST.SV.alpha)
                end
                counter = counter + 1
            else
                if AST.SV.interval == 1000 then
                    element:SetText(AST.time(AST.Data.TrackerTimer[k], 0))
                else
                    element:SetText(string.format("%.1f", AST.time(AST.Data.TrackerTimer[k], 1)))
                end
                element:SetColor(255, 0, 0, 1)
                icon:SetColor(0.5, 0.5, 0.5, 1)

            end

            countAll = countAll + 1
        end

    end

    if AST.SV.healerui then
        for k, v in ipairs(AST.Data.HealerTimer) do
            local z = (k * 2 - 1)
            local x = k * 2

            if k <= 12 then
                if AST.time(v.firstsynergy, 1) <= 0.1 then
                    local element = ASTHealerUI:GetNamedChild("HealerTimer"..z)
                    element:SetText("0")
                    element:SetColor(255, 255, 255, 1)
                    count = count + 1
                else
                    local element = ASTHealerUI:GetNamedChild("HealerTimer"..z)
                    element:SetText(AST.time(AST.Data.HealerTimer[k].firstsynergy, 0))
                    element:SetColor(255, 0, 0, 1)
                end

                if not AST.SV.healer.onesynergy then
                    if AST.time(v.secondsynergy, 1) <= 0.1 then
                        local element = ASTHealerUI:GetNamedChild("HealerTimer"..x)
                        element:SetText("0")
                        element:SetColor(255, 255, 255, 1)
                        count = count + 1
                    else
                        local element = ASTHealerUI:GetNamedChild("HealerTimer"..x)
                        element:SetText(AST.time(AST.Data.HealerTimer[k].secondsynergy, 0))
                        element:SetColor(255, 0, 0, 1)
                    end
                end

                counttotal = counttotal + 2
            end
        end
    end

    if counter == countAll and count == counttotal then
        em:UnregisterForUpdate(AST.name.."Update")
    end
end

function AST.windowState()
    if AST.SV.windowstate then
        if AST.SV.trackerui then
            ASTGrid:SetHidden(true)
            HUD_SCENE:RemoveFragment(fragment)
            HUD_UI_SCENE:RemoveFragment(fragment)
        end

        if AST.SV.healerui then
            ASTHealerUI:SetHidden(true)
            HUD_SCENE:RemoveFragment(fragment2)
            HUD_UI_SCENE:RemoveFragment(fragment2)
        end

        d(zo_strformat("|cfd6a02[AiMs Synergy Tracker]|r |cffffffTrackers are now <<1>> outside of combat", "|cdc143chidden|r"))
    else
        if AST.SV.trackerui then
            ASTGrid:SetHidden(false)
            HUD_SCENE:AddFragment(fragment)
            HUD_UI_SCENE:AddFragment(fragment)
        end

        if AST.SV.healerui then
            ASTHealerUI:SetHidden(false)
            HUD_SCENE:AddFragment(fragment2)
            HUD_UI_SCENE:AddFragment(fragment2)
        end
        d(zo_strformat("|cfd6a02[AiMs Synergy Tracker]|r |cffffffTrackers are now <<1>> outside of combat", "|c32cd32visible|r"))
    end
end

function AST.HealerUIVisibility(value)
    if not value then
        ASTHealerUI:SetHidden(true)
        HUD_SCENE:RemoveFragment(fragment2)
        HUD_UI_SCENE:RemoveFragment(fragment2)
    else 
        ASTHealerUI:SetHidden(false)
        HUD_SCENE:AddFragment(fragment2)
        HUD_UI_SCENE:AddFragment(fragment2)
    end
end

function AST.combatState(event, inCombat)
    if not AST.SV.windowstate then
        if AST.SV.trackerui then
            HUD_SCENE:AddFragment(fragment)
            HUD_UI_SCENE:AddFragment(fragment)
        end

        if AST.SV.healerui then
            HUD_SCENE:AddFragment(fragment2)
            HUD_UI_SCENE:AddFragment(fragment2)
        end
    else
        if inCombat ~= combat then
            combat = inCombat
            if inCombat then
                if AST.SV.trackerui then
                    ASTGrid:SetHidden(false)
                end

                if AST.SV.healerui then
                    ASTHealerUI:SetHidden(false)
                end
            else
                if AST.SV.trackerui then
                    ASTGrid:SetHidden(true)
                end

                if AST.SV.healerui then
                    ASTHealerUI:SetHidden(true)
                end
            end
        end
        if AST.SV.trackerui then
            HUD_SCENE:RemoveFragment(fragment)
            HUD_UI_SCENE:RemoveFragment(fragment)
        end
        if AST.SV.healerui then
            HUD_SCENE:RemoveFragment(fragment2)
            HUD_UI_SCENE:RemoveFragment(fragment2)
        end
    end
end

function AST.LoadAlpha(value)
    if AST.SV.trackerui then
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

    if AST.SV.healerui then
        ASTHealerUIbdBackDrop:SetAlpha(value)
    end
end

function AST.LockWindow(value)
    if not value then
        if AST.SV.trackerui then
            ASTGrid:SetMovable(true)
        end

        if AST.SV.healerui then
            ASTHealerUI:SetMovable(true)
        end
    else
        if AST.SV.trackerui then
            ASTGrid:SetMovable(false)
        end

        if AST.SV.healerui then
            ASTHealerUI:SetMovable(false)
        end
    end
end

function AST.UpdateGroup()
    local gSize = GetGroupSize()

    AST.Data.HealerTimer = {}

    if gSize > 0 then
        local counter = 1
        for i = 1, gSize do
            local accName = GetUnitDisplayName("group" .. i)
            local role = GetGroupMemberAssignedRole("group" .. i)
            if (role ~= LFG_ROLE_HEAL and role ~= LFG_ROLE_INVALID and accName ~= "") then return; end --healers and offliner will be ignored
            if AST.SV.healer.tanksonly and role ~= LFG_ROLE_TANK then return; end --only tracking tanks, everythin else will be ignored
            if AST.SV.healer.ddsonly and role ~= LFG_ROLE_DD then return; end

            AST.Data.HealerTimer[counter] = {}
            AST.Data.HealerTimer[counter].name = accName
            AST.Data.HealerTimer[counter].firstsynergy = "0"
            AST.Data.HealerTimer[counter].secondsynergy = "0"
            AST.Data.HealerTimer[counter].role = role

            counter = counter + 1
        end
    end
end

function AST.GetUnitName(unitId)
    local unit = LibUnit:GetDisplayNameForUnitId(unitId)

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
    if AST.SV.trackerui then
        local left = AST.SV.left
        local top = AST.SV.top
        ASTGrid:ClearAnchors()
        ASTGrid:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
    end

    if AST.SV.healerui then
        local left = AST.SV.healer.left
        local top = AST.SV.healer.top

        ASTHealerUI:ClearAnchors()
        ASTHealerUI:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
    end
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