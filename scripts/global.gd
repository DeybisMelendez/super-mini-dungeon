extends Node

var consola = [
" ",
" ",
" ",
]

var vidaMax = 100
var vida = 100
var ataque = 10
var nivel = 1
var xpA = 0
var xpN = 10
var aAtaque = 0
var aVida = 0
var piso = 1

func _process(delta):
	if consola.size() > 3:
		consola.remove(0)
	if xpA >= xpN:
		xpA -= xpN
		xpN = round(xpN * 1.2)
		nivel += 1
		aAtaque = randi()%5
		aVida = randi()%5
		ataque += aAtaque
		vidaMax += aVida
		vida += aVida
		autoload.get_node("nivelar").play()
		global.consola.append(tr("mensaje10") + " " + tr("menuAtaque") + str(aAtaque) + " " + tr("menuSalud") + str(aVida))