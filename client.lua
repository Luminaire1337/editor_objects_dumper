local thisResource = getThisResource()
local thisResourceName = getResourceName(thisResource)

addEventHandler("onClientResourceStart", resourceRoot, function()
	outputChatBox(
		"// Editor Objects Dumper // #ffffffUse /dumpobjects <categoryName> to dump objects!",
		119,
		119,
		119,
		true
	)
	outputChatBox(
		"// Editor Objects Dumper // #ffffffDISCLAIMER: editor_gui resource must be unzipped for this resource to work!",
		119,
		119,
		119,
		true
	)
end)

addCommandHandler("dumpobjects", function(cmd, ...)
	local categoryName = table.concat({ ... }, " ")
	if string.len(categoryName) == 0 then
		return outputChatBox("[ERROR] #ffffffYou must specify a category name!", 255, 0, 0, true)
	end

	local objects = {}
	for id, object in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("editor_main")))) do
		local modelID = getElementModel(object)
		objects[modelID] = engineGetModelNameFromID(modelID)
	end

	triggerServerEvent(
		string.format("%s:onPlayerRequestObjectsDump", thisResourceName),
		localPlayer,
		categoryName,
		objects
	)
end)
