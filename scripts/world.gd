extends Node3D

@onready var wait_zone = $WaitZone
@onready var path = $Path3D
@onready var sub_view_container = $SubViewportContainer

func _ready() -> void:
	## TODO: the window resolution is weird now for some reason
	var screen_size = get_viewport().get_visible_rect().size
	sub_view_container.position = (screen_size - sub_view_container.size) / 2


func _on_wait_zone_area_entered(area: Area3D) -> void:
	pass
