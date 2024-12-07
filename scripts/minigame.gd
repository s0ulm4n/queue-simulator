extends Node3D

enum StampShapes {
	TRIANGLE,
	CIRCLE,
	DIAMOND,
}

enum StampColors {
	RED,
	GREEN,
	BLUE,
}

#var solution_shapes: Array[StampShapes] = []
#var solution_colors: Array[StampColors] = []
var solution_shape: StampShapes
var solution_color: StampColors

func _ready() -> void:
	solution_shape = StampShapes.values().pick_random()
	solution_color = StampColors.values().pick_random()
