extends Node

var is_any_dragging = false
var layer_stack = []

func bring_to_front(obj):
	if not is_instance_valid(obj):
		return
	
	if layer_stack.has(obj):
		layer_stack.erase(obj)
	
	layer_stack.append(obj)
	_update_z_indices()

func remove_from_stack(obj):
	if layer_stack.has(obj):
		layer_stack.erase(obj)
		_update_z_indices()

func _update_z_indices():
	for i in range(layer_stack.size()):
		var item = layer_stack[i]
		if is_instance_valid(item):
			# Se estiver conectado a um slot, não mexemos no Z aqui
			if not item.get("connected_slot"):
				item.z_index = i * 10
				item.z_as_relative = false  # 🔥 CORREÇÃO IMPORTANTE

# 🔥 FUNÇÃO DE PRIORIDADE DE CLIQUE (mantida)
func can_grab(attempting_obj):
	if is_any_dragging:
		return false
	
	var mouse_pos = attempting_obj.get_global_mouse_position()
	var space_state = attempting_obj.get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	
	var results = space_state.intersect_point(query)
	
	var highest_z = -1000000
	var winner = null
	
	for r in results:
		var col = r.collider
		
		if col is Area2D:
			var is_valid = layer_stack.has(col) or col.get("connected_slot") != null
			
			if is_valid:
				var z = col.z_index
				
				# 🔥 PRIORIDADE PRA OBJETO EM SLOT
				if col.get("connected_slot") != null:
					z += 10000
				
				if z > highest_z:
					highest_z = z
					winner = col
	
	return winner == attempting_obj
