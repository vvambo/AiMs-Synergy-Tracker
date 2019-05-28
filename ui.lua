----------------------
-- data namespace
----------------------
AST.UI = {}

----------------------
-- variables
----------------------
local U             = AST.UI
local wm            = WINDOW_MANAGER
local tlw           = nil
local hui           = nil


----------------------
-- Main Functions
----------------------

function U.TrackerUI(enabled)
    if not enabled then return; end

    U.TrackerBuildElements()
    U.UpdateElements()
end

function U.TrackerBuildElements()   
    U.TopLevelControl()
    U.BackdropControl()
    U.TrackerElements()
end


----------------------
-- Creating Elements
----------------------

function U.TopLevelControl()
    tlw = wm:CreateTopLevelWindow("ASTGrid")
    tlw:SetResizeToFitDescendents(true)
    tlw:SetAnchor(CENTER, GuiRoot, CENTER, 0,0)
    tlw:SetMovable(true)
    tlw:SetMouseEnabled(true)
    tlw:SetHandler("OnMoveStop", function(control)
        AST.SV.left = ASTGrid:GetLeft()
	    AST.SV.top  = ASTGrid:GetTop()
    end)
end

function U.BackdropControl()
    local bdBackdrop = wm:CreateControl("$(parent)bdBackDrop", tlw, CT_BACKDROP)
    bdBackdrop:SetEdgeColor(0.4,0.4,0.4, 0)
    bdBackdrop:SetCenterColor(0, 0, 0)
    bdBackdrop:SetAnchor(TOPLEFT, tlw, TOPLEFT, 0, 0)
    bdBackdrop:SetAlpha(0.8)
    bdBackdrop:SetDrawLayer(0)
end

function U.TrackerElements()
    local windowscale   = AST.SV.windowscale
    local fontSize      = 18
    local fontStyle     = "MEDIUM_FONT"        
    local fontWeight    = "thick-outline" 
    local astFont       = string.format("$(%s)|$(KB_%s)|%s", fontStyle, fontSize, fontWeight)

    for k, v in ipairs(AST.Data.TrackerTimer) do
        local SynergyIcon = wm:CreateControl("$(parent)SynergyIcon"..k, tlw, CT_TEXTURE)
        SynergyIcon:SetScale(1)
        SynergyIcon:SetDrawLayer(1)
        SynergyIcon:SetTexture(AST.Data.SynergyTexture[k])
        SynergyIcon:SetDimensions(40,40)

        local SynergyTimer = wm:CreateControl("$(parent)SynergyTimer"..k, tlw, CT_LABEL)
        SynergyTimer:SetColor(255, 255, 255, 1)
        SynergyTimer:SetFont(astFont)
        SynergyTimer:SetScale(1.0)
        SynergyTimer:SetWrapMode(TEX_MODE_CLAMP)
        SynergyTimer:SetDrawLayer(1)
        SynergyTimer:SetText("0.0")
    end
end

function U.UpdateElements()
    local check = {
        [1] = AST.SV.orb,
        [2] = AST.SV.liq,
        [3] = AST.SV.pur,
        [4] = AST.SV.hea,
        [5] = AST.SV.bon,
        [6] = AST.SV.blo,
        [7] = AST.SV.tra,
        [8] = AST.SV.rad,
        [9] = AST.SV.cha,
        [10] = AST.SV.sha,
        [11] = AST.SV.imp,
        [12] = AST.SV.gra,
        [13] = AST.SV.hir,
        [14] = AST.SV.sol,
        [15] = AST.SV.rob,
        [16] = AST.SV.ago,
    }
    local windowscale   = AST.SV.windowscale
    local counter       = 0
    
    for k, v in ipairs(check) do
        if v then
            ASTGrid:GetNamedChild("SynergyIcon"..k):SetHidden(false)
            ASTGrid:GetNamedChild("SynergyTimer"..k):SetHidden(false)
            U.SetIconPosition(ASTGrid, windowscale, counter, "SynergyIcon"..k)
            U.SetTimerPosition(ASTGrid, windowscale, counter, "SynergyTimer"..k, "SynergyIcon"..k)
            counter = counter + 1
        else 
            ASTGrid:GetNamedChild("SynergyIcon"..k):SetHidden(true)
            ASTGrid:GetNamedChild("SynergyTimer"..k):SetHidden(true)
        end
    end

    U.SetBackgroundDimensions(ASTGrid, windowscale, counter, "bdBackDrop")
