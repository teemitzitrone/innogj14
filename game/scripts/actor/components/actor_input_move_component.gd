extends "res://scripts/actor/actor_component.gd"
## ActorInputMoveComponent



var target = Vector2.ZERO


func ready():
  target = actor.position


func physics_process(_delta) -> void:
  var direction := _get_direction()
  direction = _normalize_diagonal_direction(direction)
  _apply_movement(direction)


func input(event) -> void:
  if event.is_action_pressed("click"):
    target = actor.get_global_mouse_position()


func _get_direction() -> Vector2:
  if target != actor.position:
    smooth_out()
    return actor.position.direction_to(target)
  return Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _normalize_diagonal_direction(direction: Vector2) -> Vector2:
  if abs(direction.x) == 1 and abs(direction.y) == 1:
    direction = direction.normalized()
  return direction


func _apply_movement(direction: Vector2) -> void:
  actor.velocity = actor.speed * direction

  if actor.velocity != Vector2.ZERO:
    actor.direction = direction


func smooth_out():
  if abs(target.x - actor.position.x) < 10.0:
    actor.position.x = target.x
  if abs(target.y - actor.position.y) < 10.0:
    actor.position.y = target.y
