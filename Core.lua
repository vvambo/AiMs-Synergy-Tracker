AST                         = AST or {}
AST.name                    = "AiMs-Synergy-Tracker"
AST.author                  = "AiMPlAyEr [EU]"
AST.version                 = "4.3"
AST.website                 = "http://www.esoui.com/downloads/info2084-AiMsSynergyTracker.html"
AST.menuname                = "AiMs Synergy Tracker"
AST.varVersion              = 7
AST.default                 = nil
AST.varName                 = "ASTSaved"

local AST                   = AST
local EM                    = EVENT_MANAGER
local LIBUNIT               = LibUnits4
local IS_PLAYER_IN_COMBAT   = IsUnitInCombat("player")
local TRACKER_WRAPPER       = nil
local TRACKER_FRAGMENT      = nil
local HEALER_WRAPPER        = nil
local HEALER_FRAGMENT       = nil

function AST:Initialize()
    EM:RegisterForEvent(AST.name.."Combat", EVENT_PLAYER_COMBAT_STATE, AST.combatState)

    for k, v in pairs(AST.Data.SynergyData) do
        EM:RegisterForEvent(AST.name.."Synergy"..k, EVENT_COMBAT_EVENT, AST.Tracking.synergyCheck)
        EM:AddFilterForEvent(AST.name.."Synergy"..k, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, k)
    end

    AST.SV = ZO_SavedVars:New(AST.varName, AST.varVersion, nil, AST.Data.default)

    if not AST.SV.healer.firstsynergy then AST.SV.healer.firstsynergy = 1 end
    if not AST.SV.healer.secondsynergy then AST.SV.healer.secondsynergy = 2 end

    AST.Tracker:Initialize(AST.SV.trackerui)
    AST.Healer:Initialize(AST.SV.healerui)

    if AST.SV.trackerui then 
        TRACKER_WRAPPER     = ASTGrid
        TRACKER_FRAGMENT    = ZO_SimpleSceneFragment:New(TRACKER_WRAPPER) 
    end
    if AST.SV.healerui then 
        HEALER_WRAPPER  = ASTHealerUI
        HEALER_FRAGMENT = ZO_SimpleSceneFragment:New(HEALER_WRAPPER) 
    end

    AST.LoadSettings()
    AST.combatState()
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
        if inCombat ~= IS_PLAYER_IN_COMBAT then
            IS_PLAYER_IN_COMBAT = inCombat
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

SLASH_COMMANDS["/asttoggle"]   = AST.windowState

function AST.OnAddOnLoaded(event, addonName)
    if addonName ~= AST.name then return end
    EM:UnregisterForEvent(AST.name, EVENT_ADD_ON_LOADED)
    AST:Initialize()
end

EM:RegisterForEvent(AST.name, EVENT_ADD_ON_LOADED, AST.OnAddOnLoaded)