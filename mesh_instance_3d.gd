extends MeshInstance3D

var player: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../CharacterBody3D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		global_position.x = player.global_position.x
		global_position.z = player.global_position.z
