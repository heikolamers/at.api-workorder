# inmation-compose - config.json

inmation-compose will scan the folder recursively. Best practice is to have multiple 'root' folders in this `model` folder:

- 10_System
- 20_KPI-IOModel
- 30_KPI-Model

Use sub folders based on inmation object names.

## Object definition for the 'mass' action

This relies on the inmation.mass() Lua API. See [inmation wiki](https://inmation.com/wiki/index.php?title=Sysdoc/Lua_Scripting#mass__function_)

Create `config.json` files like:

```json
{
    "version": "1.0",
    "objects": [
        {
            "path": "/System/Core/TestItem",
            "class": "GenFolder",
            "ObjectName": "TestItem",
            "ObjectDescription": "TestItem"
        },
        {
            "path": "/System/Core/TestItem/SubFolder",
            "class": "GenFolder",
            "ObjectName": "SubFolder",
            "ObjectDescription": "SubFolder"
        }
    ]
}
```

Or relative to the parent object config:

```json
{
    "version": "1.0",
    "objects": [
        {
            "path": "/System/Core/TestItem",
            "class": "GenFolder",
            "ObjectName": "TestItem",
            "ObjectDescription": "This is a TestItem",
            "children": [
                {
                    "class": "GenFolder",
                    "ObjectName": "SubFolder",
                    "ObjectDescription": "This is a SubFolder"
                }
            ]
        }
    ]
}
```

Script Library:

```json
{
    "version": "1.0",
    "objects": [
        {
            "path": "/System/Core/TestItem",
            "class": "GenFolder",
            "ObjectName": "TestItem",
            "ObjectDescription": "This is a TestItem",
            "ScriptLibrary": {
                "ScriptList": [
                    {
                        "LuaModuleName": "lib-name",
                        "scriptReference": "scripts.script-name"
                    }
                ]
            }
        }
    ]
}
```

Script Library with reference to data file which will be import into the script:

```json
{
    "version": "1.0",
    "objects": [
        {
            "path": "/System/Core/TestItem",
            "class": "GenFolder",
            "ObjectName": "TestItem",
            "ObjectDescription": "This is a TestItem",
            "ScriptLibrary": {
                "ScriptList": [
                    {
                        "LuaModuleName": "lib-name1",
                        "scriptReference": "script-name",
                        "dataReference": "data-file1.json"
                    },
                    {
                        "LuaModuleName": "lib-name2",
                        "scriptReference": "script-name",
                        "dataReference": {
                            "filename": "data-file2.json",
                            "key": "#DATA#"
                        }
                    }
                ]
            }
        }
    ]
}
```

Lua library script to expose data:

```lua
local data = [[#DATA#]]
return data
```
