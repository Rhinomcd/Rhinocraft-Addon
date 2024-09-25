local concentrationCurrencies = { 3013, 3040, 3041, 3042, 3043, 3044, 3045, 3046, 3047, 3050, 3052, 3054 }

local function professionLearned(professionName)
    local prof1, prof2 = GetProfessions()
    local prof1Name = GetProfessionInfo(prof1) or nil
    local prof2Name = GetProfessionInfo(prof2) or nil

    return prof1Name == professionName or prof2Name == professionName
end

local function saveCurrency(id)
    local info = C_CurrencyInfo.GetCurrencyInfo(id)
    if not info then
        return
    end

    local professionName = info.name:match("^(%S+)")

    if not professionLearned(professionName) then
        return
    end

    local nameAndRealm = GetUnitName("player") .. "-" .. GetRealmName()
    if Rhinocraft[nameAndRealm] == nil then
        Rhinocraft[nameAndRealm] = {}
    end
    if Rhinocraft[nameAndRealm][professionName] == nil then
        Rhinocraft[nameAndRealm][professionName] = {}
    end
    if Rhinocraft[nameAndRealm][professionName][id] == nil then
        Rhinocraft[nameAndRealm][professionName][id] = {}
    end
    Rhinocraft[nameAndRealm][professionName][id].time = time()
    Rhinocraft[nameAndRealm][professionName][id].name = info.name
    Rhinocraft[nameAndRealm][professionName][id].quantity = info.quantity
    Rhinocraft[nameAndRealm][professionName][id].maxQuantity = info.maxQuantity
end

local function updateConcentration()
    for _, id in ipairs(concentrationCurrencies) do
        saveCurrency(id)
    end
end

local function init()
    Rhinocraft = Rhinocraft or {}
    print("RhinoCraft: Initialized.")
    updateConcentration()
end

local name, addon = ...
local f = CreateFrame("Frame")
local login = true
local function onevent(self, event, arg1, ...)
    if login and ((event == "ADDON_LOADED" and name == arg1) or (event == "PLAYER_LOGIN")) then
        login = nil
        f:UnregisterEvent("ADDON_LOADED")
        f:UnregisterEvent("PLAYER_LOGIN")
        init()
    end
    if event == "CURRENCY_DISPLAY_UPDATE" then
        updateConcentration()
    end
end
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
f:SetScript("OnEvent", onevent)
