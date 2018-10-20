extends Control

func _ready():
	$CenterContainer/salud.set_text(tr("menuSalud"))
	$CenterContainer/ataque.set_text(tr("menuAtaque"))
	$CenterContainer/nivel.set_text(tr("menuNivel"))

func _process(delta):
	$"0".set_text(global.consola[0])
	$"1".set_text(global.consola[1])
	$"2".set_text(global.consola[2])
	$"3".set_text(tr("menuPiso") + str(global.piso))
	$CenterContainer/"3".set_text(str(global.vida) + "/" + str(global.vidaMax))
	$CenterContainer/"4".set_text(str(global.ataque))
	$CenterContainer/"5".set_text(str(global.nivel))
	$CenterContainer/"7".set_text(str(global.xpA) + "/" + str(global.xpN))