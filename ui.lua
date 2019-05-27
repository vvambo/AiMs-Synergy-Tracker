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

    local tlw2 = wm:CreateTopLevelWindow("ASTHealerUI")
    tlw2:SetResizeToFitDescendents(true)
    tlw2:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
    tlw2:SetMovable(true)
    tlw2:SetMouseEnabled(true)

    local bdBackdrop = wm:CreateControl("$(parent)bdBackDrop", tlw2, CT_BACKDROP)
    bdBackdrop:SetEdgeColor(0.4,0.4,0.4, 0)
    bdBackdrop:SetCenterColor(0, 0, 0)
    bdBackdrop:SetAnchor(TOPLEFT, tlw2, TOPLEFT, 0, 0)
    bdBackdrop:SetAlpha(0.8)
    bdBackdrop:SetDrawLayer(0)
    bdBackdrop:SetDimensions(205, 275)

    U.HealerUIGroup(tlw2, bdBackdrop)
    U.HealerUISynergies(tlw2, bdBackdrop)
    U.HealerUITimer(tlw2, bdBackdrop)
    U.HealerUIUpdate()
end

function U.HealerUIUpdate()
    U.HealerUIGroupUpdate()
end

function U.HealerUIGroup(tlw2, bdBackdrop)
    for i = 1, 10 do
        local SynergyTimer = wm:CreateControl("$(parent)UnitName"..i, tlw2, CT_LABEL)
        SynergyTimer:SetColor(255, 255, 255, 1)
        SynergyTimer:SetFont("ZoFontGameSmall")
        SynergyTimer:SetScale(1.0)
        SynergyTimer:SetWrapMode(TEX_MODE_CLAMP)
        SynergyTimer:SetDrawLayer(1)
        SynergyTimer:SetText("|t16:16:esoui/art/icons/ability_necromancer_004_b.dds|t Skaloria Tateri "..i)
        SynergyTimer:SetAnchor(TOPLEFT, bdBackdrop, TOPLEFT, 5, 25 * i + 5)
        SynergyTimer:SetDimensions(120, 20)
        SynergyTimer:SetHidden(true)
    end
end

function U.HealerUIGroupUpdate()
    local group = AST.Data.HealerTimer

    for x = 1, 10 do
        
        local unit = ASTHealerUI:GetNamedChild("UnitName"..x)
        unit:SetText(group[x]["name"])
        unit:SetHidden(false)
    end
end

function U.HealerUISynergies(tlw2, bdBackdrop)
    local synergies = {AST.SV.healer.firstsynergy, AST.SV.healer.secondsynergy}
    for i = 1, 2 do
        local SynergyIcon = wm:CreateControl("$(parent)HealerSynergy"..i, tlw2, CT_TEXTURE)
        SynergyIcon:SetScale(1)
        SynergyIcon:SetDrawLayer(1)
        SynergyIcon:SetTexture(D.SynergyTexture[synergies[i]])
        SynergyIcon:SetDimensions(24,24)
        SynergyIcon:SetAnchor(TOPLEFT, bdBackdrop, TOPLEFT, 105 + (35 * i), 5)
    end
end

function U.HealerUITimer(tlw2, bdBackdrop)
    local counter = 1
    for i = 1, 10 do
        for z = 1, 2 do
            local HealerTimer = wm:CreateControl("$(parent)HealerTimer"..counter, tlw2, CT_LABEL)
            HealerTimer:SetColor(255, 255, 255, 1)
            HealerTimer:SetFont("ZoFontGameSmall")
            HealerTimer:SetScale(1.0)
            HealerTimer:SetWrapMode(TEX_MODE_CLAMP)
            HealerTimer:SetDrawLayer(1)
            HealerTimer:SetText("0")
            HealerTimer:SetAnchor(TOPLEFT, bdBackdrop, TOPLEFT, 114 + (35 * z), 25 * i + 5)
            HealerTimer:SetHidden(true)

            counter = counter + 1
        end
    end
end