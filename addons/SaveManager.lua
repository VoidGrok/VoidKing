--[[
    VoidKing SaveManager
    Salvar e carregar configurações
]]

local BASE = "https://raw.githubusercontent.com/VoidGrok/VoidKing/main/"

local SaveManager = loadstring(game:HttpGet(BASE .. "addons/SaveManager.lua"))()

return SaveManager
