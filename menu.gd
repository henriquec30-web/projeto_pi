extends Control

@onready var creditos_panel = $Panel

func _ready():
	creditos_panel.visible = false


# 🎮 BOTÕES

func _on_jogar_pressed():
	pass  # ainda não faz nada


func _on_sandbox_pressed():
	get_tree().change_scene_to_file("res://main.tscn") 


func _on_creditos_pressed():
	creditos_panel.visible = true


func _on_sair_pressed():
	get_tree().quit()


# 🔙 BOTÃO VOLTAR DOS CRÉDITOS
func _on_voltar_pressed():
	creditos_panel.visible = false
