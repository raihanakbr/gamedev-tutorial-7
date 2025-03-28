extends Control

@export var slot_count: int = 9
@export var slot_size: Vector2 = Vector2(64, 64)

func _ready():
	pass

func update_inventory():
	#Implementasi jelek krn ngapus semuanya trus instantiate lg tapi krn gaada UI saya gamau dislpaynya jelek
	var hbox = $HBoxContainer
	
	for child in hbox.get_children():
		child.queue_free()

	await get_tree().process_frame
	
	for i in range(Global.inventory.size()):
		var slot = TextureRect.new()
		slot.custom_minimum_size = slot_size
		slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot.texture = Global.inventory[i]["icon"]
		hbox.add_child(slot)
