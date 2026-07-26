--[[
    VoidKing UI Library
    Baseada na Obsidian (créditos ao deividcomsono)
    Botão flutuante com logo + organização VoidKing
]]

local BASE = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local Library = loadstring(game:HttpGet(BASE .. "Library.lua"))()

-- BOTÃO FLUTUANTE
local function CriarBotaoFlutuante(WindowInfo)
	if not WindowInfo or not WindowInfo.FloatLogo then
		return
	end

	local ScreenGui = Library.ScreenGui
	if not ScreenGui then
		return
	end

	local UserInputService = game:GetService("UserInputService")
	local logo = WindowInfo.FloatLogo
	if typeof(logo) == "number" then
		logo = "rbxassetid://" .. tostring(logo)
	end

	local tamanho = WindowInfo.FloatSize or 52
	-- azul marinho
	local cor = WindowInfo.FloatColor or Color3.fromRGB(15, 50, 100)

	local FloatBtn = Instance.new("ImageButton")
	FloatBtn.Name = "VoidKingFloat"
	FloatBtn.Size = UDim2.fromOffset(tamanho, tamanho)
	FloatBtn.Position = UDim2.new(0, 16, 0.5, -math.floor(tamanho / 2))
	FloatBtn.BackgroundColor3 = Color3.fromRGB(12, 20, 35)
	FloatBtn.AutoButtonColor = false
	FloatBtn.Image = logo
	FloatBtn.ScaleType = Enum.ScaleType.Fit
	FloatBtn.ZIndex = 100
	FloatBtn.Parent = ScreenGui

	local canto = Instance.new("UICorner")
	canto.CornerRadius = UDim.new(0, 12)
	canto.Parent = FloatBtn

	local borda = Instance.new("UIStroke")
	borda.Color = cor
	borda.Thickness = 1.5
	borda.Parent = FloatBtn

	-- arrastar
	local arrastando = false
	local inicio, posInicial
	local inicioClique

	FloatBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			arrastando = true
			inicio = input.Position
			posInicial = FloatBtn.Position
			inicioClique = input.Position
		end
	end)

	Library:GiveSignal(UserInputService.InputChanged:Connect(function(input)
		if not arrastando then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - inicio
			FloatBtn.Position = UDim2.new(
				posInicial.X.Scale,
				posInicial.X.Offset + delta.X,
				posInicial.Y.Scale,
				posInicial.Y.Offset + delta.Y
			)
		end
	end))

	Library:GiveSignal(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			if arrastando and inicioClique then
				-- só abre/fecha se não arrastou muito
				if (input.Position - inicioClique).Magnitude < 8 then
					Library:Toggle()
				end
			end
			arrastando = false
		end
	end))

	Library.FloatButton = FloatBtn
	return FloatBtn
end

-- CreateWindow com botão flutuante
local CreateWindowOriginal = Library.CreateWindow

function Library:CreateWindow(WindowInfo)
	WindowInfo = WindowInfo or {}

	-- logo padrão VoidKing
	if WindowInfo.FloatLogo == nil then
		WindowInfo.FloatLogo = "rbxassetid://126387680451970"
	end

	-- esconde botões mobile originais
	WindowInfo.ShowMobileButtons = false

	-- azul marinho padrão
	if WindowInfo.FloatColor == nil then
		WindowInfo.FloatColor = Color3.fromRGB(15, 50, 100)
	end

	local Window = CreateWindowOriginal(self, WindowInfo)

	task.defer(function()
		CriarBotaoFlutuante(WindowInfo)
	end)

	return Window
end

return Library
