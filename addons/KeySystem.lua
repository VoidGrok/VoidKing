-- KeySystem VoidKing (Platoboost + visual da library)
local HttpService = game:GetService("HttpService")

local KeySystem = {
    Library = nil,
    Config = nil,
    Validated = false,
}

local function lEncode(t)
    return HttpService:JSONEncode(t)
end
local function lDecode(s)
    return HttpService:JSONDecode(s)
end

-- SHA256 (mesmo do Platoboost)
local a = 2 ^ 32
local b = a - 1
local function c(d, e)
    local f, g = 0, 1
    while d ~= 0 or e ~= 0 do
        local h, i = d % 2, e % 2
        local j = (h + i) % 2
        f = f + j * g
        d = math.floor(d / 2)
        e = math.floor(e / 2)
        g = g * 2
    end
    return f % a
end
local function k(d, e, l, ...)
    local m
    if e then
        d = d % a
        e = e % a
        m = c(d, e)
        if l then
            m = k(m, l, ...)
        end
        return m
    elseif d then
        return d % a
    else
        return 0
    end
end
local function n(d, e, l, ...)
    local m
    if e then
        d = d % a
        e = e % a
        m = (d + e - c(d, e)) / 2
        if l then
            m = n(m, l, ...)
        end
        return m
    elseif d then
        return d % a
    else
        return b
    end
end
local function o(p)
    return b - p
end
local function q(d, r)
    if r < 0 then
        return lshift(d, -r)
    end
    return math.floor(d % 2 ^ 32 / 2 ^ r)
end
local function s(p, r)
    if r > 31 or r < -31 then
        return 0
    end
    return q(p % a, r)
end
local function lshift(d, r)
    if r < 0 then
        return s(d, -r)
    end
    return d * 2 ^ r % 2 ^ 32
end
local function t(p, r)
    p = p % a
    r = r % 32
    local u = n(p, 2 ^ r - 1)
    return s(p, r) + lshift(u, 32 - r)
end
local v = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}
local function w(x)
    return string.gsub(x, ".", function(ch)
        return string.format("%02x", string.byte(ch))
    end)
end
local function y(z, A)
    local x = ""
    for _ = 1, A do
        local C = z % 256
        x = string.char(C) .. x
        z = (z - C) / 256
    end
    return x
end
local function D(x, B)
    local A = 0
    for i = B, B + 3 do
        A = A * 256 + string.byte(x, i)
    end
    return A
