extends CharacterBody3D

@export var speed: float = 5.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3
@export var sprint_speed_multiplier: float = 1.6
@export var crouch_speed_multiplier: float = 0.3
@export var crouch_height: float = 0.5
@export var standing_height: float = 2.0
@export var crouch_transition_speed: float = 10.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var item_offset: Node3D = $Head/Camera3D/ItemOffset

var camera_x_rotation: float = 0.0
var is_sprinting: bool = false
var is_crouching: bool = false
var current_height: float = 0.0
var standing_camera_height: float = 0.0
var crouch_camera_height: float = 0.0
var current_camera_height: float = 0.0
var equipped_item: Node3D = null

func add_to_inventory(item_scene_path):
	Global.inventory.append(item_scene_path)
	Global.inventory_updated.emit()
	print("Picked up:", item_scene_path)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_height = standing_height
	
	if collision_shape and collision_shape.shape:
		standing_height = collision_shape.shape.height
	
	standing_camera_height = camera.position.y
	
	crouch_camera_height = standing_camera_height - (standing_height - crouch_height) * 0.3
	current_camera_height = standing_camera_height
	
	Global.inventory = []
	Global.inventory_updated.connect($"../CanvasLayer/InventoryUI".update_inventory)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation
	
	if event is InputEventKey and event.pressed:
		var key_number = event.keycode - KEY_1 + 1
		if key_number >= 1 and key_number <= 9:
			equip_item_from_inventory(key_number - 1)

func equip_item_from_inventory(slot_index: int):
	if slot_index < 0 or slot_index >= Global.inventory.size():
		return
	
	var item_scene_path = Global.inventory[slot_index]["path"]
	if item_scene_path == null or item_scene_path == "":
		return
	
	if equipped_item:
		equipped_item.queue_free()
	
	var item_scene = load(item_scene_path)
	if item_scene:
		equipped_item = item_scene.instantiate()
		equipped_item.global_position = global_position
		get_parent().add_child(equipped_item)

func _physics_process(delta):
	# Handle sprint and crouch inputs
	handle_sprint_input()
	handle_crouch_input(delta)
	
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()
	
	var current_speed = speed
	if is_sprinting and !is_crouching:
		current_speed *= sprint_speed_multiplier
	elif is_crouching:
		current_speed *= crouch_speed_multiplier

	velocity.x = lerp(velocity.x, movement_vector.x * current_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * current_speed, acceleration * delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_crouching:
		velocity.y = jump_power

	move_and_slide()

func handle_sprint_input():
	is_sprinting = Input.is_action_pressed("sprint")

func handle_crouch_input(delta):
	if Input.is_action_pressed("crouch"):
		is_crouching = true
	else:
		if can_stand_up():
			is_crouching = false
	
	if collision_shape and collision_shape.shape:
		var target_height = crouch_height if is_crouching else standing_height
		current_height = lerp(current_height, target_height, crouch_transition_speed * delta)
		
		collision_shape.shape.height = current_height
		
		collision_shape.position.y = current_height / 2
	
	var target_camera_height = crouch_camera_height if is_crouching else standing_camera_height
	current_camera_height = lerp(current_camera_height, target_camera_height, crouch_transition_speed * delta)
	
	camera.position.y = current_camera_height

func can_stand_up() -> bool:
	if !collision_shape:
		return true
	return true
	
	#ada bug kalo di Level.tcsn and i ain't spending my time on that
	#var space_state = get_world_3d().direct_space_state
	#var params = PhysicsRayQueryParameters3D.new()
	#params.from = global_position
	#params.to = global_position + Vector3(0, standing_height - crouch_height, 0)
	#params.exclude = [self]
	#
	#var result = space_state.intersect_ray(params)
	#for res in result:
		#print(res)
	#return result.is_empty()
