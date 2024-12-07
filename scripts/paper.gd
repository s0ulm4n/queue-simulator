class_name Paper
extends MeshInstance3D

var test_texture: Texture2D

## Handler for a signal emitted by a stamp object when it attempts to "stamp"
## the paper. Creates a new decal using the passed position and texture.
# TODO: pretty sure I will also need to pass modulation color
func _on_emit_stamp(pos: Vector3, texture: Texture2D) -> void:
	var decal = Decal.new()
	# Since decal actually has a bounding box, if we don't set its y size to
	# near zero, it can show up on top of the stamp base when it touches the paper.
	decal.size.y = 0.001
	decal.texture_albedo = texture
	#decal.modulate = Color.RED
	# Place the decal at the emitted position, but set its y coordinate to 0
	# so that it is displayed on top of the paper plane mesh.
	decal.position = pos
	decal.position.y = 0
	add_child(decal)
