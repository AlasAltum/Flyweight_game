extends Node2D

export (String, FILE, "*.json") var dialogue_file_path : String


func _on_DialogueBox_dialogue_finished():
	LevelManager.change_scene_to_main_menu()