end

function U.SetIconPosition(TopLevelControl, windowscale, counter, SynergyIcon)
    SynergyIcon = TopLevelControl:GetNamedChild(SynergyIcon)
    local bdBackDrop = TopLevelControl:GetNamedChild("bdBackDrop")

    if AST.SV.orientation == "vertical" then
        SynergyIcon:SetAnchor(TOPLEFT, bdBackDrop, TOPLEFT, 5 * windowscale, ( 5 + 45 * (counter) ) * windowscale )
    elseif AST.SV.orientation == "compact" then
        SynergyIcon:SetAnchor(TOPLEFT, bdBackDrop, TOPLEFT, ( 5 + 45 * (counter) ) * windowscale, 5 * windowscale)
    else
        SynergyIcon:SetAnchor(TOPLEFT, bdBackDrop, TOPLEFT, ( 5 + 90 * (counter) ) * windowscale, 5 * windowscale)
    end

    SynergyIcon:SetDimensions(40 * windowscale, 40 * windowscale)
end

function U.SetTimerPosition(TopLevelControl, windowscale, counter, SynergyTimer, SynergyIcon)
    SynergyIcon         = TopLevelControl:GetNamedChild(SynergyIcon)
    SynergyTimer        = TopLevelControl:GetNamedChild(SynergyTimer)
    local bdBackDrop    = TopLevelControl:GetNamedChild("bdBackDrop")

    if AST.SV.orientation == "vertical" then
        SynergyTimer:SetAnchor(CENTER, SynergyIcon, CENTER, 45 * windowscale, 0)
    elseif AST.SV.orientation == "compact" then
        SynergyTimer:SetAnchor(CENTER, SynergyIcon, CENTER, 0, 10 * windowscale)
    else
        SynergyTimer:SetAnchor(CENTER, SynergyIcon, CENTER, 45 * windowscale, 0)
    end

    SynergyTimer:SetScale(windowscale)
end

function U.SetBackgroundDimensions(TopLevelControl, windowscale, counter, bdBackDrop)
    if AST.SV.orientation == "vertical" then
        ASTGridbdBackDrop:SetDimensions(90 * windowscale,(5 + 45 * counter) * windowscale)
    elseif AST.SV.orientation == "compact" then
        ASTGridbdBackDrop:SetDimensions(5 + (45 * counter) * windowscale, 50 * windowscale)
    else
        ASTGridbdBackDrop:SetDimensions((10 + 90 * counter) * windowscale, 50 * windowscale)
    end
end

function U.EnableTracker(enabled)
    if not enabled then
        ASTGrid:SetHidden(enabled)
    else
        ASTGrid:SetHidden(not enabled) --not entirely sure if this works or not
    end
end


----------------------
-- Healer UI
----------------------

function U.HealerUI(enabled)
    if not enabled then return; end

    local healerui = wm:CreateTopLevelWindow("ASTHealerUI")
    healerui:SetResizeToFitDescendents(true)
    healerui:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
    healerui:SetMovable(true)
    healerui:SetMouseEnabled(true)

    local healeruiBackdrop = wm:CreateControl("$(parent)bdBackDrop", healerui, CT_BACKDROP)
    healeruiBackdrop:SetEdgeColor(0.4,0.4,0.4, 0)
    healeruiBackdrop:SetCenterColor(0, 0, 0)
    healeruiBackdrop:SetAnchor(TOPLEFT, healerui, TOPLEFT, 0, 0)
    healeruiBackdrop:SetAlpha(0.8)
    healeruiBackdrop:SetDrawLayer(0)
    healeruiBackdrop:SetDimensions(205, 40)

    U.HealerUIGroup(healerui, healeruiBackdrop)
    U.HealerUISynergies(healerui, healeruiBackdrop)
    U.HealerUITimer(healerui, healeruiBackdrop)
    U.HealerUIUpdate()
