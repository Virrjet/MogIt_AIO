local MogIt_Companions,c = ...;
local m=c.AddCompanion
local mog = MogIt;

local module = mog:GetModule("MogIt_Companions") or mog:RegisterModule("MogIt_Companions",{});
local companions = {};
local list = {};
local data = {
	spell = {},
	item = {},
};

function c.AddCompanion(display,spell,item)
	tinsert(companions,display);
	data.spell[display] = spell;
	data.item[display] = item;
end

local function DropdownTier1(self)
	mog:SetModule(self.value,"Companions");
	CloseDropDownMenus();
end

function module.Dropdown(module,tier)
	local info;
	if tier == 1 then
		info = UIDropDownMenu_CreateInfo();
		info.text = module.label;
		info.value = module;
		info.colorCode = "\124cFF00FF00";
		info.notCheckable = true;
		info.func = DropdownTier1;
		UIDropDownMenu_AddButton(info,tier);
	end
end

function module.FrameUpdate(module,self,value)
	self.data.display = value;
	self.data.spell = data.spell[value];
	self.data.item = data.item[value];
	self.model:SetModel("Interface\\Buttons\\TalkToMeQuestion_Grey.mdx");
	self.model:SetCreature(value);
	--print(value)
end

function module.OnEnter(module,self)
	if not self or not self.data.display then return end;
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip[mog] = true;

	local name,_,icon = GetSpellInfo(self.data.spell);
	local link = GetSpellLink(self.data.spell);
	GameTooltip:AddLine("\124T"..(icon or "")..":18\124t "..(link or name or ""),0,1,0);
	if self.data.item then
		TryCacheItem(self.data.item)
		local itemName = GetItemInfo(self.data.item);
		if itemName then
			GameTooltip:AddDoubleLine("Item:",itemName);
		end
	end

	GameTooltip:Show();
end

function module.OnClick(module,self,btn)
	if btn == "LeftButton" then
		if IsShiftKeyDown() then
			local link = GetSpellLink(self.data.spell);
			if link then
				ChatEdit_InsertLink(link);
			end
		elseif IsControlKeyDown() then
			if self.data.item then
				local _,link = GetItemInfo(self.data.item);
				if link then
					ChatEdit_InsertLink(link);
				end
			end
		end
	elseif btn == "RightButton" then
		if IsShiftKeyDown() then
			mog:ShowURL(self.data.spell,"spell");
		elseif IsControlKeyDown() then
			if self.data.item then
				mog:ShowURL(self.data.item);
			end
		end
	end
end

function module.Unlist(module)
	wipe(list);
	for k,v in ipairs(mog.models) do
		v.model:SetUnit("PLAYER");
		--v.model:SetModel("Interface\\Buttons\\TalkToMeQuestion_Grey.mdx");
	end
end

function module.BuildList(module)
	wipe(list);
	for k,v in ipairs(companions) do
		tinsert(list,v);
	end
	return list;
end

module.Help = {

	"Shift-left click to link spell",
	"Shift-right click for spell URL",
	"Ctrl-left click to link item",
	"Ctrl-right click for item URL",
};