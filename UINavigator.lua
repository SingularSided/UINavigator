local UINavigator = {}

UINavigator._UIData = {}

local function GetUIDataByName(uiName)
	for categoryName,categoryData in next, UINavigator._UIData do
		for i, uiData in pairs(categoryData) do
			if uiData.Name == uiName then
				return categoryName, uiData
			end
		end
	end
	return false
end

function UINavigator.CreateCategory(categoryName)
	if UINavigator._UIData[categoryName] then
		error("Category "..categoryName.." already exists.")
	end
	UINavigator._UIData[categoryName] = {}
end

function UINavigator.AddUI(uiName, uiCategory, uiOpenFunc, uiCloseFunc)
	local data = {}
	data.Name = uiName
	data.OpenFunc = uiOpenFunc
	data.CloseFunc = uiCloseFunc
	data.IsOpen = false
	UINavigator._UIData[uiCategory][uiName] = data
end

function UINavigator.CloseUI(uiName)
	local categoryName, uiData = GetUIDataByName(uiName)
	if not uiData then
		return false
	end
	if not uiData.IsOpen then
		return false
	end
	if not uiData.CloseFunc then
		return false
	end
	
	uiData.IsOpen = false
	uiData.CloseFunc()
end

function UINavigator.OpenUI(uiName)
	local categoryName, uiData = GetUIDataByName(uiName)
	if not uiData then
		return false
	end
	if uiData.IsOpen then
		return false
	end
	if not uiData.OpenFunc then
		return false
	end
	
	for i,v in pairs(UINavigator._UIData[categoryName]) do
		if v.Name ~= uiName then
			UINavigator.CloseUI(v.Name)
		end
	end
	
	uiData.IsOpen = true
	uiData.OpenFunc()
end

function UINavigator.ToggleUI(uiName)
	local categoryName, uiData = GetUIDataByName(uiName)
	if not uiData then
		return false
	end
	
	if uiData.IsOpen then
		UINavigator.CloseUI(uiName)
	else
		UINavigator.OpenUI(uiName)
	end
end

return UINavigator
