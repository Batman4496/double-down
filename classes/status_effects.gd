class_name StatusEffects extends Node2D

signal status_added(status: Status);
signal status_removed(status: Status);

var entity: Entity;
var active: Array[Status] = [];

func _init(__entity: Entity):
	print("__StatusEffects__ created!");
	entity = __entity;

func _ready():
	pass;

func add_status(status: Status):
	active.push_back(status);
	status_added.emit(status);
	
func inflict_status_damage():
	var i = 0;
	for status in active:
		if status._count > 0:
			status.handle(entity);
			status._count -= 1;
		else:
			status_removed.emit(active[i]);
			active.remove_at(i);
		
		i += 1;
