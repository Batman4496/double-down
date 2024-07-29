class_name Entity extends Node2D

var _name;
var health;
var max_health;
var attacks: AttackManager;
var status_effects: StatusEffects;
var animations: EntityAnimations;

func _init(__name: String, max_hp: int):
	print("__entity__ created!");
	_name = __name;
	attacks = AttackManager.new(self);
	status_effects = StatusEffects.new(self);
	max_health = max_hp;
	health = max_hp;

func set_health(amount: int):
	health = amount
	return self

func deal_damage(amount: int):
	if health - amount <= 0:
		return set_health(0);
	
	return set_health(health - amount);

func set_animations(anim: EntityAnimations):
	animations = anim;
	return self;

func get_entity_name():
	return _name;
	
func get_attack_animation():
	if attacks.current_attack.animation:
		return attacks.current_attack.animation;
	
	return animations.attack;

func attack(enemy: Entity):
	return attacks.attack(enemy);

func is_dead():
	return health <= 0
