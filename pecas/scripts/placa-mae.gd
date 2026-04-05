extends Area2D

var dragging = false
var drag_offset = Vector2.ZERO

# 🔥 ZOOM
var tween = null
var original_scale = Vector2.ONE
@onready var menu = $PopupMenu
@onready var inspecionar = $PopupPanel
func _ready():
	menu.clear()
	menu.add_item("Deletar", 0)
	menu.add_item("Inspecionar", 1)
	menu.id_pressed.connect(_on_popup_menu_id_pressed)
	DragManager.bring_to_front(self)
	original_scale = scale


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			menu.position = get_global_mouse_position()
			menu.popup()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			
			# 🔥 NÃO deixa clicar se tiver peça em cima (RAM/CPU/etc)
			var space = get_world_2d().direct_space_state
			var query = PhysicsPointQueryParameters2D.new()
			query.position = get_global_mouse_position()
			query.collide_with_areas = true
			
			var results = space.intersect_point(query)
			
			for r in results:
				var col = r.collider
				if col != self and col.get("connected_slot") != null:
					return
			
			if DragManager.can_grab(self):
				get_viewport().set_input_as_handled()
				DragManager.bring_to_front(self)
				DragManager.is_any_dragging = true
				dragging = true
				drag_offset = global_position - get_global_mouse_position()

				# 🔥 ZOOM AO PEGAR
				animate_pickup()
func _on_popup_menu_id_pressed(id):
	if id == 0:
		queue_free()
	if id == 1:
		inspecionar.position = menu.position
		inspecionar.popup()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			dragging = false
			DragManager.is_any_dragging = false

			# 🔥 VOLTA TAMANHO
			animate_drop()


func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset


# 🔥 ANIMAÇÃO DE PEGAR
func animate_pickup():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "scale", original_scale * 1.15, 0.12)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)


# 🔥 ANIMAÇÃO DE SOLTAR
func animate_drop():
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(self, "scale", original_scale, 0.1)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func _on_button_pressed() -> void:
	inspecionar.hide()
