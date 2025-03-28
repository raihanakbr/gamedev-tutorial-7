extends RayCast3D

var current_collider

func _ready():
	pass

func _process(delta):
	var collider = get_collider()

	if is_colliding():
		if collider is Interactable:
			if Input.is_action_just_pressed("interact"):
				collider.interact()
		elif collider is PickupableItem:
			if Input.is_action_just_pressed("interact"):
				var player = get_parent().get_parent().get_parent() #cara haram
				var item_scene = collider.scene_file_path
				var item_icon = collider.icon
				player.add_to_inventory({ "path": item_scene, "icon": item_icon })
				collider.queue_free()
