class_name Attack extends Node2D

var _name; 
var _damage;
var _count = -1;
var animation = null;
var icon;

func _init(__name: String, __damage: int):
	print("__Attack__ created: " + __name + '!');
	_name = __name;
	_damage = __damage;
	_count = -1;

func set_animation(anim: String):
	animation = anim;
	return self;
	
func set_count(value):
	_count = value;
	return self;

func set_icon(path):
	icon = path;
	return self;


func handle(entity: Entity):
	if _count > 0 or _count == -1:
		print("Dealt " + str(_damage) + " to " + entity.get_entity_name() + " with " + _name + "!");
		entity.deal_damage(_damage);
	
	if _count != -1 and _count > 0:
		_count -= 1;
