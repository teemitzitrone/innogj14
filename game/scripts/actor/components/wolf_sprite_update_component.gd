extends "res://scripts/actor/actor_component.gd"

func process(_delta: float) -> void:
  var centerPoint = Vector2(160, 90)

  if actor.velocity == Vector2.ZERO:
      actor.emit_signal("component_message_send", "animation_state", "idle")
      actor.emit_signal("component_message_send", "show_on_top", true)
  else:
    if actor.global_position.distance_to(centerPoint) > 10:
      actor.emit_signal("component_message_send", "animation_state", "run")
      actor.emit_signal("component_message_send", "show_on_top", false)
    else:
      actor.emit_signal("component_message_send", "animation_state", "dark_run")
      actor.emit_signal("component_message_send", "show_on_top", true)

