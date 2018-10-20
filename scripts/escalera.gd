extends Area2D

func _ready():
	if global.piso >= 12:
		queue_free()

func _on_escalera_body_entered(body):
	if body.is_in_group("jugador"):
		body.get_node("cam/menu/trans/anim").play("fadeIn")
		yield(body.get_node("cam/menu/trans/anim"),"animation_finished")
		global.piso += 1
		get_tree().reload_current_scene()