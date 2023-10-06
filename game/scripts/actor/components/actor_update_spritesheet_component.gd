extends "res://scripts/actor/actor_component.gd"
## ActorUpdateSpritesheetComponent


func process(_delta: float) -> void:
  if actor.velocity == Vector2.ZERO:
    actor.emit_signal("component_message_send", "animation_state", "idle")
  else:
    actor.emit_signal("component_message_send", "animation_state", "run")
