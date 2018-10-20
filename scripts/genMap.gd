extends TileMap

var cW = 5 #cuarto Ancho
var cH = 5 #cuarto Alto
var cC = 10 #cuarto Cantidad
var o = Vector2(0,0) #tile Origen
var cT = 0 #ID del terreno para el cuarto
var cM = 1 #ID del muro para el cuarto
var s = 2 #ID de la sombra
var tamMap = 50 #tamaño maximo de la habitacion
var pos = o #variable reutilizable
var ultimoNivel = 12
export (PackedScene) var enemigo
export (PackedScene) var caja
export (PackedScene) var escalera
export (PackedScene) var anillo

func _ready():
	genMap()

func genMap():
	randomize()
	for i in cC:
		cW = randi()%5+5
		cH = randi()%5+5
		pos = Vector2(0,0)
		#Generamos un cuarto
		for a in range(cW * cH):
			set_cell(o.x + pos.x, o.y + pos.y,cT)
			pos.x += 1
			if pos.x >= cW:
				pos.x = 0
				pos.y += 1
			#Colocamos cajas
			if randi()%20 == 0:
				colocarCaja()
			if i == cC - 1 and a == (cW * cH)/2:
				if global.piso < ultimoNivel:
					var e = escalera.instance()
					e.global_position = map_to_world(Vector2(o.x + pos.x , o.y + pos.y))
					add_child(e)
				else:
					var e = anillo.instance()
					e.global_position = map_to_world(Vector2(o.x + pos.x , o.y + pos.y))
					add_child(e)
		#Seleccionamos un punto aleatorio para el colocar el siguiente cuarto
		pos.x = o.x + round(cW/2)
		pos.y = o.y + round(cH/2)
		o = Vector2(randi()% tamMap, randi()% tamMap)
		#generamos el camino
		if i != cC - 1:
			for i in range(abs(pos.x - o.x) + abs(pos.y - o.y)):
				if pos.x > o.x:
					pos.x -= 1
				elif pos.x < o.x:
					pos.x += 1
				elif pos.y > o.y:
					pos.y -= 1
				elif pos.y < o.y:
					pos.y += 1
				set_cellv(pos, cT)
	# Generamos los muros
	var terreno = get_used_cells_by_id(cT)
	for i in terreno:
		pos = Vector2(-1,-1)
		for a in 9:
			if get_cellv(i + pos) == -1:
				set_cellv(i + pos , cM)
			pos.x += 1
			if pos.x > 1:
				pos.x = -1
				pos.y += 1
	# Colocamos enemigos al azar
	for i in terreno:
		if randi()%50 == 0:
			var nEnemigo = enemigo.instance()
			nEnemigo.global_position = map_to_world(i)
			add_child(nEnemigo)

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		get_parent().get_node("Camera2D").global_position.y -= 16
	elif Input.is_action_just_pressed("ui_down"):
		get_parent().get_node("Camera2D").global_position.y += 16
	elif Input.is_action_just_pressed("ui_left"):
		get_parent().get_node("Camera2D").global_position.x -= 16
	elif Input.is_action_just_pressed("ui_right"):
		get_parent().get_node("Camera2D").global_position.x += 16
	elif Input.is_action_just_pressed("reiniciar"):
		get_tree().reload_current_scene()

func colocarCaja():
	var c = caja.instance()
	c.global_position = Vector2((o.x + pos.x) * 16, (o.y + pos.y) * 16)
	add_child(c)