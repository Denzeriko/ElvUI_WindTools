local E = unpack(ElvUI);
local LSM = LibStub("LibSharedMedia-3.0")
local _G = _G
-- ѡ����ϲ������ɫ
local borderr, borderg, borderb = 0, 0, 0
local backdropr, backdropg, backdropb = 0, 0, 0

-- ��Ӱ����

function CreateMyShadow(frame, size)
	local shadow = CreateFrame("Frame", nil, frame)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(frame:GetFrameStrata())
	shadow:SetOutside(frame, size, size)
	shadow:SetBackdrop( {
		edgeFile = LSM:Fetch("border", "ElvUI GlowBorder"), edgeSize = E:Scale(5),
		insets = {left = E:Scale(5), right = E:Scale(5), top = E:Scale(5), bottom = E:Scale(5)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.8)
	frame.shadow = shadow
end

-- ������Ӱ
FrameListSize3 = {
	"GameTooltip", -- �����ʾ
}

for i, frameName in ipairs(FrameListSize3) do
    local tempFrame = _G[frameName]
    CreateMyShadow(tempFrame, 3)
end

FrameListSize5 = {
	"MMHolder", -- С��ͼ
	"GameMenuFrame", -- ��Ϸ�˵�
	"SplashFrame", -- ȫ����ɫ
	"InterfaceOptionsFrame", -- ����ѡ��
	"VideoOptionsFrame", -- ϵͳѡ��
}

for i, frameName in ipairs(FrameListSize5) do
    local tempFrame = _G[frameName]
    CreateMyShadow(tempFrame, 5)
end