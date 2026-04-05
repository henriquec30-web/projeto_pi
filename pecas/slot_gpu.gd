extends Area2D

@export var slot_type = "gpu"

var occupied = false
var current_object = null

@onready var highlight = $ColorRect

# 🔥 NOVO: controle de estados
var is_global_highlight = false
var is_hover_highlight = false


func _ready():
	highlight.visible = false


func can_accept(obj):
	return not occupied and obj.slot_type == slot_type


# 🔵 HIGHLIGHT DE PROXIMIDADE (mouse em cima)
func show_highlight():
	is_hover_highlight = true
	_update_visual()


func hide_highlight():
	is_hover_highlight = false
	_update_visual()


# 🟢 HIGHLIGHT GLOBAL (quando segura item)
func show_global_highlight():
	is_global_highlight = true
	_update_visual()


func hide_global_highlight():
	is_global_highlight = false
	_update_visual()


# 🔥 CONTROLE FINAL DO VISUAL
func _update_visual():
	highlight.visible = is_global_highlight or is_hover_highlight


func attach(obj):
	occupied = true
	current_object = obj

	DragManager.remove_from_stack(obj)

	if obj.get_parent():
		obj.get_parent().remove_child(obj)
	add_child(obj)

	obj.position = Vector2.ZERO
	
	obj.z_index = 5
	obj.z_as_relative = true

	obj.connected_slot = self
	
	# 🔥 limpa tudo quando encaixa
	is_global_highlight = false
	is_hover_highlight = false
	_update_visual()


func detach():
	if current_object:
		var obj = current_object
		var global_pos = obj.global_position

		remove_child(obj)
		get_tree().current_scene.add_child(obj)

		obj.global_position = global_pos
		
		obj.connected_slot = null
		current_object = null
		occupied = false
		
		DragManager.bring_to_front(obj)
