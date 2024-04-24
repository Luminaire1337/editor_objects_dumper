local thisResource = getThisResource()
local thisResourceName = getResourceName(thisResource)
local objectsPath = ":editor_gui/client/browser/objects.xml"
local mainCategoryName = "Editor Objects Dumper"
local stopTimer

addEventHandler("onResourceStart", resourceRoot, function()
	local success, permission = checkResourcePermissions()
	if not success then
		outputChatBox(
			string.format("[ERROR] #ffffffResource %s does not have '%s' permission!", thisResourceName, permission),
			255,
			0,
			0,
			true
		)
	end
end)

local dumpObjectsRPC = string.format("%s:onPlayerRequestObjectsDump", thisResourceName)
addEvent(dumpObjectsRPC, true)
addEventHandler(dumpObjectsRPC, root, function(categoryName, objects)
	if client ~= source then
		return
	end

	if not checkResourcePermissions() then
		return
	end

	local editorGuiResource = getResourceFromName("editor_gui")
	if not editorGuiResource then
		return outputChatBox("[ERROR] #ffffffFailed to get editor_gui resource!", source, 255, 0, 0, true)
	end

	local function modifyObjectsFile()
		local xmlPointer = xmlLoadFile(objectsPath)
		if not xmlPointer then
			return outputError(
				string.format("Failed to load objects.xml file from %s", objectsPath),
				source,
				editorGuiResource
			)
		end

		local mainCategoryNode = findGroupNode(xmlPointer, mainCategoryName)
		if not mainCategoryNode then
			mainCategoryNode = createGroupNode(xmlPointer, mainCategoryName)
			if not mainCategoryNode then
				xmlUnloadFile(xmlPointer)
				return outputError(
					string.format("Failed to create main category node %s", mainCategoryName),
					source,
					editorGuiResource
				)
			end
		end

		local dumpCategoryNode = findGroupNode(mainCategoryNode, categoryName)
		if dumpCategoryNode then
			xmlUnloadFile(xmlPointer)
			return outputError(string.format("Category %s already exists!", categoryName), source, editorGuiResource)
		end

		dumpCategoryNode = createGroupNode(mainCategoryNode, categoryName)
		if not dumpCategoryNode then
			xmlUnloadFile(xmlPointer)
			return outputError(
				string.format("Failed to create category node %s", categoryName),
				source,
				editorGuiResource
			)
		end

		for modelID, modelName in pairs(objects) do
			local objectNode = xmlCreateChild(dumpCategoryNode, "object")
			if not objectNode then
				outputError(string.format("Failed to create object node for model %d (%s)", modelID, modelName), source)
			end

			xmlNodeSetAttribute(objectNode, "model", modelID)
			xmlNodeSetAttribute(objectNode, "name", modelName)
			xmlNodeSetAttribute(objectNode, "keywords", string.format("%s, %s", mainCategoryName, categoryName))
		end

		if not xmlSaveFile(xmlPointer) then
			xmlUnloadFile(xmlPointer)
			return outputError(
				string.format("Failed to save objects.xml file to %s", objectsPath),
				source,
				editorGuiResource
			)
		end

		xmlUnloadFile(xmlPointer)
		outputChatBox(
			string.format("// Editor Objects Dumper // #ffffffCategory %s was successfully dumped!", categoryName),
			source,
			119,
			119,
			119,
			true
		)

		startResource(editorGuiResource)
	end

	if getResourceState(editorGuiResource) == "running" then
		stopResource(editorGuiResource)

		if isTimer(stopTimer) then
			killTimer(stopTimer)
		end
		stopTimer = setTimer(modifyObjectsFile, 1000, 1)
	else
		modifyObjectsFile()
	end
end)
