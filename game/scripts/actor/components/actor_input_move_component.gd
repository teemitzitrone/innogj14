extends "res://scripts/actor/actor_component.gd"
## ActorInputMoveComponent


func physics_process(_delta) -> void:
  var direction := _get_direction()
  direction = _normalize_diagonal_direction(direction)
  _apply_movement(direction)


func _get_direction() -> Vector2:
  var direction := Vector2.ZERO
  direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
  direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
  return direction


func _normalize_diagonal_direction(direction: Vector2) -> Vector2:
  if abs(direction.x) == 1 and abs(direction.y) == 1:
    direction = direction.normalized()
  return direction


func _apply_movement(direction: Vector2) -> void:
  actor.velocity = actor.speed * direction

  if actor.velocity != Vector2.ZERO:
    actor.direction = direction
