class_name Stamp
extends MeshInstance3D

@export var ray_picker_camera: RayPickerCamera
@export var stamp_texture: Texture2D
@export var base_mesh: Mesh
@export_custom(PROPERTY_HINT_RANGE, "0,360,0.1,radians_as_degrees")
var base_rotation: Vector3
@export_custom(PROPERTY_HINT_RANGE, "-5,5,0.1,suffix:m")
var base_transform_offset: Vector3

signal emit_stamp(pos: Vector3, texture: Texture2D)

## If true, the stamp will follow the mouse around
var is_dragged := false
## Original position of the stamp
var origin_pos: Vector3
## Stamping animation tween
var tween: Tween

## This is the mesh representing the base of the stamp
@onready var base_mesh_node = $BaseMesh

func _ready() -> void:
	# Save the original position for later
	origin_pos = position
	# Assign the passed in base mesh to the base mesh instance
	base_mesh_node.mesh = base_mesh
	var tween = create_tween()
	base_mesh_node.rotation = base_rotation
	base_mesh_node.transform = \
			base_mesh_node.transform.translated(base_transform_offset)


func _process(_delta: float) -> void:
	if is_dragged:
		# If dragging is active, find the collision point between a ray cast
		# from the camera and the paper plane.
		var new_pos = ray_picker_camera.collision_point
		# Keep the y position constant, but change the x and z to match
		# the collision point.
		position.x = new_pos.x
		position.z = new_pos.z
		

func _input(event: InputEvent) -> void:
	# If the player clicks left mouse button while dragging the stamp,
	# we need to activate the stamping animation.
	if is_dragged and event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# First stop dragging it
		is_dragged = false
		
		# In order to move the stamp to where it would touch the paper,
		# get the bounding boxes (AABB) of both the handle and the base
		# meshes, add their height and divide by two.
		# Since the paper plane's y coord is 0, this should give us the correct
		# height for the center of our mesh.
		var touch_paper_pos = position
		# Originally I also used the bounding box for the stamp base, but that
		# didn't work for the triangle stamp, because it's rotated! So the
		# y size wasn't the right one. So now we just assume that all of the
		# stamp bases are 0.5m tall (once rotated properly).
		touch_paper_pos.y = (mesh.get_aabb().size.y + 0.5) / 2
		
		# We will use a Tween for the actual animation
		tween = create_tween()
		# Lower the stamp to touch the paper
		tween.tween_property(self, "position", touch_paper_pos, 0.5)
		# Emit the signal to create a decal on the paper mesh
		tween.tween_callback(emit_stamp.emit.bind(touch_paper_pos, stamp_texture))
		# Wait a bit, then return the stamp to its starting position
		tween.tween_property(self, "position", origin_pos, 0.5).set_delay(0.5)
		# Once that's done, make it clickable again
		tween.tween_property(self, "animation_playing", false, 0)


func _on_clickable_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# The stamp can be picked up if 
	# 1) it's not already being dragged, and
	# 2) the stamping animation tween is not currently running
	# If that's the case, left click on the stamp will start dragging it
	# TODO: this is no longer correct if we have other stamps in the scene,
	#       I probably need to emit signals whenever a stamp is picked up or
	#       set down, and have all other stamps listen to those.
	if !is_dragged and (tween == null or !tween.is_running()) \
			and event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		is_dragged = true
