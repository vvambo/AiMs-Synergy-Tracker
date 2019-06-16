AST.Healer = {}

local H = AST.Healer
local wm = WINDOW_MANAGER
local tlw = nil
local hui = nil

function H:Initialize(enabled)
    if not enabled then return; end

    EVENT_MANAGER:RegisterForEvent(AST.name.."GroupUpdate",EVENT_GROUP_MEMBER_JOINED ,  AST.Healer.HealerUIUpdate)
    EVENT_MANAGER:RegisterForEvent(AST.name.."GroupUpdate",EVENT_GROUP_MEMBER_LEFT ,  AST.Healer.HealerUIUpdate)
    EVENT_MANAGER:RegisterForEvent(AST.name.."GroupUpdate",EVENT_GROUP_MEMBER_ROLE_CHANGED ,  AST.Healer.HealerUIUpdate)

    local healerui = wm:CreateTopLevelWindow("ASTHealerUI")
    healerui:SetResizeToFitDescendents(true)
    healerui:SetMovable(true)
    healerui:SetMouseEnabled(true)
    healerui:SetHandler("OnMoveStop", function(control)
        AST.SV.healer.left = ASTHealerUI:GetLeft()
	    AST.SV.healer.top  = ASTHealerUI:GetTop()
    end)

    local healeruiBackdrop = wm:CreateControl("$(parent)bdBackDrop", healerui, CT_BACKDROP)
    healeruiBackdrop:SetEdgeColor(0.4,0.4,0.4, 0)
    healeruiBackdrop:SetCenterColor(0, 0, 0)
    healeruiBackdrop:SetAnchor(TOPLEFT, healerui, TOPLEFT, 0, 0)
    healeruiBackdrop:SetAlpha(0.8)
    healeruiBackdrop:SetDrawLayer(0)
    healeruiBackdrop:SetDimensions(205, 40)

    H.HealerUIGroup(healerui, healeruiBackdrop)
    H.HealerUISynergies(healerui, healeruiBackdrop)
    H.HealerUITimer(healerui, healeruiBackdrop)

    H.HealerUIUpdate()
    H.SetHealerPosition()
    H.SetHealerAlpha(AST.SV.alpha)
    H.SetWindowLock(AST.SV.lockwindow)
end

function H.HealerUIGroup(healerui, healeruiBackdrop)
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

function H.HealerUIGroupUpdate()
    local units = 0

    --unit labels
    for x = 1, 10 do
        local unit = ASTHealerUI:GetNamedChild("UnitName"..x)
        unit:SetText("")
        unit:SetHidden(true)
    end


    for k, v in pairs(AST.Data.HealerTimer) do
        if k <= 10 then
            local unit = ASTHealerUI:GetNamedChild("UnitName"..k)
            unit:SetText("|t16:16:"..AST.Data.UnitType[v.role].."|t "..v.name)
            unit:SetHidden(false)
            units = units + 1
        end
    end

    --backdrop
    local backdrop = ASTHealerUI:GetNamedChild("bdBackDrop")
    backdrop:SetDimensions(205, 35 + (24 * units))

    units = units * 2
    
    --timer
    for x = 1, 20 do
        local timer = ASTHealerUI:GetNamedChild("HealerTimer"..x)
        timer:SetHidden(true)
    end

    if units > 0 then
        for x = 1, units do
            local timer = ASTHealerUI:GetNamedChild("HealerTimer"..x)
            timer:SetHidden(false)
        end
    end

    local synergies = {
        [1] = AST.SV.healer.firstsynergy, 
        [2] = AST.SV.healer.secondsynergy,
    }

    --synergy textures
    for x = 1, 2 do
        local healeruisynergy = ASTHealerUI:GetNamedChild("HealerSynergy"..x)
        healeruisynergy:SetTexture(AST.Data.SynergyTexture[synergies[x]])
    end
end

function H.HealerUISynergies(healerui, healeruiBackdrop)
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

function H.HealerUITimer(healerui, healeruiBackdrop)
    local counter = 1
    for i = 1, 10 do
        for z = 1, 2 do
            local healeruitimer = wm:CreateControl("$(parent)HealerTimer"..counter, healerui, CT_LABEL)
            healeruitimer:SetColor(255, 255, 255, 1)
            healeruitimer:SetFont("ZoFontWinT2")
            healeruitimer:SetScale(1.0)
            healeruitimer:SetWrapMode(TEX_MODE_CLAMP)
            healeruitimer:SetDrawLayer(1)
            healeruitimer:SetText("0")
            healeruitimer:SetAnchor(CENTER, healeruiBackdrop, TOPLEFT, 116 + (35 * z), 25 * i + 15)
            healeruitimer:SetHidden(true)

            counter = counter + 1
        end
    end
end

function H.UpdateGroup()
    local gSize = GetGroupSize()

    AST.Data.HealerTimer = {}

    if gSize > 0 then
        local counter = 1
        for i = 1, gSize do
            local accName = GetUnitDisplayName("group" .. i)
            local role = GetGroupMemberAssignedRole("group" .. i)
            if (role ~= LFG_ROLE_HEAL and role ~= LFG_ROLE_INVALID and accName ~= "") then --healers and offliner will be ignored
                if not AST.SV.healer.tanksonly and role == LFG_GROUP_TANK then --only track tanks
                    AST.Data.HealerTimer[counter] = {}
                    AST.Data.HealerTimer[counter].name = accName
                    AST.Data.HealerTimer[counter].firstsynergy = "0"
                    AST.Data.HealerTimer[counter].secondsynergy = "0"
                    AST.Data.HealerTimer[counter].role = role
                else
                    AST.Data.HealerTimer[counter] = {} 
                    AST.Data.HealerTimer[counter].name = accName
                    AST.Data.HealerTimer[counter].firstsynergy = "0"
                    AST.Data.HealerTimer[counter].secondsynergy = "0"
                    AST.Data.HealerTimer[counter].role = role
                end

                counter = counter + 1
            end
        end
    end
end

function H.HealerUIUpdate()
    H.UpdateGroup()
    H.HealerUIGroupUpdate()
end

function H.SetHealerPosition()
    local left = AST.SV.healer.left
    local top = AST.SV.healer.top

    ASTHealerUI:ClearAnchors()
    ASTHealerUI:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end

function H.SetHealerAlpha(value)
    ASTHealerUIbdBackDrop:SetAlpha(value)
end

function H.SetWindowLock()
    if not value then
        if AST.SV.healerui then
            ASTHealerUI:SetMovable(true)
        end
    else
        if AST.SV.healerui then
            ASTHealerUI:SetMovable(false)
        end
    end
end