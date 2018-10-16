extends KinematicBody2D

var jugador = null
var mov = 16
var p = Vector2()
var jP = Vector2()
var m = Vector2()
onready var tilemap = get_parent() #Debe ser hijo de un TileMap
var vida = 20
var ataque = 2
var nivel = 1
var tipo = "snake"

# Destino del movimiento
var dest
var can_move = true

func _ready():
	dest = global_position

func mover():
	if not can_move:
		return
	
	if jugador != null:
		p = global_position
		jP = jugador.dest
		m = (jP - p).normalized()
		m.x = int(round(m.x))
		m.y = int(round(m.y))
		
		if jP != p + m * mov:
			if tilemap.get_cellv(tilemap.world_to_map(p + m * mov)) == 0:
				dest += m * mov
		else:
			global.consola.append("enemigo ataco a jugador")
			global.vida -= ataque

	$Movement.interpolate_property(
		self,
		"position",
		global_position,
		dest,
		0.1,
		Tween.TRANS_ELASTIC,
		Tween.EASE_IN_OUT
	)
	$Movement.start()

func atacado():
	vida -= global.ataque
	if vida <= 0:
		queue_free()

func _on_vision_body_entered(body):
	if body.is_in_group("jugador"):
		jugador = body
		
func _on_Movement_tween_started(object, key):
	can_move = false

func _on_Movement_tween_completed(object, key):
	can_move = true