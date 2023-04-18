-- syslib.api-workorders
local lib = {
    workorders = require('syslib.workorders')
}

local function isTable(arg) return type(arg) == 'table' end
local function isArray(arg) return isTable(arg) and #arg > 0 end
local function isNumber(arg) return type(arg) == 'number' end
local function isString(arg) return type(arg) == 'string' end

local function fixMongoID(documentOrQuery)
    if isTable(documentOrQuery) then
        local _id = documentOrQuery._id
        if isString(_id) then
            documentOrQuery._id = {
                ["$oid"] = _id
            }
        end
    end
    return documentOrQuery
end

function lib:find(arg, req, hlp)

    local query = fixMongoID(arg.query) or {}
    local options = arg.options or {}
    local prefs = arg.prefs

    local documents, err = self.workorders.find(query, options, prefs)
    if err then return hlp:createResponse(nil, err, 400) end
	return {
        documents = documents
    }
end


return lib