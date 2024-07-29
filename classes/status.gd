class_name Status extends Node

var _name;
var _damage;
var _count;

func _init(__name: String, __damage: int, _count: int = 1):
	_name = __name;
	_damage = __damage;
	
func handle(entity: Entity):
	entity.deal_damage(_damage);
