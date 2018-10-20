extends KinematicBody2D

var jugador = null
var id = randi()%4 + 1
var sprite = load("res://sprites/sprite_"+str(id)+".png")
var mov = 16
var p = Vector2()
var jP = Vector2()
var m = Vector2()
onready var tilemap = get_parent() #Debe ser hijo de un TileMap
var vida = 20
var ataque = 2
var nivel = 1
var mostrar = false
const tipos = [
"Snake",
"Golem",
"Elf",
"Ghost",
"Fairy"
]
var tipo = tipos[id - 1]
func _ready():
	$Sprite.set_texture(sprite)
	match id:
		1:
			vida = 20
			ataque = 2
		2:
			vida = 30
			ataque = 2
		3:
			vida = 10
			ataque = 5
		4:
			vida = 30
			ataque = 4
		5:
			vida = 10
			ataque = 4
	nivel = randi()%global.nivel + 1
	for i in range(nivel):
		vida += randi()%nivel
		ataque += randi()%nivel

func _process(delta):
	if mostrar:
		$Label.set_text(tr("menuNombre") + ": " + tipo + ", " + tr("menuSalud")+ ": " + str(vida)+ ", " + tr("menuAtaque") + ": " + str(ataque)+ ", " + tr("menuNivel") + ": " + str(nivel))
	else:
		$Label.set_text("")

func mover():
	p = global_position
	if jugador != null:
		jP = jugador.global_position
		m = (jP - p).normalized()
		m = Vector2(int(round(m.x)) , int(round(m.y)))
		
		if jP != p + m * mov:
			if tilemap.get_cellv((p + m * mov)/16) == 0:
				global_position += m * mov
		else:
			global.consola.append(tipo + tr("mensaje5"))
			global.vida -= ataque
			autoload.get_node("golpe").play()
	else:
		m = Vector2(randi()%3 - 1,randi()%3 - 1)
		if tilemap.get_cellv((p + m * mov)/16) == 0:
			global_position += m * mov

func atacado():
	vida -= global.ataque
	autoload.get_node("golpe").play()
	if vida <= 0:
		global.xpA += abs(round((vida + ataque)/(nivel + 1)))
		global.consola.append(tipo + tr("mensaje9") + str(abs(round((vida + ataque)/(nivel + 1)))) + " XP")
		queue_free()

func _on_vision_body_entered(body):
	if body.is_in_group("jugador"):
		jugador = body

func _on_info_mouse_entered():
	mostrar = true

func _on_info_mouse_exited():
	mostrar = false
