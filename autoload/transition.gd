extends Node2D

signal scene_changed(scene: String);

enum TRANSTION_TYPE {
	FADE
}

func change_scene(scene_path: String, type: TRANSTION_TYPE = TRANSTION_TYPE.FADE):
	if type == TRANSTION_TYPE.FADE:
		transition_fade(scene_path);
	else:
		get_tree().change_scene_to_file(scene_path);
		scene_changed.emit(scene_path);

func transition_fade(scene_path):
	$AnimationPlayer.play_backwards("fade");
	await $AnimationPlayer.animation_finished;
	scene_changed.emit(scene_path);
	get_tree().change_scene_to_file(scene_path);
	scene_changed.emit(scene_path);
	$AnimationPlayer.play("fade");
	await $AnimationPlayer.animation_finished;
