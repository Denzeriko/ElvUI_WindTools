local W, F, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.Libs.LSM
local format, pairs, tonumber, type = format, pairs, tonumber, type
local strlen, strsub, strfind, tinsert = strlen, strsub, strfind, tinsert

--[[
    从数据库设定字体样式
    @param {object} text FontString 型对象
    @param {table} db 字体样式数据库
]]
function F.SetFontWithDB(text, db)
    if not text or not text.GetFont then
        F.DebugMessage("函数", "[1]找不到处理字体风格的字体")
        return
    end
    if not db or type(db) ~= "table" then
        F.DebugMessage("函数", "[1]找不到字体风格数据库")
        return
    end

    text:FontTemplate(LSM:Fetch("font", db.name), db.size, db.style)
end

--[[
    从数据库设定字体颜色
    @param {object} text FontString 型对象
    @param {table} db 字体颜色数据库
]]
function F.SetFontColorWithDB(text, db)
    if not text or not text.GetFont then
        F.DebugMessage("函数", "[2]找不到处理字体风格的字体")
        return
    end
    if not db or type(db) ~= "table" then
        F.DebugMessage("函数", "[1]找不到字体颜色数据库")
        return
    end

    text:SetTextColor(db.r, db.g, db.b, db.a)
end

--[[
    更换字体描边为轮廓
    @param {object} text FontString 型对象
    @param {string} [font] 字型路径
    @param {number|string} [size] 字体尺寸或是尺寸变化量字符串
]]
function F.SetFontOutline(text, font, size)
    if not text or not text.GetFont then
        F.DebugMessage("函数", "[3]找不到处理字体风格的字体")
        return
    end
    local fontName, fontHeight = text:GetFont()

    if size and type(size) == "string" then
        size = fontHeight + tonumber(size)
    end

    text:FontTemplate(font or fontName, size or fontHeight, "OUTLINE")
    text:SetShadowColor(0, 0, 0, 0)
    text.SetShadowColor = E.noop
end

local function RGBToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 0
    g = g <= 1 and g >= 0 and g or 0
    b = b <= 1 and b >= 0 and b or 0
    return format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

--[[
    从数据库创建彩色字符串
    @param {string} text 文字
    @param {table} db 字体颜色数据库
]]
function F.CreateColorString(text, db)
    if not text or not type(text) == "string" then
        F.DebugMessage("函数", "[4]找不到处理字体风格的字体")
        return
    end
    if not db or type(db) ~= "table" then
        F.DebugMessage("函数", "[2]找不到字体颜色数据库")
        return
    end

    local hex = db.r and db.g and db.b and RGBToHex(db.r, db.g, db.b) or "ffffff"

    return "|cff" .. hex .. text .. "|r"
end

--[[
    更换窗体内部字体描边为轮廓
    @param {object} frame 窗体
    @param {string} [font] 字型路径
    @param {number|string} [size] 字体尺寸或是尺寸变化量字符串
]]
function F.SetFrameFontOutline(frame, font, size)
    if not frame or not frame.GetRegions then
        F.DebugMessage("函数", "找不到处理字体风格的窗体")
        return
    end
    for _, region in pairs({frame:GetRegions()}) do
        if region:IsObjectType("FontString") then
            F.SetFontOutline(region, font, size)
        end
    end
end

--[[
    输出 Debug 信息
    @param {table/string} module Ace3 模块或自定义字符串
    @param {string} text 错误讯息
]]
function F.DebugMessage(module, text)
    if not text then
        return
    end

    if not module then
        module = "函数"
        text = "无模块名>" .. text
    end
    if type(module) ~= "string" and module.GetName then
        module = module:GetName()
    end
    local message = format("[WT - %s] %s", module, text)
    print(message)
end

--[[
    延迟去除全部模块函数钩子
    @param {table/string} module Ace3 模块或自定义字符串
]]
function F.DelayUnhookAll(module)
    if type(module) == "string" then
        module = W:GetModule(module)
    end

    if module then
        if module.UnhookAll then
            E:Delay(1, module.UnhookAll, module)
        else
            F.DebugMessage(module, "无 AceHook 库函数！")
        end
    else
        F.DebugMessage(nil, "找不到模块！")
    end
end

--[[
    分割 CJK 字符串
    @param {string} str 待分割字符串
    @param {string} split_char 分割符
参考自 https://blog.csdn.net/sftxlin/article/details/48275197
]]
function F.SplitString(str, split_char)
    if str == "" or str == nil then
        F.DebugMessage(nil, "分割字符串为空")
        return {}
    end
    local split_len = strlen(split_char)
    local sub_str_tab = {}
    local i = 0
    local j = 0
    while true do
        j = strfind(str, split_char, i + split_len)
        if strlen(str) == i then
            break
        end

        if j == nil then
            tinsert(sub_str_tab, strsub(str, i))
            break
        end

        tinsert(sub_str_tab, strsub(str, i, j - 1))
        i = j + split_len
    end
    return sub_str_tab
end
