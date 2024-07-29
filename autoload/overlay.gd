extends Node2D

var animating = false;
var scroll_speed = 300;

func _ready():
	State.enemy_defeated.connect(show_enemy_defeated_overlay);
	State.player_rewarded.connect(show_reward_overlay);

func _process(delta):
	if animating:
		$ParallaxBackground.scroll_offset.x -= scroll_speed * delta;
	else:
		$ParallaxBackground.scroll_offset.x = 0;

func show_reward_overlay(type, data):
	if type == "health":
		create_overlay("+" + str(data) + " HP!");
	if type == "attack":
		create_overlay("Learned " + str(data.get('name')) + "!");
		
	State.attacking = true;
	animating = true;
	$AnimationPlayer.queue("fade_in_out");
	await $AnimationPlayer.animation_finished;
	animating = false;
	empty_background();
	State.attacking = false;


func show_turn_overlay():
	create_overlay("Turn " + str(State.turn_count));
	State.attacking = true;
	animating = true;
	$AnimationPlayer.queue("fade_in_out");
	await $AnimationPlayer.animation_finished;
	animating = false;
	empty_background();
	State.attacking = false;


func show_enemy_defeated_overlay(enemy):
	create_overlay("Defeated " + enemy.get_entity_name() + "!");
	State.attacking = true;
	animating = true;
	$AnimationPlayer.queue("fade_in_out");
	await $AnimationPlayer.animation_finished;
	animating = false;
	empty_background();
	State.attacking = false;

func empty_background():
	for node in $ParallaxBackground.get_children():
		node.queue_free();
	
func create_overlay(title):	
	if not State.area.get('overlays'):
		return;
	
	empty_background();
		
	var mid = len(State.area.overlays) / 2;
	
	var i = 0;
	for overlay in State.area.overlays:
		if i == mid:
			var scene = load("res://nodes/turn_label.tscn").instantiate();
			var label: Label = scene.get_node('Text');
			label.text = title;
			label.visible = true;
			#var parallax_layer = ParallaxLayer.new();
			#parallax_layer.add_child(label);
			$ParallaxBackground.add_child(scene);
		
		var scale = Vector2((i + 1) * 0.1, 0);
		var parallax_layer = ParallaxLayer.new();
		parallax_layer.motion_mirroring = Vector2(get_window().size.x, 0);
		parallax_layer.motion_scale = scale;
		var texture_rect = TextureRect.new();
		texture_rect.size = get_window().size;
		texture_rect.texture = load(overlay);
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH;
		parallax_layer.add_child(texture_rect);
		$ParallaxBackground.add_child(parallax_layer);
		
		i += 1;

	for x in $ParallaxBackground.get_children():
		pass
		#print(x.name, ": " , x.motion_mirroring);

func _input(event):
	pass
	#if event.is_action_pressed("basic_attack"):
		#$AnimationPlayer.seek($AnimationPlayer.current_animation_length, true);
		#$AnimationPlayer.stop();	
