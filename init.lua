minetest.register_chatcommand("whois", {
	params = "",
	description = "Get player ip",
	privs = { basic_privs = true },
	func = function(player, message)
		local pinfo = minetest.get_player_information(message)
		if not pinfo then
			minetest.chat_send_player(player, "Failed to retrieve player info", true)
			return
		end
		minetest.chat_send_player(player,
			message .. ": " .. pinfo.address .. " (avg_rtt=" ..
			string.format("%.3f", pinfo.avg_rtt) .. ")", true)
	end
})

--shortcut commands

minetest.register_chatcommand("mute", {
	params = "player",
	description = "Mutes a player",
	privs = {basic_privs = true},
	func = function(player, param)
		if not minetest.auth_table[param] then
			return false, "Player " .. param .. " does not exist."
		end
		local privs = minetest.get_player_privs(param)
			privs.shout = nil
			minetest.set_player_privs(param, privs)
		minetest.chat_send_player(param, "Notice: "..param..": you have been muted .")
		minetest.chat_send_player(player, "Notice: "..param..": has been muted .")
		minetest.log("action", "[easyprivs] Player, " .. param .. " Was Muted by "..player)	
	end,
})

minetest.register_chatcommand("unmute", {
	params = "player",
	description = "Mutes a player",
	privs = {basic_privs = true},
	func = function(player, param)
		if not minetest.auth_table[param] then
			return false, "Player " .. param .. " does not exist."
		end
		local privs = minetest.get_player_privs(param)
			privs.shout = true
			minetest.set_player_privs(param, privs)
		minetest.chat_send_player(param, "Notice: "..param..": you have been unmuted .")
		minetest.chat_send_player(player, "Notice: "..param..": has been unmuted .")
		minetest.log("action", "[easyprivs] Player, " .. param .. " Was Unmuted by "..player)	
	end,
})

minetest.register_chatcommand("cuff", {
	params = "player",
	description = "Revokes interact from a player",
	privs = {basic_privs = true},
	func = function(player, param)
		if not minetest.auth_table[param] then
			return false, "Player " .. param .. " does not exist."
		end
		local privs = minetest.get_player_privs(param)
			privs.interact = nil
			minetest.set_player_privs(param, privs)
		minetest.chat_send_player(param, "Notice: "..param..": you have lost interact .")
		minetest.chat_send_player(player, "Notice: "..param..": has been de-interact'ed .")
		minetest.log("action", "[easyprivs] Player, " .. param .. " Was cuffed by " ..player)	
	end,
})

minetest.register_chatcommand("uncuff", {
	params = "<player>",
	description = "restores interact to a player",
	privs = {basic_privs = true},
	func = function(player, param)
		if not minetest.auth_table[param] then
			return false, "Player " .. param .. " does not exist."
		end
		local privs = minetest.get_player_privs(param)
			privs.interact = true
			minetest.set_player_privs(param, privs)
		minetest.chat_send_player(param, "Notice: "..param..": you have been re-given interact .")
		minetest.chat_send_player(player, "Notice: "..param..": has been granted interact again .")
		minetest.log("action", "[easyprivs] Player, " .. param .. " Was Uncuffed by "..player)	
	end,
})

minetest.register_chatcommand("freeze", {
	params = "<player>",
	description = "Freeze a player",
	privs = {basic_privs = true},
	func = function(player, param)
		local target = minetest.get_player_by_name(param)
		local privs = minetest.get_player_privs(param)
		if not target then
			minetest.chat_send_player(player,"Player not found")
			return "Player not found"
		end
		target:set_physics_override(tonumber(0), tonumber(0), nil)
		privs.interact = nil
		minetest.set_player_privs(param, privs)
		minetest.chat_send_player(param, "Notice: "..param..": you have been frozen .")
		minetest.chat_send_player(player, "Notice: "..param..": has been frozen .")
		minetest.log("action", "[easyprivs] Player, " .. param .. " Was frozen by "..player)	
	end,
})

minetest.register_chatcommand("unfreeze", {
	params = "<player>",
	description = "Freeze a player",
	privs = {basic_privs = true},
	func = function(player, param)
		local target = minetest.get_player_by_name(param)
		if not target then
			minetest.chat_send_player(player,"Player not found")
			return
		end		
		target:set_physics_override(tonumber(1), tonumber(1), nil)
		minetest.chat_send_player(param, "Notice: "..param..": you have been unfrozen .")
		minetest.chat_send_player(player, "Notice: "..param..": has been unfrozen (you will have to regrant interact to that  player )")
		minetest.log("action", "[easyprivs] Player, " .. param .. " Was unfrozen by " ..player)	
	end,
})
