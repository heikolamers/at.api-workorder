-- syslib.workorders
-- supplies CRUD functions for accessing 

local lib = {}

local JSON = require "rapidjson"
local jsonDecode = JSON.decode

local lib = {
	bigtable = require "syslib.bigtable"
}
local VariantTypes = syslib.model.codes.VariantTypes

local function isTable(arg) return type(arg) == 'table' end

local function isNumber(arg) return type(arg) == 'number' end

-- The custom property "BigTableSelector" needs to exist in Core object. 
-- The value needs to be objectid of the CustomBigTableStore, see syslib.getstoreid(syslib.model.codes.RepoStoreName.STORE_BIG_TABLE)
-- Property ObjectName can be any valid inmation property
local function getPropertyId()
	local p = syslib.getcorepath()
	local prop_id = syslib.getpropertyid(p, "ObjectName")
	return prop_id
end

--- Overload of original bigtable function, to use Core.ObjectName property ID is Collection name
function lib.bigtable.getDatabaseNameAndClient(propInstanceID)
    -- Masking out the low 16 bit of prpid to reveal the actual object ID to which the property belongs:
    local obj = syslib.getobject(propInstanceID & ~0xffff)
	local bigTableSelectorPath, bigTableStoreID
	if obj:path() == syslib.getcorepath() then
		bigTableSelectorPath = obj:path() .. "." .. "BigTableSelector"
		bigTableStoreID = syslib.getvalue(bigTableSelectorPath)
		bigTableStoreID = tonumber(bigTableStoreID)
		if not isNumber(bigTableStoreID) then
        	error(("Failed to get property ID for %s"):format(bigTableSelectorPath))
    	end		
	else
		bigTableSelectorPath = obj:path() .. "." .. syslib.getpropertyname(propInstanceID) .. ".BigTableSelector"
		bigTableStoreID = syslib.getvalue(bigTableSelectorPath)
		if not isNumber(bigTableStoreID) then
        	error(("Failed to get property ID for %s"):format(bigTableSelectorPath))
    	end
	end
    local bigTableStoreObj = syslib.getobject(bigTableStoreID)
    local store = bigTableStoreObj
    local _, classCode = bigTableStoreObj:type()
    if classCode == syslib.model.classes.System then
        store = syslib.model.codes.RepoStoreName.STORE_BIG_TABLE
    end
    local _, dbname = syslib.getmongoconnectionstring(store)
    local client = syslib.getmongoconnection(store)
    return dbname, client
end

--- Example schema for WorkOrder properties
function lib.bigtable.tableDataValidationSchema()
    local tableDataValidationSchema = {
		definitions = {
			system = { 
				properties = {
					["Created Date"] = {
						pcode = "Created Date",
						sm_property = {
							datatype = VariantTypes.VT_DATE
						}
					}
				}
			}
		}
	}

    return tableDataValidationSchema
end

---Insert one document
function lib.insertOne(doc)
	local prop_id = getPropertyId()
	return lib.bigtable.insertOne(prop_id, doc)
end

---Find documents
-- see syslib.bigtable documentation
function lib.find(query)
	local prop_id = getPropertyId()
	return lib.bigtable.find(prop_id, query)
end

---Update one document.
function lib.updateOne(query, document)
	local prop_id = getPropertyId()
	return lib.bigtable.updateOne(prop_id, query, document)
end

---Remove one document.
function lib.removeOne(query)
	local prop_id = getPropertyId()
	return lib.bigtable.removeOne(prop_id, query)
end

return lib