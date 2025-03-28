extends Node

var inventory: Array = []  # Global inventory
signal inventory_updated

func add_to_inventory(item):
	inventory.append(item)
	inventory_updated.emit()
