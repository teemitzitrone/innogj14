extends Node2D


#const Start = preload("")
const Level1 = preload("res://scenes/levels/level_1.tscn")
const GameOver = preload("res://scenes/ui/gameover.tscn")


func _ready():
  _load_scene(Level1)

  G.go_to_start.connect(_on_start_btn_clicked)
  G.kill_kitty.connect(_on_game_over)

func _on_game_over():
  _load_scene(GameOver)


func _on_start_btn_clicked():
  # TODO: load start screen instead
  _load_scene(Level1)


func _load_scene(scene):
  var s = scene.instantiate()
  for a in $Scene.get_children():
    a.queue_free()

  $Scene.add_child(s)
