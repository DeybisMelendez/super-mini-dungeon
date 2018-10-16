extends CanvasLayer

func _process(delta):
	$"0".set_text(global.consola[0])
	$"1".set_text(global.consola[1])
	$"2".set_text(global.consola[2])
	$CenterContainer/"3".set_text(str(global.vida) + "/" + str(global.vidaMax))
	$CenterContainer/"4".set_text(str(global.ataque))
	$CenterContainer/"5".set_text(str(global.nivel))