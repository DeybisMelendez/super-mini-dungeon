extends KinematicBody2D

var p = Vector2()
var enemigosArea = []
var dir ={
	derecha = Vector2(16,0),
	izquierda = Vector2(-16,0),
	arriba = Vector2(0,-16),
	abajo = Vector2(0,16),
}
onready var tilemap = get_parent() #Debe ser hijo de un TileMap
onready var enemigos = get_tree().get_nodes_in_group("enemigo")

func _physics_process(delta):
	p = global_position

func _input(event):
	var arriba = Input.is_action_just_pressed("arriba")
	var abajo = Input.is_action_just_pressed("abajo")
	var derecha = Input.is_action_just_pressed("derecha")
	var izquierda = Input.is_action_just_pressed("izquierda")
	var esperar = Input.is_action_just_pressed("esperar")
	var atacar = Input.is_action_just_pressed("atacar")
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
