extends StaticBody2D

var tipo = "caja"
export (PackedScene) var pocion

func mover():
	pass

func atacado():
	autoload.get_node("caja").play()
	if randi()%5 == 0:
		var p = pocion.instance()
		p.global_position = global_position
		get_parent().add_child(p)
		global.consola.append(tr("mensaje7"))
	else:
		global.consola.append(tr("mensaje6"))
	queue_free()