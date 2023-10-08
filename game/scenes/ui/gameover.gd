extends Node2D


func _ready():
  $CanvasLayer/Button.button_up.connect(_on_start_btn)


func _on_start_btn():
  G.go_to_start.emit()
