extends "res://scripts/actor/actor_component.gd"

enum AiState {
  NORMAL,
  BUNNY_RUN_AWAY,
}


const INTERACTION_RADIUS: float = 60.0 # Radius in which player has to be, to be followed


var current_state: AiState = AiState.NORMAL



func ready():
  pass


func process(_delta):
  if current_state == AiState.BUNNY_RUN_AWAY:
    return

  var centerPoint = G.get_viewport().get_camera_2d().get_screen_center_position()
  var direction = Vector2.ZERO

  if actor.global_position.distance_to(centerPoint) < INTERACTION_RADIUS:

    if centerPoint.x < actor.global_position.x:
      direction.x = -1
    elif centerPoint.x > actor.global_position.x:
      direction.x = 1

    if centerPoint.y < actor.global_position.y:
      direction.y = -1
    elif centerPoint.y > actor.global_position.y:
      direction.y = 1

    if abs(direction.x) == 1 and abs(direction.y) == 1:
      direction = direction.normalized()

    actor.velocity = direction * actor.speed
  else:
    actor.velocity = Vector2.ZERO

  if actor.velocity != Vector2.ZERO:
    actor.direction = direction
