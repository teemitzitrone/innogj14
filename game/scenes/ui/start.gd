extends Node2D

func _ready():
  $CanvasLayer/Button.button_up.connect(_on_button_up)


func _on_button_up():
  G.start_game.emit()