end
local function E(F, G)
    local H = 64 - (G + 9) % 64
    G = y(8 * G, 8)
    F = F .. "\128" .. string.rep("\0", H) .. G
    assert(#F % 64 == 0)
    return F
end
local function I(J)
    J[1] = 0x6a09e667
    J[2] = 0xbb67ae85
    J[3] = 0x3c6ef372
    J[4] = 0xa54ff53a
    J[5] = 0x510e527f
    J[6] = 0x9b05688c
    J[7] = 0x1f83d9ab
    J[8] = 0x5be0cd19
    return J
end
local function K(F, B, J)
    local L = {}
    for M = 1, 16 do
        L[M] = D(F, B + (M - 1) * 4)
    end
    for M = 17, 64 do
        local N = L[M - 15]
        local O = k(t(N, 7), t(N, 18), s(N, 3))
        N = L[M - 2]
        L[M] = (L[M - 16] + O + L[M - 7] + k(t(N, 17), t(N, 19), s(N, 10))) % a
    end
    local d, e, l, P, Q, R, S, T = J[1], J[2], J[3], J[4], J[5], J[6], J[7], J[8]
    for idx = 1, 64 do
        local O = k(t(d, 2), t(d, 13), t(d, 22))
        local U = k(n(d, e), n(d, l), n(e, l))
        local V = (O + U) % a
        local W = k(t(Q, 6), t(Q, 11), t(Q, 25))
        local X = k(n(Q, R), n(o(Q), S))
        local Y = (T + W + X + v[idx] + L[idx]) % a
        T = S
        S = R
        R = Q
        Q = (P + Y) % a
        P = l
        l = e
        e = d
        d = (Y + V) % a
    end
    J[1] = (J[1] + d) % a
    J[2] = (J[2] + e) % a
    J[3] = (J[3] + l) % a
    J[4] = (J[4] + P) % a
    J[5] = (J[5] + Q) % a
    J[6] = (J[6] + R) % a
    J[7] = (J[7] + S) % a
    J[8] = (J[8] + T) % a
end
local function Z(F)
    F = E(F, #F)
    local J = I({})
    for B = 1, #F, 64 do
        K(F, B, J)
    end
    return w(y(J[1], 4) .. y(J[2], 4) .. y(J[3], 4) .. y(J[4], 4) .. y(J[5], 4) .. y(J[6], 4) .. y(J[7], 4) .. y(J[8], 4))
end
local lDigest = Z

local useNonce = true
local fSetClipboard = setclipboard or toclipboard or function() end
local fStringChar, fToString, fOsTime, fMathRandom, fMathFloor = string.char, tostring, os.time, math.random, math.floor
local fGetHwid = gethwid or function()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

local function safeRequest(options)
    local req = request or http_request or syn_request or (http and http.request)
    if not req then
        return nil
    end
    local ok, res = pcall(function()
        return req(options)
    end)
    if ok then
        return res
    end
    return nil
end

local host = "https://api.platoboost.com"
do
    local r = safeRequest({ Url = host .. "/public/connectivity", Method = "GET" })
    if not r or (r.StatusCode ~= 200 and r.StatusCode ~= 429) then
        host = "https://api.platoboost.net"
    end
end

local cachedLink, cachedTime = "", 0

local function generateNonce()
    local str = ""
    for _ = 1, 16 do
        str = str .. fStringChar(fMathFloor(fMathRandom() * 26) + 97)
    end
    return str
end

function KeySystem:SetLibrary(Library)
    KeySystem.Library = Library
end

local function getConfig()
    return KeySystem.Config or {}
end

local function cacheLink()
    local Config = getConfig()
    if cachedTime + 600 < fOsTime() then
        local response = safeRequest({
            Url = host .. "/public/start",
            Method = "POST",
            Body = lEncode({ service = Config.ServiceId, identifier = lDigest(fGetHwid()) }),
            Headers = { ["Content-Type"] = "application/json" },
        })
        if response and response.StatusCode == 200 then
            local decoded = lDecode(response.Body)
            if decoded.success then
                cachedLink = decoded.data.url
                cachedTime = fOsTime()
                return true, cachedLink
            end
            return false, decoded.message or "Erro"
        end
        return false, "Servidor indisponivel"
    end
    return true, cachedLink
end

local function redeemKey(key)
    local Config = getConfig()
    local nonce = generateNonce()
    local body = { identifier = lDigest(fGetHwid()), key = key }
    if useNonce then
        body.nonce = nonce
    end

    local response = safeRequest({
        Url = host .. "/public/redeem/" .. fToString(Config.ServiceId),
        Method = "POST",
        Body = lEncode(body),
        Headers = { ["Content-Type"] = "application/json" },
    })

    if response and response.StatusCode == 200 then
        local decoded = lDecode(response.Body)
        if decoded.success and decoded.data and decoded.data.valid then
            local validHash = true
            if useNonce then
                validHash = decoded.data.hash == lDigest("true-" .. nonce .. "-" .. Config.PlatoSecret)
            end
            if validHash then
                if writefile and Config.KeyFileName then
                    pcall(writefile, Config.KeyFileName, key)
                end
                -- info extra se a API mandar (expira, etc)
                local info = {}
                local data = decoded.data
                if data.expires_at then info.expires_at = data.expires_at end
                if data.expires then info.expires = data.expires end
                if data.expiry then info.expiry = data.expiry end
                if data.time_left then info.time_left = data.time_left end
                if data.left then info.left = data.left end
                if data.message then info.message = data.message end
                return true, info
            end
            return false, { message = "Falha na verificacao do hash" }
        end
        local msg = (decoded and decoded.message) or "Key invalida"
        return false, { message = msg }
    end
    return false, { message = "Servidor indisponivel" }
end

local function loadSavedKey()
    local Config = getConfig()
    if not Config.KeyFileName then
        return nil
    end
    if isfile and isfile(Config.KeyFileName) then
        local ok, res = pcall(readfile, Config.KeyFileName)
        if ok and res and res ~= "" then
            return res
        end
    end
    return nil
end

function KeySystem:IsValidated()
    return KeySystem.Validated == true
end

-- Monta a tela de key no visual da library
-- Config: ServiceId, PlatoSecret, Secret, DiscordURL, KeyFileName, TabName, OnSuccess
function KeySystem:Setup(Window, Config)
    assert(KeySystem.Library, "Chame KeySystem:SetLibrary(Library) primeiro.")
    assert(Window, "Window e obrigatoria.")
    assert(typeof(Config) == "table", "Config deve ser uma tabela.")
    assert(Config.ServiceId, "ServiceId e obrigatorio.")
    assert(Config.PlatoSecret, "PlatoSecret e obrigatorio.")

    KeySystem.Config = Config
    local Library = KeySystem.Library

    local TabName = Config.TabName or "Key System"
    local KeyTab = Window:AddKeyTab(TabName, Config.TabIcon or "key")

    KeyTab:AddLabel({
        Text = "Digite sua key para liberar o script",
        DoesWrap = true,
        Size = 16,
    })

    KeyTab:AddDivider()

    local statusLabel = KeyTab:AddLabel("Status: aguardando key...", true)

    KeyTab:AddKeyBox(function(ReceivedKey)
        if not ReceivedKey or ReceivedKey == "" then
            statusLabel:SetText("Status: digite uma key!")
            Library:Notify({
                Title = "Key vazia",
                Description = "Digite uma key antes de enviar.",
                Time = 3,
            })
            return
        end

        statusLabel:SetText("Status: verificando...")
        Library:Notify({
            Title = "Verificando",
            Description = "Aguarde um momento...",
            Time = 2,
        })

        task.spawn(function()
            local ok, info = redeemKey(ReceivedKey)
            if ok then
                KeySystem.Validated = true
                if Config.Secret then
                    _G[Config.Secret] = true
                end
                local extra = ""
                if info then
                    if info.time_left then extra = " | Tempo: " .. tostring(info.time_left)
                    elseif info.left then extra = " | Tempo: " .. tostring(info.left)
                    elseif info.expires_at then extra = " | Expira: " .. tostring(info.expires_at)
                    elseif info.expires then extra = " | Expira: " .. tostring(info.expires)
                    elseif info.expiry then extra = " | Expira: " .. tostring(info.expiry)
                    end
                end
                statusLabel:SetText("Status: key valida!" .. extra)
                Library:Notify({
                    Title = "Key aceita",
                    Description = "Script liberado." .. extra,
                    Time = 4,
                })
                if typeof(Config.OnSuccess) == "function" then
                    task.defer(Config.OnSuccess)
                end
                -- Remove a aba de Key depois de validar
                task.defer(function()
                    if KeyTab and KeyTab.Destroy then
                        pcall(function() KeyTab:Destroy() end)
                    end
                end)
            else
                local msg = (info and info.message) or "Key invalida ou expirada"
                statusLabel:SetText("Status: " .. tostring(msg))
                -- apaga key salva se invalida/expirou
                if Config.KeyFileName and isfile and isfile(Config.KeyFileName) and delfile then
                    pcall(delfile, Config.KeyFileName)
                end
                Library:Notify({
                    Title = "Key recusada",
                    Description = tostring(msg),
                    Time = 4,
                })
            end
        end)
    end)

    KeyTab:AddDivider()

    KeyTab:AddButton({
        Text = "Copiar link da key",
        Func = function()
            task.spawn(function()
                local ok, link = cacheLink()
                if ok and link then
                    fSetClipboard(link)
                    statusLabel:SetText("Status: link copiado!")
                    Library:Notify({
                        Title = "Link copiado",
                        Description = "Cole no navegador para pegar sua key.",
                        Time = 3,
                    })
                else
                    statusLabel:SetText("Status: erro ao pegar link")
                    Library:Notify({
                        Title = "Falha no link",
                        Description = tostring(link) or "Nao foi possivel gerar o link.",
                        Time = 3,
                    })
                end
            end)
        end,
    })

    -- Auto login com key salva
    task.spawn(function()
        local saved = loadSavedKey()
        if saved then
            statusLabel:SetText("Status: tentando auto-login...")
            local ok, info = redeemKey(saved)
            if ok then
                KeySystem.Validated = true
                if Config.Secret then
                    _G[Config.Secret] = true
                end
                local extra = ""
                if info then
                    if info.time_left then extra = " | Tempo: " .. tostring(info.time_left)
                    elseif info.left then extra = " | Tempo: " .. tostring(info.left)
                    elseif info.expires_at then extra = " | Expira: " .. tostring(info.expires_at)
                    elseif info.expires then extra = " | Expira: " .. tostring(info.expires)
                    end
                end
                statusLabel:SetText("Status: key valida (auto-login)!" .. extra)
                Library:Notify({
                    Title = "Auto-login",
                    Description = "Key salva aceita." .. extra,
                    Time = 3,
                })
                if typeof(Config.OnSuccess) == "function" then
                    task.defer(Config.OnSuccess)
                end
                -- Remove a aba de Key depois do auto-login
                task.defer(function()
                    if KeyTab and KeyTab.Destroy then
                        pcall(function() KeyTab:Destroy() end)
                    end
                end)
            else
                local msg = (info and info.message) or "key salva invalida"
                statusLabel:SetText("Status: " .. tostring(msg))
                if Config.KeyFileName and isfile and isfile(Config.KeyFileName) and delfile then
                    pcall(delfile, Config.KeyFileName)
                end
            end
        end
    end)

    return KeyTab
end

return KeySystem