end

function U.HealerUIUpdate()
    AST.UpdateGroup()
    U.HealerUIGroupUpdate()
end

function U.HealerUIVisibility(value)
    ASTHealerUI:SetHidden(value)
end

function U.HealerUIGroup(healerui, healeruiBackdrop)
    for i = 1, 10 do
        local unit = wm:CreateControl("$(parent)UnitName"..i, healerui, CT_LABEL)
        unit:SetColor(255, 255, 255, 1)
        unit:SetFont("ZoFontGameSmall")
        unit:SetScale(1.0)
        unit:SetWrapMode(TEX_MODE_CLAMP)
        unit:SetDrawLayer(1)
        unit:SetText("")
        unit:SetAnchor(TOPLEFT, healeruiBackdrop, TOPLEFT, 5, 25 * i + 5)
        unit:SetDimensions(120, 20)
        unit:SetHidden(true)
    end
end

function U.HealerUIGroupUpdate()
    local units = 0

    --unit labels
    for x = 1, 10 do
        local unit = ASTHealerUI:GetNamedChild("UnitName"..x)

        if AST.Data.HealerTimer[x].name then 
            local unitclass = GetUnitClass(AST.Data.HealerTimer[x].name)
            unit:SetText("|t16:16:"..AST.Data.UnitClasses[unitclass].."|t "..AST.Data.HealerTimer[x].name)
            unit:SetHidden(false)
            units = units + 1
        else
            unit:SetText("")
            unit:SetHidden(true)
        end
    end

    units = units * 2
    
    --timer
    if units > 0 then
        for x = 1, units do
            local timer = ASTHealerUI:GetNamedChild("HealerTimer"..x)
            timer:SetHidden(false)
        end
    end

    local synergies = {AST.SV.healer.firstsynergy, AST.SV.healer.secondsynergy}

    --synergy textures
    for x = 1, 2 do
        local healeruisynergy = ASTHealerUI:GetNamedChild("HealerSynergy")
        healeruisynergy:SetTexture(D.SynergyTexture[synergies[x]])
    end

    --backdrop
    local backdrop = ASTHealerUI:GetNamedChild("bdBackDrop")
    backdrop:SetDimensions(205, 40 + (20 * units))
end

function U.HealerUISynergies(healerui, healeruiBackdrop)
    local synergies = {AST.SV.healer.firstsynergy, AST.SV.healer.secondsynergy}
    for i = 1, 2 do
        local healeruisynergy = wm:CreateControl("$(parent)HealerSynergy"..i, healerui, CT_TEXTURE)
        healeruisynergy:SetScale(1)
        healeruisynergy:SetDrawLayer(1)
        healeruisynergy:SetTexture(D.SynergyTexture[synergies[i]])
        healeruisynergy:SetDimensions(24,24)
        healeruisynergy:SetAnchor(TOPLEFT, healeruiBackdrop, TOPLEFT, 105 + (35 * i), 5)
    end
end

function U.HealerUITimer(healerui, healeruiBackdrop)
    local counter = 1
    for i = 1, 10 do
        for z = 1, 2 do
            local healeruitimer = wm:CreateControl("$(parent)HealerTimer"..counter, healerui, CT_LABEL)
            healeruitimer:SetColor(255, 255, 255, 1)
            healeruitimer:SetFont("ZoFontGameSmall")
            healeruitimer:SetScale(1.0)
            healeruitimer:SetWrapMode(TEX_MODE_CLAMP)
            healeruitimer:SetDrawLayer(1)
            healeruitimer:SetText("0")
            healeruitimer:SetAnchor(TOPLEFT, healeruiBackdrop, TOPLEFT, 114 + (35 * z), 25 * i + 5)
            healeruitimer:SetHidden(true)

            counter = counter + 1
        end
    end
end