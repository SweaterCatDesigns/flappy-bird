extends Node2D


const PIPES = preload("res://scenes/pipes.tscn")
const PIPE_Y_RANGE: Vector2 = Vector2(220.0, 440.0)
const PIPE_X_OFFSET: float = 300.0


@onready var camera: Camera2D = $Player/Camera2D
@onready var pipe_container: Node2D = $PipeContainer
@onready var score_label: Label = $CanvasLayer/ScoreLabel
@onready var start_label: Label = $CanvasLayer/StartLabel
@onready var pipe_timer: Timer = $PipeTimer
@onready var player: Player = $Player
@onready var black_out: ColorRect = $CanvasLayer/BlackOut
@onready var game_over_timer: Timer = $GameOverTimer


var score: int = 0
var running: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if running:
		check_pipes()
	elif Input.is_action_just_pressed("action"):
		start_game()


func _on_pipe_timer_timeout() -> void:
	spawn_pipes()


func start_game() -> void:
	running = true
	start_label.hide()
	pipe_timer.start()
	player.activate()


func reset_game() -> void:
	running = false
	score = 0
	score_label.text = "0"
	start_label.show()
	remove_pipes()
	player.reset()


func spawn_pipes() -> void:
	var new_pipes = PIPES.instantiate()
	var y_pos = randf_range(PIPE_Y_RANGE.x, PIPE_Y_RANGE.y)
	new_pipes.position = Vector2(camera.get_screen_center_position().x + PIPE_X_OFFSET, y_pos)
	new_pipes.score_point.connect(score_point)
	pipe_container.add_child(new_pipes)


func check_pipes() -> void:
	if pipe_container.get_child_count() > 0:
		var first_pipes = pipe_container.get_child(0)
		if first_pipes.position.x < camera.get_screen_center_position().x - PIPE_X_OFFSET:
			first_pipes.queue_free()


func remove_pipes() -> void:
	for pipes in pipe_container.get_children():
		pipes.queue_free()


func score_point() -> void:
	score += 1
	score_label.text = str(score)


func _on_player_died() -> void:
	pipe_timer.stop()
	game_over_timer.start()


func _on_game_over_timer_timeout() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(black_out, "color:a", 1.0, 1.0)
	tween.tween_callback(reset_game)
	tween.tween_property(black_out, "color:a", 0.0, 1.0)
