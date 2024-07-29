extends Node2D

signal attack();

func _process(delta):
	if !State.attacking:
		$AnimatedSprite.play(State.player.animations.idle);

func _ready():
	print("Player Loaded!");
	$AnimatedSprite.play(State.player.animations.idle);

func _input(event):
	if event.is_action_pressed("switch_attack"):	
		State.change_attack();

	if event.is_action_pressed("basic_attack"):
		attack.emit();
