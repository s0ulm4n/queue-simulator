class_name Customer
extends PathFollow3D

@onready var mesh_instance = $MeshInstance3D
@onready var id_label = $Label3D
@onready var minigame_viewport = $"../../SubViewportContainer"

const COLOR_GREEN = Color("#008011")
const COLOR_RED = Color("#800000")

var impatience: float = 0.0
var max_progress: int
var id: int

func _ready() -> void:
	# mesh_instalce.mesh.material is SHARED between all instances of this mesh.
	# So if I try to change its color, it will affect all of the mesh instances
	# In order to affect a single mesh, I need to use the material_override
	# property of the mesh instance.
	mesh_instance.material_override = mesh_instance.mesh.material.duplicate()


func _process(_delta: float) -> void:
	id_label.text = str(id)

	mesh_instance.material_override.albedo_color = \
			COLOR_GREEN.lerp(COLOR_RED, impatience / 100.0)


func _on_area_3d_area_entered(area: Area3D) -> void:
	#print(area.name)
	pass


## Handle clicking on a "customer" mesh
func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#prints("customer", id, "clicked")
		minigame_viewport.visible = true
