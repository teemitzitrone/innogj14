extends Node

const ActorBuilder = preload("res://scripts/actor/actor_builder.gd")



signal crystal_broken()
signal kill_kitty()


func _ready():
  kill_kitty.connect(on_kitty_killed)



func on_kitty_killed():
  print_debug("kitty is dead")
