extends Area2D

@export var slot_type = "cpu"

var connected_slot = null
var dragging = false
var drag_offset = Vector2.ZERO
var hovered_slot = null
@onready var inspecionar = $PopupPanel
@onready var menu = $PopupMenu

# 🔥 ZOOM
var tween = null
var original_scale = Vector2.ONE


func _ready():
	menu.clear()
	menu.add_item("Deletar", 0)
	menu.add_item("Inspecionar", 1)
	# conecta o sinal corretamente
	menu.id_pressed.connect(_on_popup_menu_id_pressed)

	if connected_slot == null:
		DragManager.bring_to_front(self)

	original_scale = scale


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if menu:
				menu.position = get_global_mouse_position()
				menu.popup()
		
		# 👉 CLICK ESQUERDO (DRAG)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if DragManager.can_grab(self):
				get_viewport().set_input_as_handled()

				if connected_slot:
					connected_slot.detach()

				DragManager.is_any_dragging = true
				dragging = true
				drag_offset = global_position - get_global_mouse_position()
				DragManager.bring_to_front(self)

				animate_pickup()
				highlight_valid_slots()


func _on_popup_menu_id_pressed(id):
	if id == 0:
		queue_free()
	if id == 1:
		inspecionar.position = menu.position
		inspecionar.popup()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and dragging:
			dragging = false
			DragManager.is_any_dragging = false

			animate_drop()
			clear_slot_highlights()

			if hovered_slot:
				hovered_slot.attach(self)
				hovered_slot = null


func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset
		_scan_for_slots()


func _scan_for_slots():
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collide_with_areas = true

	var results = space.intersect_point(query)

	var found_slot = null
	for r in results:
		var obj = r.collider
		if obj.has_method("can_accept") and obj.can_accept(self):
			found_slot = obj
			break

	if hovered_slot and hovered_slot != found_slot:
		hovered_slot.hide_highlight()

	if found_slot:
		found_slot.show_highlight()

	hovered_slot = found_slot


# 🔥 GLOBAL: destaca slots válidos
func highlight_valid_slots():
	var slots = get_tree().get_nodes_in_group("slots")

	for slot in slots:
		if slot.has_method("can_accept") and slot.can_accept(self):
			slot.show_global_highlight()


# 🔥 LIMPA highlights
func clear_slot_highlights():
	var slots = get_tree().get_nodes_in_group("slots")

	for slot in slots:
		slot.hide_global_highlight()


# 🔥 ANIMAÇÃO PEGAR
func animate_pickup():
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "scale", original_scale * 1.2, 0.12)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)


# 🔥 ANIMAÇÃO SOLTAR
func animate_drop():
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(self, "scale", original_scale, 0.1)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
func _on_button_pressed() -> void:
	inspecionar.hide()
