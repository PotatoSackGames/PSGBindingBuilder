extends Node

var player := preload("res://player_main_viewmodel.tres")

func next_scene() -> void:
  get_tree().change_scene_to_file("res://level_1.tscn")
