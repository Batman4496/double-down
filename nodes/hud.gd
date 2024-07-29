extends Node2D

@onready var attack_1 = $TextureRect/Control/Attack1;
@onready var attack_2 = $TextureRect/Control/Attack2;
@onready var attack_3 = $TextureRect/Control/Attack3;
@onready var health_label = $TextureRect/Control/HealthLabel;
@onready var turn_label = $TextureRect/Control/TurnLabel;


func _ready():
	update_attacks();
	_on_turn_change(State.turn, State.turn_count);
	State.turn_changed.connect(_on_turn_change);
	State.player_rewarded.connect(update_attacks);
	State.attack_changed.connect(update_attacks);
	
func _on_turn_change(turn, turn_count):
	health_label.text = str(State.player.health) + "/" + str(State.player.max_health);
	turn_label.text = "Turn " + str(turn_count);
	update_attacks();


func update_attacks():

	var attacks = State.player.attacks.get_secondary_attacks();
	
	var i = 2;
	for atk in attacks:
		var texture = load(atk.icon);
		var node = $TextureRect/Control.get_node("Attack" + str(i));
		node.texture = texture; 
		node.get_node('Counter').text = "Infinte" if atk._count == -1 else str(atk._count);
		i += 1;

	var attack = State.player.attacks.current_attack;
	if State.player.attacks.current_attack.icon:
		var texture = load(State.player.attacks.current_attack.icon);
		attack_1.texture = texture;
		attack_1.get_node('Counter').text = "Infinte" if attack._count == -1 else str(attack._count);
	
