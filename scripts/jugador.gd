extends KinematicBody2D

var p = Vector2()
var enemigosArea = []
var dir ={
	derecha = Vector2(16,0),
	izquierda = Vector2(-16,0),
	arriba = Vector2(0,-16),
	abajo = Vector2(0,16),
}

# Destino del movimiento
var dest = Vector2()
var can_move = true

onready var tilemap = get_parent() #Debe ser hijo de un TileMap
onready var enemigos = get_tree().get_nodes_in_group("enemigo")

func _physics_process(delta):
	p = global_position

func _input(event):
	if not can_move:
		return
	
	var arriba = Input.is_action_just_pressed("arriba")
	var abajo = Input.is_action_just_pressed("abajo")
	var derecha = Input.is_action_just_pressed("derecha")
	var izquierda = Input.is_action_just_pressed("izquierda")
	var esperar = Input.is_action_just_pressed("esperar")
	var atacar = Input.is_action_just_pressed("atacar")
	if arriba:
		if tilemap.get_cellv(tilemap.world_to_map(p + dir.arriba)) == 0:
			if !hayEnemigo(dir.arriba):
				dest += dir.arriba
	if abajo:
		if tilemap.get_cellv(tilemap.world_to_map(p + dir.abajo)) == 0:
			if !hayEnemigo(dir.abajo):
				dest += dir.abajo
	if derecha:
		if tilemap.get_cellv(tilemap.world_to_map(p + dir.derecha)) == 0:
			if !hayEnemigo(dir.derecha):
				dest += dir.derecha
	if izquierda:
		if tilemap.get_cellv(tilemap.world_to_map(p + dir.izquierda)) == 0:
			if !hayEnemigo(dir.izquierda):
				dest += dir.izquierda
	
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
	
	if esperar:
		mover()
		if global.vidaMax > global.vida:
			global.vida += 1
			global.consola.append("Has descansado, recupero algo de vida")
		else:
			global.consola.append("Has descansado")
	
	if arriba or abajo or derecha or izquierda:
		mover()
	
	if atacar:
		if enemigosArea.size() > 0:
			enemigosArea[0].atacado()
			global.consola.append("Atacaste " + enemigosArea[0].tipo + " nivel " + str(enemigosArea[0].nivel))

func mover():
	enemigos = get_tree().get_nodes_in_group("enemigo")
	for i in enemigos:
		i.mover()

func hayEnemigo(pos):
	for i in enemigosArea:
		if i.global_position == p + pos:
			return true
	return false

func _on_areaAtaque_body_entered(body):
	if body.is_in_group("enemigo"):
		if !enemigosArea.has(body):
			enemigosArea.append(body)


func _on_areaAtaque_body_exited(body):
	if body.is_in_group("enemigo"):
		if enemigosArea.has(body):
			enemigosArea.erase(body)


func _on_Movement_tween_started(object, key):
	can_move = false

func _on_Movement_tween_completed(object, key):
	can_move = true
