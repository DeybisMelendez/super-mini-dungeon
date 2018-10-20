extends CenterContainer

export (PackedScene) var juego

func _ready():
	$anim.play("texto")
	$Label.set_text(tr("finalBueno"))
	yield($anim,"animation_finished")
	$trans/anim.play("fadeIn")
	yield($trans/anim,"animation_finished")
	get_tree().change_scene_to(juego)