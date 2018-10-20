extends Area2D

func _on_anillo_body_entered(body):
	if body.is_in_group("jugador"):
		var finalBueno = load("res://escenas/finalBueno.tscn")
		body.get_node("cam/menu/trans/anim").play("fadeIn")
		yield(body.get_node("cam/menu/trans/anim"),"animation_finished")
		get_tree().change_scene_to(finalBueno)