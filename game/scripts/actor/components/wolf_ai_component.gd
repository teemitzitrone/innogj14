extends "res://scripts/actor/actor_component.gd"

enum AiState {
  NORMAL,
  BUNNY_RUN_AWAY,
}


const INTERACTION_RADIUS: float = 70.0 # Radius in which player has to be, to be followed


var current_state: AiState = AiState.NORMAL:
  set(value):
    current_state = value
    actor.component_message_send.emit("ai_state_changed", value)
    if value == AiState.NORMAL:
      actor.isBunny = false


var runaway_direction: Vector2


func ready():
  runaway_direction = Vector2.DOWN if actor.direction == Vector2.ZERO else actor.direction * -1
  actor.component_message_send.connect(on_message)


func process(_delta):
  var centerPoint = G.get_viewport().get_camera_2d().get_screen_center_position()

  if current_state == AiState.BUNNY_RUN_AWAY:
    if actor.global_position.distance_to(centerPoint) < INTERACTION_RADIUS:
      actor.direction = runaway_direction
      actor.velocity = actor.direction * actor.speed
    else:
      current_state = AiState.NORMAL
      actor.velocity = Vector2.ZERO
      actor.component_message_send.emit("ai_state_changed", 0)
    return


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


func on_message(type, info):
  if type == "collision":
    if info == "wolf:lightcone":
      actor.isBunny = true
      current_state = AiState.BUNNY_RUN_AWAY
      actor.component_message_send.emit("ai_state_changed", 1)
      runaway_direction = Vector2.DOWN if actor.direction == Vector2.ZERO else actor.direction * -1
