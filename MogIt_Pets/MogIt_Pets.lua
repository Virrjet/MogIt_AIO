local MogIt_Pets,p = ...;
local mog = MogIt;

local module = mog:GetModule("MogIt_Pets") or mog:RegisterModule("MogIt_Pets",{});
local pets = {};
local list = {};
local display = {};
local data = {
	display = {},
	family = {},
	lvl = {},
	item = {},
	zone = {},
	name = {},
	rare = {},
};

p.family = {
	name = {},
	icon = {},
	exotic = {},
};

function p.AddFamily(id,name,icon,exotic)
	p.family.name[id] = name;
	p.family.icon[id] = icon;
	p.family.exotic[id] = exotic;
end

local function AddData(id,display,name,family,lvl,item,zone,rare)
	data.display[id] = display;
	data.name[id] = name;
	data.family[id] = family;
	data.lvl[id] = lvl;
	data.item[id] = item;
	data.zone[id] = zone;
	data.rare[id] = rare;
end

function p.AddPet(id,...)
	tinsert(pets,id);
	AddData(id,...);
end

local function DropdownTier1(self)
	mog:SetModule(module,"Pets");
	CloseDropDownMenus();
end

function module.Dropdown(module,tier)
	local info;
	if tier == 1 then
		info = UIDropDownMenu_CreateInfo();
		info.text = module.label;
		info.value = module;
		info.colorCode = "\124cFF00FF00";
		--info.hasArrow = true;
		--info.keepShownOnClick = true;
		info.notCheckable = true;
		info.func = DropdownTier1;
		UIDropDownMenu_AddButton(info,tier);
	end
end

function module.FrameUpdate(module,self,value)
	self.data.display = value;
	self.data.pets = display[value];
	self.data.cycle = 1;
	self.data.pet = type(self.data.pets) ~= "table" and self.data.pets or self.data.pets[self.data.cycle];
--	self.model:SetDisplayInfo(self.data.display);
	self.model:SetModel("Interface\\Buttons\\TalkToMeQuestion_Grey.mdx");
	self.model:SetCreature(self.data.pet);
end

function module.OnEnter(module,self)
	if not self or not self.data.pet then return end;
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip[mog] = true;	

	local icon = "";
	local fam;
	if data.family[self.data.pet] then
		if p.family.icon[data.family[self.data.pet]] then
			icon = icon.."\124TInterface\\Icons\\"..p.family.icon[data.family[self.data.pet]]..":18\124t ";
		end
		if p.family.name[data.family[self.data.pet]] then
			fam = p.family.name[data.family[self.data.pet]];
			if p.family.exotic[data.family[self.data.pet]] then
				fam = fam.." \124cFFFF9900(Exotic)\124r";
			end
		end
	end
	
	GameTooltip:AddDoubleLine(icon..(data.name[self.data.pet] or " "),(type(self.data.pets) == "table") and (#self.data.pets > 1) and ("Pet %d/%d"):format(self.data.cycle,#self.data.pets),0,1,0,1,0,0);
	if data.item[self.data.pet] then
		local itemName = GetItemInfo(data.item[self.data.pet]);
		if itemName then
			GameTooltip:AddDoubleLine("Item:",itemName);
		end
	end
	if data.zone[self.data.pet] then
		local zone = GetMapNameByID(data.zone[self.data.pet]);
		if zone then
			GameTooltip:AddDoubleLine("Zone:",zone,nil,nil,nil,1,1,1);
		end
	end
	
	GameTooltip:AddLine(" ");
	local level;
	if data.lvl[self.data.pet] then
		level = ""..data.lvl[self.data.pet];
	end
	if data.rare[self.data.pet] then
		level = (level and level.." " or "").."\124cFF999999(Rare)\124r";
	end
	if level then
		GameTooltip:AddDoubleLine("Level:",level,nil,nil,nil,1,1,1);
	end
	if fam then
		GameTooltip:AddDoubleLine("Family:",fam,nil,nil,nil,1,1,1);
	end
	
	GameTooltip:AddLine(" ");
	GameTooltip:AddDoubleLine("ID:",self.data.pet,nil,nil,nil,1,1,1);
	
	GameTooltip:Show();
end

function module.OnClick(module,self,btn)
	if btn == "LeftButton" then
		if IsShiftKeyDown() then
			local _,link = GetItemInfo(data.item[self.data.pet]);
			if link then
				ChatEdit_InsertLink(link);
			end
		elseif type(self.data.pets) == "table" then
			self.data.cycle = (self.data.cycle == #self.data.pets and 1) or (self.data.cycle + 1);
			self.data.pet = self.data.pets[self.data.cycle];
			module:OnEnter(self);
		end
	elseif btn == "RightButton" then
		mog:ShowURL(self.data.pet,"npc");
	end
end

function module.Unlist(module)
	wipe(list);
	wipe(display);
	for k,v in ipairs(mog.models) do
		v.model:SetUnit("PLAYER");
	end
end

function module.GetFilterArgs(filter,pet)
	if filter == "name" then
		return data.name[pet];
	end
end

function module.BuildList(module)
	wipe(list);
	wipe(display);
	for k,v in ipairs(pets) do
		if mog:CheckFilters(module,v) then
			local disp = data.display[v];
			if not display[disp] then
				display[disp] = v;
				tinsert(list,disp);
			elseif type(display[disp]) == "table" then
				tinsert(display[disp],v);
			else
				display[disp] = {display[disp],v};
			end
		end
	end
	return list;
end

function module.Help(module)
	GameTooltip:AddDoubleLine("Change pet","Left click",0,1,0,1,1,1);
	GameTooltip:AddDoubleLine("Pet URL","Right click",0,1,0,1,1,1);
end

module.Help = {
	"Left click to cycle through pets",
	"Right click for pet URL",
};

module.filters = {
	"name",
};