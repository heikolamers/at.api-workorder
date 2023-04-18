local base = "/System/Core"

-- Also create:
-- Custop Big Table Store
-- Custom Property on Core object, with ObjectID of BigTableStore +10

-- Test objects
syslib.mass({
	{
		class = syslib.model.classes.GenFolder,
		operation = syslib.model.codes.MassOp.INSERT,
		path =  base .. "/Tests",
		["ObjectName"] = "Tests"
	},
	{
		class = syslib.model.classes.ActionItem,
		operation = syslib.model.codes.MassOp.INSERT,
		path =  base .. "/Tests/01_insertOne",
		["ObjectName"] = "01_insertOne",
		["AdvancedLuaScript"] = [=[
local JSON = require "rapidjson"
local LIB = require "syslib.workorders"

local doc = {
	ObjectId = "/inmation Software GmbH Köln/Zollstock/Reactor 4711",
	ObjectType = "Asset",
	Title = "My workorder",
	Description = "Description for My workorder"
}
doc["Created Date"] = syslib.gettime(syslib.currenttime())

local res, err = LIB.insertOne(doc)

return JSON.encode({
	res = res,
	err = err
})

]=],
		["DedicatedThreadExecution"] = true
	},
	{
		class = syslib.model.classes.ActionItem,
		operation = syslib.model.codes.MassOp.INSERT,
		path =  base .. "/Tests/01_insertOne",
		["ObjectName"] = "01_insertOne",
		["AdvancedLuaScript"] = [=[
local JSON = require "rapidjson"
local LIB = require "syslib.workorders"

local doc = {
	ObjectId = "/inmation Software GmbH Köln/Zollstock/Reactor 4711",
	ObjectType = "Asset",
	Title = "My workorder",
	Description = "Description for My workorder"
}
doc["Created Date"] = syslib.gettime(syslib.currenttime())

local res, err = LIB.insertOne(doc)

return JSON.encode({
	res = res,
	err = err
})

]=],
		["DedicatedThreadExecution"] = true
	},
	{
		class = syslib.model.classes.ActionItem,
		operation = syslib.model.codes.MassOp.INSERT,
		path =  base .. "/Tests/02_find",
		["ObjectName"] = "02_find",
		["AdvancedLuaScript"] = [=[
local JSON = require "rapidjson"
local LIB = require "syslib.workorders"

local startts = 1
local endts = syslib.currenttime()
local from = math.floor(startts + 0.5)
local to = math.floor(endts + 0.5)
local query =  ([[{ "$and" : [ {"Created Date": { "$gte": { "$date": %s } }}, {"Created Date": { "$lte": { "$date": %s }}} ]}]]):format(from, to)
--error(query)
local res, err = LIB.find(query)

return JSON.encode({
	res = res,
	err = err
})

]=],
		["DedicatedThreadExecution"] = true
	},
	{
		class = syslib.model.classes.ActionItem,
		operation = syslib.model.codes.MassOp.INSERT,
		path =  base .. "/Tests/02_update",
		["ObjectName"] = "02_update",
		["AdvancedLuaScript"] = [=[
local JSON = require "rapidjson"
local LIB = require "syslib.workorders"

local id = "643ec691e5200000ee0077da"
local query =  ([[{ "_id" : { "$oid":"%s"}}]]):format(id)
--error(query)

local doc = {
	["$set"] = { 
		Description = "Description for My workorder YYY", 
		Tasks = {
			{
				Title = "my task",
				Description = "do something quick"
			}
		}
	}
}

--local res, err = LIB.find(query)
local res, err = LIB.updateOne(query, doc)

return JSON.encode({
	res = res,
	err = err
})

]=],
		["DedicatedThreadExecution"] = true
	}
})