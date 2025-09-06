extends Node3D  # Usamos Node3D para trabalhar no espaço 3D
class_name Spawner

@export var spawn_points: Array[Node3D]  # Array de referências a nós de spawn
@export var orb_scene: PackedScene  # Cena do orbe
@export var goldenorb_scene: PackedScene  # Cena do orbe
@export var pinkorb_scene: PackedScene  # Cena do orbe
@export var env: WorldEnvironment
@onready var text = $"../Label"
var OrbCount = 1000

# Função para spawnar orbes
func spawn_orb(orb_scene: PackedScene, decrement: int, delay: float = 0.0) -> void:
	randomize()  # Randomizar o gerador de números aleatórios
	if spawn_points.size() == 0:
		print("Nenhum ponto de spawn definido!")
		return
	
	var random_index = randi() % spawn_points.size()
	var spawn_point = spawn_points[random_index]
	
	if spawn_point == null:
		print("Ponto de spawn inválido na posição ", random_index)
		return
	
	var orb_instance = orb_scene.instantiate() as Node3D  # Garante que o objeto instanciado seja Node3D
	orb_instance.global_transform.origin = spawn_point.global_transform.origin  # Usamos a posição global do nó de spawn
	add_child(orb_instance)
	print("Orbe spawnado em: ", spawn_point.name)
	OrbCount -= decrement
	env.environment.fog_density += 0.001
	
	orb_instance.connect("orb_destroyed", Callable(self, "_on_orb_destroyed"))

	if delay > 0.0:
		await get_tree().create_timer(delay).timeout
		orb_instance.queue_free()

func _on_golden_orb_destroyed():
	print("Um orbe foi destruído! Spawning um novo orbe...")
	spawn_orb(goldenorb_scene, 13)  # Chame a função de spawn com os parâmetros necessários
	OrbCount -= 50
	
func _on_pink_orb_destroyed():
	print("Um orbe foi destruído! Spawning um novo orbe...")
	spawn_orb(pinkorb_scene, 5)  # Chame a função de spawn com os parâmetros necessários
	OrbCount -= 200

func _on_orb_destroyed():
	print("Um orbe foi destruído! Spawning um novo orbe...")
	spawn_orb(orb_scene, 0)  # Chame a função de spawn com os parâmetros necessários
	OrbCount -= 5
	
func _on_destroyedG():
	print("Um orbe foi destruído! Spawning um novo orbe...")
	spawn_orb(goldenorb_scene, 13)  # Chame a função de spawn com os parâmetros necessários
	
func _on_destroyedP():
	print("Um orbe foi destruído! Spawning um novo orbe...")
	spawn_orb(pinkorb_scene, 5)  # Chame a função de spawn com os parâmetros necessários

func _ready():
	spawn_orb(orb_scene, 5)  # Spawna um orbe ao iniciar
	if OrbCount <= 900:
		spawn_orb(goldenorb_scene, 50)
		spawn_orb(pinkorb_scene, 200, 3)
