local a,t=...
local m=t.AddMount

-- local function refresh_vanity()
--     local jsonData = LoadAscensionContentJSON("VanityCollectionData")
--     jsonData = jsonData and C_Serialize:FromJSON(jsonData)

--     assert(jsonData, "Data\\VanityItems: Failed to deserialize Data\\Content\\VanityCollectionData.json")

--     for _, data in ipairs(jsonData) do
--         VANITY_ITEMS[data.itemid] = tcopy(data)

--         if data.learnedSpell and data.learnedSpell > 0 then
--             VANITY_SPELL_REFERENCE[data.learnedSpell] = data.itemid
--         end

--         if data.contentsPreview and data.contentsPreview ~= "" then 
--             local items = string.SplitToTable(data.contentsPreview, " ", tonumber)
--             for _, itemId in ipairs(items) do
--                 VANITY_CONTENT_REFERENCE[itemId] = data.itemid
--             end
--         end
--     end
-- end

-- refresh_vanity()

for k,v in pairs(VANITY_ITEMS) do
    local itemID = v.itemid or 0
    TryCacheItem(itemID)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType,
    itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemID)
    if(v.group == Enum.VanityFlags.Mounts) then
        local mount = v.creaturePreview
        local learnedSpell = v.learnedSpell or 0
        if mount and learnedSpell then
            m(mount, learnedSpell, itemID)
        end
    end
end


--m(DisplayID,SpellID,ItemID)