
local FORMNAME = "mission_block_user"

missions.form.missionblock_user = function(pos, node, player)

	local meta = minetest.get_meta(pos)
	local name = meta:get_string("name")
	local time = meta:get_int("time")
	local owner = meta:get_string("owner")
	local description = meta:get_string("description")

	local formspec = "size[8,8;]" ..
		"label[0,0;Mission by " .. owner .. "]" ..
		"label[4,0;Time: " .. missions.format_time(time) .. "]" ..
		"label[0,1;" .. name .. "]" ..
		"label[0,2;" .. description .. "]" ..
		"button_exit[5.5,1;2,1;start;Start]" ..
		missions.FORMBG

	minetest.show_formspec(player:get_player_name(),
		FORMNAME .. ";" .. minetest.pos_to_string(pos),
		formspec
	)
end


minetest.register_on_player_receive_fields(function(player, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local pos = minetest.string_to_pos(parts[2])

	if fields.start then
		local result = missions.validate_mission(pos, player)

		if not result.success then
			minetest.chat_send_player(player:get_player_name(), "Mission invalid: " .. result.msg)
		else
			missions.start(pos, player)
		end
	end


end)
