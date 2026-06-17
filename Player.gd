extends KinematicBody2D

onready var global_vars = get_node("/root/Globals")
export var speed = 200
var velocity = Vector2.ZERO

var facing = "Down"

var is_attacking = false
var is_shooting = false
var is_dead = false

var attack_timer = 0.0
var attack_duration = 0.4  # adjust this (lower = faster attacks)

var shoot_timer = 0.0
var shoot_duration = 0.3 # shooting timer

var ArrowScene = preload("res://Arrow.tscn")

var current_weapon = "slash"   # or "bow"

func _ready():
	get_node("/root/Globals").player = self   # ✅ ADD THIS
	var map = get_parent().get_node("TileMap")
	var map_limits = map.get_used_rect()
	var map_cellsize = map.cell_size
#	var cam = $Camera2D
#	cam.limit_left = map_limits.position.x * map_cellsize.x
#	cam.limit_top = map_limits.position.y * map_cellsize.y
#	cam.limit_right = map_limits.end.x * map_cellsize.x
#	cam.limit_bottom = map_limits.end.y * map_cellsize.y
	var g = get_node("/root/Globals")
	
	if g.next_spawn_position != Vector2.ZERO:
		global_position = g.next_spawn_position
		g.next_spawn_position = Vector2.ZERO

	$SlashHitbox.monitoring = false   # 🔥 THIS FIXES IDLE DAMAGE
	
	# 🔥 THIS LINE FIXES YOUR ISSUE
	$Sprite.connect("animation_finished", self, "_on_Sprite_animation_finished")

func _physics_process(delta):
	if global_vars.Health <= 0:
		game_over()
	
	if is_dead:
		return

	var input_vector = Vector2.ZERO

	# --- INPUT ---
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	# NOW define movement state (AFTER input)
	var is_moving = input_vector != Vector2.ZERO and not is_attacking and not is_shooting and not is_dead

	# --- FACING ---
	if input_vector != Vector2.ZERO:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				facing = "Right"
			else:
				facing = "Left"
		else:
			if input_vector.y > 0:
				facing = "Down"
			else:
				facing = "Up"
	# --- MOVEMENT ---
	if not is_attacking and not is_shooting:
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide(velocity)

	if is_moving:
		if not $SFX_Walk.playing:
			$SFX_Walk.play()
	else:
		if $SFX_Walk.playing:
			$SFX_Walk.stop()

	# --- ACTIONS ---
	if Input.is_action_just_pressed("ui_accept"):
		if current_weapon == "slash":
			start_slash()
		elif current_weapon == "bow":
			start_bow()

	update_animation(input_vector)
	
	# Handle attack timer
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			
	# Handle shooting timer
	if is_shooting:
		shoot_timer -= delta
		if shoot_timer <= 0:
			is_shooting = false
			
	# --- SWITCH WEAPON ---
	if Input.is_action_just_pressed("switch_weapon"):
		if current_weapon == "slash":
			current_weapon = "bow"
		else:
			current_weapon = "slash"

func _input(event):
	if event.is_action_pressed("use_potion"):
		print("POTION KEY PRESSED")
#		global_vars.use_potion()
		get_node("/root/Globals").use_potion()


# ========================
# ACTIONS
# ========================

func start_slash():
	if is_attacking or is_shooting or is_dead:
		return

	is_attacking = true
	attack_timer = attack_duration

	update_hitbox_position()   # 🔥 ADD THIS
	$SlashHitbox.monitoring = true
	
	# 🔥 ADD THIS BLOCK
	for body in $SlashHitbox.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(global_vars.slash_damage)
	
	$SFX_Slash.play()  # 🔊 ADD THIS
	$Sprite.play("Slash_" + facing)
	#$SFX_Slash.stop()

func start_bow():
	if is_attacking or is_shooting or is_dead:
		return

	is_shooting = true
	shoot_timer = shoot_duration

	update_muzzle_position()   # 🔥 ADD THIS
	
	$SFX_Shoot.play()  # 🔊 ADD THIS

	$Sprite.play("Bow_" + facing)
	
	spawn_arrow()
	
	#$SFX_Shoot.stop()

	
func spawn_arrow():
	var arrow = ArrowScene.instance()
	get_parent().add_child(arrow)

	var offset = Vector2.ZERO

	match facing:
		"Right":
			offset = Vector2(20, 0)
			arrow.set_direction(Vector2.RIGHT)

		"Left":
			offset = Vector2(-20, 0)
			arrow.set_direction(Vector2.LEFT)

		"Down":
			offset = Vector2(0, 20)
			arrow.set_direction(Vector2.DOWN)

		"Up":
			offset = Vector2(0, -20)
			arrow.set_direction(Vector2.UP)

	arrow.global_position = $Muzzle.global_position + offset

func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	
	$SFX_Die.play()  # 🔊 ADD THIS

	$Sprite.play("Death_" + facing)
	# OR if you only have one death animation:
	# $Sprite.play("Death")

func update_hitbox_position():
	var offset = 20
	
	match facing:
		"Right":
			$SlashHitbox.position = Vector2(offset, 0)
		"Left":
			$SlashHitbox.position = Vector2(-offset, 0)
		"Down":
			$SlashHitbox.position = Vector2(0, offset)
		"Up":
			$SlashHitbox.position = Vector2(0, -offset)
			
func update_muzzle_position():
	var offset = 20
	
	match facing:
		"Right":
			$Muzzle.position = Vector2(offset, 0)
		"Left":
			$Muzzle.position = Vector2(-offset, 0)
		"Down":
			$Muzzle.position = Vector2(0, offset)
		"Up":
			$Muzzle.position = Vector2(0, -offset)

# ========================
# ANIMATIONS
# ========================

func update_animation(input_vector):
	if is_attacking or is_shooting or is_dead:
		return

	if input_vector == Vector2.ZERO:
		 $Sprite.play("Idle_" + facing)
		
	else:
		 $Sprite.play("Walk_" + facing)
		


# ========================
# ANIMATION FINISHED
# ========================

func _on_Sprite_animation_finished():
	if is_attacking:
		is_attacking = false
		$SlashHitbox.monitoring = false   # 🔥 ADD THIS

	elif is_shooting:
		is_shooting = false

	elif is_dead:
		pass


func _on_SlashHitbox_body_entered(body):
	if not is_attacking:
		return

	if body.has_method("take_damage"):
		body.take_damage(global_vars.arrow_damage)
	pass # Replace with function body.
	
func game_over():
	# Optional: reset globals if needed
#	global_vars.reset_globals()

	# Switch to Game Over scene properly
	get_tree().change_scene("res://GameOver1.tscn")
