extends Node2D


#const Start = preload("")
const Level1 = preload("res://scenes/levels/level_1.tscn")
const GameOver = preload("res://scenes/ui/gameover.tscn")
const Start = preload("res://scenes/ui/start.tscn")


func _ready():
  _on_start_btn_clicked()

  G.go_to_start.connect(_on_start_btn_clicked)
  G.kill_kitty.connect(_on_game_over)
  G.start_game.connect(_on_start_game)

func _on_game_over():
  _load_scene(GameOver)


func _on_start_btn_clicked():
   _load_scene(Start)

func _on_start_game():
  _load_scene(Level1)


func _load_scene(scene):
  var s = scene.instantiate()
  for a in $Scene.get_children():
    a.queue_free()

  $Scene.add_child(s)
