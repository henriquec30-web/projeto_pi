extends CanvasLayer
@onready var confirmacao = $HBoxContainer/Button2/PopupPanel
@onready var panel = $Panel
@onready var grid = $Panel/VBoxContainer/GridContainer

@export var placa_scene: PackedScene
@export var ram_scene: PackedScene
@export var processador_scene: PackedScene
@export var gpu_scene: PackedScene
var aberto = false

# ================================
# DRAG SYSTEM
# ================================
var dragging = false
var drag_scene: PackedScene = null
var drag_preview: Node2D = null


func _ready():
	panel.visible = aberto


func _on_button_pressed():
	aberto = !aberto
	panel.visible = aberto


# ================================
# START DRAG (USANDO A CENA REAL)
# ================================
func start_drag(scene: PackedScene):
	if scene == null:
		print("ERRO: cena não atribuída")
		return

	dragging = true
	drag_scene = scene

	# 🔥 Instancia a PRÓPRIA peça
	drag_preview = scene.instantiate()

	# 🔥 opcional: leve aumento ao segurar
	drag_preview.scale *= 1.1

	add_child(drag_preview)


func _process(delta):
	if dragging and drag_preview:
		drag_preview.global_position = get_viewport().get_mouse_position()


func _input(event):
	if dragging and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			spawn_dragged_object()


# ================================
# SPAWN FINAL
# ================================
func spawn_dragged_object():
	if drag_scene == null:
		return

	var obj = drag_scene.instantiate()
	get_tree().current_scene.add_child(obj)

	obj.global_position = get_viewport().get_mouse_position()

	# remove preview
	if drag_preview:
		drag_preview.queue_free()

	dragging = false
	drag_scene = null
	drag_preview = null

	await get_tree().process_frame
	DragManager.bring_to_front(obj)


# ================================
# FILTRO
# ================================
func filtrar_categoria(cat):
	for item in grid.get_children():
		if cat == "todos":
			item.visible = true
		else:
			if item.has_meta("categoria"):
				item.visible = item.get_meta("categoria") == cat
			else:
				item.visible = false


# ================================
# BOTÕES
# ================================
func _on_placamae_button_down():
	start_drag(placa_scene)

func _on_ram_button_down():
	start_drag(ram_scene)

func _on_processador_button_down():
	start_drag(processador_scene)

func _on_placa_video_button_down():
	start_drag(gpu_scene)


# ================================
# FILTROS
# ================================
func _on_todos_pressed():
	filtrar_categoria("todos")

func _on_placas_pressed():
	filtrar_categoria("placa")

func _on_memoria_pressed():
	filtrar_categoria("ram")
	
func _on_cpu_pressed():
	filtrar_categoria("cpu")
	
func _on_gpu_pressed():
	filtrar_categoria("gpu")


# ================================
# VOLTAR MENU
# ================================
func _on_button_2_pressed():
	confirmacao.position = get_viewport().get_visible_rect().size / 2
	confirmacao.popup()


func _on_sim_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_nao_pressed() -> void:
	confirmacao.hide()
