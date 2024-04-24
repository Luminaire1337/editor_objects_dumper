local thisResource = getThisResource()
local requiredPermissions = { "general.ModifyOtherObjects", "function.startResource", "function.stopResource" }
function checkResourcePermissions()
	for id, permission in ipairs(requiredPermissions) do
		if not hasObjectPermissionTo(thisResource, permission, true) then
			return false, permission
		end
	end

	return true
end

function findGroupNode(parentPointer, groupName)
	for id, node in ipairs(xmlNodeGetChildren(parentPointer)) do
		if xmlNodeGetName(node) == "group" and xmlNodeGetAttribute(node, "name") == groupName then
			return node
		end
	end

	return nil
end

function createGroupNode(parentPointer, groupName)
	local groupNode = xmlCreateChild(parentPointer, "group")
	if not groupNode then
		return nil
	end

	xmlNodeSetAttribute(groupNode, "name", groupName)
	return groupNode
end

function outputError(message, player, guiResource)
	outputChatBox(string.format("[ERROR] #ffffff%s", message), source, 255, 0, 0, true)

	if guiResource then
		startResource(guiResource)
	end
end
