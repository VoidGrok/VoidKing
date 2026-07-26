-- VoidKing — exemplo com Key System
-- Enquanto a key nao validar, so a aba de Key aparece.
-- Depois da key: cria as outras tabs e salva a key pro auto-login.

local repo = "https://raw.githubusercontent.com/VoidGrok/VoidKing/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local KeySystem = loadstring(game:HttpGet(repo .. "addons/KeySystem.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
	Title = "VoidKing",
	Footer = "versao: exemplo",
	Icon = 126387680451970,
	NotifySide = "Right",
	ShowCustomCursor = true,
})

KeySystem:SetLibrary(Library)

local function BuildMainUI()
	local Tabs = {
		Main = Window:AddTab("Principal", "user"),
		Config = Window:AddTab("Configuracoes", "settings"),
	}

	local LeftGroup = Tabs.Main:AddLeftGroupbox("Combate", "swords")

	LeftGroup:AddToggle("Aimbot", {
		Text = "Aimbot",
		Default = false,
		Callback = function(Value)
			print("Aimbot:", Value)
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
			print("FOV:", Value)
		end,
	})

	LeftGroup:AddDropdown("Target", {
		Text = "Alvo",
		Values = { "Head", "Torso", "HumanoidRootPart" },
		Default = 1,
		Multi = false,
		Callback = function(Value)
			print("Alvo:", Value)
		end,
	})

	LeftGroup:AddButton({
		Text = "Teste",
		Func = function()
			Library:Notify({
				Title = "VoidKing",
				Description = "Botao funcionando!",
				Time = 3,
			})
		end,
	})

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
end

-- IMPORTANTE: so a aba de Key existe ate OnSuccess
KeySystem:Setup(Window, {
	ServiceId = 28492,
	PlatoSecret = "d0c1d79d-5e36-4668-9dc4-3a5e817ddde7",
	Secret = "VoidKingSecret",
	KeyFileName = "VoidKing_Key.txt",
	DiscordURL = "https://discord.gg/HPgq4TPfzN",
	TabName = "Key System",
	TabIcon = "key",
	OnSuccess = function()
		BuildMainUI()
	end,
})
