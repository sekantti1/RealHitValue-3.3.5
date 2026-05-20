local _G = _G
local _, playerClass = UnitClass("player")

local function GetTalentHitBonus(statType)
    local hit = 0
    local debuffHit = 0
    local talentNames = {}
    local debuffNames = {}

    local function CheckTalent(tab, index, multiplier)
        local name, _, _, _, rank = GetTalentInfo(tab, index)
        if name and rank and rank > 0 then
            hit = hit + (rank * multiplier)
            table.insert(talentNames, name)
        end
    end

    local function CheckDebuff(tab, index, multiplier)
        local name, _, _, _, rank = GetTalentInfo(tab, index)
        if name and rank and rank > 0 then
            debuffHit = debuffHit + (rank * multiplier)
            table.insert(debuffNames, name)
        end
    end

    if playerClass == "MAGE" then
        if statType == "SPELL" then
            local maxPoints = -1
            local activeTree = 1
            for i = 1, 3 do
                local _, _, pointsSpent = GetTalentTabInfo(i)
                if pointsSpent and pointsSpent > maxPoints then
                    maxPoints = pointsSpent
                    activeTree = i
                end
            end

            if activeTree == 1 then
                CheckTalent(1, 2, 1.0) -- Arcane Focus
            end
            
            CheckTalent(3, 6, 1.0) -- Precision
        end

    elseif playerClass == "WARLOCK" then
        if statType == "SPELL" then
            CheckTalent(1, 2, 1.0) -- Suppression
        end

    elseif playerClass == "PRIEST" then
        if statType == "SPELL" then
            CheckTalent(3, 6, 1.0) -- Shadow Focus
            CheckDebuff(3, 22, 1.0) -- Misery
        end

    elseif playerClass == "DRUID" then
        if statType == "SPELL" then
            CheckTalent(1, 17, 2.0) -- Balance of Power
            CheckDebuff(1, 20, 1.0) -- Improved Faerie Fire
        end

    elseif playerClass == "SHAMAN" then
        if statType == "SPELL" then
            CheckTalent(1, 14, 1.0) -- Elemental Precision
        elseif statType == "MELEE" then
            CheckTalent(2, 17, 2.0) -- Dual Wield Specialization
        end

    elseif playerClass == "ROGUE" then
        if statType == "MELEE" or statType == "RANGED" then
            CheckTalent(2, 6, 1.0) -- Precision
        end

    elseif playerClass == "HUNTER" then
        if statType == "MELEE" or statType == "RANGED" then
            CheckTalent(2, 2, 1.0) -- Focused Aim
        end

    elseif playerClass == "WARRIOR" then
        if statType == "MELEE" or statType == "RANGED" then
            CheckTalent(2, 13, 1.0) -- Precision
        end

    elseif playerClass == "DEATHKNIGHT" then
        if statType == "SPELL" then
            CheckTalent(3, 2, 1.0) -- Virulence (Unholy Tab)
        elseif statType == "MELEE" then
            CheckTalent(2, 6, 1.0) -- Nerves of Cold Steel (Frost Tab)
        end
    end

    local nameString = ""
    if #talentNames > 0 then
        nameString = " (" .. table.concat(talentNames, ", ") .. ")"
    end

    local debuffNameString = ""
    if #debuffNames > 0 then
        debuffNameString = " (" .. table.concat(debuffNames, ", ") .. ")"
    end

    return hit, nameString, debuffHit, debuffNameString
end

local function UpdateHitTooltip(statFrame, statType)
    if not statFrame or not statFrame.tooltip2 then return end

    -- 1. Grab base hit from gear ratings and set up our cap constants
    local gearHit = 0
    local currentRating = 0
    local baseCap = 0
    local conversion = 0

    if statType == "MELEE" then
        gearHit = GetCombatRatingBonus(CR_HIT_MELEE)
        currentRating = GetCombatRating(CR_HIT_MELEE)
        baseCap = 263
        conversion = 32.8
    elseif statType == "RANGED" then
        gearHit = GetCombatRatingBonus(CR_HIT_RANGED)
        currentRating = GetCombatRating(CR_HIT_RANGED)
        baseCap = 263
        conversion = 32.8
    elseif statType == "SPELL" then
        gearHit = GetCombatRatingBonus(CR_HIT_SPELL)
        currentRating = GetCombatRating(CR_HIT_SPELL)
        baseCap = 446
        conversion = 26.23
    end

    -- 2. Grab bonuses
    local talentHit, talentNameStr, debuffHit, debuffNameStr = GetTalentHitBonus(statType)
    local totalHit = gearHit + talentHit + debuffHit
        
    -- 3. Append the breakdown
    statFrame.tooltip2 = statFrame.tooltip2 .. "\n\n|cffffffffHit Breakdown:|r"
    statFrame.tooltip2 = statFrame.tooltip2 .. "\n|cffccccccGear:|r |cff00ff00+" .. string.format("%.2f%%", gearHit) .. "|r"
        
    if talentHit > 0 then
        statFrame.tooltip2 = statFrame.tooltip2 .. "\n|cffccccccTalents:|r |cff00ff00+" .. string.format("%.2f%%", talentHit) .. "|r" .. talentNameStr
    else
        statFrame.tooltip2 = statFrame.tooltip2 .. "\n|cffccccccTalents:|r |cff00ff00+0.00%|r"
    end

    if debuffHit > 0 then
        statFrame.tooltip2 = statFrame.tooltip2 .. "\n|cffccccccDebuffs:|r |cff00ff00+" .. string.format("%.2f%%", debuffHit) .. "|r" .. debuffNameStr
    end
        
    statFrame.tooltip2 = statFrame.tooltip2 .. "\n\n|cffffd100Total Hit Chance:|r |cff00ff00" .. string.format("%.2f%%", totalHit) .. "|r"

    -- 4. Calculate the Rating Cap
    -- We subtract the rating value of your talents/debuffs from the base cap
    local effectiveCapRating = baseCap - ((talentHit + debuffHit) * conversion)
    local ratingDiff = currentRating - effectiveCapRating

    if ratingDiff > 0 then
        local overCapPct = ratingDiff / conversion
        statFrame.tooltip2 = statFrame.tooltip2 .. "\n|cffff2020Over Cap:|r |cffffffff" .. math.floor(ratingDiff + 0.5) .. " Rating|r |cffff2020(" .. string.format("+%.2f%%", overCapPct) .. ")|r"
    elseif ratingDiff < 0 then
        local underCapPct = math.abs(ratingDiff) / conversion
        statFrame.tooltip2 = statFrame.tooltip2 .. "\n|cffffff00Missing to Cap:|r |cffffffff" .. math.floor(math.abs(ratingDiff) + 0.5) .. " Rating|r |cffffff00(" .. string.format("%.2f%%", underCapPct) .. ")|r"
    else
        statFrame.tooltip2 = statFrame.tooltip2 .. "\n|cff00ff00Exactly Hit Capped!|r"
    end
end

-- Hook all 3 hit types through the single WotLK Rating function
hooksecurefunc("PaperDollFrame_SetRating", function(statFrame, ratingIndex)
    if ratingIndex == CR_HIT_MELEE then
        UpdateHitTooltip(statFrame, "MELEE")
    elseif ratingIndex == CR_HIT_RANGED then
        UpdateHitTooltip(statFrame, "RANGED")
    elseif ratingIndex == CR_HIT_SPELL then
        UpdateHitTooltip(statFrame, "SPELL")
    end
end)