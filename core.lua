----------------------
-- AST namespace and settings related variables
----------------------
AST                 = {}
AST.name            = "AiMs-Synergy-Tracker"
AST.author          = "AiMPlAyEr [EU]"
AST.version         = "4.1.1"
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
local combat                = IsUnitInCombat("player")
local wrapper, wrapper2     = nil, nil
local fragment, fragment2   = nil, nil
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
    ["windowstate"] = false,
    ["windowscale"] = 1,
    ["left"]        = 500,
    ["top"]         = 500,
    ["orientation"] = "horizontal",
    ["alpha"]       = 0.8,
    ["lockwindow"]  = false,
    ["trackerui"]   = true,
    ["healerui"]    = false,
    ["interval"]    = 50,
    ["textures"]    = false,
    ["healer"]      = {
        ["left"]            = 500,
        ["top"]             = 500,
        ["tanksonly"]       = true,
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
        em:RegisterForEvent(AST.name.."Synergy"..k,EVENT_COMBAT_EVENT , AST.Tracking.synergyCheck)
        em:AddFilterForEvent(AST.name.."Synergy"..k,EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, k)
    end

    AST.SV = ZO_SavedVars:New(AST.varName, AST.varVersion, nil, AST.default)

    --workaround
    --they will be removed as soon as a new major patch arrives
    if AST.SV.healer.firstsynergy == nil then AST.SV.healer.firstsynergy = 1 end
    if AST.SV.healer.secondsynergy == nil then AST.SV.healer.secondsynergy = 2 end

    AST.Tracker:Initialize(AST.SV.trackerui)
    AST.Healer:Initialize(AST.SV.healerui)

    if AST.SV.trackerui then wrapper, fragment = ASTGrid, ZO_SimpleSceneFragment:New(wrapper) end
    if AST.SV.healerui then wrapper2, fragment2 = ASTHealerUI, ZO_SimpleSceneFragment:New(wrapper2) end

    AST.LoadSettings()
    AST.combatState()
end

----------------------
-- Main Functions
----------------------

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
                if AST.SV.trackerui then ASTGrid:SetHidden(false) end
                if AST.SV.healerui then ASTHealerUI:SetHidden(false) end
            else
                if AST.SV.trackerui then ASTGrid:SetHidden(true) end
                if AST.SV.healerui then ASTHealerUI:SetHidden(true) end
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

----------------------
-- Supporting Functions
----------------------
function AST.time(nd, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
	return math.floor((nd - GetGameTimeMilliseconds()/1000) * mult + 0.5)/mult
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