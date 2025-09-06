extends Area3D  # Usamos Area3D para detecção de colisão

signal orb_destroyed  # Sinal para indicar que o orbe foi destruído

# Função para lidar com colisões
func _on_area_entered(body: Node):
	if body.is_in_group("player"):  # Verifica se o objeto colidido pertence ao grupo "player"
		emit_signal("pink_orb_destroyed")  # Emite o sinal de que o orbe foi destruído
		queue_free()  # Destroi o orbe atual

func _ready():
	connect("body_entered", Callable(self, "_on_area_entered"))

func _process(delta: float) -> void:
	await get_tree().create_timer(5).timeout
	emit_signal("destroyedP")
	queue_free()  # Destroi o orbe atual
