extends Area3D  # Usamos Area3D para detecção de colisão

signal orb_destroyed  # Sinal para indicar que o orbe foi destruído
@export var spawner = Spawner

# Função para lidar com colisões
func _on_orb_area_entered(body):
	if body.is_in_group("player"):  # Verifica se o objeto colidido pertence ao grupo "player"
		emit_signal("orb_destroyed")  # Emite o sinal de que o orbe foi destruído
		#spawner.spawn_orb()
		queue_free()  # Destroi o orbe atual

func _ready():
	# Conectar o sinal de colisão ao Area3D
	connect("body_entered", Callable(self, "_on_orb_area_entered"))
