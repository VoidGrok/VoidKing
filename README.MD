# VoidKing UI Library — Guia Rápido

Biblioteca de UI para scripts Roblox.  
Repositório: https://github.com/VoidGrok/VoidKing

---

### 1. Carregar a Library
```lua
local repo = "https://raw.githubusercontent.com/VoidGrok/VoidKing/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles
```

### 2. Criar a Janela
```lua
local Window = Library:CreateWindow({
    Title = "Meu Script",
    Footer = "versao: 1.0",
    Icon = 126387680451970,          -- logo padrao VoidKing
    NotifySide = "Right",
    ShowCustomCursor = true,
})
```

> Um **botao flutuante** com a logo e criado automaticamente.  
> Ele e arrastavel e ao clicar (sem arrastar) abre/fecha a interface.

### 3. Criar Tab
```lua
local Tabs = {
    Main = Window:AddTab("Principal", "user"),           -- icone lucide
    Config = Window:AddTab("Configuracoes", "settings"),
}
```

### 4. Criar Groupbox (Section)
```lua
local LeftGroup = Tabs.Main:AddLeftGroupbox("Combate", "swords")
local RightGroup = Tabs.Main:AddRightGroupbox("Visual", "eye")
```

### 5. Elementos

**Toggle**
```lua
LeftGroup:AddToggle("Aimbot", {
    Text = "Aimbot",
    Default = false,
    Tooltip = "Ativa o aimbot",
    Callback = function(Value)
        print(Value)
    end,
})

-- Ou usando OnChanged depois:
Toggles.Aimbot:OnChanged(function()
    print("Aimbot:", Toggles.Aimbot.Value)
end)
```

**Checkbox**
```lua
LeftGroup:AddCheckbox("Silent", {
    Text = "Silent Aim",
    Default = true,
    Callback = function(Value)
        print(Value)
    end,
})
```

**Slider**
```lua
LeftGroup:AddSlider("FOV", {
    Text = "FOV",
    Default = 100,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Suffix = "°",
    Callback = function(Value)
        print(Value)
    end,
})
```

**Dropdown**
```lua
LeftGroup:AddDropdown("Target", {
    Text = "Alvo",
    Values = { "Head", "Torso", "HumanoidRootPart" },
    Default = 1,
    Multi = false,
    Callback = function(Value)
        print(Value)
    end,
})
```

**Dropdown Multi**
```lua
LeftGroup:AddDropdown("Hits", {
    Text = "Hitboxes",
    Values = { "Head", "Torso", "Arms" },
    Default = 1,
    Multi = true,
    Callback = function(Value)
        for k, v in pairs(Options.Hits.Value) do
            print(k, v)
        end
    end,
})
```

**Button**
```lua
LeftGroup:AddButton({
    Text = "Kill All",
    Func = function()
        print("Executado")
    end,
    Tooltip = "Mata todos os jogadores",
})
```

**Input (TextBox)**
```lua
LeftGroup:AddInput("Webhook", {
    Text = "Webhook",
    Default = "",
    Placeholder = "Cole o link...",
    Finished = false,
    Callback = function(Text)
        print(Text)
    end,
})
```

**ColorPicker**
```lua
LeftGroup:AddLabel("Cor do ESP"):AddColorPicker("ESPColor", {
    Default = Color3.fromRGB(255, 0, 0),
    Title = "Cor do ESP",
    Transparency = 0,
    Callback = function(Color)
        print(Color)
    end,
})
```

**KeyPicker (Keybind)**
```lua
LeftGroup:AddLabel("Tecla do Aim"):AddKeyPicker("AimKey", {
    Default = "E",
    Mode = "Toggle",          -- Always, Toggle, Hold, Press
    Text = "Aim Key",
    Callback = function(Value)
        print(Value)
    end,
})
```

**Label e Divider**
```lua
LeftGroup:AddLabel("Texto simples")
LeftGroup:AddLabel("Texto que quebra\nlinha", true)
LeftGroup:AddDivider()
```

---

### Estrutura basica completa
```lua
-- VoidKing UI Library
local repo = "https://raw.githubusercontent.com/VoidGrok/VoidKing/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title = "Meu Script",
    Footer = "versao: 1.0",
    Icon = 126387680451970,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Principal", "user"),
    Config = Window:AddTab("Configuracoes", "settings"),
}

local LeftGroup = Tabs.Main:AddLeftGroupbox("Combate", "swords")

LeftGroup:AddToggle("Aimbot", {
    Text = "Aimbot",
    Default = false,
    Callback = function(Value)
        print(Value)
    end,
})

LeftGroup:AddSlider("FOV", {
    Text = "FOV",
    Default = 100,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Suffix = "°",
    Callback = function(Value)
        print(Value)
    end,
})

LeftGroup:AddDropdown("Target", {
    Text = "Alvo",
    Values = { "Head", "Torso", "HumanoidRootPart" },
    Default = 1,
    Multi = false,
    Callback = function(Value)
        print(Value)
    end,
})

LeftGroup:AddButton({
    Text = "Kill All",
    Func = function()
        print("Executado")
    end,
})

-- Configuracoes de tema e save
local MenuGroup = Tabs.Config:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddLabel("Tecla do menu")
    :AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        NoUI = true,
        Text = "Tecla do menu",
    })

MenuGroup:AddButton("Descarregar", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("VoidKing")
SaveManager:SetFolder("VoidKing/jogo")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)
SaveManager:LoadAutoloadConfig()
```

---

### Notificacoes
```lua
Library:Notify({
    Title = "Sucesso",
    Description = "Config carregada!",
    Time = 4,
})
```

### Descarregar
```lua
Library:Unload()
```

### Estrutura do repositorio
```
VoidKing/
├── Library.lua
├── Example.lua
├── README.md
├── LICENSE
├── addons/
│   ├── SaveManager.lua
│   └── ThemeManager.lua
└── assets/
    ├── CheckIcon.png
    ├── LoadingIcon.png
    ├── SaturationMap.png
    └── TransparencyTexture.png
```

### Info
- **Logo padrao:** `rbxassetid://126387680451970`
- **Cor de destaque:** azul marinho `#00468c` / `Color3.fromRGB(0, 70, 140)`
- **Botao flutuante:** automatico (arrasta + clique abre/fecha)
- **Icones:** nomes do [Lucide](https://lucide.dev/)
