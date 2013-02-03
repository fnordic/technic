minetest.register_craftitem("technic:injector", {
	description = "Injector",
	stack_max = 99,
})

minetest.register_node("technic:injector", {
	description = "Injector",
	tiles = {"technic_injector_top.png", "technic_injector_bottom.png", "technic_injector_side.png",
		"technic_injector_side.png", "technic_injector_side.png", "technic_injector_side.png"},
	groups = chest_groups1,
	tube = tubes_properties,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"invsize[8,9;]"..
				"label[0,0;Injector]"..
				"list[current_name;main;0,2;8,2;]"..
				"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "Injector")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
})

minetest.register_abm({
	nodenames = {"technic:injector"},
	interval = 1,
	chance = 1,

	action = function(pos, node, active_object_count, active_object_count_wider)
	local pos1={}
	pos1.x = pos.x
	pos1.y = pos.y-1
	pos1.z = pos.z
	local meta=minetest.env:get_meta(pos1) 
		if meta:get_int("tubelike")==1 then inject_items (pos) end
	end,
})

function inject_items (pos)
		local meta=minetest.env:get_meta(pos) 
		local inv = meta:get_inventory()
		local i=0
		for _,stack in ipairs(inv:get_list("main")) do
		i=i+1
			if stack then
			local item0=stack:to_table()
			if item0 then 
				item0["count"]="1"
				local item1=tube_item({x=pos.x,y=pos.y,z=pos.z},item0)
				item1:get_luaentity().start_pos = {x=pos.x,y=pos.y,z=pos.z}
				item1:setvelocity({x=0, y=-1, z=0})
				item1:setacceleration({x=0, y=0, z=0})
				stack:take_item(1);
				inv:set_stack("main", i, stack)
				return
				end
			end
		end
end
