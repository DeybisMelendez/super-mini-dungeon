extends Node

var consola = [
" ",
" ",
" ",
]
var vidaMax = 20
var vida = 20
var ataque = 10
var nivel = 1

func _process(delta):
	if consola.size() > 3:
		consola.remove(0)