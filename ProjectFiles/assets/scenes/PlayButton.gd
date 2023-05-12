extends Button

export var next_scene: PackedScene


func _on_button_up():
	get_tree().change_scene_to(next_scene)
