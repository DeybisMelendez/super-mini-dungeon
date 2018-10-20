extends Control

export (PackedScene) var juego

func _ready():
	$CenterContainer/VBoxContainer/made.set_text(tr("menuHecho"))
	$CenterContainer/VBoxContainer/press.set_text(tr("menuPress"))
	global.vidaMax = 100
	for i in range(3):
		global.consola.append(" ")
	global.vida = 100
	global.ataque = 10
	global.nivel = 1
	global.xpA = 0
	global.xpN = 10
	global.piso = 1

func _input(event):
	if Input.is_action_just_pressed("comenzar"):
		$trans/anim.play("fadeIn")
		yield($trans/anim,"animation_finished")
		get_tree().change_scene_to(juego)