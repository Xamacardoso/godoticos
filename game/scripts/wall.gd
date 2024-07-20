extends Area2D

@export var MAX_HEALTH : int;
@onready var health: int;

@onready var health_particles : PackedScene = preload("res://scenes/health_particles.tscn");

func _ready():
	update_max_health();
	restore_health();
	health = MAX_HEALTH;

# Atualiza a vida máxima do muro com base no banco de dados do jogo
func update_max_health():
	MAX_HEALTH = int(Global.game_db[str(Global.current_wave)]["wall_health"]);
	print(MAX_HEALTH);

# Restaura 15% do hp do muro
func restore_health():
	health = clampi(health+(MAX_HEALTH*0.15), 0, MAX_HEALTH);
	var _particles : CPUParticles2D = health_particles.instantiate();
	_particles.emitting = true;
	add_child(_particles);

# Toma dano
func take_damage(attack : Attack):
	health -= attack.attack_damage;
	
	
