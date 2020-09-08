AST.Healer = {}

local H = AST.Healer
local wm = WINDOW_MANAGER
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
    healeruiBackdrop:SetAlpha(AST.SV.healer.alpha)
    healeruiBackdrop:SetDrawLayer(0)
    healeruiBackdrop:SetDimensions(205, 40)

    H.HealerUIGroup(healerui, healeruiBackdrop)
    H.HealerUISynergies(healerui, healeruiBackdrop)
    H.HealerUITimer(healerui, healeruiBackdrop)

    H.HealerUIUpdate()
    H.SetHealerPosition()
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

    local backdrop = ASTHealerUI:GetNamedChild("bdBackDrop")
    backdrop:SetAlpha(AST.SV.healer.alpha)
	
	local synergies = {
        [1] = AST.SV.healer.firstsynergy, 
        [2] = AST.SV.healer.secondsynergy,
		[3] = AST.SV.healer.thirdsynergy,
		[4] = AST.SV.healer.fourthsynergy,
    }

	local activeCount = 0
	for i=1,#synergies do
		if (synergies[i] ~= 99) then
			activeCount = activeCount + 1
		end	
	end

    backdrop:SetDimensions(135 + activeCount * 35, 35 + (24 * units))


    units = units * 4

    for x = 1, 40 do
       local timer = ASTHealerUI:GetNamedChild("HealerTimer"..x)
       timer:SetHidden(true)
    end

    if units > 0 then
		local synTimer = 1
        for x = 1, units do
			--TODO: Ugly, refactor synTimer
            local timer = ASTHealerUI:GetNamedChild("HealerTimer"..x)
			if (synergies[synTimer]) == 99 then
				timer:SetHidden(true)
			else
				timer:SetHidden(false)	
			end	
			
			synTimer = synTimer +1
			if synTimer >= 5 then
				synTimer = 1
			end

        end
    end
	
    for x = 1, 4 do
		if (synergies[x] ~= 99) then
			ASTHealerUI:GetNamedChild("HealerSynergy"..x):SetHidden(false)
			local healeruisynergy = ASTHealerUI:GetNamedChild("HealerSynergy"..x)
			healeruisynergy:SetTexture(AST.Data.SynergyTexture[synergies[x]])
		else
			ASTHealerUI:GetNamedChild("HealerSynergy"..x):SetHidden(true)
		end
    end
end

function H.HealerUISynergies(healerui, healeruiBackdrop)
    local synergies = {AST.SV.healer.firstsynergy, AST.SV.healer.secondsynergy, AST.SV.healer.thirdsynergy, AST.SV.healer.fourthsynergy}
    for i = 1, 4 do
		--if (synergies[i] ~= 99) then
			local healeruisynergy = wm:CreateControl("$(parent)HealerSynergy"..i, healerui, CT_TEXTURE)
			healeruisynergy:SetScale(1)
			healeruisynergy:SetDrawLayer(1)
			healeruisynergy:SetTexture(D.SynergyTexture[synergies[i]])
			healeruisynergy:SetDimensions(24,24)
			healeruisynergy:SetAnchor(TOPLEFT, healeruiBackdrop, TOPLEFT, 105 + (35 * i), 5)
		--end
    end
end

function H.HealerUITimer(healerui, healeruiBackdrop)
    local counter = 1
	local synergies = {AST.SV.healer.firstsynergy, AST.SV.healer.secondsynergy, AST.SV.healer.thirdsynergy, AST.SV.healer.fourthsynergy}
    for i = 1, 10 do
        for z = 1, 4 do
			--if (synergies[i] ~= 99) then
				local healeruitimer = wm:CreateControl("$(parent)HealerTimer"..counter, healerui, CT_LABEL)
				healeruitimer:SetColor(255, 255, 255, 1)
				healeruitimer:SetFont("ZoFontWinT2")
				healeruitimer:SetScale(1.0)
				healeruitimer:SetWrapMode(TEX_MODE_CLAMP)
				healeruitimer:SetDrawLayer(1)
				healeruitimer:SetText("0")
				healeruitimer:SetAnchor(CENTER, healeruiBackdrop, TOPLEFT, 116 + (35 * z), 25 * i + 15)
				healeruitimer:SetHidden(true)
			--end
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
            if (role ~= LFG_ROLE_HEAL and role ~= LFG_ROLE_INVALID and accName ~= "") then
                if AST.SV.healer.tanksonly then
                    if role == 2 then
                        AST.Data.HealerTimer[counter] = {}
                        AST.Data.HealerTimer[counter].name = accName
                        AST.Data.HealerTimer[counter].firstsynergy = "0"
                        AST.Data.HealerTimer[counter].secondsynergy = "0"
						AST.Data.HealerTimer[counter].thirdsynergy = "0"
						AST.Data.HealerTimer[counter].fourthsynergy = "0"
                        AST.Data.HealerTimer[counter].role = role

                        counter = counter + 1
                    end
                elseif AST.SV.healer.ddsonly then
                    if role == 1 then
                        AST.Data.HealerTimer[counter] = {}
                        AST.Data.HealerTimer[counter].name = accName
                        AST.Data.HealerTimer[counter].firstsynergy = "0"
                        AST.Data.HealerTimer[counter].secondsynergy = "0"
						AST.Data.HealerTimer[counter].thirdsynergy = "0"
						AST.Data.HealerTimer[counter].fourthsynergy = "0"
                        AST.Data.HealerTimer[counter].role = role

                        counter = counter + 1
                    end
                else
                    AST.Data.HealerTimer[counter] = {} 
                    AST.Data.HealerTimer[counter].name = accName
                    AST.Data.HealerTimer[counter].firstsynergy = "0"
                    AST.Data.HealerTimer[counter].secondsynergy = "0"
					AST.Data.HealerTimer[counter].thirdsynergy = "0"
					AST.Data.HealerTimer[counter].fourthsynergy = "0"
                    AST.Data.HealerTimer[counter].role = role

                    counter = counter + 1
                end
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
