extends CenterContainer

export (PackedScene) var juego

func _ready():
	$anim.play("texto")
	$Label.set_text(tr("historia"))
	yield($anim,"animation_finished")
	$trans/anim.play("fadeIn")
	yield($trans/anim,"animation_finished")
	get_tree().change_scene_to(juego)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
