extends "res://scripts/actor/actor_component.gd"

const DISTANCE_REQUIREMENT = 70.0

func process(_delta: float) -> void:
  var centerPoint = G.get_viewport().get_camera_2d().get_screen_center_position()

  if actor.velocity == Vector2.ZERO:
      actor.emit_signal("component_message_send", "animation_state", "run_dark")
      actor.emit_signal("component_message_send", "show_on_top", true)
  else:
    if actor.global_position.distance_to(centerPoint) < DISTANCE_REQUIREMENT:
      actor.emit_signal("component_message_send", "animation_state", "run")
      actor.emit_signal("component_message_send", "show_on_top", false)
    else:
      actor.emit_signal("component_message_send", "animation_state", "run_dark")
      actor.emit_signal("component_message_send", "show_on_top", true)

