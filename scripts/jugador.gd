extends KinematicBody2D

var p = Vector2()
var enemigosArea = []
var pociones = []
var dir ={
	derecha = Vector2(16,0),
	izquierda = Vector2(-16,0),
	arriba = Vector2(0,-16),
	abajo = Vector2(0,16),
}
var morir = false

export (PackedScene) var enemigo

onready var tilemap = get_parent() #Debe ser hijo de un TileMap
onready var enemigos = get_tree().get_nodes_in_group("enemigo")

func _physics_process(delta):
	p = global_position
	if global.vida <= 0 and !morir:
		morir = true
		terminaJuego()

func _input(event):
	var arriba = Input.is_action_just_pressed("arriba")
	var abajo = Input.is_action_just_pressed("abajo")
	var derecha = Input.is_action_just_pressed("derecha")
	var izquierda = Input.is_action_just_pressed("izquierda")
	var esperar = Input.is_action_just_pressed("esperar")
	var atacar = Input.is_action_just_pressed("atacar")
	var tomar = Input.is_action_just_pressed("tomar")
	if arriba:
		if tilemap.get_cellv(tilemap.world_to_map(p + dir.arriba)) == 0:
			if !hayEnemigo(dir.arriba):
				global_position += dir.arriba
	if abajo:
		if tilemap.get_cellv(tilemap.world_to_map(p + dir.abajo)) == 0:
			if !hayEnemigo(dir.abajo):
				global_position += dir.abajo
	if derecha:
		if tilemap.get_cellv(tilemap.world_to_map(p + dir.derecha)) == 0:
			if !hayEnemigo(dir.derecha):
				global_position += dir.derecha
	if izquierda:
		if tilemap.get_cellv(tilemap.world_to_map(p + dir.izquierda)) == 0:
			if !hayEnemigo(dir.izquierda):
				global_position += dir.izquierda
	
	if esperar:
		mover()
		if global.vidaMax > global.vida:
			global.vida += 1
			global.consola.append(tr("mensaje2"))
		else:
			global.consola.append(tr("mensaje1"))
		if randi()%5 == 0:
			generarEnemigo()
	if tomar:
		mover()
		if pociones.size() > 0:
			pociones[0].queue_free()
			global.consola.append(tr("mensaje8"))
			global.vida += 20
			autoload.get_node("pocion").play()
			if global.vida > global.vidaMax:
				global.vida = global.vidaMax
	
	if arriba or abajo or derecha or izquierda:
		mover()
	
	if atacar:
		mover()
		if enemigosArea.size() > 0:
			if enemigosArea[0].tipo != "caja":
				global.consola.append(tr("mensaje3") + enemigosArea[0].tipo + tr("mensaje3-2") + str(enemigosArea[0].nivel))
			enemigosArea[0].atacado()

func mover():
	enemigos = get_tree().get_nodes_in_group("enemigo")
	for i in enemigos:
		i.mover()

func hayEnemigo(pos):
	for i in enemigosArea:
		if i.global_position == p + pos:
			return true
	return false

func generarEnemigo():
	var x = Vector2(-1,-1)
	var t = tilemap.world_to_map(p)
	for i in 9:
		randomize()
		if i != 4 and randi()%9 == 0:
			if tilemap.get_cellv(t+x) == 0:
				var n = enemigo.instance()
				n.global_position = (t + x) * 16
				get_parent().add_child(n)
				global.consola.append(n.tipo + tr("mensaje4"))
		x.x += 1
		if x.x > 1:
			x.x = -1
			x.y += 1

func terminaJuego():
	var finalMalo = load("res://escenas/finalMalo.tscn")
	$cam/menu/trans/anim.play("fadeIn")
	yield($cam/menu/trans/anim,"animation_finished")
	get_tree().change_scene_to(finalMalo)

func _on_areaAtaque_body_entered(body):
	if body.is_in_group("enemigo"):
		if !enemigosArea.has(body):
			enemigosArea.append(body)
	elif body.is_in_group("pocion"):
		if !pociones.has(body):
			pociones.append(body)

func _on_areaAtaque_body_exited(body):
	if body.is_in_group("enemigo"):
		if enemigosArea.has(body):
			enemigosArea.erase(body)
	elif body.is_in_group("pocion"):
		if pociones.has(body):
			pociones.erase(body)