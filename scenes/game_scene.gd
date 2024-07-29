extends Node2D

func _ready():
	Overlay.show_turn_overlay();
	$Background.texture = load(State.area.background);
	State.turn_changed.connect(_turn_changed);
	State.area_changed.connect(_on_area_change);
	$Player.connect("attack", player_attack);
	$Enemy.connect("attack", enemy_attack);

func _on_area_change(area):
	$Background.texture = load(area.background);

func _turn_changed(turn, turn_count):
	if turn:
		Overlay.show_turn_overlay();

func player_attack():
	if not State.player or not State.enemy:
		return
	
	if not State.turn or State.attacking or not State.started:
		return;
	
	State.attacking = true;
	$Player/AnimatedSprite.play(State.player.get_attack_animation());
	await $Player/AnimatedSprite.animation_finished;
	State.player.attack(State.enemy);
	$Enemy/AnimatedSprite.play(State.enemy.animations.damage);
	await $Enemy/AnimatedSprite.animation_finished;
	
	State.next_turn();

func enemy_attack():
	if not State.player or not State.enemy:
		return

	if State.turn or State.attacking or not State.started:
		return;

	State.attacking = true;
	$Enemy/AnimatedSprite.play(State.enemy.get_attack_animation());
	await $Enemy/AnimatedSprite.animation_finished;
	State.enemy.attack(State.player);
	$Player/AnimatedSprite.play(State.player.animations.damage);
	await $Player/AnimatedSprite.animation_finished;
	State.next_turn();
