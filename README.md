# jSync: Server side Weather and Time system

jSync is a server-side weather and time system that works with ESX but can be easily modified


# Usage (Client-Side)

```lua
--You have two options for exporting jSync in your resources
--First method:
TriggerEvent("jSync:getSharedObject", function(obj)
	jSync = obj
end)

print(jSync.getCurrentHour(), jSync.getCurrentMinute())

--Second method:
jSync = exports["jSync"]:getSharedObject()

print(jSync.getCurrentHour(), jSync.getCurrentMinute())

```

for any question join my discord:  [Discord
](https://discord.gg/DbuTNv9sqD)
for any suggestion, create a pull request.
