extends KinematicBody2D

const gravity := 980.0
const jump_force := -400.0
const speed := 200.0

export var positions_to_remember = 20

var positions := [position]
var velocity := Vector2.ZERO

var recalling := false

func _process(delta):
	$ghost.set_as_toplevel(true)
	recalling = (Input.is_action_just_pressed("recall") or recalling) and not positions.empty()
	velocity = move_and_slide(position.direction_to(target()) * speed if recalling else Vector2(speed * horizontal(), jump_force if Input.is_action_pressed("jump") and is_on_floor() else velocity.y + gravity * delta), Vector2.UP)
	$ghost.position = position if positions.empty() else $ghost.position.linear_interpolate(positions.back(), delta * 10.0)

func horizontal():
	return Input.get_action_strength("right") - Input.get_action_strength("left")

func target():
	if not positions.empty() and position.distance_to(positions.front()) < 5.0:
			positions.pop_front()
	return position if positions.empty() else positions.front()

func _on_remember_position_timeout():
	if not recalling:
		positions.push_front(position)
		if positions.size() > positions_to_remember:
			positions.pop_back()


