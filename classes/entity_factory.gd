class_name EntityFactory

static func make_attack(data: Dictionary):
	var atk = Attack.new(data.name, data.damage);
		
	if data.get('animation'):
		atk.set_animation(data.animation);
	
	if data.get('count'):
		atk.set_count(data.count);
	
	if data.get('icon'):
		atk.set_icon(data.icon);
		
	return atk;

static func make(data: Dictionary):
	var entity = Entity.new(data.name, data.hp);
	
	for attack in data.attacks:
		print(attack);
		entity.attacks.add_attack(EntityFactory.make_attack(attack));
		
	if data.get("animations"):
		var anims = EntityAnimations.new(
			data.animations.idle,
			data.animations.attack,
			data.animations.damage,
		);
		entity.set_animations(anims);

	entity.attacks.set_next_attack();
		
	return entity;
