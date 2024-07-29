extends Node2D

signal attack();

func _process(delta):
	if !State.attacking:
		$AnimatedSprite.play(State.enemy.animations.idle);

	if State.attacking or State.turn or not State.started:
		return;
	
	await get_tree().create_timer(1).timeout;
	attack.emit();

func _ready():
	print("Enemy Loaded!");
	$AnimatedSprite.play(State.enemy.animations.idle);
