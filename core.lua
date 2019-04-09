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

----------------------
-- other variables
----------------------
local combat        = IsUnitInCombat("player")
local wrapper       = nil
local fragment      = nil

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
        ["orb"] = true,
        ["liq"] = true,
        ["pur"] = true,
        ["hea"] = true,
        ["bon"] = false,
        ["blo"] = false,
        ["tra"] = false,
        ["rad"] = false,
        ["cha"] = false,
        ["sha"] = false,
        ["imp"] = false,
        ["gra"] = false,
        ["hir"] = false,
        ["sol"] = false,
    }
}

----------------------
-- AddOn Initialize
----------------------
function AST:Initialize()
    em:RegisterForEvent(AST.name.."Combat", EVENT_PLAYER_COMBAT_STATE, AST.combatState)

    --local LibUnit = LibStub:GetLibrary("LibUnits")

    for k, v in pairs(AST.Data.SynergyData) do
        em:RegisterForEvent(AST.name.."Synergy"..k, EVENT_COMBAT_EVENT , AST.synergyCheck)
        em:AddFilterForEvent(AST.name.."Synergy"..k, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, k)
    end

    AST.SV = ZO_SavedVars:New(AST.varName, AST.varVersion, nil, AST.default)

    AST.UI.TrackerUI(true)
    AST.UI.HealerUI(false)

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

function AST.synergyCheck(eventCode, result, _, abilityName, _, _, _, sourceType, _, _, _, _, _, _, sourceUnitId, targetUnitId, abilityId)
    if sourceType == COMBAT_UNIT_TYPE_NONE or 
        sourceType == COMBAT_UNIT_TYPE_PLAYER_PET or 
        sourceType == COMBAT_UNIT_TYPE_OTHER then 
            return;
    end

    local start = GetFrameTimeSeconds()

    if sourceType == COMBAT_UNIT_TYPE_PLAYER then

        if AST.Data.SynergyData[abilityId].group == 1 then

            if result == 2240 then
                AST.Data.TrackerTimer[1] = start + AST.Data.SynergyData[abilityId].cooldown
            end
        else
            AST.Data.TrackerTimer[AST.Data.SynergyData[abilityId].group] = start + AST.Data.SynergyData[abilityId].cooldown
        end
    end

    if sourceType == COMBAT_UNIT_TYPE_GROUP then
        --healerui
    end

    em:RegisterForUpdate(AST.name.."Update", AST.SV.interval, AST.countDown)
end

function AST.countDown()
    local counter   = 0
    local countAll  = 0

    for k, v in ipairs(AST.Data.TrackerTimer) do
        local element   = ASTGrid:GetNamedChild("SynergyTimer"..k)
        local icon      = ASTGrid:GetNamedChild("SynergyIcon"..k)

        if AST.time(v) <= 0.1 then
            element:SetText("0.0")
            element:SetColor(255, 255, 255, 1)
            icon:SetColor(1, 1, 1, 1)

            counter = counter + 1
        else
            element:SetText(string.format("%.1f", AST.time(AST.Data.TrackerTimer[k])))
            element:SetColor(255, 0, 0, 1)
            icon:SetColor(0.5, 0.5, 0.5, 1)

        end

        countAll = countAll + 1
    end

    if counter == countAll then
        em:UnregisterForUpdate(AST.name.."Update")
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

----------------------
-- Supporting Functions
----------------------
function AST.time(nd)
	return math.floor((nd - GetGameTimeMilliseconds()/1000) * 10 + 0.5)/10
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