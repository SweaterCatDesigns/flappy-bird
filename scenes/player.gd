extends CharacterBody2D


class_name Player


const H_SPEED: float = 100.0
const V_SPEED: float = 350.0
const GRAVITY: float = 1000.0
const TILT_ANGLE: float = 0.05
const START_POS: Vector2 = Vector2(70.0, 205.0)


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


signal died


var dead: bool = false
var active: bool = false


func _ready() -> void:
	velocity.x = H_SPEED
	position = START_POS


func _physics_process(delta: float) -> void:
	if active:
		if not is_on_floor():
			velocity.y += GRAVITY * delta
		
		if is_on_floor() or is_on_ceiling():
			die()
		
		if Input.is_action_just_pressed("action") and not dead:
			velocity.y = -V_SPEED
		
		sprite.rotation_degrees = velocity.y * TILT_ANGLE
	
	move_and_slide()


func die() -> void:
	if dead:
		return
	
	dead = true
	velocity.x = 0
	velocity.y = 0
	sprite.stop()
	died.emit()


func activate() -> void:
	active = true
	velocity.y = -V_SPEED


func reset() -> void:
	position = START_POS
	active = false
	dead = false
	velocity.x = H_SPEED
	sprite.play("fly")
