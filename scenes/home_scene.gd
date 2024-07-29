extends Node2D

func _on_scene_changed(scene_path):
	Transition.scene_changed.disconnect(_on_scene_changed);

func _on_button_pressed():
	Transition.scene_changed.connect(_on_scene_changed);
	AudioPlayer.play_sfx("res://assets/sounds/punch.mp3")
	Transition.change_scene("res://scenes/game_scene.tscn");
