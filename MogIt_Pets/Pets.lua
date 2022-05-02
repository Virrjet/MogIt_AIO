local a,t=...
local p=t.AddPet
t.AddFamily(1,"Wolf","Ability_Hunter_Pet_Wolf",nil)
t.AddFamily(2,"Cat","Ability_Hunter_Pet_Cat",nil)
t.AddFamily(3,"Spider","Ability_Hunter_Pet_Spider",nil)
t.AddFamily(4,"Bear","Ability_Hunter_Pet_Bear",nil)
t.AddFamily(5,"Boar","Ability_Hunter_Pet_Boar",nil)
t.AddFamily(6,"Crocolisk","Ability_Hunter_Pet_Crocolisk",nil)
t.AddFamily(7,"Carrion Bird","Ability_Hunter_Pet_Vulture",nil)
t.AddFamily(8,"Crab","Ability_Hunter_Pet_Crab",nil)
t.AddFamily(9,"Gorilla","Ability_Hunter_Pet_Gorilla",nil)
t.AddFamily(11,"Raptor","Ability_Hunter_Pet_Raptor",nil)
t.AddFamily(12,"Tallstrider","Ability_Hunter_Pet_TallStrider",nil)
t.AddFamily(20,"Scorpid","Ability_Hunter_Pet_Scorpid",nil)
t.AddFamily(21,"Turtle","Ability_Hunter_Pet_Turtle",nil)
t.AddFamily(24,"Bat","Ability_Hunter_Pet_Bat",nil)
t.AddFamily(25,"Hyena","Ability_Hunter_Pet_Hyena",nil)
t.AddFamily(26,"Bird of Prey","Ability_Hunter_Pet_Owl",nil)
t.AddFamily(27,"Wind Serpent","Ability_Hunter_Pet_WindSerpent",nil)
t.AddFamily(30,"Dragonhawk","Ability_Hunter_Pet_DragonHawk",nil)
t.AddFamily(31,"Ravager","Ability_Hunter_Pet_Ravager",nil)
t.AddFamily(32,"Warp Stalker","Ability_Hunter_Pet_WarpStalker",nil)
t.AddFamily(33,"Sporebat","Ability_Hunter_Pet_Sporebat",nil)
t.AddFamily(34,"Nether Ray","Ability_Hunter_Pet_NetherRay",nil)
t.AddFamily(35,"Serpent","Spell_Nature_GuardianWard",nil)
t.AddFamily(38,"Chimaera","Ability_Hunter_Pet_Chimera",true)
t.AddFamily(37,"Moth","Ability_Hunter_Pet_Moth",nil)
t.AddFamily(39,"Devilsaur","Ability_Hunter_Pet_Devilsaur",true)
t.AddFamily(41,"Silithid","Ability_Hunter_Pet_Silithid",true)
t.AddFamily(42,"Worm","Ability_Hunter_Pet_Worm",true)
t.AddFamily(43,"Rhino","Ability_Hunter_Pet_Rhino",true)
t.AddFamily(44,"Wasp","Ability_Hunter_Pet_Wasp",nil)
t.AddFamily(45,"Core Hound","Ability_Hunter_Pet_CoreHound",true)
t.AddFamily(46,"Spirit Beast","Ability_Druid_PrimalPrecision",true)

p(69,4124,"Diseased Timber Wolf",1,2,79337,nil,nil)

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
    local contentsPreview = v.creaturePreview or 0
    local learnedSpell = v.learnedSpell or 0
    if contentsPreview and contentsPreview and (
        v.group == Enum.VanityFlags.TamedPets.SummonStone or 
        v.group == Enum.VanityFlags.TamedPets.Vellum or 
        v.group == Enum.VanityFlags.TamedPets.Whistle
    ) then
        p(contentsPreview, itemID, itemName, 1, 1, itemID, nil, nil)
    end
end


--m(DisplayID,SpellID,ItemID)