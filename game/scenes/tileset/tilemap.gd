extends TileMap

# OBJECT TILE INFORMATION
var object_layer = 1
var crystal_terrain = 8

# Effects Tile Information
var effects_layer = 2

# Custom Datas
var is_breakable = "breakable"

var player : Node2D

func _ready():
    get_tree().get_current_scene().child_entered_tree.connect(_on_child_entered_tree)

func _unhandled_input(_event):
    if player && Input.is_action_just_pressed('action'):
        var action_map_position = local_to_map(get_global_mouse_position())
        var tile_data : TileData = get_cell_tile_data(object_layer, action_map_position)
        if tile_data && tile_data.get_custom_data(is_breakable):
            set_cell(object_layer, action_map_position, -1)
            set_cell(effects_layer, action_map_position, -1)

func _on_child_entered_tree(node: Node):
    if node.get_groups().has('kitty'):
        player = node
        get_tree().get_current_scene().child_entered_tree.disconnect(_on_child_entered_tree)
