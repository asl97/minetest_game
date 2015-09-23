local homes_file = minetest.get_worldpath() .. "/homes"
local homepos = {}

local function loadhomes()
	local input,err = io.open(homes_file, "r")
	if input then
		repeat
			local x = input:read("*n")
			if x == nil then
				break
			end
			local y = input:read("*n")
			local z = input:read("*n")
			local name = input:read("*l")
			homepos[name:sub(2)] = {x = x, y = y, z = z}
		until input:read(0) == nil
		io.close(input)
	end
end

loadhomes()

minetest.register_privilege("home", "Can use /sethome and /home")

minetest.register_chatcommand("home", {
    description = "Teleport you to your home point",
    privs = {home=true},
	func = function(name)
		local player = minetest.get_player_by_name(name)
		if homepos[name] and player then
			player:setpos(homepos[name])
			return true, "Teleported to home!"
		else
			return false, "Set a home using /sethome"
		end
	end,
})

minetest.register_chatcommand("sethome", {
    description = "Set your home point",
    privs = {home=true},
    func = function(name)
	   local pos = minetest.get_player_by_name(name):getpos()
		local data = ""
		local output = io.open(homes_file, "w")
		homepos[name] = pos
		for i, v in pairs(homepos) do
			data = string.format("%s %.1f %.1f %.1f %s\n",  data,v.x,v.y,v.z,i)
		end
		output:write(data)
		io.close(output)
		return true, "Home set!"
	end,
})
