-- Exemplo de uso da VoidKing UI Library
-- Repositorio: https://github.com/VoidGrok/VoidKing

local repo = "https://raw.githubusercontent.com/VoidGrok/VoidKing/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
	Title = "VoidKing",
	Footer = "versao: exemplo",
	Icon = 126387680451970,
	NotifySide = "Right",
	ShowCustomCursor = true,
})

local Tabs = {
	Main = Window:AddTab("Principal", "user"),
	Key = Window:AddKeyTab("Sistema de Key"),
	["UI Settings"] = Window:AddTab("Configuracoes", "settings"),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Grupo", "boxes")

LeftGroupBox:AddToggle("MyToggle", {
	Text = "Este e um toggle",
	Tooltip = "Dica ao passar o mouse",
	Default = true,
	Callback = function(Value)
		print("[cb] MyToggle mudou para:", Value)
	end,
})

Toggles.MyToggle:OnChanged(function()
	print("MyToggle mudou para:", Toggles.MyToggle.Value)
end)

LeftGroupBox:AddCheckbox("MyCheckbox", {
	Text = "Este e um checkbox",
	Default = true,
	Callback = function(Value)
		print("[cb] MyCheckbox mudou para:", Value)
	end,
})

LeftGroupBox:AddButton({
	Text = "Botao",
	Func = function()
		print("Voce clicou em um botao!")
	end,
	Tooltip = "Botao principal",
})

LeftGroupBox:AddLabel("Este e um label")
LeftGroupBox:AddDivider()

LeftGroupBox:AddSlider("MySlider", {
	Text = "Este e meu slider!",
	Default = 0,
	Min = 0,
	Max = 5,
	Rounding = 1,
	Callback = function(Value)
		print("[cb] MySlider mudou! Novo valor:", Value)
	end,
})

LeftGroupBox:AddInput("MyTextbox", {
	Default = "Minha caixa!",
	Text = "Esta e uma caixa de texto",
	Placeholder = "Texto de placeholder",
	Callback = function(Value)
		print("[cb] Texto atualizado:", Value)
	end,
})

local DropdownGroupBox = Tabs.Main:AddRightGroupbox("Dropdowns")

DropdownGroupBox:AddDropdown("MyDropdown", {
	Values = { "Isto", "e", "um", "dropdown" },
	Default = 1,
	Multi = false,
	Text = "Um dropdown",
	Callback = function(Value)
		print("[cb] Dropdown mudou:", Value)
	end,
})

DropdownGroupBox:AddDropdown("MyMultiDropdown", {
	Values = { "Isto", "e", "um", "dropdown" },
	Default = 1,
	Multi = true,
	Text = "Dropdown multi",
	Callback = function(Value)
		print("[cb] Multi dropdown mudou")
	end,
})

LeftGroupBox:AddLabel("Cor"):AddColorPicker("ColorPicker", {
	Default = Color3.new(0, 1, 0),
	Title = "Alguma cor",
	Callback = function(Value)
		print("[cb] Cor mudou!", Value)
	end,
})

LeftGroupBox:AddLabel("Tecla"):AddKeyPicker("KeyPicker", {
	Default = "MB2",
	Mode = "Toggle",
	Text = "Auto lockpick",
	Callback = function(Value)
		print("[cb] Keybind clicado!", Value)
	end,
})

Library:OnUnload(function()
	print("Descarregado!")
end)

Tabs.Key:AddLabel({
	Text = "Key: Banana",
	DoesWrap = true,
	Size = 16,
})

Tabs.Key:AddKeyBox(function(ReceivedKey)
	local Success = ReceivedKey == "Banana"
	print("Key esperada: Banana - Recebida:", ReceivedKey, "| Sucesso:", Success)
	Library:Notify({
		Title = "Key esperada: Banana",
		Description = "Key recebida: " .. ReceivedKey .. "\nSucesso: " .. tostring(Success),
		Time = 4,
	})
end)

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Abrir menu de keybinds",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Cursor personalizado",
	Default = Library.ShowCustomCursor,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})

MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",
	Text = "Lado das notificacoes",
	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})

MenuGroup:AddSlider("UICornerSlider", {
	Text = "Raio dos cantos",
	Default = Library.CornerRadius,
	Min = 0,
	Max = 20,
	Rounding = 0,
	Callback = function(value)
		Window:SetCornerRadius(value)
	end
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Tecla do menu")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Tecla do menu" })

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
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
