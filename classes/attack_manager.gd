class_name AttackManager extends Node2D

var entity;
var attacks: Array[Attack];
var current_attack: Attack;
var next = 0;

func _init(attacker: Entity):
	print("__AttackManager__ created!");
	entity = attacker;

func get_damage():
	if not current_attack:
		return 0;

	return current_attack._damage;

func set_current_attack(index = 0):
	if index >= len(attacks):
		index = 0;

	current_attack = attacks[index];
	return self;
	
func set_next_attack():
	set_current_attack(next);
	
	if (next + 1) >= len(attacks):
		next = 0;
	else:
		next += 1;
	
	return self;

func add_attack(atk: Attack):
	print(atk);
	for attack in attacks:
		if atk._name == attack._name:
			attack.set_count(attack._count + atk._count); 
			return self;
			
	attacks.append(atk);
	return self

func get_secondary_attacks():
	var atks = [];
	for a in attacks:
		if a._name == current_attack._name:
			continue;
			
		atks.append(a);
	
	return atks;

func get_attacks():
	return attacks;

func attack(enemy: Entity):
	if not current_attack:
		return;
	  
	current_attack.handle(enemy);
