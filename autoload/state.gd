extends Node2D

var player: Entity;
var enemy: Entity;

var started = null;
var xp = 0;
var turn = true;
var turn_count = 1;
var attacking = false;

# Current area and its enemies
var area_id = 1;
var area;
var enemies;

# Number of stages based on total enemies
var stage;
var stage_count;

signal turn_changed(turn, turn_count);
signal stage_change(stage, stage_count);
signal area_changed(area);
signal player_defeated(enemy);
signal enemy_defeated(enemy);
signal player_rewarded(type, data);
signal attack_changed();

func _ready():
	change_area(area_id);


func change_area(area_id):
	area = get_area(area_id);
	enemies = get_enemies(area.id);
	
	if not area or not enemies:
		get_tree().quit();
	
	stage = 0;
	stage_count = len(enemies);
	
	enemy = EntityFactory.make(enemies[stage]);
	player = EntityFactory.make(get_enemies(0));
	area_changed.emit();

func _process(delta):
	if not player or not enemy: 
		return;
	
	if started == null:
		started = true;

func next_turn():
	print("Enemy: ", enemy.health);
	print("Player: ", player.health);
	turn = not turn;
	turn_count += 1;
	attacking = false;
	
	print("Turn: " + str(turn) + "! Count: " + str(turn_count));

	if player.is_dead():
		print("Player Dead!");
		return
		
	if enemy.is_dead():
		print(enemy.get_entity_name() + " Dead!");
		enemy_defeated.emit(enemy);
		
		if (stage + 1) >= stage_count:
			return change_area(area + 1);
		
		stage += 1;
		enemy = EntityFactory.make(enemies[stage]);
		give_random_reward();
	
	stage += 1;
	stage_change.emit(stage, stage_count);
	turn_changed.emit(turn, turn_count);

func give_random_reward():
	var reward = area.rewards.pick_random();
	var data = reward.data;
	
	if reward.type == "health":
		player.health += reward.data;
	elif reward.type == "attack":
		var attack = get_attack(reward.data);
		player.attacks.add_attack(EntityFactory.make_attack(attack));
		data = attack;
	
	player_rewarded.emit(reward.type, data);

func get_area(area_id):
	var areas = JSON.parse_string(FileAccess.get_file_as_string("res://storage/areas.json"));
	for a in areas:
		if a.id == area_id:
			return a;
		
	return;

func get_enemies(area_id):
	var ems = JSON.parse_string(FileAccess.get_file_as_string("res://storage/entities.json"));
	return ems.get(str(area_id));
	
func get_attack(attack_id):
	var attacks = JSON.parse_string(FileAccess.get_file_as_string("res://storage/attacks.json"));
	for attack in attacks:
		if attack.id == attack_id:
			return attack
	
	return null;
	
func change_attack():
	player.attacks.set_next_attack();
	attack_changed.emit();
	
